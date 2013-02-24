Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53942 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413Ab3BXBGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 03/13] brcmsmac: remove brcms_bss_cfg->BSS
Date: Sun, 24 Feb 2013 02:06:01 +0100
Message-Id: <1361667972-22909-4-git-send-email-hauke@hauke-m.de> (sfid-20130224_020659_378967_A01CD3A9)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was a read only member. The checks using BSS are replaced by
better fitting checks of the new type member.

The change in brcms_c_tbtt() was based on code from b43, in
brcms_c_ps_allowed() the same happens with BSS being true or false,
beaconing and probe responses are just needed in ap mode.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   21 +++++++--------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5696257..2242ec0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1069,7 +1069,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 
 static void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
-	if (!wlc->bsscfg->BSS)
+	if (wlc->bsscfg->type == BRCMS_TYPE_ADHOC)
 		/*
 		 * DirFrmQ is now valid...defer setting until end
 		 * of ATIM window
@@ -3059,16 +3059,8 @@ static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
 		return false;
 
-	if (cfg->associated) {
-		/*
-		 * disallow PS when one of the following
-		 * bsscfg specific conditions meets
-		 */
-		if (!cfg->BSS)
-			return false;
-
+	if (cfg->associated)
 		return false;
-	}
 
 	return true;
 }
@@ -5078,8 +5070,9 @@ int brcms_c_up(struct brcms_c_info *wlc)
 				struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
-
-				if (bsscfg->enable && bsscfg->BSS)
+				if (bsscfg->enable &&
+				    (bsscfg->type == BRCMS_TYPE_STATION ||
+				     bsscfg->type == BRCMS_TYPE_ADHOC))
 					brcms_err(wlc->hw->d11core,
 						  "wl%d: up: rfdisable -> "
 						  "bsscfg_disable()\n",
@@ -7386,7 +7379,7 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	if (bsscfg->up && !bsscfg->BSS)
+	if (bsscfg->up && bsscfg->type == BRCMS_TYPE_AP)
 		/* Clear the soft intmask */
 		wlc->defmacintmask &= ~MI_BCNTPL;
 }
@@ -7461,7 +7454,7 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
 	/* update AP or IBSS probe responses */
-	if (bsscfg->up && !bsscfg->BSS)
+	if (bsscfg->up && bsscfg->type == BRCMS_TYPE_AP)
 		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index dbf027c..0cfe782 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -590,7 +590,6 @@ enum brcms_bss_type {
  * up: is this configuration up operational
  * enable: is this configuration enabled
  * associated: is BSS in ASSOCIATED state
- * BSS: infraustructure or adhoc
  * SSID_len: the length of SSID
  * SSID: SSID string
  *
@@ -610,7 +609,6 @@ struct brcms_bss_cfg {
 	bool up;
 	bool enable;
 	bool associated;
-	bool BSS;
 	u8 SSID_len;
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
 	u8 BSSID[ETH_ALEN];
-- 
1.7.10.4

