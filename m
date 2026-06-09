Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13839D3D0
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 09:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780998358; cv=none; b=iEzKgI52YzKHXf4Suq5+8WIgOnBgAQ7JN1DN40wGc06YzBtm1UJIpxNdtLYA+wLoVdh3t9631ovnHWnV4ALdzAgIv2RFVVVrEFdrNLAgO55Z6aP+56mEu890yVc3QKSfdcJgOhnC47YHK7Ni0MFy0bxItLJoMtgy/9/UgrfSq9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780998358; c=relaxed/simple;
	bh=doy1T2Bs+gjUMpmwqLG6LdJIZqk4kxlswYk4o8L7Vug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msWWQqN3MCaeku/kAOhsf9b8kLrZxmLvtO4z9n4KVsFex6dCWYLDSqS9VN7YSGGiyY9ppQX87jvCAoAikLMI3DzPvMhHnPZ+q+3RZ8onO4eB/HLvkMPzyMa7nKJSXwFBot7gFkyD1Wbz0pwWD8IxR0QKA8Lli+tvX2vxoHEYqVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9JFiVLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9JFiVLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFB71F00893;
	Tue,  9 Jun 2026 09:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780998356;
	bh=BFMyPnH9P9OcrjHoLKj3Hs5CgDr1P+aeIkg5WaCwLu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I9JFiVLmQ4otB3VskJtlrJZ72F31wfuI9gZ1irtiCQHG9HJjJKcFuznndHyrtx0Ih
	 Moa3QPZncrKATfKrwkcxUoZsKlMXCLxKFkWgVAFXHq7CGw78DNqEQOqOZ/AzK6ze0u
	 6zsIXfiPRZ+qNlSXTYAskqEXLmne3XWwUcyqT3SksJAYSKI2KbJj+COtSELW1ENuEp
	 G7abJCj8S+vPpbeCU5BgGp5hIq98XG27kXVpPFZtThkyTVfbn/VMKIAeihUdpcMyd4
	 xXlyoymGPPdwroucisHhswJxRoh2paTB9q803DRyB47BKc/IIu7AZeoUcEjMALjVZk
	 M3S+XJJMfWKdw==
Date: Tue, 9 Jun 2026 11:45:53 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Filip Bakreski <phial@phiality.com>
Cc: nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mt76: mt76u: use a threaded NAPI for the RX path
Message-ID: <aifg0WOxWD6x7no4@lore-desk>
References: <20260609003224.132191-1-phial@phiality.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="W+1fLvVLPbMhyLVK"
Content-Disposition: inline
In-Reply-To: <20260609003224.132191-1-phial@phiality.com>


--W+1fLvVLPbMhyLVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> The USB RX path delivers frames to the stack via mt76_rx_complete() with
> a NULL napi pointer, taking the netif_receive_skb_list() path, so it never
> benefits from GRO -- unlike the DMA-based mt76 drivers, which pass a real
> napi and use napi_gro_receive(). For bulk TCP traffic this is costly, as
> every segment traverses the stack individually.
>=20
> Service the MT_RXQ_MAIN queue from a threaded NAPI, reusing mt76_dev's
> existing napi_dev and napi[] rather than adding new fields. The URB
> completion handler schedules the napi; its poll drains the URBs, builds
> the skbs, resubmits and delivers them through napi_gro_receive(). The MCU
> queue stays on the existing RX worker. This enables GRO and moves RX
> processing into its own kernel thread, parallelising the datapath.
>=20
> On mt7921u at HE-MCS 11 (2x2, 80 MHz; fast.com, multiple streams) this
> averages ~588 Mbit/s, versus ~424 Mbit/s when the same napi is instead
> driven manually from the RX worker, and ~380 Mbit/s for the unmodified
> driver.
>=20
> Suggested-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Filip Bakreski <phial@phiality.com>
> ---
> v2:
> - Service MT_RXQ_MAIN from a threaded NAPI instead of a NAPI driven
>   manually from the RX worker; on mt7921u the threaded variant measured
>   ~39% faster (~588 vs ~424 Mbit/s, fast.com) (Lorenzo Bianconi).
> - Reuse mt76_dev's existing napi_dev/napi[] instead of adding new fields
>   to struct mt76_usb (Lorenzo Bianconi).
>=20
> v1: https://lore.kernel.org/linux-wireless/20260608044109.31730-1-phial@p=
hiality.com/

Hi Filip,

I guess the patch is fine, just a couple of nits inline.

Regards,
Lorenzo

>=20
>  drivers/net/wireless/mediatek/mt76/usb.c | 56 +++++++++++++++++++++---
>  1 file changed, 49 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index d9638a9b7..aef8f855f 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -580,7 +580,10 @@ static void mt76u_complete_rx(struct urb *urb)
> =20
>  	q->head =3D (q->head + 1) % q->ndesc;
>  	q->queued++;
> -	mt76_worker_schedule(&dev->usb.rx_worker);

nit: new-line here.

> +	if (q =3D=3D &dev->q_rx[MT_RXQ_MAIN])
> +		napi_schedule(&dev->napi[MT_RXQ_MAIN]);
> +	else
> +		mt76_worker_schedule(&dev->usb.rx_worker);
>  out:
>  	spin_unlock_irqrestore(&q->lock, flags);
>  }
> @@ -618,11 +621,23 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct=
 mt76_queue *q)
