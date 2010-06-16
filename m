Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:41323 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758692Ab0FPKMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:42 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-090313161
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:41 +0900 (JST)
Subject: [PATCH 14/17] ath5k: update 5210/5211 frame types
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:22 +0900
Message-ID: <20100616101222.10067.15213.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update 5210 frame types to match the HAL. We have to apply the same bitshift to
the constants as we use later.

Add 5211 specific frame types.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/desc.c |    2 +-
 drivers/net/wireless/ath/ath5k/desc.h |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 41a490e..f1f1a22 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -110,7 +110,7 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 		case AR5K_PKT_TYPE_PIFS:
 			frame_type = AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS;
 		default:
-			frame_type = type /*<< 2 ?*/;
+			frame_type = type;
 		}
 
 		tx_ctl->tx_control_0 |=
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 50f9a12..1aca4af 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -169,11 +169,13 @@ struct ath5k_hw_2w_tx_ctl {
 #define AR5K_2W_TX_DESC_CTL1_RTS_DURATION_5210	0xfff80000 /* [5210] lower 13 bit of duration */
 
 /* Frame types */
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NORMAL   0x00
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_ATIM     0x04
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PSPOLL   0x08
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY 0x0c
-#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS     0x10
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NORMAL	0
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_ATIM	1
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PSPOLL	2
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_NO_DELAY	3
+#define AR5K_AR5211_TX_DESC_FRAME_TYPE_BEACON	3
+#define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS	4
+#define AR5K_AR5211_TX_DESC_FRAME_TYPE_PRESP	4
 
 /*
  * 5212 hardware 4-word TX control descriptor

