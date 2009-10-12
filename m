Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40749 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbZJLNqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 09:46:47 -0400
Date: Mon, 12 Oct 2009 09:38:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: kalle.valo@iki.fi, johannes@sipsolutions.net,
	hidave.darkstar@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
Message-ID: <20091012133835.GB27575@tuxdriver.com>
References: <873a5pq5vc.fsf@purkki.valot.fi> <1255276971.4095.241.camel@johannes.local> <87y6nhoqud.fsf@purkki.valot.fi> <20091011.200857.141215452.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091011.200857.141215452.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 11, 2009 at 08:08:57PM -0700, David Miller wrote:
> From: Kalle Valo <kalle.valo@iki.fi>
> Date: Sun, 11 Oct 2009 19:08:58 +0300
> 
> > Johannes Berg <johannes@sipsolutions.net> writes:
> > 
> >>> > +	local_bh_disable();
> >>> >  	ieee80211_rx(dev->wl->hw, skb);
> >>> > +	local_bh_enable();
> >>> 
> >>> This is a bit awkward from drivers' point of view, we have to add the
> >>> same code to all mac80211 drivers using either SPI or SDIO buses.
> >>> 
> >>> What about adding a new inline function ieee80211_rx_ni() which would
> >>> disable bottom halves like above and call ieee80211_rx()? IMHO that's
> >>> easier for the driver developers to understand and also easier to
> >>> document ("use this function when calling from process context"). If
> >>> this is acceptable, I can create a patch.
> >>
> >> I really don't see the point, since it's just three lines of code, but I
> >> wouldn't mind all that much either.
> > 
> > My worry are the developers who even don't know what is a bottom half
> > and might get it all wrong. (Yes, there really are such people.)
> 
> And the difference between this and knowing you need to call the
> ieee80211_rx_ni() thing is?
> 
> You have to know what the heck a bottom half is to even know that you
> would need to call the ieee80211_rx_ni() thing.
> 
> And that's the same amount of knowledge necessary to simply wrap the
> thing in a BH disable/enable sequence.

I'm not sure I see the difference between this and the rationale for
having netif_rx_ni vs. an open-coded version of it?  ieee80211_rx_ni
seems like a small amount of code (could even be inline) that
potentially avoids some stupid bugs...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
