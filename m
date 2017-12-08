Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42879 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753260AbdLHQeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 11:34:10 -0500
Received: by mail-wr0-f193.google.com with SMTP id s66so11347103wrc.9
        for <linux-wireless@vger.kernel.org>; Fri, 08 Dec 2017 08:34:09 -0800 (PST)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, nicolas.dechesne@linaro.org,
        k.eugene.e@gmail.com, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Fix dynamic power saving
Date: Fri,  8 Dec 2017 17:34:06 +0100
Message-Id: <1512750846-13591-1-git-send-email-loic.poulain@linaro.org> (sfid-20171208_173430_812210_C500C2BB)
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

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

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
-- 
2.7.4
