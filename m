Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:17945 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZJLHu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 03:50:58 -0400
Received: by fg-out-1718.google.com with SMTP id 16so367942fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 00:49:11 -0700 (PDT)
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	hidave.darkstar@gmail.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
References: <873a5pq5vc.fsf@purkki.valot.fi>
	<1255276971.4095.241.camel@johannes.local>
	<87y6nhoqud.fsf@purkki.valot.fi>
	<20091011.200857.141215452.davem@davemloft.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 12 Oct 2009 10:49:08 +0300
In-Reply-To: <20091011.200857.141215452.davem@davemloft.net> (David Miller's message of "Sun\, 11 Oct 2009 20\:08\:57 -0700 \(PDT\)")
Message-ID: <87tyy5njbf.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller <davem@davemloft.net> writes:

>>> I really don't see the point, since it's just three lines of code, but I
>>> wouldn't mind all that much either.
>> 
>> My worry are the developers who even don't know what is a bottom half
>> and might get it all wrong. (Yes, there really are such people.)
>
> And the difference between this and knowing you need to call the
> ieee80211_rx_ni() thing is?
>
> You have to know what the heck a bottom half is to even know that you
> would need to call the ieee80211_rx_ni() thing.
>
> And that's the same amount of knowledge necessary to simply wrap the
> thing in a BH disable/enable sequence.

I was thinking that it's possible to document it something like this:

o in irq context use ieee80211_rx_irqsafe()
o in a tasklet use ieee80211_rx()
o in process context use ieee80211_rx_ni()

Also in the future it might be easier to optimise something based on
these functions. Maybe.

But as Johannes didn't like the idea, and neither do you, I'm going to
drop the idea. I'll add the BH disable/enable to wl1251 instead and
hopefully Luciano does the same to wl1271.

-- 
Kalle Valo
