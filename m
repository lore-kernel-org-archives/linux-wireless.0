Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:48346 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0FQUdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 16:33:12 -0400
Received: by fg-out-1718.google.com with SMTP id l26so177235fgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 13:33:10 -0700 (PDT)
Subject: Re: [PATCH] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	Bob Copeland <bcopeland@gmail.com>
In-Reply-To: <20100528100901.14580.1322.stgit@fate.lan>
References: <20100528100901.14580.1322.stgit@fate.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 23:33:05 +0300
Message-ID: <1276806785.20754.8.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-28 at 13:09 +0300, Jussi Kivilinna wrote: 
> Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
> Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
> enabled. With ASPM ath5k will eventually stall on heavy traffic with often
> 'unsupported jumbo' warnings appearing. Disabling ASPM L0s/L1 in ath5k fixes
> these problems.
> 
> Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
> both ends (usually stalls within seconds).

This fixes the same nasty problem on my AR2425.

My AR2425 will stall if it transmits for about 1~2 minutes.

It sends storm of RXORN interrupts although it only transmits.

I see that now lspci calls it AR5001.

Jussi Kivilinna, million thanks to you. I would never think of going
this direction.

Luis, so I was right after all, wasn't I?
It is a hardware bug that is worked around in windows driver by
disabling PCIE ASPM L0S.

Jussi Kivilinna, thanks again, I really mean it.


Best regards,
Maxim Levitsky 

