Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXHJXqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 19:46:25 -0400
Subject: [PATCH] mac80211: remove special casing of EAPOL on mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sat, 11 Aug 2007 01:48:57 +0200
Message-Id: <1186789737.4862.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes sending EAPOL frames to the management interface and
sends them to the regular ethernet interface instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-11 00:45:05.647838974 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-11 01:45:58.517838974 +0200
@@ -837,15 +837,8 @@ static ieee80211_txrx_result
 ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
 {
 	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
-	    rx->sdata->type != IEEE80211_IF_TYPE_STA && rx->u.rx.ra_match) {
-		/* Pass both encrypted and unencrypted EAPOL frames to user
-		 * space for processing. */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
-		return TXRX_QUEUED;
-	}
+	    rx->sdata->type != IEEE80211_IF_TYPE_STA && rx->u.rx.ra_match)
+		return TXRX_CONTINUE;
 
 	if (unlikely(rx->sdata->ieee802_1x &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&


