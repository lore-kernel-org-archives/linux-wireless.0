Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53950 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab3BXBGu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 20:06:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC 05/13] brcmsmac: remove brcms_bss_cfg->enable
Date: Sun, 24 Feb 2013 02:06:03 +0100
Message-Id: <1361667972-22909-6-git-send-email-hauke@hauke-m.de> (sfid-20130224_020658_055423_2A42B9B4)
In-Reply-To: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was a read only member.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    5 ++---
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b5b7a8f..95f44b1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5065,9 +5065,8 @@ int brcms_c_up(struct brcms_c_info *wlc)
 				struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
-				if (bsscfg->enable &&
-				    (bsscfg->type == BRCMS_TYPE_STATION ||
-				     bsscfg->type == BRCMS_TYPE_ADHOC))
+				if (bsscfg->type == BRCMS_TYPE_STATION ||
+				    bsscfg->type == BRCMS_TYPE_ADHOC)
 					brcms_err(wlc->hw->d11core,
 						  "wl%d: up: rfdisable -> "
 						  "bsscfg_disable()\n",
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 96dc2f4..e2551a7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -588,7 +588,6 @@ enum brcms_bss_type {
  * wlc: wlc to which this bsscfg belongs to.
  * type: interface type
  * up: is this configuration up operational
- * enable: is this configuration enabled
  * SSID_len: the length of SSID
  * SSID: SSID string
  *
@@ -606,7 +605,6 @@ struct brcms_bss_cfg {
 	struct brcms_c_info *wlc;
 	enum brcms_bss_type type;
 	bool up;
-	bool enable;
 	u8 SSID_len;
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
 	u8 BSSID[ETH_ALEN];
-- 
1.7.10.4

