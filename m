Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:9495 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYAEVya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jan 2008 16:54:30 -0500
Received: by py-out-1112.google.com with SMTP id u52so11786358pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jan 2008 13:54:30 -0800 (PST)
Message-ID: <43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com> (sfid-20080105_215436_065864_54944967)
Date: Sat, 5 Jan 2008 16:54:29 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: rtl8187 rate control doesn't work
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	linux-kernel@vger.kernel.org,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <477F9890.5050107@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <477F9890.5050107@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 5, 2008 9:47 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Hi
>
> Now the compat-wireless-2.6 package is working and I get an Internet
> connection with my rtl8187 based card. (It's on an ASUS P5B Deluxe)
>
> I used the compat-wireless-2.6 package for this log, but I have the same
> problem with the version integrated in kernel 2.6.24-rc6
>
> The Access Point is some rooms away so the signal is not the best at my
> location. When starting the device with no fixed rate it wants to
> connect with 54MBit/s and as iwconfig says it was successful but I can't
> ping any device in the wireless LAN. (it's the first part of the log)
> The rate will not be slowed down it stays fixed at 54MBit/s.
>
> After starting the device with rate fixed to 11M I get a connection to
> the Access Point and iwconfig's output looks the same as without fixed
> rate, but I'm able to ping the all devices in the network. (second part
> of the log)
> Now it slows down the rate to 1MBit/s

Seems to be the new PID rate control algorithm. I believe Stephano
(CC'd) was sending some patches for this. Please try changing in
config.mk

>From this value:

CONFIG_MAC80211_RC_DEFAULT=pid

To this:

CONFIG_MAC80211_RC_DEFAULT=simple

and let us know how that goes. Oh and linux-kernel is the wrong list
to use, please just use linux-wireless for future e-mails.

  Luis
