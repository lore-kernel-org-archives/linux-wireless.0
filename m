Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41901 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2DWR34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 13:29:56 -0400
Received: by bkcik5 with SMTP id ik5so8850481bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 10:29:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [PATCH 2/4] ath9k: set PHYRADAR in RX filter when on DFS channel
Date: Mon, 23 Apr 2012 19:29:47 +0200
Cc: Felix Fietkau <nbd@openwrt.org>,
	Zefir Kurtisi <zefir.kurtisi@gmail.com>,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com,
	achadd@qca.qualcomm.com
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com> <4F946340.3020700@openwrt.org> <4F951D01.60509@neratec.com>
In-Reply-To: <4F951D01.60509@neratec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204231929.47949.chunkeey@googlemail.com> (sfid-20120423_192959_566404_06C02D80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, April 23, 2012 11:12:33 AM Zefir Kurtisi wrote:
> On 22.04.2012 22:00, Felix Fietkau wrote:
> > On 2012-04-22 9:50 PM, Zefir Kurtisi wrote:
> >> From: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> >>
> >>
> >> Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
> >> ---
> >>   drivers/net/wireless/ath/ath9k/recv.c |    6 ++++++
> >>   1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> >> index f4ae3ba..ef45c0c 100644
> >> --- a/drivers/net/wireless/ath/ath9k/recv.c
> >> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> >> @@ -17,6 +17,7 @@
> >>   #include<linux/dma-mapping.h>
> >>   #include "ath9k.h"
> >>   #include "ar9003_mac.h"
> >> +#include "dfs.h"
> >>
> >>   #define SKB_CB_ATHBUF(__skb)	(*((struct ath_buf **)__skb->cb))
> >>
> >> @@ -467,6 +468,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
> >>   		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
> >>   	}
> >>
> >> +	if (sc->sc_ah->curchan->chan->flags&  IEEE80211_CHAN_RADAR)
> >> +		rfilt |= ATH9K_RX_FILTER_PHYRADAR;
> >> +	else
> >> +		rfilt&= ~ATH9K_RX_FILTER_PHYRADAR;
> > This should only be done in AP mode, maybe mac80211 should have a
> > separate flag to tell the driver to enable this. Same comment also
> > applies to patch 4/4.
> >
> > - Felix
> >
> Are you aware of any issues enabling DFS in client modes? My thinking 
> was that it won't hurt to detect radars in any mode and let the DFS 
> management component decide what to do with that events.
> 
Hm, what about:

"2. Slave devices with a maximum EIRP of less than 23 dBm do not have
to implement radar detection."
<http://linuxwireless.org/en/developers/DFS/ETSI> - Table D.2

So, 5GHz ath9k devices with 23 dBm (or more) have to have
radar detection anyway?

Regards,
	Christian 
