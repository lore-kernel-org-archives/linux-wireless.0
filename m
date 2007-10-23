Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3363 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXJWWJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 18:09:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, flamingice@sourmilk.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] mac80211: no decrypt failed complaint if frame may not be for us
Date: Tue, 23 Oct 2007 17:46:21 -0400
Message-Id: <11931759811502-git-send-email-linville@tuxdriver.com> (sfid-20071023_230945_100389_1F2C6A14)
In-Reply-To: <1193175981828-git-send-email-linville@tuxdriver.com>
References: <1193175981828-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

Please see changelog entry for "mac80211: no missing key complaint if
frame may not be for us" for background information.

If multiple protected SSIDs share a BSSID, then each will see the
other's encrypted multicast traffic.  Rather than complain about being
unable to decrypt multicast traffic which may not be for us, just keep
quiet.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/wep.c |   11 ++++++++++-
 net/mac80211/wpa.c |   27 +++++++++++++++++++++------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6675261..4b75ccb 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -311,6 +311,8 @@ u8 * ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
 ieee80211_txrx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
 	    ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT ||
 	     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_AUTH))
@@ -318,7 +320,14 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_txrx_data *rx)
 
 	if (!(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) {
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key)) {
-			if (net_ratelimit())
+			/* if there are multiple SSIDs on this BSSID,
+			   the frame may not be for us anyway; so, check
+			   that either the frame is unicast or that we
+			   are not in managed mode before complaining
+			   about a missing key */
+			if ((!is_multicast_ether_addr(hdr->addr1) ||
+			     rx->sdata->type != IEEE80211_IF_TYPE_STA) &&
+			    net_ratelimit())
 				printk(KERN_DEBUG "%s: RX WEP frame, decrypt "
 				       "failed\n", rx->dev->name);
 			return TXRX_DROP;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0b32ab6..2d5bf83 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -321,9 +321,16 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_txrx_data *rx)
 					  &rx->u.rx.tkip_iv32,
 					  &rx->u.rx.tkip_iv16);
 	if (res != TKIP_DECRYPT_OK || wpa_test) {
-		printk(KERN_DEBUG "%s: TKIP decrypt failed for RX frame from "
-		       MAC_FMT " (res=%d)\n",
-		       rx->dev->name, MAC_ARG(rx->sta->addr), res);
+		/* if there are multiple SSIDs on this BSSID, the
+		   frame may not be for us anyway; so, check that either
+		   the frame is unicast or that we are not in managed
+		   mode before complaining about a missing key */
+		if ((!is_multicast_ether_addr(hdr->addr1) ||
+		     rx->sdata->type != IEEE80211_IF_TYPE_STA) &&
+		    net_ratelimit())
+			printk(KERN_DEBUG "%s: TKIP decrypt failed for RX "
+			       "frame from " MAC_FMT " (res=%d)\n",
+			       rx->dev->name, MAC_ARG(rx->sta->addr), res);
 		return TXRX_DROP;
 	}
 
@@ -590,9 +597,17 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_txrx_data *rx)
 			    skb->data + hdrlen + CCMP_HDR_LEN, data_len,
 			    skb->data + skb->len - CCMP_MIC_LEN,
 			    skb->data + hdrlen + CCMP_HDR_LEN)) {
-			printk(KERN_DEBUG "%s: CCMP decrypt failed for RX "
-			       "frame from " MAC_FMT "\n", rx->dev->name,
-			       MAC_ARG(rx->sta->addr));
+			/* if there are multiple SSIDs on this BSSID,
+			   the frame may not be for us anyway; so, check
+			   that either the frame is unicast or that we
+			   are not in managed mode before complaining
+			   about a missing key */
+			if ((!is_multicast_ether_addr(hdr->addr1) ||
+			     rx->sdata->type != IEEE80211_IF_TYPE_STA) &&
+			    net_ratelimit())
+				printk(KERN_DEBUG "%s: CCMP decrypt failed "
+				       "for RX frame from " MAC_FMT "\n",
+				       rx->dev->name, MAC_ARG(rx->sta->addr));
 			return TXRX_DROP;
 		}
 	}
-- 
1.5.2.4

