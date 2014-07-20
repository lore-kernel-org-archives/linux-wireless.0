Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:47351 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGTOeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:23 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so6480105wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/25] staging: vt6656: struct vnt_private replace wBasicRate with basic_rates
Date: Sun, 20 Jul 2014 15:33:13 +0100
Message-Id: <1405866815-2687-3-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163428_220664_A80285C2)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same name as in struct ieee80211_bss_conf

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 14 +++++++-------
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 80b2ff8..80b6732 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -109,7 +109,7 @@ static u16 vnt_get_cck_rate(struct vnt_private *priv, u16 rate_idx)
 	u16 ui = rate_idx;
 
 	while (ui > RATE_1M) {
-		if (priv->wBasicRate & (1 << ui))
+		if (priv->basic_rates & (1 << ui))
 			return ui;
 		ui--;
 	}
@@ -135,7 +135,7 @@ static u16 vnt_get_ofdm_rate(struct vnt_private *priv, u16 rate_idx)
 	u16 ui = rate_idx;
 
 	dev_dbg(&priv->usb->dev, "%s basic rate: %d\n",
-					__func__,  priv->wBasicRate);
+					__func__,  priv->basic_rates);
 
 	if (!vnt_ofdm_min_rate(priv)) {
 		dev_dbg(&priv->usb->dev, "%s (NO OFDM) %d\n",
@@ -146,7 +146,7 @@ static u16 vnt_get_ofdm_rate(struct vnt_private *priv, u16 rate_idx)
 	}
 
 	while (ui > RATE_11M) {
-		if (priv->wBasicRate & (1 << ui)) {
+		if (priv->basic_rates & (1 << ui)) {
 			dev_dbg(&priv->usb->dev, "%s rate: %d\n",
 							__func__, ui);
 			return ui;
@@ -389,7 +389,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 		priv->difs = C_SIFS_BG + 2 * priv->slot;
 
 		for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-			if (priv->wBasicRate & ((u32)(0x1 << ii))) {
+			if (priv->basic_rates & ((u32)(0x1 << ii))) {
 				ofdm_rate = true;
 				break;
 			}
@@ -454,7 +454,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 
 	/*Determines the highest basic rate.*/
 	for (i = RATE_54M; i >= RATE_6M; i--) {
-		if (priv->wBasicRate & (u16)(1 << i)) {
+		if (priv->basic_rates & (u16)(1 << i)) {
 			top_ofdm = i;
 			break;
 		}
@@ -463,7 +463,7 @@ void vnt_update_top_rates(struct vnt_private *priv)
 	priv->byTopOFDMBasicRate = top_ofdm;
 
 	for (i = RATE_11M;; i--) {
-		if (priv->wBasicRate & (u16)(1 << i)) {
+		if (priv->basic_rates & (u16)(1 << i)) {
 			top_cck = i;
 			break;
 		}
@@ -479,7 +479,7 @@ int vnt_ofdm_min_rate(struct vnt_private *priv)
 	int ii;
 
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-		if ((priv->wBasicRate) & ((u16)(1 << ii)))
+		if ((priv->basic_rates) & ((u16)(1 << ii)))
 			return true;
 	}
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 1f9ea51..8cc33df 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -332,7 +332,7 @@ struct vnt_private {
 	/* Rate */
 	u8 bb_type; /* 0: 11A, 1:11B, 2:11G */
 	u8 packet_type; /* 0:11a 1:11b 2:11gb 3:11ga */
-	u32 wBasicRate;
+	u32 basic_rates;
 	u8 byTopOFDMBasicRate;
 	u8 byTopCCKBasicRate;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 85142b7..02898ff 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -742,7 +742,7 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		priv->wBasicRate = conf->basic_rates;
+		priv->basic_rates = conf->basic_rates;
 
 		vnt_update_top_rates(priv);
 
-- 
2.0.1

