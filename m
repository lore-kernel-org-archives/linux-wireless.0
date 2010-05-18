Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23613 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0ERGxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 02:53:55 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 23:53:55 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19442.14757.146506.330602@gargle.gargle.HOWL>
Date: Tue, 18 May 2010 12:24:29 +0530
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
Subject: [patch -next 1/2] ath9k_htc: dereferencing before check in
	hif_usb_tx_cb()
In-Reply-To: <20100514145056.GE17487@bicker>
References: <20100514145056.GE17487@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> After c11d8f89d3b7: "ath9k_htc: Simplify TX URB management" we no longer
> assume that tx_buf is a non-null pointer.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks.

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 46dc41a..ac82911 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -107,12 +107,14 @@ static inline void ath9k_skb_queue_purge(struct hif_device_usb *hif_dev,
>  static void hif_usb_tx_cb(struct urb *urb)
>  {
>  	struct tx_buf *tx_buf = (struct tx_buf *) urb->context;
> -	struct hif_device_usb *hif_dev = tx_buf->hif_dev;
> +	struct hif_device_usb *hif_dev;
>  	struct sk_buff *skb;
>  
> -	if (!hif_dev || !tx_buf)
> +	if (!tx_buf || !tx_buf->hif_dev)
>  		return;
>  
> +	hif_dev = tx_buf->hif_dev;
> +
>  	switch (urb->status) {
>  	case 0:
>  		break;
