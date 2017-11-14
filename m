Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbdKNMmX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 07:42:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Slow connection with rtl8xxxu and 8192eu chipset
References: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com>
Date: Tue, 14 Nov 2017 14:42:18 +0200
In-Reply-To: <1195e649-c57f-1247-a0dc-2f0cc0732a00@gmail.com> (Nikolay
        Borisov's message of "Tue, 14 Nov 2017 11:26:58 +0200")
Message-ID: <87inedkp5h.fsf@purkki.adurom.net> (sfid-20171114_134226_939602_0195B64F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay Borisov <n.borisov.lkml@gmail.com> writes:

> (Please CC as I'm not subscribed)
>
> Hello,
>
> I have the tp-link tl-wn822N usb wifi dongle. lsbusb reports it as
>
> Bus 001 Device 003: ID 2357:0108
>
> Unfortunately with the in-kernel rtl8xxxu driver I don't get very good
> results:
>
> wifi1     IEEE 802.11  ESSID:"HOME"
>           Mode:Managed  Frequency:2.462 GHz  Access Point:
> 30:B5:C2:75:A4:CD
>           Bit Rate=1 Mb/s   Tx-Power=20 dBm
>           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>           Power Management:off
>           Link Quality=26/70  Signal level=-84 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:165   Missed beacon:0
>
>
> At the same time if I use an out of tree driver acquired from github:
> https://github.com/Mange/rtl8192eu-linux-driver I get the following:
>
> wifi1     IEEE 802.11bgn  ESSID:"HOME"  Nickname:"<WIFI@REALTEK>"
>           Mode:Managed  Frequency:2.462 GHz  Access Point:
> 30:B5:C2:75:A4:CD
>           Bit Rate:144.4 Mb/s   Sensitivity:0/0
>           Retry:off   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=81/100  Signal level=100/100  Noise level=0/100
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> Clearly this is a software problem of the in-kernel driver.

iwconfig is old and not really properly supported anymore. Instead use
iw and specifically 'iw wlan0 link' to check the transmit rate. And then
testing speed it's best to use tools like iperf to verify the real
speed, not just rely on what tools report.

-- 
Kalle Valo
