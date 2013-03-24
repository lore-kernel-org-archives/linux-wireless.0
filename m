Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55606 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab3CXAsT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 20:48:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 08/15] brcmsmac: remove brcms_pub->bcmerr
Date: Sun, 24 Mar 2013 01:45:56 +0100
Message-Id: <1364085963-25940-9-git-send-email-hauke@hauke-m.de> (sfid-20130324_014822_956785_4718A279)
In-Reply-To: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was a write only member

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h  |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 056ca2c..7e19295 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4325,7 +4325,6 @@ static void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 
 	/* WME QoS mode is Auto by default */
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
-	wlc->pub->bcmerror = 0;
 }
 
 static uint brcms_c_attach_module(struct brcms_c_info *wlc)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index aa8580f..9dae59c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -164,8 +164,6 @@ struct brcms_pub {
 
 	u8 cur_etheraddr[ETH_ALEN];	/* our local ethernet address */
 
-	int bcmerror;		/* last bcm error */
-
 	u32 radio_disabled;	/* bit vector for radio disabled reasons */
 
 	u16 boardrev;	/* version # of particular board */
-- 
1.7.10.4

