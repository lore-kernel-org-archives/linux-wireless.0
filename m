Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLVPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:15:17 -0500
Message-ID: <1355346934.9708.17.camel@jlt4.sipsolutions.net> (sfid-20121212_221521_613322_19B60339)
Subject: Re: Question about "authorized state" test in tx.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 12 Dec 2012 22:15:34 +0100
In-Reply-To: <CAMcMvshyr6p2dqv-4YKW3=ZqLXskqvOtR9E4+UGOM4pzzJumgg@mail.gmail.com> (sfid-20121212_220839_643820_505C0A07)
References: <CAMcMvshyr6p2dqv-4YKW3=ZqLXskqvOtR9E4+UGOM4pzzJumgg@mail.gmail.com>
	 (sfid-20121212_220839_643820_505C0A07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 13:08 -0800, Paul Stewart wrote:
> The "unauthorized port" test in ieee80211_subif_start_xmit reads as follows:
> 
>         /*
>          * Drop unicast frames to unauthorised stations unless they are
>          * EAPOL frames from the local station.
>          */
>         if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
>                      !is_multicast_ether_addr(hdr.addr1) && !authorized &&
>                      (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
>                       !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))
> ) {
> #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
>                 net_info_ratelimited("%s: dropped frame to %pM (unauthorized por
> t)\n",
>                                     dev->name, hdr.addr1);
> #endif
> 
>   [...]
> 
> Was it explicitly meant to allow multicast/broadcast frames while not
> authorized?  I'm starting to see isolated cases in packet traces where
> APs deauth clients due to errant broadcasts being sent during/before
> the 4-way handshake, after association.  Are there situations where
> these broadcasts / multicasts should be allowed, or would it be
> acceptable to drop the multicast check?  The change which introduced
> it is
> 7d185b8bb17eac9e9d673eb483ded0fbf0b28b97, but I don't quite understand
> it since if we're not authenticated to the AP, should we still be
> allowed to send (non-authentication) traffic to it?

That commit was meant for AP mode, and in managed mode hdr.addr1 should
never be a multicast address. Any idea how that happens?

johannes

