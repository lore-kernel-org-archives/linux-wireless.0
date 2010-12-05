Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab0LEPmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 10:42:40 -0500
Subject: Re: RSN IBSS and GTK configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101205044415.GA12705@jm.kir.nu>
References: <20101205044415.GA12705@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Dec 2010 16:42:38 +0100
Message-ID: <1291563758.3495.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-12-04 at 20:44 -0800, Jouni Malinen wrote:
> Since mac80211/cfg80211 is now supposed to have more or less everything
> that is needed for RSN IBSS to work, I tried to get the final pieces
> implemented. 

I guess you found out that it didn't work -- let me just say that I'm
not too surprised :-)

> wpa_supplicant is now using the new STA event to trigger
> 4-way handshakes with other STAs in the IBSS (that works fine) and tries
> to configure the per-STA RX GTK (that does not work for some reason).

Hey, it's a start. Can you push the code into a test branch or so?

> What should be used as parameters for the new key for this per-STA RX
> GTK? I'm now trying to use an individual address (the peer), non-zero
> key index, and key type set to group. At least this not overriding our
> own TX GTK anymore, but the new key is not set either (EINVAL).

That seems about right -- NL80211_KEY_TYPE or NL80211_ATTR_KEY_TYPE
should be used I guess. Did you change your driver (presumably ath9k) to
set WIPHY_FLAG_IBSS_RSN? That's required -- I do expect drivers to have
issues with this in many cases, at least until they are changed to not
attempt to program multiple GTKs into hardware for IBSS.

> As far as actually being able to complete the 4-way handshakes is
> concerned, there is an issue in how we select the TX key. In the RSN
> IBSS case, there is a STA entry for the recipient of the EAPOL frame,
> but that STA entry does not have a key. We end up using the default key
> (our TX GTK) and obviously, the peer has no way of processing this frame
> at this point.. 

Oops. But then again, why do we have a default key? I think I was
probably thinking we wouldn't have a default key at all? But then again,
for our multicast packets we actually do need it.

> I'm currently using the following change to work around
> this. This is not exactly correct, but I did not yet have a chance to
> think through all the cases to figure out if something cleaner would
> cause problems for non-IBSS cases and WEP IBSS cases..
> 
> Anyway, with this patch, 4-way handshakes can be completed successfully
> and the PTK works, i.e., I can ping successfully with manually
> configured ARP table.

Hey, that's not _so_ bad! Of course, PTKs worked before, I guess ...

> --- wireless-testing.orig/net/mac80211/tx.c	2010-12-04 18:27:39.000000000 -0800
> +++ wireless-testing/net/mac80211/tx.c	2010-12-04 18:53:13.000000000 -0800
> @@ -539,14 +539,17 @@ ieee80211_tx_h_select_key(struct ieee802
>  		 ieee80211_is_robust_mgmt_frame(hdr) &&
>  		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
>  		tx->key = key;
> -	else if ((key = rcu_dereference(tx->sdata->default_key)))
> +	else if ((key = rcu_dereference(tx->sdata->default_key))) {
>  		tx->key = key;
> -	else if (tx->sdata->drop_unencrypted &&
> -		 (tx->skb->protocol != tx->sdata->control_port_protocol) &&
> -		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> -		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
> -		  (ieee80211_is_action(hdr->frame_control) &&
> -		   tx->sta && test_sta_flags(tx->sta, WLAN_STA_MFP)))) {
> +		if (tx->sta && tx->sdata->vif.type == NL80211_IFTYPE_ADHOC &&
> +		    tx->skb->protocol == tx->sdata->control_port_protocol)
> +			tx->key = NULL;

Huh, ok, I guess that won't really break anything else unless you
suddenly decide to transmit EAP packets in a WEP session as data ...
Still, I kinda agree that this needs more thought ...

*me thinks for a while*

So if we go back to my above mistake -- thinking that we wouldn't have a
default_key -- maybe we can slightly change the API to set that key as a
multicast-only TX key?

johannes

