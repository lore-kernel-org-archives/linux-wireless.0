Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2FFC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36C3F2175B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389734AbfDXTlp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:41:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:44995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729820AbfDXTln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454911"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:41 -0700
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
Subject: [PATCH v8 15/15] x86/split_lock: Add a sysfs interface to enable/disable split lock detection during run time
Date:   Wed, 24 Apr 2019 12:33:02 -0700
Message-Id: <1556134382-58814-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

To workaround or debug a split lock issue, the administrator may need to
disable or enable split lock detection during run time without rebooting
the system.

The interface /sys/device/system/cpu/split_lock_detect is added to allow
the administrator to disable or enable split lock detection and show
current split lock detection setting.

Writing [yY1] or [oO][nN] to the file enables split lock detection and
writing [nN0] or [oO][fF] disables split lock detection. Split lock
detection is enabled or disabled on all CPUs.

Reading the file returns current global split lock detection setting:
0: disabled
1: enabled

Add an ABI document entry for /sys/devices/system/cpu/split_lock_detect.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
Not sure if the justification for the sysfs knob is valid. If not, this
patch could be removed from this patch set.

 .../ABI/testing/sysfs-devices-system-cpu      | 22 ++++++++
 arch/x86/kernel/cpu/intel.c                   | 52 ++++++++++++++++++-
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 9605dbd4b5b5..aad7b1698065 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -67,6 +67,28 @@ Description:	Discover NUMA node a CPU belongs to
 		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
 
 
+What:		/sys/devices/system/cpu/split_lock_detect
+Date:		March 2019
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	(RW) Control split lock detection on Intel Tremont and
+		future CPUs
+
+		Reads return split lock detection status:
+			0: disabled
+			1: enabled
+
+		Writes enable or disable split lock detection:
+			The first character is one of 'Nn0' or [oO][fF] for off
+			disables the feature.
+			The first character is one of 'Yy1' or [oO][nN] for on
+			enables the feature.
+
+		Please note the interface only shows or controls global setting.
+		During run time, split lock detection on one CPU may be
+		disabled if split lock operation in kernel code happens on
+		the CPU. The interface doesn't show or control split lock
+		detection on individual CPU.
+
 What:		/sys/devices/system/cpu/cpu#/topology/core_id
 		/sys/devices/system/cpu/cpu#/topology/core_siblings
 		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 959ebf25beda..f257d1e92706 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -35,6 +35,7 @@
 DEFINE_PER_CPU(u64, msr_test_ctl_cache);
 EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
 
+static DEFINE_MUTEX(split_lock_detect_mutex);
 static bool split_lock_detect_enable;
 
 /*
@@ -660,7 +661,7 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
-static void split_lock_update_msr(void)
+static void split_lock_update_msr(void *__unused)
 {
 	if (split_lock_detect_enable) {
 		/* Enable split lock detection */
@@ -682,7 +683,7 @@ static void init_split_lock_detect(struct cpuinfo_x86 *c)
 		rdmsrl(MSR_TEST_CTL, test_ctl_val);
 		this_cpu_write(msr_test_ctl_cache, test_ctl_val);
 
-		split_lock_update_msr();
+		split_lock_update_msr(NULL);
 	}
 }
 
@@ -1114,3 +1115,50 @@ void handle_split_lock_kernel_mode(void)
 	this_cpu_and(msr_test_ctl_cache, ~TEST_CTL_SPLIT_LOCK_DETECT);
 	WARN_ONCE(1, "split lock operation detected\n");
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
+	if (split_lock_detect_enable)
+		pr_info("enabled\n");
+	else
+		pr_info("disabled\n");
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

