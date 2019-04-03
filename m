Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF7EC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8EE2084B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDCVdG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:33:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:37323 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbfDCVaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:30:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2019 14:30:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,306,1549958400"; 
   d="scan'208";a="334754270"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 03 Apr 2019 14:30:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v6 15/20] x86/split_lock: Document the new sysfs file for split lock detection
Date:   Wed,  3 Apr 2019 14:22:01 -0700
Message-Id: <1554326526-172295-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add an ABI document entry for /sys/devices/system/cpu/split_lock_detect.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 .../ABI/testing/sysfs-devices-system-cpu          | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 9605dbd4b5b5..a4e8c2e2e1ac 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -67,6 +67,21 @@ Description:	Discover NUMA node a CPU belongs to
 		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
 
 
+What:		/sys/devices/system/cpu/split_lock_detect
+Date:		March 2019
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	Control split lock detection on Intel Tremont and future CPUs
+
+		Read/write interface to control split lock detection:
+			"0"	disable split lock detection on all CPUs
+			"1"	enable split lock detection on all CPUs
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
-- 
2.19.1

