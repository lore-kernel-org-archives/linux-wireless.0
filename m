Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60476 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137Ab1FAMZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 08:25:24 -0400
Received: by qwk3 with SMTP id 3so2548728qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 05:25:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110601130842.077da1c3@boulder.homenet>
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
Date: Wed, 1 Jun 2011 14:25:23 +0200
Message-ID: <BANLkTi=2xYrrjEdHuYCKFKy4H2EXoUGQuQ@mail.gmail.com> (sfid-20110601_142529_722587_5C918FB9)
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
> On Wed, 1 Jun 2011 12:56:22 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> 2011/6/1 Chris Vine <chris@cvine.freeserve.co.uk>:
>> > On Wed, 1 Jun 2011 11:23:45 +0200
>> > Rafał Miłecki <zajec5@gmail.com> wrote:
>> >> AFAIK to enable this debugging you only need to:
>> >> echo 1 > /sys/kernel/debug/b43/phy0/debug_dmaverbose
>> >
>> > I don't have a /sys/kernel/debug directory with a running 3.0.0-rc1
>> > kernel, so it appears that b43 debugging (which I do have enabled)
>> > doesn't use it.
>>
>> mount -t debugfs none /sys/kernel/debug/
>
> Ah, so I need to compile in debugfs.  That isn't/wasn't necessary for
> the DMA error debugging.  I am surprised that debugfs enables you to
> alter kernel debugging levels on the fly (I thought it was a
> passive logging mechanism for kernel state), but you live and learn.

Removing following if () condition:
 if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
will work fine as well ;)
You can just leave:
b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
without condition around it (and make sure to enable B43 debugging).


> I will compile in debugfs, but I don't expect to have any rapid results
> for you. With 3 and a half hours of streaming yesterday it happened
> once.  I won't be able to do much testing by way of transferring files
> over the LAN for a while either (I imagine that would provide greater
> stress testing).

I think you should easily get this error by transmitting. Streaming
some video is mostly receiving. Just putting some random
(ftp/sftp/iperf) server in the network would make the trick.

-- 
Rafał
