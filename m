Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXHOKoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:44:39 -0400
Subject: Re: [PATCHv2] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Volker Braun <volker.braun@physik.hu-berlin.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 03:47:00 +0200
Message-Id: <1187142421.31200.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-10 at 23:31 +0000, Volker Braun wrote:

[...]

Your key setting change looks weird, you're right that key indexes 0
through 3 should all be valid for default keys but now you're changing
the code to actually look at the key index that is being set while
setting a unicast (key-mapping) key! In another mail you said:

> 2) The Cisco AP sets the unicast key to some index higher than
> 0. While outright weird, this is probably legal. However, mac80211
> does not allow this setting. I patched ieee80211_set_encryption to
> remove this invalid restriction of the key index.

Which seems to be a weird statement. How can the Cisco AP set the
unicast key index at all, that is on your side after all, no? In fact,
the standard has something to say against that:

     When a key-mapping key for an address pair is
     present, the WEP Key ID subfield in the MPDU shall
     be set to 0 on transmit and ignored on receive.

So there's a requirement to set the key index to 0. However, by the same
standard text, the AP mustn't care which key index is used for that
key-mapping key.

What happens when you don't patch the ioctls?

Also, you said:

> I see some similar (wrong) assumptions about keyidx==0 being the
> unicast key in ieee80211_rx_michael_mic_report. The statistics
> gathering is probably still broken in that regard.

In fact, that isn't wrong. Well, the key index must be ignored on
receive, but that doesn't change the fact that the sender did something
wrong if it's nonzero.

> +       if (rx->fc & IEEE80211_FCTL_PROTECTED && /* WEP */
> +           (rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV)) {
> +
> +               if (rx->skb->pkt_type == PACKET_HOST && 
> +                   rx->sta && rx->sta->key) {

That doesn't look too good. Now you're only loading up keys at all if
the hardware includes the IV.

> +       } else { /* No WEP */
> +               if (rx->sta && rx->sta->key)
> +                       rx->key = rx->sta->key;
> +               else
> +                       rx->key = rx->sdata->default_key;

That looks plain bogus. Why haven't you loaded the key in load_key?

Can you try this along with your other changes?

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-15 02:51:32.430200043 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-15 02:55:45.960200043 +0200
@@ -316,52 +316,62 @@ static ieee80211_txrx_result
 ieee80211_rx_h_load_key(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
-	int always_sta_key;
-
-	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
-		always_sta_key = 0;
-	else
-		always_sta_key = 1;
+	int have_key_mapping = 0;
+	int keyidx;
+	int encrypted_frame = rx->fc & IEEE80211_FCTL_PROTECTED;
+
+	rx->key = NULL;
+
+	/*
+	 * We need to load the key even for unencryped frames because
+	 * later RX handlers will drop the packet based on that.
+	 */
 
-	if (rx->sta && rx->sta->key && always_sta_key) {
+	/*
+	 * "A key-mapping key is an unnamed key corresponding to a
+	 *  distinct transmitter address-receiver address <TA,RA>
+	 *  pair. Implementations shall use the key-mapping key
+	 *  if it is configured for a <TA,RA> pair."
+	 */
+	if (rx->sta && rx->sta->key && rx->skb->pkt_type == PACKET_HOST) {
 		rx->key = rx->sta->key;
-	} else {
-		if (rx->sta && rx->sta->key)
-			rx->key = rx->sta->key;
-		else
-			rx->key = rx->sdata->default_key;
-
-		if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-		    rx->fc & IEEE80211_FCTL_PROTECTED) {
-			int keyidx = ieee80211_wep_get_keyidx(rx->skb);
-
-			if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS &&
-			    (!rx->sta || !rx->sta->key || keyidx > 0))
-				rx->key = rx->sdata->keys[keyidx];
-
-			if (!rx->key) {
-				if (!rx->u.rx.ra_match)
-					return TXRX_DROP;
-				if (net_ratelimit())
-					printk(KERN_DEBUG "%s: RX WEP frame "
-					       "with unknown keyidx %d "
-					       "(A1=" MAC_FMT
-					       " A2=" MAC_FMT
-					       " A3=" MAC_FMT ")\n",
-					       rx->dev->name, keyidx,
-					       MAC_ARG(hdr->addr1),
-					       MAC_ARG(hdr->addr2),
-					       MAC_ARG(hdr->addr3));
-				/*
-				 * TODO: notify userspace about this
-				 * via cfg/nl80211
-				 */
+		have_key_mapping = 1;
+	} else
+		rx->key = rx->sdata->default_key;
+
+	/*
+	 * "When key-mapping keys are used, the Key ID field value is ignored."
+	 */
+	/* should we really load a key for frames not addressed to us?? */
+	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
+	    encrypted_frame && !have_key_mapping) {
+		keyidx = ieee80211_wep_get_keyidx(rx->skb);
+
+		if (keyidx >= 0 && keyidx < NUM_DEFAULT_KEYS)
+			rx->key = rx->sdata->keys[keyidx];
+
+		if (!rx->key) {
+			if (!rx->u.rx.ra_match)
 				return TXRX_DROP;
-			}
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: RX WEP frame "
+				       "with unknown keyidx %d "
+				       "(A1=" MAC_FMT
+				       " A2=" MAC_FMT
+				       " A3=" MAC_FMT ")\n",
+				       rx->dev->name, keyidx,
+				       MAC_ARG(hdr->addr1),
+				       MAC_ARG(hdr->addr2),
+				       MAC_ARG(hdr->addr3));
+			/*
+			 * TODO: notify userspace about this
+			 * via cfg/nl80211
+			 */
+			return TXRX_DROP;
 		}
 	}
 
-	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
+	if (encrypted_frame && rx->key && rx->u.rx.ra_match) {
 		rx->key->tx_rx_count++;
 		if (unlikely(rx->local->key_tx_rx_threshold &&
 			     rx->key->tx_rx_count >


