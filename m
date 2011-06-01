Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [193.252.22.128] ([193.252.22.128]:7744 "EHLO
	smtp5.freeserve.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab1FAPBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 11:01:20 -0400
Date: Wed, 1 Jun 2011 16:01:01 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael =?ISO-8859-1?B?QvxzY2g=?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 error under heavy load
Message-ID: <20110601160101.75e30b3d@boulder.homenet> (sfid-20110601_170124_833614_32374BBE)
In-Reply-To: <BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 1 Jun 2011 14:25:23 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> I think you should easily get this error by transmitting. Streaming
> some video is mostly receiving. Just putting some random
> (ftp/sftp/iperf) server in the network would make the trick.

OK rather than recompile the kernel with debugfs enabled, as you
suggested I took the debugging call to b43dbg() out of the
B43_DBG_DMAVERBOSE if block (so it is entered whether or not verbose
debugging is set).

I transferred a 268MB file across the LAN in a little over 5 minutes
(so the transfer speed was a little under 10Mb/s).  During the course
of the transfer I got about 500 "b43-phy0 debug: Stopped TX ring 1"
statements logged.

However the interesting thing is that with this debugging statement
included, I got no messages about any out of order TX status; instead,
apart from the overrun messages to the debug log, the link performed
normally. The file transfer did not fail (I have checked that the file
received is identical to the file sent) nor was the link to the router
lost. Probably writing to the debug log has changed some timing race
somewhere to the benefit of link integrity.

However, as I said, I am not going to be in a position to do much
testing by way of transferring further files over the LAN for a period
of time, for unrelated reasons.

Chris


