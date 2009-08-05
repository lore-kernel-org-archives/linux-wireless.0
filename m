Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58624 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932677AbZHEAQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 20:16:48 -0400
Message-ID: <4A78CF6E.6080903@gmx.de>
Date: Wed, 05 Aug 2009 02:16:46 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [PATCH 2/2] ar9170: remove unnecessary calls to ar9170_set_beacon_timers
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ar9170_op_remove_interface: mac80211 calls us before with
   BSS_CHANGED_BEACON_ENABLED set and bss_conf->enable_beacon == 0
ar9170_op_config: this was a bogus call; mac80211 never sets
   BSS_CHANGED_BEACON_ENABLED here

Signed-off-by: Joerg Albert <jal2@gmx.de>
---
 drivers/net/wireless/ath/ar9170/main.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index d51b6ad..693a999 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1990,7 +1990,6 @@ static void ar9170_op_remove_interface(struct ieee80211_hw *hw,
 	ar->vif = NULL;
 	ar->want_filter = 0;
 	ar9170_update_frame_filter(ar);
-	ar9170_set_beacon_timers(ar);
 	dev_kfree_skb(ar->beacon);
 	ar->beacon = NULL;
 	ar->sniffer_enabled = false;
@@ -2032,12 +2031,6 @@ static int ar9170_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out;
 	}
 
-	if (changed & BSS_CHANGED_BEACON_INT) {
-		err = ar9170_set_beacon_timers(ar);
-		if (err)
-			goto out;
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 
 		/* adjust slot time for 5 GHz */
-- 
1.6.0.4

