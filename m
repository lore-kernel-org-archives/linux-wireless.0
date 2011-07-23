Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44026 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab1GWTWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 15:22:36 -0400
Received: by vws1 with SMTP id 1so2276011vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 12:22:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107151622.43671.chunkeey@googlemail.com>
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>
	<201107151622.43671.chunkeey@googlemail.com>
Date: Sat, 23 Jul 2011 14:22:35 -0500
Message-ID: <CAJ8GFOiQfMvZAHh4ahCx5_ovqh4_83+a3QADVuNVRohaKyAR6A@mail.gmail.com> (sfid-20110723_212240_076892_F67C7121)
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
From: Harshal Chhaya <harshal@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

Thanks for your patch - it definitely helped. My feedback to this (and
some more info) is below.


On Fri, Jul 15, 2011 at 9:22 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday 14 July 2011 21:37:29 Harshal Chhaya wrote:
>> I am working on an AP design that uses a TI-OMAP3 host processor with
>> an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
>> carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.
> One question: have you considered ath9k_htc? I would certainly recommend
> it over any ar9170 device.

I was under the impression that AP mode support is better in carl9170
than in ath9k_htc. I had considered using AR9271 (which is a more
recent chipset than the AR9170) but decided against it based on my
understanding (which is based on the info on the wiki pages).

If AR9271 (and ath9k_htc) are more stable and preferable to the AR9170
w/ carl9170, please let me know.

Also, to clarify: my application is a wireless network that needs to
support 60-70 802.11g clients connecting to the AP using WPA2-PEAP.
All of the clients are battery powered and use the power save
mechanisms of 802.11.

Do you see any issues using AR9170 and carl9170 in this scenario?

Also, I am running openWRT on an TI-OMAP3 processor @ 600 MHz.


>> During network tests, several of the clients drop-off the network.
> what tests? Also isn't there any verbose logs on the client/ap to why
> they kick each other?

The clients didn't have any helpful logs except that they disconnected
due to not seeing any beacons for a few seconds. That's when I started
looking at the beacons in more detail.


>> The packet captures show that the beacons sent by the AP are at a much
>> lower power than the other data packets. Is this wide variation in the AP's
>> transmit power the expected behavior with this driver/firmware/chipset?
>> If not, where do I look to fix this.
> Try this:
> ---
> diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
> index 261f893..3025f0b 100644
> --- a/drivers/net/wireless/ath/carl9170/hw.h
> +++ b/drivers/net/wireless/ath/carl9170/hw.h
> @@ -391,7 +391,39 @@
>
>
[patch snipped for brevity and also because it has been submitted in a
separate email]


This patch definitely helped stabilize the network. Thanks a lot for
looking into this and providing the patch.

However, I still see problems when I enable both WPA2 and power-save
on the clients.

Here is what I have tried so far:

30 802.11g clients

open mode + power save - no problems, can send data to all 30 for hrs
wpa2 + disable power save - no problems, can send data to all 30 for hrs
wpa2 + enable power save - clients connect but then randomly
disconnect every few seconds.

My delay in replying is due to this odd behavior I was seeing. It took
me a couple of days to figure out what was going on.


Any suggestions on where to look for this problem?

Thanks again,
- Harshal
