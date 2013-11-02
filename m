Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:49517 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab3KBVyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Nov 2013 17:54:06 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so2648526eae.24
        for <linux-wireless@vger.kernel.org>; Sat, 02 Nov 2013 14:54:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: alexandre.f.demers@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: r92su: status and will it be merged anytime soon?
Date: Sat, 02 Nov 2013 22:50:22 +0100
Message-ID: <1549404.FOHYIQhGu0@debian64> (sfid-20131102_225411_020029_04FC2B24)
In-Reply-To: <52755E44.1060501@gmail.com>
References: <52755E44.1060501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Saturday 02 November 2013 16:19:16 Alexandre Demers wrote:
> I was playing in r8712u because I wanted to send a patch to 
> conditionally silence a flooding netdev_info(). But then I found out on 
> http://wireless.kernel.org/en/users/Drivers/rtl819x that r8712u was to 
> be replaced by r92su.
> 
>  From its git tree, it seems no commit were added since 4 months ago. 
> Could someone tell me in what shape is this new driver? Is there any 
> plan to merge it (under staging I suppose) soon?

That's the story:

"Yes, r8712u has been in staging for a long time; however, it is not a
matter of improving it. For a new wireless driver to be included in the
main wireless directories, it must use mac80211."

<http://www.spinics.net/lists/linux-wireless/msg105633.html>

r92su is "just a nice" rewrite of r8712u with a cfg80211 interface.
However, this is due to the firmware interface shortcomings. For 
instance the r8712u firmware won't allow a driver initialize the PHY.
It's true that there's a command to set the phy to a specified 
channel, however it's not possible to define the channel mode.
(whenever it is supposed to be legacy, HT20, HT40+ or HT40-.)

The issue with r92su is: The driver is ready, but it's fundamentally
incompatible with the rtlwifi framework and mac80211.

...

However, 

José Vázquez discovered that Realtek has produced two linux drivers
for these devices. The other driver (and more importantly: the firmware)
can be the base for a rtl8192su+rtlwifi driver 
(which could even support a proper AP mode!)

If you want to take a look:
<http://www.edimax.com/images/Image/OpenSourceCode/Wireless/Router/AR-7284WnA/AR-7284WnA&B_SDK_6222.tar.zip>

The driver is located in:
  Edimax/src/kernel/linux-2.6.18.8/drivers/usb/net/8192su

The firmware + phy values:
  Edimax/src/kernel/linux-2.6.18.8/usr/ramfs/usr/rtl8192su

So, it's back to the drawing board.

...

I hope this answers your question, if not... let me know ;).

Regards

Christian
