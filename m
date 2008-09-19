Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bluegiga.fi ([194.100.31.45]:8404 "EHLO darkblue.bluegiga.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbYISOUg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 10:20:36 -0400
Subject: Re: ACK matching [was: TX status reporting with help of an ack
	queue]
From: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de, j@w1.fi
In-Reply-To: <1221832302.4514.6.camel@localhost>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
	 <1221817584.4491.29.camel@localhost>
	 (sfid-20080919_114701_416600_478C4255)  <1221818057.10419.58.camel@johannes.berg>
	 <1221819579.4491.34.camel@localhost>
	 (sfid-20080919_122011_765612_F53F8EFC)  <1221820265.10419.78.camel@johannes.berg>
	 <1221832302.4514.6.camel@localhost>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 17:20:33 +0300
Message-Id: <1221834033.22224.22.camel@virkkmi-linux> (sfid-20080919_162051_200212_7F7F0979)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-19 at 15:51 +0200, Mattias Nissler wrote:
> On Fri, 2008-09-19 at 12:31 +0200, Johannes Berg wrote:
> > On Fri, 2008-09-19 at 12:19 +0200, Mattias Nissler wrote:
> > 
> > > Well, maybe we can work around this requirement? I still need to learn
> > > about the details, but what happens for example if the STA sends the ACK
> > > and then resets due to a crash? I guess the AP is able to cope with
> > > that, no? So maybe we can relax the rules a bit (unless we become really
> > > incompliant with the standard of course).
> > 
> > I don't really see how to. We can't just assume the station got the
> > frame properly and advance our state machine. The case you're citing is
> > quite different, we'll advance the state machine but it won't work
> > because the STA crashed; if we advance but the station simply hasn't
> > gotten the frame we'll get out of sync and stuff will fail for no real
> > reason.
> 
> Well, I understand that we need synchronization of the state machines,
> maybe we can advance optimistically and detect in the next state that
> the STA didn't receive the last message? Just some random thoughts, I
> see it'll at least be tricky, I just wanted your opinion on whether you
> see a chance :-) As I said, I'll look into it when I find some time.
> 

Just as a side note: it's the mac80211 stack which converts a missing
TX_ACK flag to be a IEEE80211_RADIOTAP_F_TX_FAIL flag. The hostapd sees
that TX_FAIL and assumes TX failed.

> > 
> > But you can do workarounds all you want in hostapd, I don't care.
> 
> :-)
> 
> > However, I do think that if the hardware just isn't up to the job you
> > should probably buy new hardware, after all, it's dirt cheap. :)
> 
> I totally agree with you. I'm just curious to see whether there is a
> chance to help our users. I'm perfectly fine if it turns out there is no
> chance to do it properly, and I'll rather accept that fact instead of
> trying to introduce workarounds that are known to be incorrect. The sad
> thing is that if we controlled the firmware, we could probably arrange
> to have the necessary information passed to the driver.
> 
> Mattias
> 

I'd really love for some workaround that would allow AP mode to work. 

It would be great if it could be deemed that the protocol doesn't really
require CTS protection/status information, and can be made reliable and
standards compliant without support for it from the driver.
Unfortunately I don't have high hopes for that, but I wonder what's Mr.
Malinen's opinion?

- Mikko




