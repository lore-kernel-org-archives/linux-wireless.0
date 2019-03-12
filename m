Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE467C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A456B206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbfCLXIS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:08:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:65104 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbfCLXIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744252"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:14 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 13/18] x86/split_lock: Add a sysfs interface to allow user to enable or disable split lock detection on all CPUs during run time
Date:   Tue, 12 Mar 2019 16:00:31 -0700
Message-Id: <1552431636-31511-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The interface /sys/device/system/cpu/split_lock_detect is added
to allow user to control split lock detection and show current split
lock detection setting.

Writing 1 to the file enables split lock detection and writing 0
disables split lock detection. Split lock detection is enabled or
disabled on all CPUs.

Reading the file shows current global split lock detection setting:
disabled when 0 and enabled when 1.

Please note the interface only shows global setting. During run time,
split lock detection on one CPU may be disabled if split lock
in kernel code happens on the CPU. The interface doesn't show split
lock detection status on individual CPU. User can run rdmsr on 0x33
to check split lock detection on each CPU.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 67 +++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 561f7d50246a..1b25ff8c75eb 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -34,6 +34,7 @@
 #define DISABLE_SPLIT_LOCK_DETECT 0
 #define ENABLE_SPLIT_LOCK_DETECT  1
 
+static DEFINE_MUTEX(split_lock_detect_mutex);
 static int split_lock_detect_val;
 
 /*
@@ -1083,3 +1084,69 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 		split_lock_detect_val = 1;
 	}
 }
+
+static ssize_t
+split_lock_detect_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	return sprintf(buf, "%u\n", READ_ONCE(split_lock_detect_val));
+}
+
+static ssize_t
+split_lock_detect_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	u32 val, l, h;
+	int cpu, ret;
+
+	ret = kstrtou32(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val != DISABLE_SPLIT_LOCK_DETECT && val != ENABLE_SPLIT_LOCK_DETECT)
+		return -EINVAL;
+
+	/*
+	 * Since split lock could be disabled by kernel #AC handler or user
+	 * may directly change bit 29 in MSR_TEST_CTL, split lock setting on
+	 * each CPU may be different from global setting split_lock_detect_val
+	 * by now. Update MSR on each CPU, so all of CPUs will have same split
+	 * lock setting.
+	 */
+	mutex_lock(&split_lock_detect_mutex);
+
+	WRITE_ONCE(split_lock_detect_val, val);
+
+	/*
+	 * Get MSR_TEST_CTL on this CPU, assuming all CPUs have same value
+	 * in the MSR except split lock detection bit (bit 29).
+	 */
+	rdmsr(MSR_TEST_CTL, l, h);
+	l = new_sp_test_ctl_val(l);
+	/* Update the split lock detection setting on all online CPUs. */
+	for_each_online_cpu(cpu)
+		wrmsr_on_cpu(cpu, MSR_TEST_CTL, l, h);
+
+	mutex_unlock(&split_lock_detect_mutex);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(split_lock_detect);
+
+static int __init split_lock_init(void)
+{
+	int ret;
+
+	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		return -ENODEV;
+
+	ret = device_create_file(cpu_subsys.dev_root,
+				 &dev_attr_split_lock_detect);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+subsys_initcall(split_lock_init);
-- 
2.19.1

