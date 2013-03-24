Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55593 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3CXAsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:11 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 06/15] brcmsmac: remove brcms_bss_cfg->up
Date: Sun, 24 Mar 2013 01:45:54 +0100
Message-Id: <1364085963-25940-7-git-send-email-hauke@hauke-m.de> (sfid-20130324_014815_672190_F1C8C577)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was a read only member, replace it with pub->up.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   10 +++++-----
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index ca1c585..9af5851 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7373,8 +7373,8 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
-			   bsscfg->type == BRCMS_TYPE_ADHOC))
+	if (wlc->pub->up && (bsscfg->type == BRCMS_TYPE_AP ||
+			     bsscfg->type == BRCMS_TYPE_ADHOC))
 		/* Clear the soft intmask */
 		wlc->defmacintmask &= ~MI_BCNTPL;
 }
@@ -7449,8 +7449,8 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
 	/* update AP or IBSS probe responses */
-	if (bsscfg->up && (bsscfg->type == BRCMS_TYPE_AP ||
-			   bsscfg->type == BRCMS_TYPE_ADHOC))
+	if (wlc->pub->up && (bsscfg->type == BRCMS_TYPE_AP ||
+			     bsscfg->type == BRCMS_TYPE_ADHOC))
 		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
@@ -7803,7 +7803,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
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

