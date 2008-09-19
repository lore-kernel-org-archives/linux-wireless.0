Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52517 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750800AbYISKTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 06:19:42 -0400
Subject: Re: ACK matching [was: TX status reporting with help of an ack
	queue]
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <1221818057.10419.58.camel@johannes.berg>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
	 <1221817584.4491.29.camel@localhost>
	 (sfid-20080919_114701_416600_478C4255)  <1221818057.10419.58.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 12:19:39 +0200
Message-Id: <1221819579.4491.34.camel@localhost> (sfid-20080919_121946_278020_F992CF6D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-19 at 11:54 +0200, Johannes Berg wrote:
> On Fri, 2008-09-19 at 11:46 +0200, Mattias Nissler wrote:
> 
> > This brings up the question whether we can do without tx status
> > reporting. Does anyone know why hostapd requires the tx status? As far
> > as I understand, mac80211 only uses the tx status reporting only for the
> > tx rate control. Rate control algos that don't use tx status are
> > definitely feasible (and in fact we'll need one for rt73).
> 
> mac80211 also uses it for reporting the sent frame to userspace on
> monitor interfaces.

Yeah, that's what hostapd relies on. But mac80211 really does not care
to much how userspace uses the information.

> 
> > I'll look into hostapd to figure out whether the tx status reporting is
> > really required when I find some time.
> 
> hostapd requires this because it needs to know whether a station
> acknowledged a frame or not to proceed its state machine, it's just how
> it has to work. If the hardware can't deal with that I guess you can't
> implement AP mode properly.

Well, maybe we can work around this requirement? I still need to learn
about the details, but what happens for example if the STA sends the ACK
and then resets due to a crash? I guess the AP is able to cope with
that, no? So maybe we can relax the rules a bit (unless we become really
incompliant with the standard of course).

Mattias

