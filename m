Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321E1C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F106D213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfCLXJU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:09:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:65108 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbfCLXIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744268"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:15 -0700
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
Subject: [PATCH v5 18/18] Change document for kernel option clearcpuid
Date:   Tue, 12 Mar 2019 16:00:36 -0700
Message-Id: <1552431636-31511-19-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since kernel option clearcpuid now supports multiple options and CPU
capability flags, the document needs to be changed.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2b8ee90bb644..7e65ae67d573 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -563,10 +563,12 @@
 			loops can be debugged more effectively on production
 			systems.
 
-	clearcpuid=BITNUM [X86]
+	clearcpuid=BITNUM | FLAG [X86]
 			Disable CPUID feature X for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
-			numbers. Note the Linux specific bits are not necessarily
+			numbers or /proc/cpuinfo for valid CPU flags.
+			Multiple options can be used to disable a few features.
+			Note the Linux specific bits are not necessarily
 			stable over kernel options, but the vendor specific
 			ones should be.
 			Also note that user programs calling CPUID directly
-- 
2.19.1

