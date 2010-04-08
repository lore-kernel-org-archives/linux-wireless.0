Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33683 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0DHDfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 23:35:40 -0400
Subject: Re: [PATCH] mac80211: fix paged RX crypto
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1270696951.10745.11.camel@debian>
References: <1270632416.3858.6.camel@jlt3.sipsolutions.net>
	 <1270696951.10745.11.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 11:36:09 +0800
Message-ID: <1270697769.10745.12.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-08 at 11:22 +0800, Zhu Yi wrote:
> On Wed, 2010-04-07 at 17:26 +0800, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > WEP crypto was broken, but upon finding the problem
> > it is evident that other things were broken by the
> > paged RX patch as well.
> > 
> > To fix it, for now move the linearising in front.
> > This means that we linearise all frames, which is
> > not at all what we want, but at least it fixes the
> > problem for now.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Acked-by: Zhu Yi <yi.zhu@intel.com>
> 
> I thought it over. We don't need to handle nonlinear skb in
> ieee80211_get_mmie_keyidx(), because we only need to touch fields out of
> 802.11 header for management frames, and we have already skb_linearize
> all management frames before. Now we just need to handle WEP IV
> correctly. How about this patch?
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

V2: reset hdr.

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 14366d4..23312dd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -894,6 +894,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			rx->key = key;
 		return RX_CONTINUE;
 	} else {
+		u8 keyid;
 		/*
 		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
@@ -916,7 +917,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		 * no need to call ieee80211_wep_get_keyidx,
 		 * it verifies a bunch of things we've done already
 		 */
-		keyidx = rx->skb->data[hdrlen + 3] >> 6;
+		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
+		keyidx = keyid >> 6;
 
 		rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
 
@@ -940,6 +942,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	if (skb_linearize(rx->skb))
 		return RX_DROP_UNUSABLE;
 
+	hdr = (struct ieee80211_hdr *)skb->data;
+
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&


