Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60439 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750936AbYECKS7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 06:18:59 -0400
Subject: Re: Please pull 'upstream' branch of rt2x00
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Scott White <nwi_sub@hotmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200805031158.43072.IvDoorn@gmail.com>
References: <BAY113-W31BC1B2DB0F0597B99310784DA0@phx.gbl>
	 <200805022325.38311.IvDoorn@gmail.com> <1209795569.10221.1.camel@localhost>
	 <200805031158.43072.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Sat, 03 May 2008 12:18:56 +0200
Message-Id: <1209809936.10921.9.camel@localhost> (sfid-20080503_121836_625343_353D8633)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-03 at 11:58 +0200, Ivo van Doorn wrote:
> On Saturday 03 May 2008, Mattias Nissler wrote:
> > On Fri, 2008-05-02 at 23:25 +0200, Ivo van Doorn wrote:
> > > On Friday 02 May 2008, Scott White wrote:
> > > > 
> > > > >Was this patch series in time for the 2.6.26 merge window?
> > > > >
> > > > >If not, please consider merging at least the following patches since
> > > > >they are real bugfixes:
> > > > >
> > > > >>       rt2x00: Don't enable short preamble for 1MBs
> > > > >>       rt2x00: Fix quality/activity led handling
> > > > >>       rt2x00: Clarify supported chipsets in Kconfig
> > > > >
> > > > >The others are code cleanups which are "nice to have", but could otherwise
> > > > >wait for 2.6.27.
> > > > 
> > > > The merge window is still open at this time.  I haven't seen a rc1 yet.  Anyway I saw that only the 3 bugfixes are currently in the queue.  As the owner of several (10 by the university and 2 personal) rt73 usb wireless cards, I would really like it if the latest version 2.1.5 made into 2.6.26.  As someone who has used 2.6.24 and finished compiling 2.6.25 two days ago I find that the driver in both kernels is not good.  Not good means I get a wireless signal and I get data transfers, but the speed fluctuates and have other issues.  However with each release, the problems I have are slowing decreasing.  I have been waiting patiently for 2.6.25-rc1 to have 2.1.5 since 2.1.5 was announced.  I really think all of 2.1.5 should get in 2.6.25-rc1.
> > > 
> > > Have you tried forcing the rate to 54Mbit instead of letting the rate selection algorithm doing its work?
> > > It seems to have helped with several other users.
> > 
> > For rt73? IIRC the rate selection algo does not work at all for that
> > device, because we cannot report failed frames. Or have you done
> > anything about that I might have missed, Ivo? If not, the rate is
> > probably fixed at 54Mbit anyway.
> 
> Well I didn't do anything new, but this line will report rt2x00lib that the
> frame was succesfully send or failed to send:
> 	txdesc.status = !urb->status ? TX_SUCCESS : TX_FAIL_RETRY;
> What is missing is the retry count, since that is something that
> the USB drivers cannot report. (Unless I grab the max retry count
> as configured by mac80211 as the number of retries on failure)

Well, I have just put my rt73 into a metal box. Many frames do fail,
only very few get through pinging my AP. The rate control still keeps
the rate at 54Mbit/s :-) So it seems neither excessive_retries nor the
retry_count in the tx_status struct is set at all.

Mattias

