Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:35590 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752253AbeEPOIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 10:08:42 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        rfried@codeaurora.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, loic.poulain@linaro.org,
        Daniel Mack <daniel@zonque.org>
Subject: [PATCH 07/10] wcn36xx: set PREASSOC and IDLE stated when BSS info changes
Date: Wed, 16 May 2018 16:08:17 +0200
Message-Id: <20180516140820.1636-8-daniel@zonque.org> (sfid-20180516_160849_247393_B907E838)
In-Reply-To: <20180516140820.1636-1-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a BSSID is joined, set the link status to 'preassoc', and set it to
'idle' when the BSS is deleted.

This is what the downstream driver is doing, and it seems to improve the
reliability during connect/disconnect stress tests.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e6330ad372b3..662e50540b07 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -798,6 +798,8 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			vif_priv->is_joining = true;
 			vif_priv->bss_index = WCN36XX_HAL_BSS_INVALID_IDX;
+			wcn36xx_smd_set_link_st(wcn, bss_conf->bssid, vif->addr,
+						WCN36XX_HAL_LINK_PREASSOC_STATE);
 			wcn36xx_smd_join(wcn, bss_conf->bssid,
 					 vif->addr, WCN36XX_HW_CHANNEL(wcn));
 			wcn36xx_smd_config_bss(wcn, vif, NULL,
@@ -805,6 +807,8 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 		} else {
 			vif_priv->is_joining = false;
 			wcn36xx_smd_delete_bss(wcn, vif);
+			wcn36xx_smd_set_link_st(wcn, bss_conf->bssid, vif->addr,
+						WCN36XX_HAL_LINK_IDLE_STATE);
 			vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE;
 		}
 	}
-- 
2.14.3
