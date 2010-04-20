Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:57334 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab0DTJcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 05:32:42 -0400
Received: by ewy20 with SMTP id 20so1830289ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Apr 2010 02:32:41 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Duarte Nuno Gomes <dnunogomes@gmail.com>
Subject: Re: p54pci does not work
Date: Tue, 20 Apr 2010 11:32:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <u2u719bd8781004122247kb48bedet36ea07db3819d202@mail.gmail.com> <201004131948.31080.chunkeey@googlemail.com> <i2u719bd8781004192319ge1e40479oa17f0f5036a6cee@mail.gmail.com>
In-Reply-To: <i2u719bd8781004192319ge1e40479oa17f0f5036a6cee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004201132.31766.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 April 2010 08:19:11 Duarte Nuno Gomes wrote:
> On Tue, Apr 13, 2010 at 6:48 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Tuesday 13 April 2010 07:47:42 Duarte Nuno Gomes wrote:
> >> it works all ok ... when i visit some websites ( www.rcmadeira.pt.vu is one
> >> of them ), my connection just disconnects and i cannot resume it . i need to
> >> shutdown and re lauch kernel in order to work with wireless again.
> >
> > hrmf, works here no matter how much i try.
> > But let's not get carry away, I guess the problem you are describing
> > has more to do with the amount of data which is transfered.
> > Ideally, you should be able to reproduce this _hang_ with any network
> > benchmarking tools (like iperf / nttcp / netperf (or whatever you prefer)).
> i would if u had a way of having a demon running on some shell and
> know what to check for
> >
> >> here is what dmesg outputs
> >>
> >> No probe response from AP 00:24:17:6c:a5:0e after 500ms, disconnecting.
> >> Phy0 : cannot boot firmware !
> >
> > are you getting these messages in this order? (some timestamps,
> > and maybe p54pci dmesg output while initializing would be jolly nice)
[...]
> >
> >  * Wireless setup (Which band (2.4 or 5GHz) ? Do you use WPA/WPA2 with CCMP/TKIP,
> >   (you can turn off the hw crypto accelerator by loading p54common with the module
> >    parameter nohwcrypt=1 )
> 
> 2.4 Ghz with WPA / TKIP
> IT WORKS WITH THAT NOHWCRYPT PARAMETER! ill test a little more !
> just need to figure out now , how to load it with parameter on boot !
> easy task !

echo "options p54common nohwcrypt=1" > /etc/modprobe/p54common.conf,
if you compiled p54common as a module (which I hope you did).
if p54common is built-in, then you'll have to add a p54common.nohwcrypt=1
kernel cmdline parameter.

The (most likely) reason why your AP drops you and does not allow you
to reconnect, is probably due to the "TKIP countermeasures".
What's your Accesspoint/Router and which firmware are you currently using?

Regards,
	Chr
