Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D50C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9B82087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfCLQZ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 12:25:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46113 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfCLQZ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 12:25:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id 33so887128wrb.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 09:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ml1z+UH8bDllp/gvP9cxq34thhwoJCIKZKtiaJhXV8E=;
        b=XH5Jh7hscJ/EDYuX/KvjKP4MmzbVFtrAlACBH3HWHw7n2yhLgkhontTZYqSC9y8Mrc
         dUSZai++a6FrhtuKaGPZaOzc26ZnnZgG8hWHtn9a3FWXokJJcylshqJBMhpnjOtsdevC
         RdPnBTw5ul15/n4ELkjQXOOL7gde+nBAXvYKiJKMQ+ZxNzGe9u/hBF/XXiAfgzElf5vh
         /VC0p04599tecwYvsMIf2NhJtF+l+ZnxKVCxUldc41Y9c+ApLSQFrW6G33TVL9R6azkh
         IvOerWRYDobPf2TxGVWQ6iusUaXEEs4mPT339wDkIMzFFOC2BH7HO5Cc39E/kX0evGKd
         SMCw==
X-Gm-Message-State: APjAAAUqsTlMinefi+coVM+K8ptc3M4Y56otoV04rt6Aq5kUT9saRFDy
        yR9w1HzC6D9BOnkFTJwFwwG4pg==
X-Google-Smtp-Source: APXvYqyy6V2GAtjwYORgO5425pTa0uxr/BcCT7EvD4JkoYwhBSgUtc+I+vBMUP3skWjGeZNA0Rabvg==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr25863224wrt.27.1552407955317;
        Tue, 12 Mar 2019 09:25:55 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e193sm7519438wmg.18.2019.03.12.09.25.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 09:25:54 -0700 (PDT)
Date:   Tue, 12 Mar 2019 17:25:50 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 05/12] mt76usb: remove mt76u_buf redundant fileds
Message-ID: <20190312162549.GD2611@localhost.localdomain>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
 <1552403166-3821-6-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <1552403166-3821-6-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Remove mt76u_buf->{len, buf} fields and operate on corresponding
> urb fields directly.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h |  2 --
>  drivers/net/wireless/mediatek/mt76/usb.c  | 40 +++++++++++++++++--------=
------
>  2 files changed, 22 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wire=
less/mediatek/mt76/mt76.h
> index 89cdfe4abf33..476cb39c99b7 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -85,8 +85,6 @@ struct mt76_queue_buf {
> =20

[...]

> @@ -377,7 +378,6 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
>  		    void *context)
>  {
>  	struct usb_device *udev =3D to_usb_device(dev->dev);
> -	u8 *data =3D buf->urb->num_sgs ? NULL : buf->buf;
>  	unsigned int pipe;
> =20
>  	if (dir =3D=3D USB_DIR_IN)
> @@ -385,8 +385,10 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
>  	else
>  		pipe =3D usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
> =20
> -	usb_fill_bulk_urb(buf->urb, udev, pipe, data, buf->len,
> -			  complete_fn, context);
> +	buf->urb->dev =3D udev;
> +	buf->urb->pipe =3D pipe;
> +	buf->urb->complete =3D complete_fn;
> +	buf->urb->context =3D context;
>  }
> =20
>  static inline struct mt76u_buf
> @@ -426,7 +428,7 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_=
len)
>  {
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
>  	struct urb *urb =3D buf->urb;
> -	u8 *data =3D urb->num_sgs ? sg_virt(&urb->sg[0]) : buf->buf;
> +	u8 *data =3D urb->num_sgs ? sg_virt(&urb->sg[0]) : urb->transfer_buffer;
>  	int data_len, len, nsgs =3D 1;
>  	struct sk_buff *skb;
> =20
> @@ -437,7 +439,7 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_=
len)
>  	if (len < 0)
>  		return 0;
> =20
> -	data_len =3D urb->num_sgs ? urb->sg[0].length : buf->len;
> +	data_len =3D urb->num_sgs ? urb->sg[0].length : INT_MAX;

In this way we only use len, maybe better to do:
	data_len =3D urb->num_sgs ? urb->sg[0].length :
				  SKB_WITH_OVERHEAD(q->buf_size)

>  	data_len =3D min_t(int, len, data_len - MT_DMA_HDR_LEN);
>  	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
>  		return 0;
> @@ -731,14 +733,16 @@ static void mt76u_complete_tx(struct urb *urb)
>  		return err;
> =20
>  	buf =3D &q->entry[idx].ubuf;
> -	buf->buf =3D skb->data;
> -	buf->len =3D skb->len;
> +	if (!dev->usb.sg_en) {
> +		buf->urb->transfer_buffer =3D skb->data;

I think you can move this in mt76u_tx_build_sg or remove the if condition in
mt76u_tx_build_sg()

Regards,
Lorenzo

> +	} else {
> +		err =3D mt76u_tx_build_sg(dev, skb, buf->urb);
> +		if (err < 0)
> +			return err;
> +	}
> +	buf->urb->transfer_buffer_length =3D skb->len;
>  	buf->done =3D false;
> =20
> -	err =3D mt76u_tx_build_sg(dev, skb, buf->urb);
> -	if (err < 0)
> -		return err;
> -
>  	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
>  			    buf, mt76u_complete_tx, buf);
> =20
> --=20
> 1.9.3
>=20

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIfdigAKCRA6cBh0uS2t
rI8zAQC3LI+Wkv4jtBtiWVYhBXUAFD/wy0f2Y6lDSvFIvjiilAEAhAg1iIirLE5N
9QcS6IVmrJU5Ky9ynpBIBSgILPeo5QY=
=PQa1
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
