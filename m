Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35814 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdBOTBv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 14:01:51 -0500
Received: by mail-wr0-f194.google.com with SMTP id q39so1665519wrb.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 11:01:51 -0800 (PST)
From: Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org, andra.paraschiv7@gmail.com,
        costin.raiciu@cs.pub.ro, dragos.niculescu@cs.pub.ro
Cc: Doru Gucea <gucea.doru@gmail.com>
Subject: [PATCH 2/2] ath9k_htc: Adjust beacon timers for power save
Date: Wed, 15 Feb 2017 21:01:43 +0200
Message-Id: <1487185303-8700-1-git-send-email-gucea.doru@gmail.com> (sfid-20170215_200154_095648_81EA35DC)
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
 drivers/net/wireless/ath/ath9k/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c27143b..d2934e1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1749,6 +1749,10 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	ath9k_ps_wakeup(sc);
 	mutex_lock(&sc->mutex);
 
+	/* adjust beacon timers */
+	if (changed && BSS_CHANGED_BEACON_INFO)
+		ath9k_htc_beacon_config(priv, vif);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		ath_dbg(common, CONFIG, "BSSID %pM Changed ASSOC %d\n",
 			bss_conf->bssid, bss_conf->assoc);
-- 
1.9.1
