Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9C0352C52
	for <linux-wireless@vger.kernel.org>; Mon,  8 Jun 2026 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780940451; cv=none; b=NMX5YC4+U+1lpwbsa6vEugNbqtvrJJIdpEIxUhwxGgPD0J4XtoTjHbM5RKWgENVx9LTbCLS937eHW2a96BNJ2PZxaYEZqyqURNzUgIYlHEY5LKw+mcwPRGLppx5XvQEG5yShaNCN3feV1X9nNdF4h15Owpr8zAlNI1NpNjQDXao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780940451; c=relaxed/simple;
	bh=NRAf0O9lQNkDKilIFGnRgrE3XqY6F4RqNR9wqxGr/Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoKTkue+UjaaBUvKtBWaZX+heUhPIL7d1OFvfl7HIYJ5GsdbZU84g2pYo9eMEPPdVbQfYkepE7IfEbQQ5vcSKzBOB4B853H+xdHu9ive806+ysZLPSbQlOaYCTKbgp0HB5G0BnrOluVIFvxufaH/caQAfnynBwpgqOp3CkmXU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLGLQiAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLGLQiAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3B81F00893;
	Mon,  8 Jun 2026 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780940449;
	bh=0CmJeFxoIhW8/1w+ob6XuhY6q4v63DjE4P2+PCOQCnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CLGLQiAZ05woAI1d97KTkxDmz6u9QLVqd7+UVtLzL0Fz8UGCpOjQNVu0XCQQktWUn
	 oNYFJQ8SUawt7XaMVOYGp4uxv3ORu49beWcF1taxgt4u9kzRioiXKIIuZ84eB7+wv8
	 +AEBhpK3YxhvTJURBaJeZCWIOuYRG10cJcWCCSQ57EHMeCjFGcm2KL3l2+g4LYpeXA
	 hUTIRhR072vw9KUdionhZ6+4oIBfvwXFPN5jMI6gz3mYAnWCaxU+/NmqXiToRtrIYW
	 8aMhbJCWEwKpDtchB4nMcAHephTUxNJnD7KJ4VeGoYFki309nXggdXNqmhgCMURMle
	 q0epTUNhag3dQ==
Date: Mon, 8 Jun 2026 19:40:47 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Filip Bakreski <phial@phiality.com>
Cc: nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt76u: use GRO on the USB RX path
Message-ID: <aib-n_sCzWOjXFE1@lore-desk>
References: <20260608044109.31730-1-phial@phiality.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZY5Pm1cMFgx4h4Cq"
Content-Disposition: inline
In-Reply-To: <20260608044109.31730-1-phial@phiality.com>


--ZY5Pm1cMFgx4h4Cq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> The USB RX path delivers frames to the stack via mt76_rx_complete() with
> a NULL napi pointer, which takes the netif_receive_skb_list() path and
> therefore never benefits from GRO. The DMA-based mt76 drivers pass a real
> napi and get napi_gro_receive(); the USB path does not. For bulk TCP
> traffic this is costly, as every segment traverses the network stack
> individually instead of being coalesced.
>=20
> Add a small container NAPI on a dummy netdev that the RX worker drives
> manually: napi_schedule_prep() marks it scheduled, frames are delivered
> through napi_gro_receive(), and napi_complete_done() flushes the coalesced
> list. The poll handler is never invoked by the core.
>=20
> On mt7921u at HE-MCS 11 (2x2, 80 MHz) this raises single-stream TCP
> download throughput from ~383 to ~475 Mbit/s (~+24%), averaged over six
> interleaved A/B measurements. The gain only applies while the link is not
> RF-limited, as expected for a host-side optimisation.
>=20
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Filip Bakreski <phial@phiality.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h |  4 +++
>  drivers/net/wireless/mediatek/mt76/usb.c  | 36 ++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wire=
less/mediatek/mt76/mt76.h
> index 07955555f..f5e52c1f4 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -668,6 +668,10 @@ struct mt76_usb {
>  	struct mt76_worker status_worker;
>  	struct mt76_worker rx_worker;
> =20
> +	/* container NAPI used only to batch GRO for the RX worker */
> +	struct net_device *napi_dev;
> +	struct napi_struct napi;

I guess we do not need to add them, we can just reuse napi_dev pointer and
napi[] array available in mt76_dev struct. Agree?

> +
>  	struct work_struct stat_work;
> =20
>  	u8 out_ep[__MT_EP_OUT_MAX];
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index d9638a9b7..f9c48140c 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -619,12 +619,31 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct=
 mt76_queue *q)
