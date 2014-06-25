Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63465 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFYUPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:39 -0400
Received: by mail-wg0-f44.google.com with SMTP id x13so2611585wgg.15
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/17] staging: vt6656: mac80211 conversion: change vnt_rf_set_txpower
Date: Wed, 25 Jun 2014 21:14:35 +0100
Message-Id: <1403727278-6666-15-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221608_108505_FDF648AC)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove old eScanState code and use.

priv->hw->conf.chandef.chan->hw_value to find current channel

Check hw_value for bounds of vt3226d0_lo_current_table

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3f54ae3..6bfd272 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -891,6 +891,8 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			return false;
 
 		if (rate <= RATE_11M) {
+			u16 hw_value = priv->hw->conf.chandef.chan->hw_value;
+
 			power_setting = ((0x3f-priv->byCurPwr) << 20) |
 				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
 						IFREGCTL_REGW;
@@ -899,21 +901,14 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			ret &= vnt_rf_write_embedded(priv, 0x03c6a200 +
 					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
 
-			if (priv->vnt_mgmt.eScanState != WMAC_NO_SCANNING) {
-				dev_dbg(&priv->usb->dev,
-				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
-						priv->vnt_mgmt.uScanChannel);
-				ret &= vnt_rf_write_embedded(priv,
-					vt3226d0_lo_current_table[priv->
-						vnt_mgmt.uScanChannel - 1]);
-			} else {
-				dev_dbg(&priv->usb->dev,
-				"vnt_rf_set_txpower> 11B mode uCurrChannel[%d]\n",
-						priv->vnt_mgmt.uCurrChannel);
+			dev_dbg(&priv->usb->dev,
+				"%s 11b channel [%d]\n", __func__, hw_value);
+
+			hw_value--;
+
+			if (hw_value < ARRAY_SIZE(vt3226d0_lo_current_table))
 				ret &= vnt_rf_write_embedded(priv,
-					vt3226d0_lo_current_table[priv->
-						vnt_mgmt.uCurrChannel - 1]);
-			}
+					vt3226d0_lo_current_table[hw_value]);
 
 			ret &= vnt_rf_write_embedded(priv, 0x015C0800 +
 				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
-- 
1.9.1

