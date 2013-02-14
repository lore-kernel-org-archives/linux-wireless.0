Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:58581 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3BNBvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 20:51:52 -0500
Received: by mail-ob0-f176.google.com with SMTP id v19so1940940obq.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2013 17:51:52 -0800 (PST)
Message-ID: <511C4336.6060508@lwfinger.net> (sfid-20130214_025156_502804_086F2D34)
Date: Wed, 13 Feb 2013 19:51:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hendrik-Jan Heins <hjheins@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Forcing Realtek based usb device into wireless G mode
References: <CAAU0D9f54W7L=kwTYEC4o8n4nr5hnSSOSNzQxEBDWLkPUFM6mQ@mail.gmail.com> <CAAU0D9d-uESonqoz11Dpd9K7gyRXf9ASsKtX3xtXZHYyO_Jwig@mail.gmail.com>
In-Reply-To: <CAAU0D9d-uESonqoz11Dpd9K7gyRXf9ASsKtX3xtXZHYyO_Jwig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 06:06 PM, Hendrik-Jan Heins wrote:
> Dear list,
>
> Currently  I have an issue with a USB wireless device that does not
> work in n-mode. It does however work in g-mode.
> So far I have found out that setting my access point to g-mode will
> force the whole network into g-mode, and thus the card works.
> However, I would like to keep my network running in n-mode and just
> force the card into g-mode.
>
> I tried: "iwconfig wlan1 rate 54M"
> but this does not work, according to iwconfig the card stays on 300M.
>
> Does anyone know how I can force this either in userland or maybe by
> modifying the driver source?
>
> The device:
> USB ID 0bda:8172 Realtek Semiconductor Corp. RTL8191SU 802.11n WLAN Adapter
>
> the driver in kernel 2.6.32:
> r8192s_usb
> though I would also like to use this device on a kernel 3.0.63, and I
> am not sure the same driver is in use there.

That is not the best driver for your device. You should be using driver r8712u, 
which has been in the staging tree of the kernel since 2.6.37. It works with 
802.11n. Using my standard tests with netperf, I get the following:

finger@larrylap:~/wireless-testing-new> ~/netperf_stats.pl sonylap 3
Pass 1
TCP_MAERTS Test:  56.08 53.95 59.70 59.05 56.02 66.14 59.44 64.85 56.92 65.15
RX Results: max 66.14, min 53.95. Mean 59.73(4.07)

TCP_STREAM Test:  35.84 38.22 37.47 38.14 38.66 38.89 37.27 39.74 38.08 37.43
TX Results: max 39.74, min 35.84. Mean 37.97(1.01)

Each of those speeds is in Mbps, and comes from a 3 second test against my 
netperf server, which runs on a host that is connected by a 100 Mbps wire to my 
AP - a Netgear WNDR3400V2 running standard firmware. The MAERTS is the RX test - 
STREAM is TX.

Note: If these tests had been run at 802.11g rates, the maximum would be less 
than half of the maximum rate on the link, or 27 Mbps for a 54 Mbps link.

As I am not familiar with the code in the driver you are using, I have no idea 
what you might do to lock out HT mode; however, when you switch to the correct 
driver, you should be able to operate under 802.11n.

Larry


