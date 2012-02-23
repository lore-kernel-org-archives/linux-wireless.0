Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2BWNnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 08:43:11 -0500
Subject: Re: [PATCH] mac80211 radiotap injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Bro <larsbro@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20120221T000341-610@post.gmane.org> (sfid-20120221_001738_057595_CEF930DD)
References: <loom.20120221T000341-610@post.gmane.org>
	 (sfid-20120221_001738_057595_CEF930DD)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 14:43:09 +0100
Message-ID: <1330004589.3448.12.camel@jlt3.sipsolutions.net> (sfid-20120223_144314_810403_82B391D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-20 at 23:17 +0000, Lars Bro wrote:
> Building on the work of Sam Leffler, adding the possibility of setting
> the tx-power also.

Please read
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches, particularly the references at the bottom of the page.

Please also follow the style of the surrounding code.

> diff --git a/Documentation/networking/mac80211-injection.txt 
> b/Documentation/networking/mac80211-injection.txt
> index 3a93007..cd3d3ef 100644
> --- a/Documentation/networking/mac80211-injection.txt
> +++ b/Documentation/networking/mac80211-injection.txt
> @@ -23,11 +23,28 @@ radiotap headers and used to control injection:
>     IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
>  			      current fragmentation threshold.
>  
> + * IEEE80211_RADIOTAP_RATE
> +   legacy transmit rate in .5 Mb/s units (u8)

This looks quite strange, for example.

> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index cbff4f9..2821b87 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -378,6 +378,9 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
>   *	would be fragmented by size (this is optional, only used for
>   *	monitor injection).
> + * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
> + *	This flag is used when an injected frame includes a transmit
> + *	rate (and possibly flags and retry count) in the radiotap header.

Does that really have to be here? This is the last bit we have, and it
seems this is internal so ... ?

>  #define IEEE80211_TX_CTL_STBC_SHIFT		23
> @@ -555,6 +559,7 @@ struct ieee80211_tx_info {
>  			struct ieee80211_vif *vif;
>  			struct ieee80211_key_conf *hw_key;
>  			struct ieee80211_sta *sta;
> +			u8 tx_power;

That's not going to be honoured by a lot of devices.

>  
>  	/* process and remove the injection radiotap header */
> -	if (!ieee80211_parse_tx_radiotap(skb))
> +	if (!ieee80211_parse_tx_radiotap(skb, local))

that's a very unusual argument order for the mac80211 code

I promise to actually look at the code when you fix all the surrounding
issues, right now I'm quite busy though so not very keen on looking
through this.

johannes