>  		mt76u_submit_rx_buf(dev, qid, urb);
>  	}
>  	if (qid =3D=3D MT_RXQ_MAIN) {
> +		struct napi_struct *napi =3D &dev->usb.napi;
> +
>  		local_bh_disable();
> -		mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
> +		/* Drive a container NAPI so the RX path can use
> +		 * napi_gro_receive(): napi_schedule_prep() marks it SCHED and
> +		 * napi_complete_done() flushes the coalesced GRO list. The poll
> +		 * handler is never actually invoked by the core.
> +		 */
> +		if (dev->usb.napi_dev && napi_schedule_prep(napi)) {
> +			mt76_rx_poll_complete(dev, MT_RXQ_MAIN, napi);
> +			napi_complete_done(napi, 1);
> +		} else {
> +			mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
> +		}
>  		local_bh_enable();
>  	}
>  }
> =20
> +/* Never invoked by the core: the RX worker drives GRO via the napi manu=
ally. */
> +static int mt76u_napi_poll(struct napi_struct *napi, int budget)
> +{
> +	napi_complete(napi);
> +	return 0;
> +}
> +
>  static void mt76u_rx_worker(struct mt76_worker *w)
>  {
>  	struct mt76_usb *usb =3D container_of(w, struct mt76_usb, rx_worker);
> @@ -1051,6 +1070,13 @@ void mt76u_queues_deinit(struct mt76_dev *dev)
>  	mt76u_stop_rx(dev);
>  	mt76u_stop_tx(dev);
> =20
> +	if (dev->usb.napi_dev) {
> +		napi_disable(&dev->usb.napi);
> +		netif_napi_del(&dev->usb.napi);
> +		free_netdev(dev->usb.napi_dev);
> +		dev->usb.napi_dev =3D NULL;
> +	}
> +
>  	mt76u_free_rx(dev);
>  	mt76u_free_tx(dev);
>  }
> @@ -1115,6 +1141,14 @@ int __mt76u_init(struct mt76_dev *dev, struct usb_=
interface *intf,
>  	sched_set_fifo_low(usb->rx_worker.task);
>  	sched_set_fifo_low(usb->status_worker.task);
> =20
> +	/* container netdev + NAPI used only to enable GRO on the RX path */
> +	usb->napi_dev =3D alloc_netdev_dummy(0);
> +	if (!usb->napi_dev)
> +		return -ENOMEM;
> +	strscpy(usb->napi_dev->name, "mt76u-rx", sizeof(usb->napi_dev->name));
> +	netif_napi_add(usb->napi_dev, &usb->napi, mt76u_napi_poll);

I guess it would be interesting verifying if threaded-napi provides better
results.

Regards,
Lorenzo

> +	napi_enable(&usb->napi);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__mt76u_init);
>=20
> base-commit: 5f6099446d1ddb888e36cdf93b6a0551f05c1267
> --=20
> 2.54.0
>=20
>=20

--ZY5Pm1cMFgx4h4Cq
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaib+nwAKCRA6cBh0uS2t
rOdnAQCTEuGjVD22YPddbTw1+fOG+j9e4e46w3RVECObdTMKsQEAlpwDby+5ZIWC
ReYgfyoVnYVNZKoN1b+Ys8rO2seflgg=
=wjLA
-----END PGP SIGNATURE-----

--ZY5Pm1cMFgx4h4Cq--
