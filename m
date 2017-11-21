Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.44.157]:37549 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbdKUVaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 16:30:55 -0500
Date: Wed, 22 Nov 2017 08:30:46 +1100
From: James Cameron <quozl@laptop.org>
To: =?iso-8859-1?Q?R=E1kosi?= Gergely <rakosi.gergely@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8723be on Fedora27
Message-ID: <20171121213046.GD5400@us.netrek.org> (sfid-20171121_223126_158351_5411869E)
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
 <c6662534-db2f-61dc-142e-8015984c6813@gmail.com>
 <2524fe93-9d8a-523e-3256-2b495c951eb0@lwfinger.net>
 <d4ba5178-3d60-76b0-3819-e70e3e173fac@gmail.com>
 <20171121203746.GC5400@us.netrek.org>
 <e639e8df-7cea-87c5-add9-cea1c5e57a8a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <e639e8df-7cea-87c5-add9-cea1c5e57a8a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 21, 2017 at 09:52:12PM +0100, Rákosi Gergely wrote:
> 2017-11-21 21:37 keltezéssel, James Cameron írta:
> > On Tue, Nov 21, 2017 at 03:08:16PM +0100, Rákosi Gergely wrote:
> >> 2017-11-18 16:52 keltezéssel, Larry Finger írta:
> >>> On 11/17/2017 06:22 PM, Rákosi Gergely wrote:
> >>>> Hello Larry,
> >>>>
> >>>> First of all, thanks your help.
> >>>> Lets see...here is the kernel version: 4.13.12-300
> >>>> The machine is an Asus ROG 553VE
> >>>>
> >>>> The firmware which loading in the dmesg is : rtlwifi/rtl8723befw_36.bin
> >>>> The output of md5sum is : 1850c1308fbcd95e9f6a7f58ede1e35f
> >>> [...]
> >>> sudo iw dev wlan0 scan | egrep "SSID|signal"
> >>>
> >>> Post that output. In addition, copy the dmesg output to some pastebin
> >>> and post the link as well.
> >>>
> >>> Larry
> >>>
> >> Hello Larry,
> >>
> >> I hope this email post format is good, and fit to the rules.
> >> Here is the output:
> >>
> >> root@skynet-x2 ~]# iw dev wlp2s0 scan | egrep "SSID|signal"
> >>         signal: -46.00 dBm
> >>         SSID: SKYNET-X2
> >> [...]
> >> [root@skynet-x2 ~]#
> > Scan results seem normal.  Was this scan before disconnect?
>
> Yes, this command output taken while the connection was OK

Thanks.

> >> And the dmesg output:
> >>
> >> https://pastebin.com/iqQSu2hD
> > Is now v4.13.13.
>
> Yes, thats the upgraded kernel
>
> > This is interesting, an H2C command was dropped, but no idea which.
> >
> > [    9.848052] rtl8723be: error H2C cmd because of Fw download fail!!!
> >
> > Disconnection happened at boot+440 seconds, associate+429 seconds;
> >
> > [  439.871033] rtlwifi: AP off, try to reconnect now
> > [  439.871093] wlp2s0: Connection to AP 4c:5e:0c:c7:fa:e3 lost
> >
> > I cannot tell what causes disconnect.  I wonder if the same
> > timing of the problem happens always, or if the timing varies.
>
> The timing always changing, never is the same. And I dont realize
> the cause at now...

Thanks.  I had similar problem with different wireless device.

> > Init MAC failed was another 30 seconds later;
> >
> > [  468.600670] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> > [  469.618926] rtl8723be: Init MAC failed
> >
> > Looking at _rtl8723be_init_mac, there are two false returns;
> > hardware power on fail, and llt write fail.
> >
> > Sorry, I don't have rtl8723be hardware.
> >
> > Rákosi, did any older kernel keep connection?
> 
> The oldest kernel is 4.13.9-300.fc27.x86_64 in Fedora 27
> installation, but did the same.  If you can give advise how, and
> what I do, then I'll try it.

You might try running "Live CD" of Fedora 26 or Fedora 25, without
installing, to test if unexpected disconnection happens in two older
kernels.  Not for permanent solution, just for easy testing.

I don't have specific advice for Fedora 27, you might ask Fedora
community about that, or use RHBZ.  A quick search finds this old 2013
page;

https://fedoraproject.org/wiki/User:Ignatenkobrain/Kernel/Bisection

-- 
James Cameron
http://quozl.netrek.org/
