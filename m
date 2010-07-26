Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:24164 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0GZLnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 07:43:13 -0400
Subject: Re: Hardware needs to know when EAP nego is complete
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1280143430.3693.7.camel@jlt3.sipsolutions.net>
References: <1280142400.6475.33.camel@wimaxnb.nmp.nokia.com>
	 <1280143430.3693.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 14:42:30 +0300
Message-ID: <1280144550.6475.48.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 13:23 +0200, ext Johannes Berg wrote:
> On Mon, 2010-07-26 at 14:06 +0300, Juuso Oikarinen wrote:
> > 
> > 
> > Thoughts? Ideas? Would this be acceptable?
> 
> I really don't like this. You _can_ figure out if a given frame is EAP
> by looking at its ethertype (but don't implement WAPI then!) ... can't
> you just give it priority _by frame_?

I don't like it either, but my hands are bound. With this chip I cannot
give priority by frame. The way it works on that chip is that after
association you tell the chip to change mode, and that's it - no going
back.

> Also, it doesn't make any sense, since if you really care then you want
> rekeying to also have priority...

Yep, this is a problem I too have been thinking about. However, with
this chip, you cannot change the priority back for re-keying. So
essentially, those negotiations are done with the "lowered"  WLAN
priority, and if they happen to fail the connection manager will as
result end up associating again with increased priority.

The fact is we need this to be done this way. I have been thinking about
all possible ways to do this hack inside the driver, triggering on
setting of keys etc, but as far as I can tell it's not doable without
assumptions having unacceptable impact on functionality.

We'll have to consider some driver-specific hack-interface then, along
with a correspondingly hacked user-space connection manager. This will
just cause other users of the wl1271 driver ending up with dysfunctional
BT-WLAN coex.

-Juuso

> johannes
> 


