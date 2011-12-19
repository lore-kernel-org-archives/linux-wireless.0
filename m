Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LSPzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 10:55:33 -0500
Subject: Re: [PATCH] mac80211: Fix frame classification in AP mode for
 relayed frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111219_110335_010382_EECE5609)
References: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111219_110335_010382_EECE5609)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 16:55:30 +0100
Message-ID: <1324310130.3414.3.camel@jlt3.sipsolutions.net> (sfid-20111219_165536_687476_67679DD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 11:02 +0100, Helmut Schaa wrote:
> When mac80211 relays a frame from STA1 to STA2 in AP mode it will get
> re-classified in the tx path. Unfortunately the frame protocol field
> is always set to ETH_P_8023 while the classification only kicks in
> for ETH_P_IP. Hence, a high priority frame from STA1 will be send to
> STA2 as best effort.
> 
> To allow proper re-classification of received frames, set the
> skb->protocol field to the correct value without using eth_type_trans
> as that would pull of the ethernet header. Also, set the network
> header position correctly as otherwise the classification code won't
> find the IP header.
> 
> This means that every frame relayed by a mac80211 AP will be
> re-classified and might change its traffic class when the associated
> STA and mac80211 use different 802.1d <-> TID mappings.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 
> We could also reuse the TID used by the source STA but I guess we should
> always classify frames according to our own mapping instead of relying
> on the associated STAs to do the right thing.

Not sure that's useful, since we classify almost nothing anyway. If this
was somehow hooked up to tc or iptables that would be more useful I
guess?

johannes

