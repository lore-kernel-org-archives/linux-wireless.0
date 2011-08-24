Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40308 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1HXTxQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 15:53:16 -0400
Date: Wed, 24 Aug 2011 21:53:09 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: zajec5@gmail.com, Michael Buesch <mb@bu3sch.de>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: Relax requirement for descriptors to be in the
 DMA zone
Message-ID: <20110824215309.2f2cbb73@milhouse> (sfid-20110824_215321_432841_F3D7C946)
In-Reply-To: <4e5553a8.vSmpTZc2Cr8jeze3%Larry.Finger@lwfinger.net>
References: <4e5553a8.vSmpTZc2Cr8jeze3%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 24 Aug 2011 14:40:24 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> @Rafal - Incorporate this in your other patch.

I would rather like to have this as a separate patch and have
Rafal's other patch apply on _top_ of this.

> @@ -903,7 +896,7 @@ struct b43_dmaring *b43_setup_dmaring(st
>  			kfree(ring->txhdr_cache);
>  			ring->txhdr_cache = kcalloc(ring->nr_slots / TX_SLOTS_PER_FRAME,
>  						    b43_txhdr_size(dev),
> -						    GFP_KERNEL | GFP_DMA);
> +						    GFP_KERNEL);
>  			if (!ring->txhdr_cache)
>  				goto err_kfree_meta;
>  
> 

Why are you removing this? Seems wrong to me.
This seems to be part of the bounce-buffer mechanism, that we _do_ still need
for legacy 30bit devices.


-- 
Greetings, Michael.
