Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36042 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbdBNTgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 14:36:45 -0500
Received: by mail-wr0-f193.google.com with SMTP id k90so28690648wrc.3
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 11:36:44 -0800 (PST)
From: Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k_htc_fw@lists.infradead.org,
        andra.paraschiv7@gmail.com, costin.raiciu@cs.pub.ro,
        dragos.niculescu@cs.pub.ro
Cc: Doru Gucea <gucea.doru@gmail.com>
Subject: [RFC-PATCH] ath9k_htc: Adjust beacon timers for Power Save
Date: Tue, 14 Feb 2017 21:36:25 +0200
Message-Id: <1487100985-4194-1-git-send-email-gucea.doru@gmail.com> (sfid-20170214_203842_791563_CDB1D16C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Doru Gucea <gucea.doru@gmail.com>

Each time we receive a beacon we need to adjust the hardware
timers for next DTIM and next TBTT.

Before this commit, the Power Save behaviour was incorrect.
The scenario was:
- STA receives a beacon from AP with TIM unset;
- mac80211 layers puts the chip to sleep;
- chip is woken up by mac80211's software timer reponsible for
beacon miss after 7 * beacon_interval period.

Normally the chip should sleep at most DTIM period. This commit
configures hardware timers for waking up the chip correctly.

More details on the wiki:
https://github.com/doru91/linux-stable/wiki/Single-Interface-Power-Save

Signed-off-by: Doru Gucea <gucea.doru@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
 net/mac80211/mlme.c                           | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 172a9ff..59a76e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1521,6 +1521,10 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
+	/* adjust beacon timers */
+	if (changed && BSS_CHANGED_BEACON_INFO)
+		ath9k_htc_beacon_config(priv, vif);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		ath_dbg(common, CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd7e55e..ce92a39 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3536,6 +3536,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.bss_conf.sync_dtim_count = 0;
 	}
 
+	/* trigger hardware timers adjustment
+	 * this needs to be done before beacon filtering
+	 */
+	changed |= BSS_CHANGED_BEACON_INFO;
+	ieee80211_bss_info_change_notify(sdata, changed);
+
 	if (ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid)
 		return;
 	ifmgd->beacon_crc = ncrc;
-- 
1.9.1
