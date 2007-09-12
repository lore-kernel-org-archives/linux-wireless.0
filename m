Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:36130 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbXILIk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 04:40:56 -0400
Received: by py-out-1112.google.com with SMTP id u77so281249pyb
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 01:40:55 -0700 (PDT)
Message-ID: <1ba2fa240709120140l56c21269p8254c790edda42b1@mail.gmail.com>
Date: Wed, 12 Sep 2007 11:40:55 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ulrich Kunitz" <kune@deine-taler.de>
Subject: Re: zd-mac80211: Fix TX status reports.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Buesch" <mb@bu3sch.de>, "Daniel Drake" <dsd@gentoo.org>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070911223258.GA31400@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200709082341.31720.mb@bu3sch.de> <200709111220.31700.mb@bu3sch.de>
	 <1189506596.6161.14.camel@johannes.berg>
	 <200709111252.30291.mb@bu3sch.de>
	 <1189508230.6161.18.camel@johannes.berg>
	 <20070911223258.GA31400@deine-taler.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/12/07, Ulrich Kunitz <kune@deine-taler.de> wrote:
> Johannes Berg wrote:
>
> > On Tue, 2007-09-11 at 12:52 +0200, Michael Buesch wrote:
> > > On Tuesday 11 September 2007 12:29:56 Johannes Berg wrote:
> > > > On Tue, 2007-09-11 at 12:20 +0200, Michael Buesch wrote:
> > > >
> > > > > What about the following:
> > > > > We have a "the packet failed" IRQ. so we know that if that didn't
> > > > > raise for a packet, it must have succeed.
> > > > > So currently we already maintain a queue of TX packets. What about
> > > > > changing the handling of this queue? Instead of dropping (and
> > > > > telling mac80211 success) on an ACK RX, simply do a timeout.
> > > > > We can calculate the time (plus some additional msecs to be sure)
> > > > > by when an ACK must have arrived, no?
> > > >
> > > > That's tricky though, because multiple retry rates mean that it can
> > > > possibly take quite a while for the packet to go through. And ath5k
> > > > wants to support up to 7 different rates for each packet.
> > >
> > > I'm only talking about zd, though.
> >
> > Yeah, but that means the driver should implement it because it has much
> > less problems getting the heuristics right.
>
> Notify that the TX-failed interrupt has only the destination MAC
> address of the transmitted packet. So if the driver has sent two packets
> to the device and both are still in their timeout time, it will
> not be known, whether the first or the second failed. (The
> destination address for STAs will always be the same.)
>
> Sending only one packet until the timeout period is over is
> certainly doable and could be used for critical activity like
> association and authentication, but for normal mode the driver
> should only be required to provide statistics.
>
That was my suggestion as well.
> --
> Uli Kunitz
>
