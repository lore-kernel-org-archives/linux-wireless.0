Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40403 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKIw0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 03:52:26 -0500
Received: by mail-wm0-f68.google.com with SMTP id f206so12523823wmf.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 00:52:25 -0800 (PST)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, k.eugene.e@gmail.com,
        bjorn.andersson@linaro.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2] wcn36xx: Fix dynamic power saving
Date: Mon, 11 Dec 2017 09:52:22 +0100
Message-Id: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org> (sfid-20171211_095229_121183_2E767E0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since driver does not report hardware dynamic power saving cap,
this is up to the mac80211 to manage power saving timeout and
state machine, using the ieee80211 config callback to report
PS changes. This patch enables/disables PS mode according to
the new configuration.

Remove old behaviour enabling PS mode in a static way, this make
the device unusable when power save is enabled since device is
forced to PS regardless RX/TX traffic.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: remove error msg on unbalanced bmps exit
     return -EALREADY if not in bmps mode

 drivers/net/wireless/ath/wcn36xx/main.c | 23 ++++++++++++-----------
 drivers/net/wireless/ath/wcn36xx/pmc.c  |  6 ++++--
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index f0b4d43..436b8ea 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -384,6 +384,18 @@ static int wcn36xx_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		list_for_each_entry(tmp, &wcn->vif_list, list) {
+			vif = wcn36xx_priv_to_vif(tmp);
+			if (hw->conf.flags & IEEE80211_CONF_PS) {
+				if (vif->bss_conf.ps) /* ps allowed ? */
+					wcn36xx_pmc_enter_bmps_state(wcn, vif);
+			} else {
+				wcn36xx_pmc_exit_bmps_state(wcn, vif);
+			}
+		}
+	}
+
 	mutex_unlock(&wcn->conf_mutex);
 
 	return 0;
@@ -747,17 +759,6 @@ static void wcn36xx_bss_info_changed(struct ieee80211_hw *hw,
 		vif_priv->dtim_period = bss_conf->dtim_period;
 	}
 
-	if (changed & BSS_CHANGED_PS) {
-		wcn36xx_dbg(WCN36XX_DBG_MAC,
-			    "mac bss PS set %d\n",
-			    bss_conf->ps);
-		if (bss_conf->ps) {
-			wcn36xx_pmc_enter_bmps_state(wcn, vif);
-		} else {
-			wcn36xx_pmc_exit_bmps_state(wcn, vif);
-		}
-	}
-
 	if (changed & BSS_CHANGED_BSSID) {
 		wcn36xx_dbg(WCN36XX_DBG_MAC, "mac bss changed_bssid %pM\n",
 			    bss_conf->bssid);
diff --git a/drivers/net/wireless/ath/wcn36xx/pmc.c b/drivers/net/wireless/ath/wcn36xx/pmc.c
index 589fe5f..1976b80 100644
--- a/drivers/net/wireless/ath/wcn36xx/pmc.c
+++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
@@ -45,8 +45,10 @@ int wcn36xx_pmc_exit_bmps_state(struct wcn36xx *wcn,
 	struct wcn36xx_vif *vif_priv = wcn36xx_vif_to_priv(vif);
 
 	if (WCN36XX_BMPS != vif_priv->pw_state) {
-		wcn36xx_err("Not in BMPS mode, no need to exit from BMPS mode!\n");
-		return -EINVAL;
+		/* Unbalanced call or last BMPS enter failed */
+		wcn36xx_dbg(WCN36XX_DBG_PMC,
+			    "Not in BMPS mode, no need to exit\n");
+		return -EALREADY;
 	}
 	wcn36xx_smd_exit_bmps(wcn, vif);
 	vif_priv->pw_state = WCN36XX_FULL_POWER;
-- 
2.7.4
