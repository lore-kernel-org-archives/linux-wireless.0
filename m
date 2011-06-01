Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44843 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab1FAPm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 11:42:57 -0400
Received: by qwk3 with SMTP id 3so2646792qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 08:42:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110601160101.75e30b3d@boulder.homenet>
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
Date: Wed, 1 Jun 2011 17:42:55 +0200
Message-ID: <BANLkTim9pQc+yxdQLSL1-6VNiyM6_tvJ6g@mail.gmail.com> (sfid-20110601_174302_255146_3C50F693)
Subject: Re: b43 error under heavy load
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
> On Wed, 1 Jun 2011 14:25:23 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> I think you should easily get this error by transmitting. Streaming
>> some video is mostly receiving. Just putting some random
>> (ftp/sftp/iperf) server in the network would make the trick.
>
> OK rather than recompile the kernel with debugfs enabled, as you
> suggested I took the debugging call to b43dbg() out of the
> B43_DBG_DMAVERBOSE if block (so it is entered whether or not verbose
> debugging is set).
>
> I transferred a 268MB file across the LAN in a little over 5 minutes
> (so the transfer speed was a little under 10Mb/s).  During the course
> of the transfer I got about 500 "b43-phy0 debug: Stopped TX ring 1"
> statements logged.
>
> However the interesting thing is that with this debugging statement
> included, I got no messages about any out of order TX status; instead,
> apart from the overrun messages to the debug log, the link performed
> normally. The file transfer did not fail (I have checked that the file
> received is identical to the file sent) nor was the link to the router
> lost. Probably writing to the debug log has changed some timing race
> somewhere to the benefit of link integrity.
>
> However, as I said, I am not going to be in a position to do much
> testing by way of transferring further files over the LAN for a period
> of time, for unrelated reasons.

Well, it just seems that hitting full TX ring does not cause firmware
problems and out of order issue. However I've no idea what else can
cause it. We were also seeing this issue with free firmware on G-PHY
cards.

Maybe this is some hardware issue firmware has to workaround? Maybe
updating firmware could help? My next idea is to try 508.1107
firmware.

-- 
Rafał
