Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51392 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab0LEEoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 23:44:21 -0500
Date: Sat, 4 Dec 2010 20:44:15 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: RSN IBSS and GTK configuration
Message-ID: <20101205044415.GA12705@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since mac80211/cfg80211 is now supposed to have more or less everything
that is needed for RSN IBSS to work, I tried to get the final pieces
implemented. wpa_supplicant is now using the new STA event to trigger
4-way handshakes with other STAs in the IBSS (that works fine) and tries
to configure the per-STA RX GTK (that does not work for some reason).

What should be used as parameters for the new key for this per-STA RX
GTK? I'm now trying to use an individual address (the peer), non-zero
key index, and key type set to group. At least this not overriding our
own TX GTK anymore, but the new key is not set either (EINVAL).

As far as actually being able to complete the 4-way handshakes is
concerned, there is an issue in how we select the TX key. In the RSN
IBSS case, there is a STA entry for the recipient of the EAPOL frame,
but that STA entry does not have a key. We end up using the default key
(our TX GTK) and obviously, the peer has no way of processing this frame
at this point.. I'm currently using the following change to work around
this. This is not exactly correct, but I did not yet have a chance to
think through all the cases to figure out if something cleaner would
cause problems for non-IBSS cases and WEP IBSS cases..

Anyway, with this patch, 4-way handshakes can be completed successfully
and the PTK works, i.e., I can ping successfully with manually
configured ARP table.


---
 net/mac80211/tx.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-12-04 18:27:39.000000000 -0800
+++ wireless-testing/net/mac80211/tx.c	2010-12-04 18:53:13.000000000 -0800
@@ -539,14 +539,17 @@ ieee80211_tx_h_select_key(struct ieee802
 		 ieee80211_is_robust_mgmt_frame(hdr) &&
 		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
 		tx->key = key;
-	else if ((key = rcu_dereference(tx->sdata->default_key)))
+	else if ((key = rcu_dereference(tx->sdata->default_key))) {
 		tx->key = key;
-	else if (tx->sdata->drop_unencrypted &&
-		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
-		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
-		  (ieee80211_is_action(hdr->frame_control) &&
-		   tx->sta && test_sta_flags(tx->sta, WLAN_STA_MFP)))) {
+		if (tx->sta && tx->sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+		    tx->skb->protocol == tx->sdata->control_port_protocol)
+			tx->key = NULL;
+	} else if (tx->sdata->drop_unencrypted &&
+		   (tx->skb->protocol != tx->sdata->control_port_protocol) &&
+		   !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+		   (!ieee80211_is_robust_mgmt_frame(hdr) ||
+		    (ieee80211_is_action(hdr->frame_control) &&
+		     tx->sta && test_sta_flags(tx->sta, WLAN_STA_MFP)))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else

-- 
Jouni Malinen                                            PGP id EFC895FA
