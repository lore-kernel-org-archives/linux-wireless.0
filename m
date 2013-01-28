Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42838 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab3A1QMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:12:34 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	ordex@autistici.org, simon.wunderlich@s2003.tu-chemnitz.de,
	rgibson@futurec.net, Sven Eckelmann <sven@narfation.org>
Subject: [RFC 2/3] mac80211: Ignore CCMP replays for IBSS WPA_NONE
Date: Mon, 28 Jan 2013 17:11:52 +0100
Message-Id: <1359389513-1554-2-git-send-email-sven@narfation.org> (sfid-20130128_171236_615117_CDF88F32)
In-Reply-To: <1359389513-1554-1-git-send-email-sven@narfation.org>
References: <30210911.93HAZKKtRJ@bentobox>
 <1359389513-1554-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WPA_NONE has no support to avoid CCMP replays and therefore we have to disable
it in this situation to allow rejoining stations.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/mac80211/wpa.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index c175ee8..f961d9a 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -517,7 +517,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	queue = rx->security_idx;
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) <= 0) {
+	if (memcmp(pn, key->u.ccmp.rx_pn[queue], CCMP_PN_LEN) <= 0 &&
+	    (rx->sdata->vif.type != NL80211_IFTYPE_ADHOC ||
+	     rx->sdata->u.ibss.control_port)) {
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
-- 
1.7.10.4

