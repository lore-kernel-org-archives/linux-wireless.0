Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:41221 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbXJVKtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 06:49:45 -0400
Received: by nf-out-0910.google.com with SMTP id g13so971920nfb
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2007 03:49:44 -0700 (PDT)
Message-ID: <2cf3b3170710220349t37ba7dd5ge04678559a9c69a5@mail.gmail.com> (sfid-20071022_114959_380270_EB4EE1EE)
Date: Mon, 22 Oct 2007 11:49:44 +0100
From: "Robin Wood" <dninja@gmail.com>
To: "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: rtl8187 not being registered
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710212125.34532.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2cf3b3170710211433t253b6a8ck7d4c6d0913d5256b@mail.gmail.com>
	 <2cf3b3170710211435k36f17aaeqed5dba65718de21a@mail.gmail.com>
	 <200710212125.34532.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/2007, Michael Wu <flamingice@sourmilk.net> wrote:
> On Sunday 21 October 2007 17:35:27 Robin Wood wrote:
> > I've just got the latest kernel source (2.6.23) from git and compiled
> > rtl8187 drivers as modules. When I plug the device in I get the
> > followoing:
> >
> > usb 1-3: new high speed USB device using ehci_hcd and address 3
> > usb 1-3: configuration #1 chosen from 1 choice
> > wmaster0: Failed to select rate control algorithm
> > wmaster0: Failed to initialize rate control algorithm
> > rtl8187: Cannot register device
> > rtl8187: probe of 1-3:1.0 failed with error -2
> >
> Make sure the rc80211_simple module can be found and is loaded.
>

Maybe a step closer but still not working. I now get this error:

usb 1-3: new high speed USB device using ehci_hcd and address 4
usb 1-3: configuration #1 chosen from 1 choice
wmaster0: Selected rate control algorithm 'simple'
wmaster0: Failed to initialize wep
rtl8187: Cannot register device
rtl8187: probe of 1-3:1.0 failed with error -12

I've modprobed in the rc80211_simple module and checked that mac80211
and eeprom are in also loaded:

# lsmod |grep |818|arc|ecb"
rtl8187                35200  0
eeprom_93cx6            6016  1 rtl8187
rc80211_simple          7808  0
mac80211              117512  2 rtl8187,rc80211_simple
arc4                    5888  0
ecb                     6656  0
blkcipher               8836  1 ecb
crypto_algapi          13824  2 arc4,ecb


I've read that this problem is caused by the failure to init wep which
is sometimes caused by loading modules in in the wrong order. This is
the order I used:

  638   modprobe  ecb
  636   modprobe arc4
  639   modprobe mac80211
  640   modprobe rc80211_simple
  641   modprobe rtl8187

What am I missing?

Robin

> -Michael Wu
>
>
>
>
