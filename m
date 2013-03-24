Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55596 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 07/15] brcmsmac: remove brcms_bss_cfg->cur_etheraddr
Date: Sun, 24 Mar 2013 01:45:55 +0100
Message-Id: <1364085963-25940-8-git-send-email-hauke@hauke-m.de> (sfid-20130324_014817_914052_77723CD1)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use brcms_pub->cur_etheraddr instead

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9af5851..056ca2c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3764,7 +3764,7 @@ static int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 	struct brcms_c_info *wlc = bsscfg->wlc;
 
 	/* enter the MAC addr into the RXE match registers */
-	brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, bsscfg->cur_etheraddr);
+	brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, wlc->pub->cur_etheraddr);
 
 	brcms_c_ampdu_macaddr_upd(wlc);
 
@@ -7355,7 +7355,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == IEEE80211_STYPE_BEACON)
 		memcpy(&h->da, &ether_bcast, ETH_ALEN);
-	memcpy(&h->sa, &cfg->cur_etheraddr, ETH_ALEN);
+	memcpy(&h->sa, &wlc->pub->cur_etheraddr, ETH_ALEN);
 	memcpy(&h->bssid, &cfg->BSSID, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 65818e2..397cff3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -606,7 +606,6 @@ struct brcms_bss_cfg {
 	u8 SSID_len;
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
 	u8 BSSID[ETH_ALEN];
-	u8 cur_etheraddr[ETH_ALEN];
 	struct brcms_bss_info *current_bss;
 };
 
-- 
1.7.10.4

