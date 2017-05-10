Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbdEJJdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 05:33:00 -0400
Date: Wed, 10 May 2017 11:31:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marek =?utf-8?Q?Floria=C5=84czyk?= <marek.florianczyk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Cubieboard2 + hostapd + 100 wireless devices
Message-ID: <20170510093113.GA9584@redhat.com> (sfid-20170510_113304_341154_0386E5EB)
References: <1946348.9jam7OIK4C@franki>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1946348.9jam7OIK4C@franki>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 07, 2017 at 02:19:25PM +0200, Marek Floriańczyk wrote:
> Hello all,
> 
> I need to set up such a configuration:
> Cubieboard2 with Debian Jessie, Hostapd 2.6 as an AP, usb wifi dongle + 100 
> devices with NodeMCU module:
> http://www.electrodragon.com/product/esp-12f-esp8266-wifi-board/
> 
> I'm using usb wifi dongle based on Ralink RT5370 Wireless Adapter,
> after I have switched hostapd network mode to "b" it works quite well (tested 
> with 70 devices). Only text commands are going to be send from server to 
> devices, so I don't need high speed, I need reliability.
> 
> Has someone any experience with such a setup ?
> Would one recommend different wifi dongle (maybe more powerful), with different 
> chipset?

If RT5370 works for you I would stick with it. RTxxx chips with rt2800
driver are capable to support up to 190 stations with HW encryption and
11n aggregation (something that you are not interested). Theoretically
more stations can be added and those should fallback to software
encryption and frame aggregation will not be done, but I'm not sure if
anyone test that.

I'm also not sure if many people test 11b, perhaps 11g would be better
choice. BTW, what kernel version are you using (I'm curious if 11b
still works on latest kernels) ?

Stanislaw
