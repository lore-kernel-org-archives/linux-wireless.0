Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3751 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/19] brcm80211: smac: don't modify sta parameters when
 adding sta
Date: Thu, 10 Nov 2011 20:30:20 +0100
Message-ID: <1320953434-16859-7-git-send-email-arend@broadcom.com> (sfid-20111110_203124_354175_7306A763)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 8655bd8..8457e96 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -620,13 +620,6 @@ brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	wl->pub->global_ampdu->scb = scb;
 	wl->pub->global_ampdu->max_pdu = 16;
 
-	sta->ht_cap.ht_supported = true;
-	sta->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
-	sta->ht_cap.ampdu_density = AMPDU_DEF_MPDU_DENSITY;
-	sta->ht_cap.cap = IEEE80211_HT_CAP_GRN_FLD |
-	    IEEE80211_HT_CAP_SGI_20 |
-	    IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT;
-
 	/*
 	 * minstrel_ht initiates addBA on our behalf by calling
 	 * ieee80211_start_tx_ba_session()
-- 
1.7.5.4


