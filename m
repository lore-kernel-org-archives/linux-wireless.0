Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:16374 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753516Ab2KYWTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 17:19:51 -0500
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] mac80211: in ADHOC don't update last_rx if sta is not authorized
Date: Sun, 25 Nov 2012 23:13:42 +0100
Message-ID: <1353881622-9279-1-git-send-email-antonio@open-mesh.com> (sfid-20121125_231954_337661_A61C251A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not make sense to keep a station alive if it is not authorised
at all. If IBSS/RSN is used it could also be the case that something
went wrong during the keys exchange and the stations ended up in a not
recoverable state.

By not updating last_rx we are giving the station a chance to be
deleted and to start the key exchange once again from scratch.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/mac80211/rx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ec15a49..7dee98b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1338,13 +1338,17 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 
 	/*
 	 * Update last_rx only for IBSS packets which are for the current
-	 * BSSID to avoid keeping the current IBSS network alive in cases
-	 * where other STAs start using different BSSID.
+	 * BSSID and for station already AUTHORIZED to avoid keeping the
+	 * current IBSS network alive in cases where other STAs start
+	 * using different BSSID. This will also give the station another
+	 * chance to restart the authentication/authorization in case
+	 * something went wrong the first time.
 	 */
 	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
-		if (ether_addr_equal(bssid, rx->sdata->u.ibss.bssid)) {
+		if (ether_addr_equal(bssid, rx->sdata->u.ibss.bssid) &&
+		    test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			sta->last_rx = jiffies;
 			if (ieee80211_is_data(hdr->frame_control)) {
 				sta->last_rx_rate_idx = status->rate_idx;
-- 
1.8.0

