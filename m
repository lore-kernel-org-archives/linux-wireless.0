Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33736 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2IYG3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 02:29:17 -0400
Received: by wgbdr13 with SMTP id dr13so4412913wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2012 23:29:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1698401.RCfH1UvLZM@pebbles>
References: <1698401.RCfH1UvLZM@pebbles>
Date: Tue, 25 Sep 2012 08:29:16 +0200
Message-ID: <CACna6rwH5ixD=f_oXse9AZpK_SNoMEXu=n-2c4ba5gFy1u3prQ@mail.gmail.com> (sfid-20120925_082923_040812_7A42296F)
Subject: Re: Throughput regression in b43 caused by spurious avoidance implementation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Stefan_Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/24 Stefan Brüns <stefan.bruens@rwth-aachen.de>:
> Hi everyone,
>
> as I have been plagued by the performance regression in b43 between linux 3.2
> and 3.3, I have bisected it:
>
> git bisect good
> 49d55cef5b1925a5c1efb6aaddaa40fc7c693335 is the first bad commit
> commit 49d55cef5b1925a5c1efb6aaddaa40fc7c693335
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Sun Dec 11 13:16:51 2011 +0100
>
>     b43: N-PHY: implement spurious tone avoidance
>
>     Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> :040000 040000 f6177f4c33e1d382a430ad83db1e4b3f9dd66dfd
> 1b161ac9a16a481f259606edda5039c2be5147f4 M      drivers
>
> lspci -v{n,}:
> 08:00.0 0280: 14e4:432b (rev 01)
>         Subsystem: 1028:000d
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at f0600000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [e8] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number 7e-d8-e5-xx-xx-xx-xx
>         Capabilities: [16c] Power Budgeting <?>
>         Kernel driver in use: b43-pci-bridge
>
> 08:00.0 Network controller: Broadcom Corporation BCM4322 802.11a/b/g/n
> Wireless LAN Controller (rev 01)
>         Subsystem: Dell Wireless 1510 Wireless-N WLAN Mini-Card
>
> Used channel is channel 13, 2.472GHz, AP is AVM 7112, "G-only" mode.

I'll take a look at this, unfortunately I'm leaving on Friday (for a
week), not sure if I'll find time before that...

-- 
Rafał
