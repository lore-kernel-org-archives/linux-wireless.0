Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0FRKPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:15:49 -0400
Received: by fxm10 with SMTP id 10so495500fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jun 2010 03:15:47 -0700 (PDT)
Subject: Re: [PATCH] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 13:15:42 +0300
Message-ID: <1276856142.9114.1.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-18 at 11:20 +0300, Jussi Kivilinna wrote: 
> Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:
> 
> > On Fri, 2010-05-28 at 13:09 +0300, Jussi Kivilinna wrote:
> >> Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
> >> Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
> >> enabled. With ASPM ath5k will eventually stall on heavy traffic with often
> >> 'unsupported jumbo' warnings appearing. Disabling ASPM L0s/L1 in ath5k fixes
> >> these problems.
> >>
> >> Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
> >> both ends (usually stalls within seconds).
> >
> > This fixes the same nasty problem on my AR2425.
> >
> > My AR2425 will stall if it transmits for about 1~2 minutes.
> >
> > It sends storm of RXORN interrupts although it only transmits.
> >
> > I see that now lspci calls it AR5001.
> >
> > Jussi Kivilinna, million thanks to you. I would never think of going
> > this direction.
> >
> > Luis, so I was right after all, wasn't I?
> > It is a hardware bug that is worked around in windows driver by
> > disabling PCIE ASPM L0S.
> 
> I noticed this L0s disabling in windows driver too. I cannot test this  
> anymore, since I don't have ath5k hw installed anymore (I switched to  
> b43).
> 
> (ok, I might switch back ath5k to work on this, but opening AAO is  
> pain.. on the other hand, I'm just user in this case and pretty  
> unwilling to work with dual-license)
What do you mean?

> 
> I did test device with L0s+L1 enabled (aspm=force), on this setup  
> device fails within seconds. I tested patch with disabling L1 but not  
> L0s, still fails but after longer time. I did _not_ test with L0s off  
> but L1 enabled. So maybe it would be worth to test this patch with  
> just disabling L0s.
I did, and it works.

> 
> AAO150 seems to enable L0s from BIOS, so this happens without  
> aspm=force or CONFIG_.._ASPM at all.
Exactly.


Best regards,
Maxim Levitsky

