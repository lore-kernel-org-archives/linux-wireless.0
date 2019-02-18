Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F31AC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CB80218B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="U01fL0yM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfBRGIc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:08:32 -0500
Received: from condef-01.nifty.com ([202.248.20.66]:41573 "EHLO
        condef-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfBRGIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:08:32 -0500
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-01.nifty.com with ESMTP id x1I62b2u024662
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2019 15:02:44 +0900
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id x1I617hR006910;
        Mon, 18 Feb 2019 15:01:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x1I617hR006910
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1550469671;
        bh=+zEAAULpGTKFRc/KBt3VH/iYZzgyTO+raU+wiYUW1tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U01fL0yMBl7DUHfNrNZj/tPwczdJrD3wj9mgLYaeSAuCULD6XSCSOZPo/NbJFZatk
         ibXYoSW5DH6qD4nCvfC9o+DKr0g2m5c8/OZEp4T3cvq8aMix7NdMOI3eK+SO4EqSmz
         OL2iQpjHoDeyqc5xYvgF4OEN6V6QMoc4Nr9uIY0inYfYaexoBLirl9h35cQhKM6TXU
         LjxezWLutCISTX2E4WPZGt3aa78JIiR6DSO1RKfBCEeZ1ActJevzSohFp8NFfoWoOx
         KIr91kSnYvvjCgonjnQSfx75FbPOW2b2RXGXEpUE2MZHG7NyguK6LRLa72PeKd5LOQ
         lEo00Gyivtf0Q==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: disable CONFIG_GENERIC_HWEIGHT and remove __HAVE_ARCH_SW_HWEIGHT
Date:   Mon, 18 Feb 2019 14:59:31 +0900
Message-Id: <1550469571-25933-3-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

arch/x86/include/asm/arch_hweight.h uses __sw_hweight{32,64} as
alternatives, but they are implemented in arch/x86/lib/hweight.S

x86 does not rely on the generic C implementation lib/hweight.c
at all, so CONFIG_GENERIC_HWEIGHT should be disabled.

__HAVE_ARCH_SW_HWEIGHT was unneeded in the first place.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 arch/x86/Kconfig                    | 3 ---
 arch/x86/include/asm/arch_hweight.h | 2 --
 lib/hweight.c                       | 4 ----
 3 files changed, 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6826143..c2813af 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -262,9 +262,6 @@ config GENERIC_BUG
 config GENERIC_BUG_RELATIVE_POINTERS
 	bool
 
-config GENERIC_HWEIGHT
-	def_bool y
-
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
 	depends on ISA_DMA_API
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
index fc06935..ba88edd 100644
--- a/arch/x86/include/asm/arch_hweight.h
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -12,8 +12,6 @@
 #define REG_OUT "a"
 #endif
 
-#define __HAVE_ARCH_SW_HWEIGHT
-
 static __always_inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
diff --git a/lib/hweight.c b/lib/hweight.c
index 7660d88..c94586b 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -10,7 +10,6 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-#ifndef __HAVE_ARCH_SW_HWEIGHT
 unsigned int __sw_hweight32(unsigned int w)
 {
 #ifdef CONFIG_ARCH_HAS_FAST_MULTIPLIER
@@ -27,7 +26,6 @@ unsigned int __sw_hweight32(unsigned int w)
 #endif
 }
 EXPORT_SYMBOL(__sw_hweight32);
-#endif
 
 unsigned int __sw_hweight16(unsigned int w)
 {
@@ -46,7 +44,6 @@ unsigned int __sw_hweight8(unsigned int w)
 }
 EXPORT_SYMBOL(__sw_hweight8);
 
-#ifndef __HAVE_ARCH_SW_HWEIGHT
 unsigned long __sw_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
@@ -69,4 +66,3 @@ unsigned long __sw_hweight64(__u64 w)
 #endif
 }
 EXPORT_SYMBOL(__sw_hweight64);
-#endif
-- 
2.7.4

