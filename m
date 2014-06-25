Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:60201 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaFYUPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:35 -0400
Received: by mail-we0-f171.google.com with SMTP id q58so2573984wes.16
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:33 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/17] staging: vt6656: mac80211 conversion: int.c changes
Date: Wed, 25 Jun 2014 21:14:32 +0100
Message-Id: <1403727278-6666-12-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221605_010994_823BE227)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove BSSvUpdateNodeTxCounter which is not used. net_device_stats and wsats
will be removed later.

Change handling of ISR_BNTX to mac80211

Change handling of ISR_TBTT. Use IEEE80211_CONF_PS for WLAN_CMD_TBTT_WAKEUP
disable bChannelSwitch this is yet to be done.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 49 ++++++--------------------------------------
 1 file changed, 6 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index f2a5225..b717ace 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -80,7 +80,6 @@ void INTvWorkItem(struct vnt_private *pDevice)
 void INTnsProcessData(struct vnt_private *priv)
 {
 	struct vnt_interrupt_data *int_data;
-	struct vnt_manager *mgmt = &priv->vnt_mgmt;
 	struct net_device_stats *stats = &priv->stats;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
@@ -92,10 +91,6 @@ void INTnsProcessData(struct vnt_private *priv)
 			priv->wstats.discard.retries++;
 		else
 			stats->tx_packets++;
-
-		BSSvUpdateNodeTxCounter(priv,
-					int_data->tsr0,
-					int_data->pkt0);
 	}
 
 	if (int_data->tsr1 & TSR_VALID) {
@@ -103,11 +98,6 @@ void INTnsProcessData(struct vnt_private *priv)
 			priv->wstats.discard.retries++;
 		else
 			stats->tx_packets++;
-
-
-		BSSvUpdateNodeTxCounter(priv,
-					int_data->tsr1,
-					int_data->pkt1);
 	}
 
 	if (int_data->tsr2 & TSR_VALID) {
@@ -115,10 +105,6 @@ void INTnsProcessData(struct vnt_private *priv)
 			priv->wstats.discard.retries++;
 		else
 			stats->tx_packets++;
-
-		BSSvUpdateNodeTxCounter(priv,
-					int_data->tsr2,
-					int_data->pkt2);
 	}
 
 	if (int_data->tsr3 & TSR_VALID) {
@@ -126,43 +112,19 @@ void INTnsProcessData(struct vnt_private *priv)
 			priv->wstats.discard.retries++;
 		else
 			stats->tx_packets++;
-
-		BSSvUpdateNodeTxCounter(priv,
-					int_data->tsr3,
-					int_data->pkt3);
 	}
 
 	if (int_data->isr0 != 0) {
-		if (int_data->isr0 & ISR_BNTX) {
-			if (priv->op_mode == NL80211_IFTYPE_AP) {
-				if (mgmt->byDTIMCount > 0) {
-					mgmt->byDTIMCount--;
-					mgmt->sNodeDBTable[0].bRxPSPoll =
-						false;
-				} else if (mgmt->byDTIMCount == 0) {
-					/* check if multicast tx buffering */
-					mgmt->byDTIMCount =
-						mgmt->byDTIMPeriod-1;
-					mgmt->sNodeDBTable[0].bRxPSPoll = true;
-					if (mgmt->sNodeDBTable[0].bPSEnable)
-						bScheduleCommand((void *) priv,
-								 WLAN_CMD_RX_PSPOLL,
-								 NULL);
-				}
-				bScheduleCommand((void *) priv,
-						WLAN_CMD_BECON_SEND,
-						NULL);
-			}
-			priv->bBeaconSent = true;
-		} else {
-			priv->bBeaconSent = false;
-		}
+		if (int_data->isr0 & ISR_BNTX &&
+				priv->op_mode == NL80211_IFTYPE_AP)
+			bScheduleCommand(priv, WLAN_CMD_BECON_SEND, NULL);
 
 		if (int_data->isr0 & ISR_TBTT) {
-			if (priv->bEnablePSMode)
+			if (priv->hw->conf.flags & IEEE80211_CONF_PS)
 				bScheduleCommand((void *) priv,
 						WLAN_CMD_TBTT_WAKEUP,
 						NULL);
+#if 0 /* TODO channel switch */
 			if (priv->bChannelSwitch) {
 				priv->byChannelSwitchCount--;
 				if (priv->byChannelSwitchCount == 0)
@@ -170,6 +132,7 @@ void INTnsProcessData(struct vnt_private *priv)
 							WLAN_CMD_11H_CHSW,
 							NULL);
 			}
+#endif
 		}
 		priv->qwCurrTSF = le64_to_cpu(int_data->tsf);
 	}
-- 
1.9.1

