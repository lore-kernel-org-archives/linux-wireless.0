Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61063 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0L3X1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 18:27:21 -0500
Received: by fxm20 with SMTP id 20so11552483fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 15:27:20 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Chin Shi Hong <cshong87@gmail.com>
Subject: Re: Get slow speed when using ar9170usb driver.
Date: Fri, 31 Dec 2010 00:27:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimYqrqUK2EjnyvkwvsFM+6b7ZMTGjBQrWFT712T@mail.gmail.com> <AANLkTikeehA_cMHndCRidknqVc7Y49_JmPbt4+Np6jDx@mail.gmail.com>
In-Reply-To: <AANLkTikeehA_cMHndCRidknqVc7Y49_JmPbt4+Np6jDx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201012310027.14433.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 30 December 2010 16:55:18 Chin Shi Hong wrote:
> Dear All,

Hello,

> Wireless adapter model: TP-LINK WN821NC (USB 300Mbps Wireless N adapter)
> Output of lsusb: Bus 001 Device 007: ID 0cf3:1002 Atheros
> Communications, Inc. TP-Link TL-WN821N v2 [Atheros AR9001U-(2)NG]
> Wireless router: TP-LINK W8960N (300Mbps Wireless N router)

That's weird, according to TP-Link's website there wasn't any WN821NC
with a WN821N v2. They "only" let you download the driver for
WN821N v3. v3 very different from the previous v2 generation, it has
new chips (AR7015+AR9287?) and needs the ath9k_htc driver.

Are you sure, you didn't get ripped off here and someone else
has "your" v3?

> Driver name ar9170usb
> Linux distro: Ubuntu 10.10 64 bit
> Kernel version: 2.6.35-24-generic
> 
> If I use Ndiswrapper + Windows XP driver, I can get full 300Mbps.
Have you measured that (with iperf/netperf)? Or is it just the
"Connection Information" pop-up which simply displays "speed: 300 Mbits" ?

> At the same distance, if I use ar9170usb driver, I can only get
> maximum 54Mbps speed.
That's true. here's ar9170usb wiki page:
<http://wireless.kernel.org/en/users/Drivers/ar9170#features> => working
	"802.11 a/b/g"

Also, the old stack (in 2.6.35) does not have minstrel_ht
(rate control algorithm for 11n) so ar9170usb is limited to
the legacy b/g rates.

Furthermore, the old driver lacks any support for aggregation, so the
uplink throughput (even with the fastest 300 mbits rate and under
"perfect" lab conditions) would struggle to get to 40 mbit and beyond.

--

The quickest way around limitations is via backports:
visit <http://wireless.kernel.org/en/users/Download>
and get compat-wireless:

<http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu>

Then, you can migrate to carl9170 (a new driver with a new firmware)
for more information, see:
<http://wireless.kernel.org/en/users/Drivers/carl9170>

However, this "new" driver+fw is still in development. You definitely
want to keep your compat-wireless package up-to-date.

Best Regards,
	Christian
