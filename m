Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36919 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGQRct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:49 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so8120772wib.15
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:32:46 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/6] b43: N-PHY: fix channel switching with 2 GHz radio 0x2057
Date: Thu, 17 Jul 2014 19:31:01 +0200
Message-Id: <1405618266-20200-1-git-send-email-zajec5@gmail.com> (sfid-20140717_193300_858483_0D33D34D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Values were written to wrong registers.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/radio_2057.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2057.c b/drivers/net/wireless/b43/radio_2057.c
index ca22faa..c9c24b6 100644
--- a/drivers/net/wireless/b43/radio_2057.c
+++ b/drivers/net/wireless/b43/radio_2057.c
@@ -163,12 +163,12 @@ static u16 r2057_rev9_init[][2] = {
 	.radio_vcobuf_tune			= r09,	\
 	.radio_logen_mx2g_tune			= r10,	\
 	.radio_logen_indbuf2g_tune		= r11,	\
-	.radio_lna2g_tune_core0			= r12,	\
-	.radio_txmix2g_tune_boost_pu_core0	= r13,	\
-	.radio_pad2g_tune_pus_core0		= r14,	\
-	.radio_lna2g_tune_core1			= r15,	\
-	.radio_txmix2g_tune_boost_pu_core1	= r16,	\
-	.radio_pad2g_tune_pus_core1		= r17
+	.radio_txmix2g_tune_boost_pu_core0	= r12,	\
+	.radio_pad2g_tune_pus_core0		= r13,	\
+	.radio_lna2g_tune_core0			= r14,	\
+	.radio_txmix2g_tune_boost_pu_core1	= r15,	\
+	.radio_pad2g_tune_pus_core1		= r16,	\
+	.radio_lna2g_tune_core1			= r17
 
 #define PHYREGS(r0, r1, r2, r3, r4, r5)	\
 	.phy_regs.phy_bw1a	= r0,	\
-- 
1.8.4.5

