Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38033 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbZESOCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:39 -0400
Message-Id: <20090519140232.813904147@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:42 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 5/7] ath9k: Set PM field in frame control when in PS mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 does not set PM field for normal data frames, so we need to
update that based on the current PS mode when using PS-Poll
(timeout=0) power save mode.

This allows the AP to remain in sync with our PS state. However, there
is still a potential race condition between PS state changes when
multiple TX queues are used and nullfunc and PS-Poll frames use
different queue. That corner case may need to be handled separately by
changing which queue is used either in ath9k or mac80211.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:35.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:37.000000000 +0300
@@ -2088,6 +2088,21 @@ static int ath9k_tx(struct ieee80211_hw 
 		goto exit;
 	}
 
+	if (sc->hw->conf.flags & IEEE80211_CONF_PS) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		/*
+		 * mac80211 does not set PM field for normal data frames, so we
+		 * need to update that based on the current PS mode.
+		 */
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    !ieee80211_is_nullfunc(hdr->frame_control) &&
+		    !ieee80211_has_pm(hdr->frame_control)) {
+			DPRINTF(sc, ATH_DBG_PS, "Add PM=1 for a TX frame "
+				"while in PS mode\n");
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+		}
+	}
+
 	if (unlikely(sc->sc_ah->power_mode != ATH9K_PM_AWAKE)) {
 		/*
 		 * We are using PS-Poll and mac80211 can request TX while in

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
