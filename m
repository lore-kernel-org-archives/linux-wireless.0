Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51529 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbaFYUPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:32 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so2654251wev.6
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/17] staging: vt6656: mac80211 conversion: change vnt_next_tbtt_wakeup
Date: Wed, 25 Jun 2014 21:14:31 +0100
Message-Id: <1403727278-6666-11-git-send-email-tvboxspy@gmail.com> (sfid-20140625_223021_240548_EA8EFCE7)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wake up to listen to next beacon when struct ieee80211_conf -> listen_interval == 1

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 6c34d36..ace0cba 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -293,25 +293,15 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
 
 int vnt_next_tbtt_wakeup(struct vnt_private *priv)
 {
-	struct vnt_manager *mgmt = &priv->vnt_mgmt;
+	struct ieee80211_hw *hw = priv->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	int wake_up = false;
 
-	if (mgmt->wListenInterval >= 2) {
-		if (mgmt->wCountToWakeUp == 0)
-			mgmt->wCountToWakeUp = mgmt->wListenInterval;
-
-		mgmt->wCountToWakeUp--;
-
-		if (mgmt->wCountToWakeUp == 1) {
-			/* Turn on wake up to listen next beacon */
-			vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
-			priv->bPSRxBeacon = false;
-			wake_up = true;
-		} else if (!priv->bPSRxBeacon) {
-			/* Listen until RxBeacon */
-			vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
-		}
+	if (conf->listen_interval == 1) {
+		/* Turn on wake up to listen next beacon */
+		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
+		wake_up = true;
 	}
+
 	return wake_up;
 }
-
-- 
1.9.1

