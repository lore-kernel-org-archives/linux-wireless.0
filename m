Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23619 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab0ERG4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 02:56:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 23:56:12 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19442.14851.603291.524128@gargle.gargle.HOWL>
Date: Tue, 18 May 2010 12:26:03 +0530
To: Dan Carpenter <error27@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: [patch -next 2/2] ath9k_htc: rare leak in
	ath9k_hif_usb_alloc_tx_urbs()
In-Reply-To: <20100514145237.GF17487@bicker>
References: <20100514145237.GF17487@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> This is obviously a small picky thing.  The original error handling code
> doesn't free the most recent allocations which haven't been added to the
> hif_dev->tx.tx_buf list yet.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 46dc41a..77b3591 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -607,6 +609,10 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
>  
>  	return 0;
>  err:
> +	if (tx_buf) {
> +		kfree(tx_buf->buf);
> +		kfree(tx_buf);
> +	}
>  	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
>  	return -ENOMEM;
>  }
