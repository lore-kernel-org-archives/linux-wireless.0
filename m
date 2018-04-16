Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57058 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754790AbeDPNQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:48 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 4/5] wcn36xx: send bss_type in scan requests
Date: Mon, 16 Apr 2018 15:16:33 +0200
Message-Id: <20180416131634.25432-5-daniel@zonque.org> (sfid-20180416_151653_324514_E556ED85)
In-Reply-To: <20180416131634.25432-1-daniel@zonque.org>
References: <20180416131634.25432-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the bss_type of the currently configured BSS in the message for the
scan request. Therefore, that setting needs to be kept in struct
wcn36xx_vif.

This seems to be only interesting when scanning for a specific SSID
and doesn't matter for regular wildcard scans.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c     | 4 +++-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index b7964f79d837..09320c3f6bd0 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -631,6 +631,7 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	msg_body.max_ch_time = 100;
 	msg_body.scan_hidden = 1;
 	memcpy(msg_body.mac, vif->addr, ETH_ALEN);
+	msg_body.bss_type = vif_priv->bss_type;
 	msg_body.p2p_search = vif->p2p;
 
 	msg_body.num_ssid = min_t(u8, req->n_ssids, ARRAY_SIZE(msg_body.ssids));
@@ -1399,9 +1400,10 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 	bss->spectrum_mgt_enable = 0;
 	bss->tx_mgmt_power = 0;
 	bss->max_tx_power = WCN36XX_MAX_POWER(wcn);
-
 	bss->action = update;
 
+	vif_priv->bss_type = bss->bss_type;
+
 	wcn36xx_dbg(WCN36XX_DBG_HAL,
 		    "hal config bss bssid %pM self_mac_addr %pM bss_type %d oper_mode %d nw_type %d\n",
 		    bss->bssid, bss->self_mac_addr, bss->bss_type,
diff --git a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
index 5854adf43f3a..22e05cb4eb98 100644
--- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
+++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
@@ -123,6 +123,7 @@ struct wcn36xx_vif {
 	bool is_joining;
 	bool sta_assoc;
 	struct wcn36xx_hal_mac_ssid ssid;
+	enum wcn36xx_hal_bss_type bss_type;
 
 	/* Power management */
 	enum wcn36xx_power_state pw_state;
-- 
2.14.3
