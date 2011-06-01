Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:27227 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759420Ab1FARtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 13:49:49 -0400
Date: Wed, 1 Jun 2011 18:49:31 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110601184931.499557c6@boulder.homenet> (sfid-20110601_194954_356159_0F1618D8)
In-Reply-To: <BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
References: <4CEAB969.20702@lwfinger.net>
	<1290451982.20888.2.camel@maggie>
	<4CEAC095.7020706@lwfinger.net>
	<BANLkTimjRA5CsSDp_+LrGq8PNgaR4JFD=w@mail.gmail.com>
	<4DC9853A.1090508@lwfinger.net>
	<BANLkTimBpGRxfidpE4hYCVscmX-Hy5q5jw@mail.gmail.com>
	<BANLkTi=TohOdjurvgqZT8=GXKbWfNe4v+w@mail.gmail.com>
	<20110601114839.433ae42d@boulder.homenet>
	<BANLkTin_RnMV3KnGS4qYPtMVxCuW=Vj7mg@mail.gmail.com>
	<20110601130842.077da1c3@boulder.homenet>
	<BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
	<20110601160101.75e30b3d@boulder.homenet>
	<BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 1 Jun 2011 17:42:55 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> > On Wed, 1 Jun 2011 14:25:23 +0200
> > Rafał Miłecki <zajec5@gmail.com> wrote:
> >> I think you should easily get this error by transmitting. Streaming
> >> some video is mostly receiving. Just putting some random
> >> (ftp/sftp/iperf) server in the network would make the trick.
> >
> > OK rather than recompile the kernel with debugfs enabled, as you
> > suggested I took the debugging call to b43dbg() out of the
> > B43_DBG_DMAVERBOSE if block (so it is entered whether or not verbose
> > debugging is set).
> >
> > I transferred a 268MB file across the LAN in a little over 5 minutes
> > (so the transfer speed was a little under 10Mb/s).  During the
> > course of the transfer I got about 500 "b43-phy0 debug: Stopped TX
> > ring 1" statements logged.
> >
> > However the interesting thing is that with this debugging statement
> > included, I got no messages about any out of order TX status;
> > instead, apart from the overrun messages to the debug log, the link
> > performed normally. The file transfer did not fail (I have checked
> > that the file received is identical to the file sent) nor was the
> > link to the router lost. Probably writing to the debug log has
> > changed some timing race somewhere to the benefit of link integrity.
> >
> > However, as I said, I am not going to be in a position to do much
> > testing by way of transferring further files over the LAN for a
> > period of time, for unrelated reasons.
> 
> Well, it just seems that hitting full TX ring does not cause firmware
> problems and out of order issue. However I've no idea what else can
> cause it. We were also seeing this issue with free firmware on G-PHY
> cards.
> 
> Maybe this is some hardware issue firmware has to workaround? Maybe
> updating firmware could help? My next idea is to try 508.1107
> firmware.
 
My earlier report didn't test in both directions (it was for a netbook
to desktop transfer). I have now made a number of transfers in both
directions of a 268MB file using sftp, and the results are below.
Both ends have sshd installed and running, and it is the sending machine
whose ssh daemon is active for the transfer in question: in other
words, all the transfers are get rather than put operations.

My netbook is the computer with the broadcom wireless device. My
desktop doesn't use wireless: it is connected to the router via 100Mb/s
ethernet. Therefore, the transfer speeds are limited by the wireless
link to the netbook rather than the ethernet link to the desktop.

The transfers from the netbook to the desktop computers took an average
of 4 mins 28 secs, and on each occasion the file transfer completed
successfully and the wireless link stayed up, although I got the
repeated reports of "b43-phy0 debug: Stopped TX ring 1" to which I have
earlier referred.

The transfers from the desktop to the netbook, when they succeeded, were
faster, taking an average of 2 mins 35 secs (this is surprisingly
quick for a 268MB file). Of the three transfer attempts I made, two
succeeded, with no error messages or any kind reported to the debug
log, and one failed. The one which failed caused the cessation of
wireless traffic, and was accompanied by the debug log reports of out
of order TX status earlier referred to, and with only one single report
in the debug log of "Stopped TX ring 1". In the case of the failed
transfer, I brought the wireless link back up by disassociating and
then reassociating with the AP/router. It was not necessary to unload
and reload the b43 module, so there was no hard error involved.

Summary: Traffic sent up from the broadcom wireless device generates
copious reports of "Stopped TX ring 1" but always carries on with its
job and stays up, although its traffic is slower than on received
packets.  Received traffic on the other hand reports no errors until
the spate of "Out of order TX status report on DMA ring 1" errors
occurs, which seems to happen at random (albeit accompanied on my
failed transfer by a single "Stopped TX ring 1" log entry), and when it
does happen brings the wireless link to a halt. Wireless traffic can be
restarted simply by reassociating with the AP.

With that, I am afraid that really is it for a few days.

Chris



