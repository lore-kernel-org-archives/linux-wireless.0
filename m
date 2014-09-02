Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65233 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbaIBVQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 17:16:24 -0400
Received: by mail-pa0-f41.google.com with SMTP id lj1so15636325pab.14
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 14:16:24 -0700 (PDT)
Date: Tue, 2 Sep 2014 14:16:20 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
Message-ID: <20140902141620.2da1f6aa@urahara> (sfid-20140902_231628_468286_DBA4AD79)
In-Reply-To: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 21 Aug 2014 19:22:27 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> +	/* RFC 1122 3.3.6:
> +	 *
> +	 *   When a host sends a datagram to a link-layer broadcast address,
> +	 *   the IP destination address MUST be a legal IP broadcast or IP
> +	 *   multicast address.
> +	 *
> +	 *   A host SHOULD silently discard a datagram that is received via
> +	 *   a link-layer broadcast (see Section 2.4) but does not specify
> +	 *   an IP multicast or broadcast destination address.
> +	 *
> +	 * We also do this for link-layer multicast.
> +	 */
> +	if ((skb->pkt_type == PACKET_BROADCAST ||
> +	     skb->pkt_type == PACKET_MULTICAST) &&
> +	    res.type != RTN_BROADCAST)
> +		goto e_inval;
> +

I think you need to all multicast packet but not broadcast.
The RFC does not specify that you should drop link-layer multicast to a unicast
address. There are several clustering products use that.
