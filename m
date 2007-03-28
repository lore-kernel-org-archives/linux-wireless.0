Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-2.dex002.intermedia.net ([64.78.21.14]:48466 "EHLO
	dhost002-2.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965696AbXC1TLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 15:11:19 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 28 Mar 2007 12:11:16 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
Message-ID: <20070328191116.GJ6036@devicescape.com>
References: <1175011305.9282.10.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175011305.9282.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 27, 2007 at 06:01:45PM +0200, Johannes Berg wrote:

> This patch optimises the ieee80211_get_hdrlen function by exploiting the
> bit masks directly.

> --- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-27 16:33:47.163155480 +0200
> +++ wireless-dev/net/mac80211/ieee80211.c	2007-03-27 16:33:48.473155480 +0200
> @@ -258,19 +258,24 @@ int ieee80211_get_hdrlen(u16 fc)
>  	case IEEE80211_FTYPE_DATA:
>  		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
>  			hdrlen = 30; /* Addr4 */
> -		if (fc & IEEE80211_STYPE_QOS_DATA)
> -			hdrlen += 2; /* QoS Control Field */
> +		/* QoS Control Field */
> +		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
> +				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
>  		break;

Could you please add a comment explaining what exactly happens here and
more importantly, include an easy way of understanding that this adds 2
bytes.

>  	case IEEE80211_FTYPE_CTL:
> -		switch (fc & IEEE80211_FCTL_STYPE) {
> -		case IEEE80211_STYPE_CTS:
> -		case IEEE80211_STYPE_ACK:
> +		/*
> +		 * ACK and CTS are 10 bytes, all others 16. To see how
> +		 * to get this condition consider
> +		 *   subtype mask:   0b0000000011110000 (0x00F0)
> +		 *   ACK subtype:    0b0000000011010000 (0x00D0)
> +		 *   CTS subtype:    0b0000000011000000 (0x00C0)
> +		 *   bits that matter:         ^^^      (0x00E0)
> +		 *   value of those: 0b0000000011000000 (0x00C0)
> +		 */
> +		if ((fc & 0xE0) == 0xC0)
>  			hdrlen = 10;
> -			break;
> -		default:
> +		else
>  			hdrlen = 16;
> -			break;
> -		}

Is this case even used anywhere? Looks like unnecessary optimization at
the cost of making the source code more difficult to understand and
modify.

-- 
Jouni Malinen                                            PGP id EFC895FA
