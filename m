Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42162 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2DWS2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 14:28:10 -0400
Received: by yenl12 with SMTP id l12so6358746yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 11:28:10 -0700 (PDT)
Date: Mon, 23 Apr 2012 11:28:04 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Zefir Kurtisi <zefir.kurtisi@gmail.com>,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com
Subject: Re: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel
Message-ID: <20120423182804.GE9438@tux> (sfid-20120423_202814_934211_3E0E66BF)
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
 <1335124223-15439-3-git-send-email-zefir.kurtisi@gmail.com>
 <4F946340.3020700@openwrt.org>
 <4F951D01.60509@neratec.com>
 <4F95902E.7040806@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F95902E.7040806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2012 at 07:23:58PM +0200, Felix Fietkau wrote:
> On 2012-04-23 11:12 AM, Zefir Kurtisi wrote:
> > On 22.04.2012 22:00, Felix Fietkau wrote:
> >> On 2012-04-22 9:50 PM, Zefir Kurtisi wrote:
> >>> From: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> >>>
> >>>
> >>> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> >>> ---
> >>>   drivers/net/wireless/ath/ath9k/recv.c |    6 ++++++
> >>>   1 files changed, 6 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> >>> index f4ae3ba..ef45c0c 100644
> >>> --- a/drivers/net/wireless/ath/ath9k/recv.c
> >>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> >>> @@ -17,6 +17,7 @@
> >>>   #include<linux/dma-mapping.h>
> >>>   #include "ath9k.h"
> >>>   #include "ar9003_mac.h"
> >>> +#include "dfs.h"
> >>>
> >>>   #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
> >>>
> >>> @@ -467,6 +468,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
> >>>   		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
> >>>   	}
> >>>
> >>> +	if (sc->sc_ah->curchan->chan->flags&  IEEE80211_CHAN_RADAR)
> >>> +		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
> >>> +	else
> >>> +		rfilt&= ~ATH9K_RX_FILTER_PHYRADAR;
> >> This should only be done in AP mode, maybe mac80211 should have a
> >> separate flag to tell the driver to enable this. Same comment also
> >> applies to patch 4/4.
> >>
> >> - Felix
> >>
> > Are you aware of any issues enabling DFS in client modes? My thinking 
> > was that it won't hurt to detect radars in any mode and let the DFS 
> > management component decide what to do with that events.
> Power consumption (for laptops), performance issues (due to DMA
> descriptor use and interrupts triggered by pulse detection).
> 
> If the DFS management component decides what to do with the events, why
> not let it decide whether it actually wants events as well ;)

This could come from mac80211's filter flag call on to the driver, that is,
mac80211 can figure out when we need something like ATH9K_RX_FILTER_PHYRADAR
and tell us, instead of having the driver figure this out.

  Luis
