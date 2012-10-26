Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2JZQfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 12:35:13 -0400
Message-ID: <1351269345.10813.19.camel@jlt4.sipsolutions.net> (sfid-20121026_183518_387769_73A8ADC8)
Subject: Re: [PATCH v2 2/3] mac80211: verify that skb data is present
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 18:35:45 +0200
In-Reply-To: <CAG6hwVOzf0uwkQUxjL0Gw0iLwdCNNQdBMB3_rfhp5AyTtJvQ6Q@mail.gmail.com> (sfid-20121026_183008_992910_4E46AFFE)
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
	 <1351205200-18094-3-git-send-email-johannes@sipsolutions.net>
	 <1351249254.10813.13.camel@jlt4.sipsolutions.net>
	 <CAG6hwVOzf0uwkQUxjL0Gw0iLwdCNNQdBMB3_rfhp5AyTtJvQ6Q@mail.gmail.com>
	 (sfid-20121026_183008_992910_4E46AFFE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 09:29 -0700, Thomas Pedersen wrote:

> > @@ -1915,9 +1934,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
> >                 if (is_multicast_ether_addr(hdr->addr1)) {
> >                         mpp_addr = hdr->addr3;
> >                         proxied_addr = mesh_hdr->eaddr1;
> > -               } else {
> > +               } else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
> 
> OK, but now the first check (is_multicast_ether_addr()) implies AE_A4
> flag. It seems cleaner to just be explicit about what you're asking
> for both cases.

Well, I dunno. That seems like a change that might be correct in the
semantics of mesh, but it's not the minimal technical change that I'm
after to make sure we have all the data we access.

This may not be valid in mesh, but if we were to receive a multicast
frame with AE_A5_A5 instead of AE_A4 then we could still use eaddr1,
though we'd probably drop the frame later or something.

johannes

