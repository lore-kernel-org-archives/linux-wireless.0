Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58657 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbbHSSJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 14:09:07 -0400
Message-ID: <1440007745.2089.11.camel@sipsolutions.net> (sfid-20150819_200910_977973_696D62A6)
Subject: Re: set channel from radiotap headers during injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Allan Matthew <allanm84@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Aug 2015 20:09:05 +0200
In-Reply-To: <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com> (sfid-20150819_183736_502054_67CA1931)
References: <CAEnVuW0JnU5yuAYBWsRfOo_S=GUK5vZzr6XqnNHHOeufmT-uiQ@mail.gmail.com>
	 <CAEnVuW1FcyBj2+ti8U8KF+rM0xO_Q+rw6PxXqgWy8WO0vRX6yg@mail.gmail.com>
	 <1439983495.2089.7.camel@sipsolutions.net>
	 <CAEnVuW18e15hOjoMYRstjgu2cr5BFAtVHThAyZGqpMAdFUQrpQ@mail.gmail.com>
	 (sfid-20150819_183736_502054_67CA1931)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 09:37 -0700, Allan Matthew wrote:

> It seems like the functionality for this (maybe not the monitor mode)
> must be available in order to support the multiple 802.11p channels 
> in the 5.8ghz band.

Not sure - I haven't looked at WAVE/11p in a long time, but the code we
have certainly assumes that the channel configuration is fixed, i.e.
only done once when "joining" the network.

> It sounds like what you are proposing is to create a non-monitor vif,
> select its channel, bitrate, bandwidth and then use the MAC address 
> to
> select it as the transmitting interface.  Is that correct?  I'm
> guessing I could do this with raw sockets and prepend the ieee80211
> header (but not the radiotap header)?
> 

No - radiotap injection has code to select the interfaces. So if you
have hardware that's capable of, say, having two AP interfaces on
different channels, then injection would select the channel by
selecting the interface. However, this isn't really a good way of
handling this either.

If you can be more specific what this would be used for, perhaps kernel
modifications would be appropriate to support it more correctly (rather
than relying on injection.)

johannes
