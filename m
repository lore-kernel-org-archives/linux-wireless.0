Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osmium.mv.net ([199.125.85.152]:56026 "HELO shell.mv.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759107Ab0FRJbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 05:31:18 -0400
Date: Fri, 18 Jun 2010 05:09:23 -0400 (EDT)
From: RHS Linux User <xxx@nei.mv.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
In-Reply-To: <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
Message-ID: <Pine.LNX.3.95.1100618050609.1393G-100000@nei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi All,

   Let's hear it for chips without available specs!

   Does anyone remember the days when paper specs arrived in plain
envelopes with no return address when you asked the manufacturer for some
real support?

   And lets hope they are REAL low in price!

   wiz


On Fri, 18 Jun 2010, Jussi Kivilinna wrote:

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
> 
> I did test device with L0s+L1 enabled (aspm=force), on this setup  
> device fails within seconds. I tested patch with disabling L1 but not  
> L0s, still fails but after longer time. I did _not_ test with L0s off  
> but L1 enabled. So maybe it would be worth to test this patch with  
> just disabling L0s.
> 
> AAO150 seems to enable L0s from BIOS, so this happens without  
> aspm=force or CONFIG_.._ASPM at all.
> 
>   -Jussi
> 
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
> 

