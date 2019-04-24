Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26127C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB91320674
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfDXToO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:44:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:15194 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbfDXTll (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454867"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:39 -0700
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
Subject: [PATCH v8 01/15] x86/common: Align cpu_caps_cleared and cpu_caps_set to unsigned long
Date:   Wed, 24 Apr 2019 12:32:48 -0700
Message-Id: <1556134382-58814-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

cpu_caps_cleared[] and cpu_caps_set[] may not be aligned to unsigned long.
Atomic operations (i.e. set_bit() and clear_bit()) on the bitmaps may
access two cache lines (a.k.a. split lock) and cause the CPU to do a bus
lock to block all memory accesses from other processors to ensure
atomicity.

To avoid the overall performance degradation from the bus locking, align
the two variables to unsigned long.

Defining the variables as unsigned long may also fix the issue because
they will be naturally aligned to unsigned long. But that needs additional
code changes. Adding __aligned(unsigned long) is a simpler fix.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cb28e98a0659..3716e2bb028b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -488,8 +488,9 @@ static const char *table_lookup_model(struct cpuinfo_x86 *c)
 	return NULL;		/* Not found */
 }
 
-__u32 cpu_caps_cleared[NCAPINTS + NBUGINTS];
-__u32 cpu_caps_set[NCAPINTS + NBUGINTS];
+/* Aligned to unsigned long to avoid split lock in atomic bitmap ops */
+__u32 cpu_caps_cleared[NCAPINTS + NBUGINTS] __aligned(sizeof(unsigned long));
+__u32 cpu_caps_set[NCAPINTS + NBUGINTS] __aligned(sizeof(unsigned long));
 
 void load_percpu_segment(int cpu)
 {
-- 
2.19.1

