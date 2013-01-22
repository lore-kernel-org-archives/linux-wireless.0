Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32872 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3AVLfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 06:35:55 -0500
Received: by mail-wi0-f182.google.com with SMTP id hn14so5803509wib.15
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 03:35:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000301cdf87b$0ef2a020$2cd7e060$@co.kr>
References: <000301cdf87b$0ef2a020$2cd7e060$@co.kr>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 22 Jan 2013 22:35:31 +1100
Message-ID: <CAGRGNgU8qDPZCWR0KryJ7_P0En-01AccBAH+qzyCExv9TFRSsQ@mail.gmail.com> (sfid-20130122_123559_411677_536AD1DE)
Subject: Re: AR6003 :: IP packet is not received.
To: =?EUC-KR?B?sce/68H4?= <gyj@x-node.co.kr>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Content-Type: text/plain; charset=EUC-KR
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gueon,

I wish I spoke Korean so we could talk easier.

On Tue, Jan 22, 2013 at 7:32 PM, ±Ç¿ëÁø <gyj@x-node.co.kr> wrote:
> Dear ath6kl-devel,
>
> I Korea's human-intech Work in a company that is Gueon.
> I am porting and embeded-board wlan AR6003 chipset features.
> embeded-board CPU samsung S5PV210, linux kenel-2.6.32 is used.

So you're porting Linux to an embedded board with a Samsung S5PV210
CPU and a AR6003 wireless chipset.

I assume that you have to use kernel version 2.6.32. I must point out
that version is rather old and a lot of changes have been made to the
drivers since then. That said, if needed, you may be able to use
compat-wireless to get the latest version of the driver running on
that particular kernel version.

> wpa_supplicant using softAP mode, powered by letting success to other client devices (ex: Desktop PC) AP Access.
>         [wpa_supplicant -i wlan0 -c /home/ath6k/SoftAP/softap.conf -Dnl80211 -B]
>         [version : wpa_supplicant v2.0-devel Copyright (c) 2003-2012]
>
> Does not accept the IP address from the DHCP client device(PC), the problem occurs.

So exactly what are you trying to do here?

Are you:

1. Trying to use the embedded board as an access point and connecting
the PC to it?

2. Trying to use the PC as an access point and connecting the embedded
board to it?

wpa_supplicant cannot run an access point. You need to use the hostapd
program to run an access point.

> I have a problem during the analysis.
> I spoke to experiment by setting a fixed IP without using a DHCP
> When embeded-Board from the PC to ping-test responses.
> However, PC from the embedded-Board to ping-test does not responses.
>
> Whether the idea of something I could try?

>From what you've described, it sounds like the wireless cards are not
connecting.

What messages are you getting in the kernel log (dmesg)?

If you run the "ifconfig -a" command, is your wireless card's network
interface UP and RUNNING?

Can you connect to an access point using this embedded board?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
