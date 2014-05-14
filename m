Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53790 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaENJIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 05:08:52 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k_htc: Stop ANI before doing hw_reset
Date: Wed, 14 May 2014 14:39:21 +0530
Message-ID: <1400058561-13411-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140514_110857_864414_EE75E541)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During remain on channel request, ANI worker thread is not stopped
before doing hw reset. This is causing kernel crash in
hw_per_calibration. This change ensures that ANI is stopped before
doing chip reset and it will be rescheduled later when the chip is
configured back to home channel and having valid bss.

Reported-by: David Herrmann <dh.herrmann@gmail.com>
Tested-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f46cd02..5627917 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -95,8 +95,10 @@ static void ath9k_htc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 	if ((vif->type == NL80211_IFTYPE_AP ||
 	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
-	    bss_conf->enable_beacon)
+	    bss_conf->enable_beacon) {
 		priv->reconfig_beacon = true;
+		priv->rearm_ani = true;
+	}
 
 	if (bss_conf->assoc) {
 		priv->rearm_ani = true;
@@ -257,6 +259,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	ath9k_htc_ps_wakeup(priv);
 
+	ath9k_htc_stop_ani(priv);
 	del_timer_sync(&priv->tx.cleanup_timer);
 	ath9k_htc_tx_drain(priv);
 
-- 
1.9.2

