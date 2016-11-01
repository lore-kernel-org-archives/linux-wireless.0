Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168198AbcKAMjS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 08:39:18 -0400
Date: Tue, 1 Nov 2016 13:38:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: "silent" TL-WDN4200 (RT593 usb) devices
Message-ID: <20161101123803.GA14803@redhat.com> (sfid-20161101_133923_483398_61A4348A)
References: <CAOiHx=nbLZHW94MF+ki8CXO9n_S5b26t1O9p_pFPu6Z1mZmOtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOiHx=nbLZHW94MF+ki8CXO9n_S5b26t1O9p_pFPu6Z1mZmOtw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Nov 01, 2016 at 10:33:14AM +0100, Jonas Gorski wrote:
> I have a bunch of rt5393 based TL-WDN4200 devices of which only one is
> working as expected, and the rest fail to tx with rt2800-usb, using
> latest master of lede (but also older verions). They are working fine
> with the windows drivers.
> 
> Symptoms are:
> 1. Scanning works fine (so RX seems to work)
> 2. Trying to assoc in STA mode will time out
> 3. In AP mode it won't show up on scan by other devices
> 
> I tried listening with tcpdump (from an ath9k card, with encryption
> disabled), but didn't see anything on the air from the non-working
> sticks.
> 
> I also tried comparing the rt3593 ralink driver with rt2x00, and
> couldn't find any differences on a first glance, so I'm a bit stumped.
> Any pointers what else I can try/test would be good.
> 
> For comparison, I attached the eeprom contents from a working and a
> non working stick, in hope it will help. 

I can not see anything unusual in EEPROM dumps and I not sure if
that makes difference. It could not be a good idea, but you can
try to hardcode EEPROM from good device in the driver and
run that on bad device and see what happens.

>If needed, I can try to
> create a usb trace on windows.

I have dump tool for compare registers programing of ralink usb
drivers, however it works with linux usbmon (I use it compare
vendor linux driver with rt2x00). Not sure how much changes
it will require to make it work with usb dump from windows.

https://github.com/sgruszka/rt2x00usb_dump

Stanislaw
