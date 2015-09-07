Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:46365 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbIGVB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 17:01:29 -0400
Message-ID: <55EDFB26.8000708@broadcom.com> (sfid-20150907_230132_319690_056E5A48)
Date: Mon, 7 Sep 2015 23:01:26 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Gucea Doru <gucea.doru@gmail.com>, <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: bcmdhd: Concurrent use of wlan0 and virtual interface in
 managed mode
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>	<55DAD0FD.3070807@broadcom.com>	<CANfLQrYQnk6bUjPEKxucxBhLvsRsqpfydvAkvsvKdg0nnte3iA@mail.gmail.com>	<CAG8K7gRdXqpfA3_HPoaM+ivgxH4eiPRWkD238QwMMbNigYHDBw@mail.gmail.com>	<CANfLQraZAkw0Eqt-Mog5t4ZfGFx3xm_8-6nJoJ68Mim18bW3Tg@mail.gmail.com> <CANfLQrYVq_eMa-CLJhqVthbm_h7yLBhZN5nm0_f70eEob+rUdw@mail.gmail.com>
In-Reply-To: <CANfLQrYVq_eMa-CLJhqVthbm_h7yLBhZN5nm0_f70eEob+rUdw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/07/2015 10:41 PM, Gucea Doru wrote:
> Hello,
>
> Thanks for helping me. I have some more questions related to parallel
> usage of p2p and STA (station) interface.
>
> I use a Nexus 5 device which has a BCM4339 [1] chip and it seems that
> it's possible to transfer data in parallel using two connections: one
> based on Wi-Fi direct(p2p, 2.4Ghz) and the other one based on a
> connection to AP (wlan0, 5Ghz).
>
> This is done by _time-sharing_ the wireless interface radio? From my
> understanding the mac80211 layer have support for multiple virtual
> interfaces and the switching between this interfaces is done inside
> mac80211. Does the driver creates multiple virtual interfaces (one for
> p2p and one for the connection to the AP) and the mac80211 manages the
> time-sharing between them?

Nope. The BCM4339 chip does not rely on mac80211. Instead, there is an 
802.11 stack running on the device, ie. in firmware. The driver creates 
the primary interface, ie. wlan0. Additional P2P interfaces are created 
by wpa_supplicant.

> I am interested in understanding the code that decides how much the
> radio should stay on a specific channel. I would be really grateful if
> you could give me some details about the architecture.

That code runs in firmware on the device and is proprietary. So I can 
not disclose any details.

Regards,
Arend

> [1] http://www.broadcom.com/press/release.php?id=s766879
>
> Thanks,
> Doru
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

