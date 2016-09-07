Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43947 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbcIGIc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 04:32:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Valerio Passini <valerio.passini@unicam.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Stability connection problems in ath9k kernel 4.7
References: <1798564.U2X6r5Zons@automatix>
Date: Wed, 07 Sep 2016 11:32:24 +0300
In-Reply-To: <1798564.U2X6r5Zons@automatix> (Valerio Passini's message of
        "Wed, 07 Sep 2016 09:49:42 +0200")
Message-ID: <87wpio155z.fsf@purkki.adurom.net> (sfid-20160907_103235_456423_59A1CA24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Valerio Passini <valerio.passini@unicam.it> writes:

> I have found some connection problems since 4.7 release using ath9k that turn 
> the wifi pretty useless, I think it might be something in the power management 
> because the signal seems really low. Previously, up to kernel 4.6.7 everything 
> worked very well.
> This is a sample of dmesg in kernel 4.7.2:
>  239.898935] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX 
> [  239.919995] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3) 
> [  239.931877] wlp4s0: authenticated 
> [  239.932357] wlp4s0: associate with XX:XX:XX:XX:XX:XX  (try 1/3) 
> [  239.942171] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431 
> status=0 aid=2) 
> [  239.942301] wlp4s0: associated 
> [  244.802853] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 
> AR_DIAG_SW=0x02000020 DMADBG_7=0x0000
> 6100                                                                                                         
> [  245.931832] wlp4s0: authenticate with XX:XX:XX:XX:XX:XX  
> [  245.953028] wlp4s0: send auth to XX:XX:XX:XX:XX:XX  (try 1/3) 
> [  245.958702] wlp4s0: authenticated 
> [  245.960386] wlp4s0: associate withXX:XX:XX:XX:XX:XX  (try 1/3) 
> [  245.980543] wlp4s0: RX AssocResp from XX:XX:XX:XX:XX:XX  (capab=0x431 
> status=0 aid=2)
>
> lspci on 4.6.7 kernel:
> 04:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network Adapter 
> (rev 01)
>         Subsystem: AzureWave AR9485 Wireless Network Adapter
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at f7900000 (64-bit, non-prefetchable) [size=512K]
>         Expansion ROM at f7980000 [disabled] [size=64K]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
>         Capabilities: [70] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
>         Kernel driver in use: ath9k
>         Kernel modules: ath9k
>
> Probably you need some debugging output, but before recompiling the kernel I 
> would like to know if you are interested in any kind of help from me and what 
> steps I should take (I'm able to help in testing patches but I'm not familiar 
> with git). Thank you

Usually it's really helpful if you can find the commit id which broke
it. 'git bisect' is a great tool to do that and this seems to be a nice
tutorial how to use it:

http://webchick.net/node/99

Instead of commit ids you can use release tags like v4.6 and v4.7 to
make it easier to start the bisect. Just make sure that v4.7 is really
broken and v4.6 works before you start the bisection.

-- 
Kalle Valo
