Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58092 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbZJKQJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 12:09:37 -0400
Received: by ewy4 with SMTP id 4so1882330ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 09:09:00 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	Dave Young <hidave.darkstar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
References: <1255256361.4095.56.camel@johannes.local>
	<873a5pq5vc.fsf@purkki.valot.fi>
	<1255276971.4095.241.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 11 Oct 2009 19:08:58 +0300
In-Reply-To: <1255276971.4095.241.camel@johannes.local> (Johannes Berg's message of "Sun\, 11 Oct 2009 18\:02\:51 +0200")
Message-ID: <87y6nhoqud.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > +	local_bh_disable();
>> >  	ieee80211_rx(dev->wl->hw, skb);
>> > +	local_bh_enable();
>> 
>> This is a bit awkward from drivers' point of view, we have to add the
>> same code to all mac80211 drivers using either SPI or SDIO buses.
>> 
>> What about adding a new inline function ieee80211_rx_ni() which would
>> disable bottom halves like above and call ieee80211_rx()? IMHO that's
>> easier for the driver developers to understand and also easier to
>> document ("use this function when calling from process context"). If
>> this is acceptable, I can create a patch.
>
> I really don't see the point, since it's just three lines of code, but I
> wouldn't mind all that much either.

My worry are the developers who even don't know what is a bottom half
and might get it all wrong. (Yes, there really are such people.)

But if you don't see any benefit from adding a new function, I'll drop
the idea. No need to complicate this anymore :)

-- 
Kalle Valo
