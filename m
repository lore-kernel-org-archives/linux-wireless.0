Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63535 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039Ab2IKX0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 19:26:39 -0400
Received: by wgbdr13 with SMTP id dr13so913954wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 16:26:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard Farina <sidhayn@gmail.com>
Subject: Re: [PATCH] carl9170: fix spurious transmissions in sniffer mode
Date: Wed, 12 Sep 2012 01:26:30 +0200
Cc: linux-wireless@vger.kernel.org, scchen@qca.qualcomm.com,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	marco@tampabay.rr.com, janusz.dziedzic@gmail.com
References: <201209112318.35334.chunkeey@googlemail.com> <504FB53C.6050106@gmail.com>
In-Reply-To: <504FB53C.6050106@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201209120126.31312.chunkeey@googlemail.com> (sfid-20120912_012643_492899_4669CFAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 September 2012 00:03:40 Richard Farina wrote:
> On 09/11/2012 05:18 PM, Christian Lamparter wrote:
> > Several people have complained about an unusual
> > and undocumented feature of the AR9170 hardware:
> > 
> > In siffer mode, the hardware generates spurious
> > ACK frames for every received frame... even
> > broadcasts.
> > 
> > The reason for this malfunction is unknown:
> > <http://marc.info/?l=linux-wireless&m=134517238506033>
> > But there's a workaround: Instead of the special
> > sniffer mode, the hardware will be put into
> > station mode and all rx filters are disabled.
> I am by no means an expert here but wouldn't it be better to disable
> ACK? Or is this not really an option?
Oh AFAIK there's some nifty software which emulates
some sort of accesspoint by (ab-)using monitor mode
and injection. And in this case having a device which
ACKs any frame destined for the semi-fake ap might be
a "good thing".

> Did you test to see if this actually does receive the same number of
> packets as "special sniffer mode"? If so, that really should be in the
> commit message imho.
One problem is that you can't really take two devices,
attach them to separate machines (one machine is patched,
the other isn't) and do a "head-to-head" comparison.
The device on the machine without the "fix" will happily
generate spurious messages which will be picked up by
everyone else (including the other machine). However,
the device on the patched machine does not generate
bogus ACKs, so the device without the patch does not
notice anything unusual... (Yep, this is very confusing.)

Note: The AR9170 MAC hardware does not feed generated
control frames like ACK,RTS/CTS,BACKs, etc... back to
the driver. Only those from other peers are picked up!

> (I know you tested it, but since you didn't say it
> the commit message reads like you didn't).
You are right, but what I need are "Tested-by" tags.
It's sort of pointless if I just add a "works-for-me",
as I do very little with monitor mode.

Regards,
	Chr
