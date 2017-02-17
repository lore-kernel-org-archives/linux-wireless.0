Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35036 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934780AbdBQUyO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 15:54:14 -0500
Received: by mail-wm0-f66.google.com with SMTP id u63so4467348wmu.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Feb 2017 12:54:13 -0800 (PST)
From: Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, andra.paraschiv7@gmail.com,
        costin.raiciu@cs.pub.ro, dragos.niculescu@cs.pub.ro
Cc: Doru Gucea <gucea.doru@gmail.com>
Subject: [RFC PATCH 2/2 v2] ath9k_htc: Adjust beacon timers for power save
Date: Fri, 17 Feb 2017 22:54:06 +0200
Message-Id: <1487364846-4675-1-git-send-email-gucea.doru@gmail.com> (sfid-20170217_215417_235029_DC65E7CE)
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

Changelog

v1:
* moved beacon configuration call in the ath9k_htc driver

Signed-off-by: Doru Gucea <gucea.doru@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a553c91..5403399 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1518,6 +1518,10 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
+	/* adjust beacon timers */
+	if (changed && BSS_CHANGED_BEACON_INFO)
+		ath9k_htc_beacon_config(priv, vif);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		ath_dbg(common, CONFIG, "BSS Changed ASSOC %d\n",
 			bss_conf->assoc);
-- 
1.9.1
