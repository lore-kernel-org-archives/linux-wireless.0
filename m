Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:41981 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYA3CIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 21:08:41 -0500
Date: Tue, 29 Jan 2008 18:08:11 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove port control enable switch, clean up
	sta flags
Message-ID: <20080130020811.GD5015@jm.kir.nu> (sfid-20080130_020845_221347_C942881E)
References: <1201537178.9397.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201537178.9397.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2008 at 05:19:37PM +0100, Johannes Berg wrote:
> This patch removes the 802.1X port acess control enable flag
> since it is not required. Instead, set the authorized flag for
> each station that we normally communicate with (WDS peers, IBSS
> peers and APs we're associated to) and require hostapd to set
> the authorized flag for all stations when port control is not
> enabled.

OK, that sounds reasonable.

> Also, since I was working in that area, this documents station
> flags and removes the unused "permanent" one.

And changes the flags.. These used to be shared with hostapd. Has that
been abstracted so that there is some kind of mapping taking care of the
differences between hostapd and mac80211? If not, this change does not
look safe..


> -#define WLAN_STA_AUTHORIZED BIT(5) /* If 802.1X is used, this flag is
> -				    * controlling whether STA is authorized to
> -				    * send and receive non-IEEE 802.1X frames
> -				    */
> -#define WLAN_STA_SHORT_PREAMBLE BIT(7)
> -/* whether this is an AP that we are associated with as a client */
> -#define WLAN_STA_ASSOC_AP BIT(8)
> -#define WLAN_STA_WME BIT(9)
> -#define WLAN_STA_WDS BIT(27)

> +	WLAN_STA_AUTHORIZED	= 1<<4,
> +	WLAN_STA_SHORT_PREAMBLE	= 1<<5,
> +	WLAN_STA_ASSOC_AP	= 1<<6,
> +	WLAN_STA_WME		= 1<<7,
> +	WLAN_STA_WDS		= 1<<8,

hostapd uses at least authorized, short_preamble, and WME flags and this
change would make these not match with kernel side anymore.. It may be
desirable to break this direct link between the bitfield, but set_flags
operation needs to be mapped properly in that case and I don't know
whether that has already been taken care of in mac80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
