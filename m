Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55793
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbZJLDJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 23:09:02 -0400
Date: Sun, 11 Oct 2009 20:08:57 -0700 (PDT)
Message-Id: <20091011.200857.141215452.davem@davemloft.net>
To: kalle.valo@iki.fi
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	hidave.darkstar@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y6nhoqud.fsf@purkki.valot.fi>
References: <873a5pq5vc.fsf@purkki.valot.fi>
	<1255276971.4095.241.camel@johannes.local>
	<87y6nhoqud.fsf@purkki.valot.fi>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 11 Oct 2009 19:08:58 +0300

> Johannes Berg <johannes@sipsolutions.net> writes:
> 
>>> > +	local_bh_disable();
>>> >  	ieee80211_rx(dev->wl->hw, skb);
>>> > +	local_bh_enable();
>>> 
>>> This is a bit awkward from drivers' point of view, we have to add the
>>> same code to all mac80211 drivers using either SPI or SDIO buses.
>>> 
>>> What about adding a new inline function ieee80211_rx_ni() which would
>>> disable bottom halves like above and call ieee80211_rx()? IMHO that's
>>> easier for the driver developers to understand and also easier to
>>> document ("use this function when calling from process context"). If
>>> this is acceptable, I can create a patch.
>>
>> I really don't see the point, since it's just three lines of code, but I
>> wouldn't mind all that much either.
> 
> My worry are the developers who even don't know what is a bottom half
> and might get it all wrong. (Yes, there really are such people.)

And the difference between this and knowing you need to call the
ieee80211_rx_ni() thing is?

You have to know what the heck a bottom half is to even know that you
would need to call the ieee80211_rx_ni() thing.

And that's the same amount of knowledge necessary to simply wrap the
thing in a BH disable/enable sequence.
