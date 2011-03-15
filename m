Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47311 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1COH6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 03:58:52 -0400
Received: by qyg14 with SMTP id 14so276270qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 00:58:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinBTXduB-uQp7FqNjPdzUm5=0v8vrE79oi5Toez@mail.gmail.com>
References: <AANLkTinBTXduB-uQp7FqNjPdzUm5=0v8vrE79oi5Toez@mail.gmail.com>
Date: Tue, 15 Mar 2011 08:58:51 +0100
Message-ID: <AANLkTikHx2J-zzCob+xVy04=RYX+K9T2HJ_14zyrto2J@mail.gmail.com>
Subject: Re: Broadcom 4331 wireless device
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Chris Neugebauer <chrisjrn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/15 Chris Neugebauer <chrisjrn@gmail.com>:
> I've recently picked up a MacBook Pro 8,1.  Its onboard wireless is a
> Broadcom 4331, which appears to be a very new chipset.  Has work begun
> on support for this device, and if not, what help can I provide to get
> work started on it (as a non-kernel developerey type)?
>
> Thanks,
>
> --Chris
>
> P.S. Please CC me as I'm not on this list.
>
> P.P.S lspci -vnn output:
>
> 03:00.0 Network controller [0280]: Broadcom Corporation Device
> [14e4:4331] (rev 02)
>        Subsystem: Apple Computer Inc. Device [106b:00d6]
>        Flags: bus master, fast devsel, latency 0, IRQ 11
>        Memory at a0600000 (64-bit, non-prefetchable) [size=16K]

bcmdevs.h:
#define BCM4331_D11N_ID         0x4331  /* 4331 802.11n dualband id */
#define BCM4331_D11N2G_ID       0x4332  /* 4331 802.11n 2.4Ghz band id */
#define BCM4331_D11N5G_ID       0x4333  /* 4331 802.11n 5Ghz band id */

So yes, it looks like new BCM4331 chipset. AFAIK there is no support
for it in wl. Plus no support in b43 or brcm80211.

-- 
Rafał
