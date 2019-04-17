Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EE1C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A4E2183F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbfDQVm3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:42:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:20166 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387596AbfDQVm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 17:42:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 14:42:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="224441200"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2019 14:42:26 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Michael Chan" <michael.chan@broadcom.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v7 15/21] x86/split_lock: Add a sysfs interface to enable/disable split lock detection during run time
Date:   Wed, 17 Apr 2019 14:34:05 -0700
Message-Id: <1555536851-17462-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The interface /sys/device/system/cpu/split_lock_detect is added
to allow user to control split lock detection and show current split
lock detection setting.

Writing [yY1] or [oO][nN] to the file enables split lock detection and
writing [nN0] or [oO][fF] disables split lock detection. Split lock
detection is enabled or disabled on all CPUs.

Reading the file returns current global split lock detection setting:
0: disabled
1: enabled

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 45 +++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 6a692d215bef..f2c04aa36d78 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -34,6 +34,7 @@
 DEFINE_PER_CPU(u64, msr_test_ctl_cache);
 EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
 
+static DEFINE_MUTEX(split_lock_detect_mutex);
 static bool split_lock_detect_enable;
 
 /*
@@ -1097,3 +1098,47 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT)
 		set_split_lock_detect();
 }
+
+static ssize_t
+split_lock_detect_show(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	return sprintf(buf, "%u\n", split_lock_detect_enable);
+}
+
+static ssize_t
+split_lock_detect_store(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	bool val;
+	int ret;
+
+	ret = strtobool(buf, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&split_lock_detect_mutex);
+
+	split_lock_detect_enable = val;
+
+	/* Update the split lock detection setting in MSR on all online CPUs. */
+	on_each_cpu(split_lock_update_msr, NULL, 1);
+
+	show_split_lock_detection_info();
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
+	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		return -ENODEV;
+
+	return device_create_file(cpu_subsys.dev_root,
+				  &dev_attr_split_lock_detect);
+}
+subsys_initcall(split_lock_init);
-- 
2.19.1

