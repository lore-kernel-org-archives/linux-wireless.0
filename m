Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41633 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbXGaNgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 09:36:24 -0400
Subject: Re: [PATCH] orinoco, wl3501, zd1201: use linux/ieee80211.h instead  of net/ieee80211.h
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, acme@ghostprotocols.net,
	pe1rxq@amsat.org
In-Reply-To: <200707310036.15013.flamingice@sourmilk.net>
References: <200707310036.15013.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 09:36:16 -0400
Message-Id: <1185888976.12153.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-31 at 00:36 -0700, Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> 
> These drivers only need 802.11 definitions.

I have nothing against the change if I understand the motivation.
What's the point?

> -#define ORINOCO_MAX_MTU		(IEEE80211_DATA_LEN - ENCAPS_OVERHEAD)
> +#define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)

We probably want to standardize on one name and use it consistently in
all drivers.
 
> -	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
> +	if ( (new_mtu + ENCAPS_OVERHEAD + sizeof(struct ieee80211_hdr)) >

I prefer the original code.  "Size of 802.11 header" is easier to
understand than "size of the structure representing 802.11 header".

Can we please make IEEE80211_HLEN available to all wireless drivers?

And by the way, the definition of struct ieee80211_hdr includes payload
(which is a good thing in my opinion).  The definition uses a
gcc-specific 0-size array, which we may want to convert to a c99 style
flexible array (i.e. payload[] as opposed to payload[0]).

Taking sizeof of a structure with a flexible array is dubious and is
likely to be discouraged in the future (I would support having a warning
in sparse).  What we really want is the offset of the payload in the
frame, not the size allocated by the compiler for the frame with 0-byte
payload.

I would prefer all the necessary changes to occur without disturbing the
individual drivers.

-- 
Regards,
Pavel Roskin
