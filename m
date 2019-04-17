Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC85C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BA962183F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387799AbfDQVnj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:43:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:20166 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387607AbfDQVm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 17:42:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 14:42:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="224441206"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2019 14:42:27 -0700
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
Subject: [PATCH v7 16/21] x86/split_lock: Document the new sysfs file for split lock detection
Date:   Wed, 17 Apr 2019 14:34:06 -0700
Message-Id: <1555536851-17462-17-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add an ABI document entry for /sys/devices/system/cpu/split_lock_detect.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 .../ABI/testing/sysfs-devices-system-cpu      | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

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
-- 
2.19.1

