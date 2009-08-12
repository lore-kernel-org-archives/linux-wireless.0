Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:34131 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZHLSNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:13:25 -0400
Received: by fxm28 with SMTP id 28so170909fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:13:25 -0700 (PDT)
Message-ID: <4A83064A.2080609@gmail.com>
Date: Wed, 12 Aug 2009 20:13:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: fix requested allocated RX skb size for DMA
References: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2009 06:58 PM, Luis R. Rodriguez wrote:
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1157,17 +1157,18 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
>  	 * fake physical layer header at the start.
>  	 */
>  	skb = ath_rxbuf_alloc(&sc->common,
> -			      sc->rxbufsize + sc->common.cachelsz - 1,

What was the exact purpose of this? My guess is that we should map
starting at a next cache line boundary and put this aligned address to
the device instead?
