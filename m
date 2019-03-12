Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2CDC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 489A22083D
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 16:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfCLQ1v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 12:27:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39532 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfCLQ1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 12:27:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id t124so3270112wma.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 09:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TO8SnBZhDi/AIrO/ubNWRcH+Vqa9SB/ILWkZOQ71lNE=;
        b=Le2/an3A/0CN7VmsKrgVYpYP93qygdbpAxi2ALm2nZzVKpWuX/hK5lS8/vcdqKTW9O
         0T9/yIUih+vNXiT9Z45rhNb/zhvUB7PeM4EgMRIsum9qU1HqNhFVFJ240N5OT8+o+wFD
         mSQ6j50BAFXN0sN4dA39Zvxbtl9BKi1tMFlF7KhkNbXjy5Q2vAsCydzkiMd4iUmlFnlA
         O4iu51wBTQBSwzESq1coW+CH2R35GtWd/omHw1RbpEA5ed8K7RLUivR7AhhbWnua9YCA
         jLSiecYqlAxxM3HCG3kkACi57XhIwK+4Aml0x77fnLoTqc2dj7IBqsUpdossMqDPMdQL
         q/zA==
X-Gm-Message-State: APjAAAXrstsQP4jOIodChOY1YjT+e3qww9jhG9yI7R9++4uIX4SsXY7/
        +zUtZuJQ7zEQDLGrwVH5ugrqiD3JQms=
X-Google-Smtp-Source: APXvYqzwt61/Hpb937pLFAn9eyV5xAThjrlAy+CHhroSQJDj84PJ/eO+T3rztsdQYw2mGce16cYBGw==
X-Received: by 2002:a1c:dc8a:: with SMTP id t132mr3280596wmg.48.1552408068231;
        Tue, 12 Mar 2019 09:27:48 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o12sm30079053wre.0.2019.03.12.09.27.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 09:27:47 -0700 (PDT)
Date:   Tue, 12 Mar 2019 17:27:43 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 07/12] mt76usb: remove mt76u_buf and use urb directly
Message-ID: <20190312162742.GE2611@localhost.localdomain>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
 <1552403166-3821-8-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Content-Disposition: inline
