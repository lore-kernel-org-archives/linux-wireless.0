Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37062 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbaGSLbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:17 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so2208023wiv.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/16] staging: vt6656: struct vnt_private rename qwCurrTSF to current_tsf
Date: Sat, 19 Jul 2014 12:30:13 +0100
Message-Id: <1405769418-2815-11-git-send-email-tvboxspy@gmail.com> (sfid-20140719_135108_830181_091729BF)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 4 ++--
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/int.c      | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 3b49ee9..8820871 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -583,7 +583,7 @@ void vnt_adjust_tsf(struct vnt_private *priv, u8 rx_rate,
 bool vnt_get_current_tsf(struct vnt_private *priv, u64 *current_tsf)
 {
 
-	*current_tsf = priv->qwCurrTSF;
+	*current_tsf = priv->current_tsf;
 
 	return true;
 }
@@ -604,7 +604,7 @@ bool vnt_clear_current_tsf(struct vnt_private *priv)
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 
-	priv->qwCurrTSF = 0;
+	priv->current_tsf = 0;
 
 	return true;
 }
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9f1216d..7697a73 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -311,7 +311,7 @@ struct vnt_private {
 
 	u8 exist_sw_net_addr;
 
-	u64 qwCurrTSF;
+	u64 current_tsf;
 
 	/* 802.11 MAC specific */
 	u32 uCurrRSSI;
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 1ea2433..9c5fefc 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -162,7 +162,7 @@ void vnt_int_process_data(struct vnt_private *priv)
 			}
 #endif
 		}
-		priv->qwCurrTSF = le64_to_cpu(int_data->tsf);
+		priv->current_tsf = le64_to_cpu(int_data->tsf);
 
 		low_stats->dot11RTSSuccessCount += int_data->rts_success;
 		low_stats->dot11RTSFailureCount += int_data->rts_fail;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9aaa816..c0951bf 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -924,7 +924,7 @@ static u64 vnt_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct vnt_private *priv = hw->priv;
 
-	return priv->qwCurrTSF;
+	return priv->current_tsf;
 }
 
 static void vnt_set_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
2.0.1

