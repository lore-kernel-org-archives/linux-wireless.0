Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53962 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab3BXBGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 06/13] brcmsmac: remove brcms_bss_cfg->up
Date: Sun, 24 Feb 2013 02:06:04 +0100
Message-Id: <1361667972-22909-7-git-send-email-hauke@hauke-m.de> (sfid-20130224_020700_165318_A0D6C95A)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was a read only member, replace it with pub->up.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    6 +++---
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 95f44b1..3985738c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7373,7 +7373,7 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	if (bsscfg->up && bsscfg->type == BRCMS_TYPE_AP)
+	if (wlc->pub->up && bsscfg->type == BRCMS_TYPE_AP)
 		/* Clear the soft intmask */
 		wlc->defmacintmask &= ~MI_BCNTPL;
 }
@@ -7448,7 +7448,7 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
 	/* update AP or IBSS probe responses */
-	if (bsscfg->up && bsscfg->type == BRCMS_TYPE_AP)
+	if (wlc->pub->up && bsscfg->type == BRCMS_TYPE_AP)
 		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
@@ -7801,7 +7801,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	brcms_c_set_bssid(wlc->bsscfg);
 
 	/* Update tsf_cfprep if associated and up */
-	if (wlc->pub->associated && wlc->bsscfg->up) {
+	if (wlc->pub->associated && wlc->pub->up) {
 		u32 bi;
 
 		/* get beacon period and convert to uS */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index e2551a7..65818e2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -587,7 +587,6 @@ enum brcms_bss_type {
  *
  * wlc: wlc to which this bsscfg belongs to.
  * type: interface type
- * up: is this configuration up operational
  * SSID_len: the length of SSID
  * SSID: SSID string
  *
@@ -604,7 +603,6 @@ enum brcms_bss_type {
 struct brcms_bss_cfg {
 	struct brcms_c_info *wlc;
 	enum brcms_bss_type type;
-	bool up;
 	u8 SSID_len;
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
 	u8 BSSID[ETH_ALEN];
-- 
1.7.10.4