In-Reply-To: <1552403166-3821-8-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Put urb pointer in mt76_queue_entry directly instead of mt76u_buf
> structure.
>=20
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h |   6 +-
>  drivers/net/wireless/mediatek/mt76/usb.c  | 132 +++++++++++++++---------=
------
>  2 files changed, 65 insertions(+), 73 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wire=
less/mediatek/mt76/mt76.h
> index 998505064dee..859d0325583b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -83,10 +83,6 @@ struct mt76_queue_buf {
>  	int len;
>  };
> =20
> -struct mt76u_buf {
> -	struct urb *urb;
> -};
> -
>  struct mt76_queue_entry {
>  	union {
>  		void *buf;
> @@ -94,7 +90,7 @@ struct mt76_queue_entry {
>  	};
>  	union {
>  		struct mt76_txwi_cache *txwi;
> -		struct mt76u_buf ubuf;
> +		struct urb *urb;
>  	};
>  	enum mt76_txq_id qid;
>  	bool schedule;
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index a4ef9bb1603d..2c21f4773a19 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -283,12 +283,11 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
>  }
> =20
>  static int
> -mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
> +mt76u_fill_rx_sg(struct mt76_dev *dev, struct urb *urb, int nsgs,
>  		 gfp_t gfp)
>  {
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
>  	int sglen =3D SKB_WITH_OVERHEAD(q->buf_size);
> -	struct urb *urb =3D buf->urb;
> =20
>  	int i;
> =20
> @@ -323,44 +322,43 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
> =20
>  static int
>  mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
> -		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
> +		struct urb *urb, int nsgs, gfp_t gfp)
>  {
>  	if (dev->usb.sg_en) {
> -		return mt76u_fill_rx_sg(dev, buf, nsgs, gfp);
> +		return mt76u_fill_rx_sg(dev, urb, nsgs, gfp);
>  	} else {
> -		buf->urb->transfer_buffer_length =3D
> -			SKB_WITH_OVERHEAD(q->buf_size);
> -		buf->urb->transfer_buffer =3D
> -			page_frag_alloc(&q->rx_page, q->buf_size, gfp);
> -		return buf->urb->transfer_buffer ? 0 : -ENOMEM;
> +		urb->transfer_buffer_length =3D SKB_WITH_OVERHEAD(q->buf_size);
> +		urb->transfer_buffer =3D page_frag_alloc(&q->rx_page,
> +						       q->buf_size, gfp);
> +		return urb->transfer_buffer ? 0 : -ENOMEM;
>  	}
>  }
> =20
>  static int
> -mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
> +mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
>  {
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
> +	struct urb *urb;
> =20
> -	buf->urb =3D usb_alloc_urb(0, GFP_KERNEL);
> -	if (!buf->urb)
> +	urb =3D usb_alloc_urb(0, GFP_KERNEL);

I guess here you can do:
	e->urb =3D usb_alloc_urb(0, GFP_KERNEL);
	if (!e->urb)
		return -ENOMEM;

Regards,
Lorenzo

> +	if (!urb)
>  		return -ENOMEM;
> +	e->urb =3D urb;
> =20
>  	if (dev->usb.sg_en) {
> -		buf->urb->sg =3D devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
> -					    sizeof(*buf->urb->sg),
> -					    GFP_KERNEL);
> -		if (!buf->urb->sg)
> +		urb->sg =3D devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
> +				       sizeof(urb->sg), GFP_KERNEL);
> +		if (!urb->sg)
>  			return -ENOMEM;
> =20
> -		sg_init_table(buf->urb->sg, MT_SG_MAX_SIZE);
> +		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
>  	}
> =20
> -	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
> +	return mt76u_refill_rx(dev, q, urb, MT_SG_MAX_SIZE, GFP_KERNEL);
>  }
> =20
> -static void mt76u_buf_free(struct mt76u_buf *buf)
> +static void mt76u_urb_free(struct urb *urb)
>  {
> -	struct urb *urb =3D buf->urb;
>  	int i;
> =20
>  	for (i =3D 0; i < urb->num_sgs; i++)
> @@ -369,12 +367,12 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
>  	if (urb->transfer_buffer)
>  		skb_free_frag(urb->transfer_buffer);
> =20
> -	usb_free_urb(buf->urb);
> +	usb_free_urb(urb);
>  }
> =20
>  static void
>  mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
> -		    struct mt76u_buf *buf, usb_complete_t complete_fn,
> +		    struct urb *urb, usb_complete_t complete_fn,
>  		    void *context)
>  {
>  	struct usb_device *udev =3D to_usb_device(dev->dev);
> @@ -385,27 +383,27 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
>  	else
>  		pipe =3D usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
> =20
> -	buf->urb->dev =3D udev;
> -	buf->urb->pipe =3D pipe;
> -	buf->urb->complete =3D complete_fn;
> -	buf->urb->context =3D context;
> +	urb->dev =3D udev;
> +	urb->pipe =3D pipe;
> +	urb->complete =3D complete_fn;
> +	urb->context =3D context;
>  }
> =20
> -static inline struct mt76u_buf
> -*mt76u_get_next_rx_entry(struct mt76_queue *q)
> +static inline struct urb *
> +mt76u_get_next_rx_entry(struct mt76_queue *q)
>  {
> -	struct mt76u_buf *buf =3D NULL;
> +	struct urb *urb =3D NULL;
>  	unsigned long flags;
> =20
>  	spin_lock_irqsave(&q->lock, flags);
>  	if (q->queued > 0) {
> -		buf =3D &q->entry[q->head].ubuf;
> +		urb =3D q->entry[q->head].urb;
>  		q->head =3D (q->head + 1) % q->ndesc;
>  		q->queued--;
>  	}
>  	spin_unlock_irqrestore(&q->lock, flags);
> =20
> -	return buf;
> +	return urb;
>  }
> =20
>  static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
> @@ -424,10 +422,9 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data=
_len)
>  }
> =20
>  static int
> -mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
> +mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
>  {
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
> -	struct urb *urb =3D buf->urb;
>  	u8 *data =3D urb->num_sgs ? sg_virt(&urb->sg[0]) : urb->transfer_buffer;
>  	int data_len, len, nsgs =3D 1;
>  	struct sk_buff *skb;
> @@ -488,7 +485,7 @@ static void mt76u_complete_rx(struct urb *urb)
>  	}
> =20
>  	spin_lock_irqsave(&q->lock, flags);
> -	if (WARN_ONCE(q->entry[q->tail].ubuf.urb !=3D urb, "rx urb mismatch"))
> +	if (WARN_ONCE(q->entry[q->tail].urb !=3D urb, "rx urb mismatch"))
>  		goto out;
> =20
>  	q->tail =3D (q->tail + 1) % q->ndesc;
> @@ -499,37 +496,37 @@ static void mt76u_complete_rx(struct urb *urb)
>  }
> =20
>  static int
> -mt76u_submit_rx_buf(struct mt76_dev *dev, struct mt76u_buf *buf)
> +mt76u_submit_rx_buf(struct mt76_dev *dev, struct urb *urb)
>  {
> -	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, buf,
> +	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, urb,
>  			    mt76u_complete_rx, dev);
> -	trace_submit_urb(dev, buf->urb);
> +	trace_submit_urb(dev, urb);
> =20
> -	return usb_submit_urb(buf->urb, GFP_ATOMIC);
> +	return usb_submit_urb(urb, GFP_ATOMIC);
>  }
> =20
>  static void mt76u_rx_tasklet(unsigned long data)
>  {
>  	struct mt76_dev *dev =3D (struct mt76_dev *)data;
>  	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
> -	struct mt76u_buf *buf;
> +	struct urb *urb;
>  	int err, count;
> =20
>  	rcu_read_lock();
> =20
>  	while (true) {
> -		buf =3D mt76u_get_next_rx_entry(q);
> -		if (!buf)
> +		urb =3D mt76u_get_next_rx_entry(q);
> +		if (!urb)
>  			break;
> =20
> -		count =3D mt76u_process_rx_entry(dev, buf);
> +		count =3D mt76u_process_rx_entry(dev, urb);
>  		if (count > 0) {
> -			err =3D mt76u_refill_rx(dev, q, buf, count,
> +			err =3D mt76u_refill_rx(dev, q, urb, count,
>  					      GFP_ATOMIC);
>  			if (err < 0)
>  				break;
>  		}
> -		mt76u_submit_rx_buf(dev, buf);
> +		mt76u_submit_rx_buf(dev, urb);
>  	}
>  	mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
> =20
> @@ -544,7 +541,7 @@ int mt76u_submit_rx_buffers(struct mt76_dev *dev)
> =20
>  	spin_lock_irqsave(&q->lock, flags);
>  	for (i =3D 0; i < q->ndesc; i++) {
> -		err =3D mt76u_submit_rx_buf(dev, &q->entry[i].ubuf);
> +		err =3D mt76u_submit_rx_buf(dev, q->entry[i].urb);
>  		if (err < 0)
>  			break;
>  	}
> @@ -576,7 +573,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
>  	q->buf_size =3D dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
>  	q->ndesc =3D MT_NUM_RX_ENTRIES;
>  	for (i =3D 0; i < q->ndesc; i++) {
> -		err =3D mt76u_buf_alloc(dev, &q->entry[i].ubuf);
> +		err =3D mt76u_urb_alloc(dev, &q->entry[i]);
>  		if (err < 0)
>  			return err;
>  	}
> @@ -591,7 +588,7 @@ static void mt76u_free_rx(struct mt76_dev *dev)
>  	int i;
> =20
>  	for (i =3D 0; i < q->ndesc; i++)
> -		mt76u_buf_free(&q->entry[i].ubuf);
> +		mt76u_urb_free(q->entry[i].urb);
> =20
>  	if (!q->rx_page.va)
>  		return;
> @@ -607,7 +604,7 @@ static void mt76u_stop_rx(struct mt76_dev *dev)
>  	int i;
> =20
>  	for (i =3D 0; i < q->ndesc; i++)
> -		usb_kill_urb(q->entry[i].ubuf.urb);
> +		usb_kill_urb(q->entry[i].urb);
>  }
> =20
>  static void mt76u_tx_tasklet(unsigned long data)
> @@ -718,7 +715,7 @@ static void mt76u_complete_tx(struct urb *urb)
>  		   struct ieee80211_sta *sta)
>  {
>  	struct mt76_queue *q =3D dev->q_tx[qid].q;
> -	struct mt76u_buf *buf;
> +	struct urb *urb;
>  	u16 idx =3D q->tail;
>  	int err;
> =20
> @@ -731,18 +728,18 @@ static void mt76u_complete_tx(struct urb *urb)
>  		return err;
> =20
>  	q->entry[idx].done =3D false;
> -	buf =3D &q->entry[idx].ubuf;
> +	urb =3D q->entry[idx].urb;
>  	if (!dev->usb.sg_en) {
> -		buf->urb->transfer_buffer =3D skb->data;
> +		urb->transfer_buffer =3D skb->data;
>  	} else {
> -		err =3D mt76u_tx_build_sg(dev, skb, buf->urb);
> +		err =3D mt76u_tx_build_sg(dev, skb, urb);
>  		if (err < 0)
>  			return err;
>  	}
> -	buf->urb->transfer_buffer_length =3D skb->len;
> +	urb->transfer_buffer_length =3D skb->len;
> =20
>  	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
> -			    buf, mt76u_complete_tx, &q->entry[idx]);
> +			    urb, mt76u_complete_tx, &q->entry[idx]);
> =20
>  	q->tail =3D (q->tail + 1) % q->ndesc;
>  	q->entry[idx].skb =3D skb;
> @@ -753,14 +750,14 @@ static void mt76u_complete_tx(struct urb *urb)
> =20
>  static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
>  {
> -	struct mt76u_buf *buf;
> +	struct urb *urb;
>  	int err;
> =20
>  	while (q->first !=3D q->tail) {
> -		buf =3D &q->entry[q->first].ubuf;
> +		urb =3D q->entry[q->first].urb;
> =20
> -		trace_submit_urb(dev, buf->urb);
> -		err =3D usb_submit_urb(buf->urb, GFP_ATOMIC);
> +		trace_submit_urb(dev, urb);
> +		err =3D usb_submit_urb(urb, GFP_ATOMIC);
>  		if (err < 0) {
>  			if (err =3D=3D -ENODEV)
>  				set_bit(MT76_REMOVED, &dev->state);
> @@ -775,7 +772,7 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struc=
t mt76_queue *q)
> =20
>  static int mt76u_alloc_tx(struct mt76_dev *dev)
>  {
> -	struct mt76u_buf *buf;
> +	struct urb *urb;
>  	struct mt76_queue *q;
>  	int i, j;
> =20
> @@ -803,19 +800,18 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
> =20
>  		q->ndesc =3D MT_NUM_TX_ENTRIES;
>  		for (j =3D 0; j < q->ndesc; j++) {
> -			buf =3D &q->entry[j].ubuf;
> -
> -			buf->urb =3D usb_alloc_urb(0, GFP_KERNEL);
> -			if (!buf->urb)
> +			urb =3D usb_alloc_urb(0, GFP_KERNEL);
> +			if (!urb)
>  				return -ENOMEM;
> +			q->entry[j].urb =3D urb;
> =20
>  			if (dev->usb.sg_en) {
>  				size_t size =3D MT_SG_MAX_SIZE *
>  					      sizeof(struct scatterlist);
> =20
> -				buf->urb->sg =3D devm_kzalloc(dev->dev, size,
> -							    GFP_KERNEL);
> -				if (!buf->urb->sg)
> +				urb->sg =3D devm_kzalloc(dev->dev, size,
> +						       GFP_KERNEL);
> +				if (!urb->sg)
>  					return -ENOMEM;
>  			}
>  		}
> @@ -831,7 +827,7 @@ static void mt76u_free_tx(struct mt76_dev *dev)
>  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
>  		q =3D dev->q_tx[i].q;
>  		for (j =3D 0; j < q->ndesc; j++)
> -			usb_free_urb(q->entry[j].ubuf.urb);
> +			usb_free_urb(q->entry[j].urb);
>  	}
>  }
> =20
> @@ -843,7 +839,7 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
>  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
>  		q =3D dev->q_tx[i].q;
>  		for (j =3D 0; j < q->ndesc; j++)
> -			usb_kill_urb(q->entry[j].ubuf.urb);
> +			usb_kill_urb(q->entry[j].urb);
>  	}
>  }
> =20
> --=20
> 1.9.3
>=20

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIfd+wAKCRA6cBh0uS2t
rEwrAP4x6Jv+Er20t5sWG7JGENShGyvIM0YXKR7QS0cJavDEuwEAu+OW4Xn7kSA4
yP1K3dxki40pbE467Tg+VI+QuHjIPwk=
=yd4U
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