>  		}
>  		mt76u_submit_rx_buf(dev, qid, urb);
>  	}
> -	if (qid =3D=3D MT_RXQ_MAIN) {
> -		local_bh_disable();
> -		mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
> -		local_bh_enable();
> -	}
> +}
> +
> +/* Threaded NAPI poll for the MAIN RX queue: drain URBs, build skbs, res=
ubmit,
> + * then deliver through napi_gro_receive() and let napi_complete() flush=
 GRO.
> + */
> +static int mt76u_napi_poll(struct napi_struct *napi, int budget)
> +{
> +	struct mt76_dev *dev =3D mt76_priv(napi->dev);
> +
> +	rcu_read_lock();
> +	mt76u_process_rx_queue(dev, &dev->q_rx[MT_RXQ_MAIN]);
> +	mt76_rx_poll_complete(dev, MT_RXQ_MAIN, napi);
> +	rcu_read_unlock();
> +
> +	napi_complete(napi);
> +
> +	return 0;
>  }
> =20
>  static void mt76u_rx_worker(struct mt76_worker *w)
> @@ -632,8 +647,12 @@ static void mt76u_rx_worker(struct mt76_worker *w)
>  	int i;
> =20
>  	rcu_read_lock();
> -	mt76_for_each_q_rx(dev, i)
> +	mt76_for_each_q_rx(dev, i) {
> +		/* MT_RXQ_MAIN is serviced by the threaded NAPI poll */
> +		if (i =3D=3D MT_RXQ_MAIN)
> +			continue;

nit: new-line here.

>  		mt76u_process_rx_queue(dev, &dev->q_rx[i]);
> +	}
>  	rcu_read_unlock();
>  }
> =20
> @@ -723,6 +742,8 @@ void mt76u_stop_rx(struct mt76_dev *dev)
>  	int i;
> =20
>  	mt76_worker_disable(&dev->usb.rx_worker);
> +	if (dev->napi_dev)
> +		napi_disable(&dev->napi[MT_RXQ_MAIN]);
> =20
>  	mt76_for_each_q_rx(dev, i) {
>  		struct mt76_queue *q =3D &dev->q_rx[i];
> @@ -751,6 +772,8 @@ int mt76u_resume_rx(struct mt76_dev *dev)
>  	}
> =20
>  	mt76_worker_enable(&dev->usb.rx_worker);
> +	if (dev->napi_dev)
> +		napi_enable(&dev->napi[MT_RXQ_MAIN]);
> =20
>  	return 0;
>  }
> @@ -1051,6 +1074,13 @@ void mt76u_queues_deinit(struct mt76_dev *dev)
>  	mt76u_stop_rx(dev);
>  	mt76u_stop_tx(dev);
> =20
> +	/* mt76u_stop_rx() (above) already napi_disable()d the MAIN queue */
> +	if (dev->napi_dev) {
> +		netif_napi_del(&dev->napi[MT_RXQ_MAIN]);
> +		free_netdev(dev->napi_dev);
> +		dev->napi_dev =3D NULL;
> +	}
> +
>  	mt76u_free_rx(dev);
>  	mt76u_free_tx(dev);
>  }
> @@ -1115,6 +1145,18 @@ int __mt76u_init(struct mt76_dev *dev, struct usb_=
interface *intf,
>  	sched_set_fifo_low(usb->rx_worker.task);
>  	sched_set_fifo_low(usb->status_worker.task);
> =20
> +	/* threaded NAPI on a dummy netdev (reusing mt76_dev's napi_dev/napi[])
> +	 * services the MAIN RX queue and gives the RX path GRO
> +	 */
> +	dev->napi_dev =3D alloc_netdev_dummy(sizeof(struct mt76_dev *));
> +	if (!dev->napi_dev)
> +		return -ENOMEM;

nit: new-line here.

> +	*(struct mt76_dev **)netdev_priv(dev->napi_dev) =3D dev;

To make the code more readable, I guess you can define priv pointer similar=
 to mt76_dma_init().


> +	strscpy(dev->napi_dev->name, "mt76u-rx", sizeof(dev->napi_dev->name));
> +	dev->napi_dev->threaded =3D 1;
> +	netif_napi_add(dev->napi_dev, &dev->napi[MT_RXQ_MAIN], mt76u_napi_poll);
> +	napi_enable(&dev->napi[MT_RXQ_MAIN]);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__mt76u_init);
>=20
> base-commit: 5f6099446d1ddb888e36cdf93b6a0551f05c1267
> --=20
> 2.54.0
>=20

--W+1fLvVLPbMhyLVK
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaifg0QAKCRA6cBh0uS2t
rOs5AQDnMCIxHmt9rHoObakXFpHlWA7yLxSCzJoVTrSXX8fhywD+MtlqupvSI6qZ
OQzryCOfmHK9qSKURzSKDe4oepaepgQ=
=l2ot
-----END PGP SIGNATURE-----

--W+1fLvVLPbMhyLVK--
