Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-133-90.gdrpmi.dsl-w.verizon.net ([71.115.133.90]:53922
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbYLFDHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 22:07:54 -0500
Message-ID: <4939EC83.4060908@erley.org> (sfid-20081206_040756_731431_661A754A)
Date: Fri, 05 Dec 2008 22:07:47 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Free Beacon skbs in AP mode
References: <20081205184245.GA10596@jm.kir.nu>
In-Reply-To: <20081205184245.GA10596@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> Fix a memory leak where AP mode did not free transmitted Beacon frame
> skbs.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> 
> Index: wireless-testing/drivers/net/wireless/ath9k/beacon.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2008-12-05 18:37:37.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2008-12-05 18:38:41.000000000 +0200
> @@ -167,6 +167,7 @@
>  		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
>  				 skb->len,
>  				 PCI_DMA_TODEVICE);
> +		dev_kfree_skb_any(skb);
>  	}
>  
>  	skb = ieee80211_beacon_get(sc->hw, vif);
> 

Acked-by: Pat Erley <pat-lkml@erley.org>

I've been using ath9k in master mode for a few weeks and
had noticed a severe memory leak (kill a gig of ram system in about a
day).  Figured it was just in hostapd, and haven't had time to track it
down.



