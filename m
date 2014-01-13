Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:39846 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaAMQL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:11:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21204.3832.404821.109119@gargle.gargle.HOWL> (sfid-20140113_171134_884700_55566E38)
Date: Mon, 13 Jan 2014 21:36:16 +0530
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
In-Reply-To: <21204.2384.710460.402183@gargle.gargle.HOWL>
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>
	<1384665016-12022-5-git-send-email-sujith@msujith.org>
	<52CE934D.1020400@neratec.com>
	<21198.40916.260973.48444@gargle.gargle.HOWL>
	<52CEA5A3.2040308@neratec.com>
	<21198.43395.235654.597422@gargle.gargle.HOWL>
	<52CEAB24.5090700@neratec.com>
	<52D3F962.1010302@neratec.com>
	<21204.319.492595.58625@gargle.gargle.HOWL>
	<52D402C3.3070606@neratec.com>
	<21204.1991.201080.986559@gargle.gargle.HOWL>
	<21204.2384.710460.402183@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> > I used this patch:
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> > index 5bf3243..c85be42 100644
> > --- a/drivers/net/wireless/ath/ath9k/recv.c
> > +++ b/drivers/net/wireless/ath/ath9k/recv.c
> > @@ -1088,6 +1088,9 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
> >  
> >  	ath9k_process_rssi(common, hw, rx_stats, rx_status);
> >  
> > +	printk("NOISE/RSSI/SIGNAL for %pM: %d/%d/%d\n",
> > +	       hdr->addr3, ah->noise, rx_stats->rs_rssi, rx_status->signal);
> > +
> >  	rx_status->band = ah->curchan->chan->band;
> >  	rx_status->freq = ah->curchan->chan->center_freq;
> >  	rx_status->antenna = rx_stats->rs_antenna;

With this patch, can you please post the kernel log with debug=0x749 ?

Sujith
