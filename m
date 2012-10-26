Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2JZKTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 06:19:07 -0400
Message-ID: <1351246782.10813.9.camel@jlt4.sipsolutions.net> (sfid-20121026_121912_401528_AD9E4EDC)
Subject: Re: [PATCH 2/3] mac80211: verify that skb data is present
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 12:19:42 +0200
In-Reply-To: <20121026005748.GA30982@shredder> (sfid-20121026_025756_120637_43AD3510)
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
	 <1351205200-18094-3-git-send-email-johannes@sipsolutions.net>
	 <20121025230505.GD20609@shredder> <20121025235816.GE20609@shredder>
	 <20121026005748.GA30982@shredder> (sfid-20121026_025756_120637_43AD3510)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 17:57 -0700, Thomas Pedersen wrote:

> Oh, that hunk is already inside the MESH_FLAGS_AE check... so:
> 
> 
>    		if (mesh_hdr->flags & MESH_FLAGS_AE_A4) {
>   			mpp_addr = hdr->addr3;
>   			proxied_addr = mesh_hdr->eaddr1;
>    		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
>   			mpp_addr = hdr->addr4;
>   			proxied_addr = mesh_hdr->eaddr2;
>   		} else
> 			return RX_DROP_MONITOR;
> 
> Should be ok since we already made sure to have enough data for each
> address extension size.

But that loses the is_multicast_ether_addr() check now, no? I mean, we
wouldn't want to accept an AE_A4 frame unless A1 was multicast, at least
not according to the original code?

All I was trying to make sure is that eaddr1/2 exist when they're used,
and that's the length check, but is equivalent (due to earlier checks)
to testing AE_A4/AE_A5_A6, I think?

None of your versions seem to be equivalent of the original code, which
says that
 * multicast -> use addr3/eaddr1
 * unicast -> use addr4/eaddr2

and I'm just adding checks that eaddr1/eaddr2 actually exist.


Ohh, ok, no I see, I'm not doing that. What we really need to do is
something entirely different:

                if (is_multicast_ether_addr(hdr->addr1)) {
                        mpp_addr = hdr->addr3;
                        proxied_addr = mesh_hdr->eaddr1;
                } else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
                        /* has_a4 already checked in ieee80211_rx_mesh_check */
                        mpp_addr = hdr->addr4;
                        proxied_addr = mesh_hdr->eaddr2;
                } else {
                        return RX_DROP_MONITOR;
                }

johannes

