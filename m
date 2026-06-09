Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CBF40B395
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 12:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781007506; cv=none; b=aerkl5rRfde1ggcZ3RWZnliVVSlXqVdUboauwtL8rol9ziSzYH6BxHrV8OumuDPFg7tMqcfoIrFiL0QaPGF7j1eo6LHulAFRWEQDEKZBtctEJWTKrRmu0dPbfun1brnE0PE+QxIIQFWcE7Q6iwsCy+dELvtwm8guaIG2sB1eIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781007506; c=relaxed/simple;
	bh=tourpYXjWGtehiayj88sxWJDa3LpT7XtEpBi0KKYi3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+IlwMcK6ztPHlHlJmdpT3pQtePIdvz6OsKtBIeQSoJvjZiYje9EevRN+VM+ljyod7jM6Uh4r9zNUvgQO6SN+R/mj+zEIl1VbKLwNmRrcquBoNOyJtuYJE0huVcBmUeCpdkaoO8vBYiB8GkPHriuG7ahBUlsJaR++RfZQAl9jeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFHEnoMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFHEnoMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0A71F00893;
	Tue,  9 Jun 2026 12:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781007505;
	bh=hZunJ4PwiNO/p1QFTlnH0cQtq3iOuFAjfcM7ml9Jj3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YFHEnoMv+duRPGhAhjCJMAQfkQ6EGk9g958TDeHEwbisTPoff4tPmWJVvR2c2afJv
	 UI/6wHVlyIkyXuP7n972t1bzbp68WINdwb6jFLY5LVIVi7S/pvbMAFdIWet4y5x7E0
	 nnIJOcaiZ/wnoKkUmoSWOl10sKmAUWy+rBlkQTa7paRfP4KfS/pd/niV20ejw35raE
	 P+g31rYKOEJqi0xIGeQCABkMRiuZ7OIJfzF3/F2vxhhSHhNugHiDvU/JxAPHKd8p09
	 EGYT8++fBSu7g9EYil6AdsFm4vGGJ/Is5pwYO8ZENcV5s19fTL3yIvDgrzMmcIrEsp
	 ou48/W9C6Aogw==
Date: Tue, 9 Jun 2026 14:18:22 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Filip Bakreski <phial@phiality.com>
Cc: nbd@nbd.name, ryder.lee@mediatek.com, shayne.chen@mediatek.com,
	sean.wang@mediatek.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] wifi: mt76: mt76u: use a threaded NAPI for the RX path
Message-ID: <aigEjjHX88z6TEBt@lore-desk>
References: <20260609105301.196302-1-phial@phiality.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JGPS4H9xpr7Na2Lc"
Content-Disposition: inline
In-Reply-To: <20260609105301.196302-1-phial@phiality.com>


--JGPS4H9xpr7Na2Lc
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

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> v3:
> - Address review nits: add blank lines for readability and use a priv
>   pointer for netdev_priv() like mt76_dma_init() (Lorenzo Bianconi).
>=20
> v2: https://lore.kernel.org/linux-wireless/20260609003224.132191-1-phial@=
phiality.com/
> v1: https://lore.kernel.org/linux-wireless/20260608044109.31730-1-phial@p=
hiality.com/
>=20
>  drivers/net/wireless/mediatek/mt76/usb.c | 61 +++++++++++++++++++++---
>  1 file changed, 54 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wirel=
ess/mediatek/mt76/usb.c
> index d9638a9b7..77a8e35b1 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -580,7 +580,11 @@ static void mt76u_complete_rx(struct urb *urb)
> =20
>  	q->head =3D (q->head + 1) % q->ndesc;
>  	q->queued++;
> -	mt76_worker_schedule(&dev->usb.rx_worker);
> +
> +	if (q =3D=3D &dev->q_rx[MT_RXQ_MAIN])
> +		napi_schedule(&dev->napi[MT_RXQ_MAIN]);
> +	else
> +		mt76_worker_schedule(&dev->usb.rx_worker);
>  out:
>  	spin_unlock_irqrestore(&q->lock, flags);
>  }
> @@ -618,11 +622,23 @@ mt76u_process_rx_queue(struct mt76_dev *dev, struct=
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
> @@ -632,8 +648,13 @@ static void mt76u_rx_worker(struct mt76_worker *w)
>  	int i;
> =20
>  	rcu_read_lock();
> -	mt76_for_each_q_rx(dev, i)
> +	mt76_for_each_q_rx(dev, i) {
> +		/* MT_RXQ_MAIN is serviced by the threaded NAPI poll */
> +		if (i =3D=3D MT_RXQ_MAIN)
> +			continue;
> +
>  		mt76u_process_rx_queue(dev, &dev->q_rx[i]);
> +	}
>  	rcu_read_unlock();
>  }
> =20
> @@ -723,6 +744,8 @@ void mt76u_stop_rx(struct mt76_dev *dev)
>  	int i;
> =20
>  	mt76_worker_disable(&dev->usb.rx_worker);
> +	if (dev->napi_dev)
> +		napi_disable(&dev->napi[MT_RXQ_MAIN]);
> =20
>  	mt76_for_each_q_rx(dev, i) {
>  		struct mt76_queue *q =3D &dev->q_rx[i];
> @@ -751,6 +774,8 @@ int mt76u_resume_rx(struct mt76_dev *dev)
>  	}
> =20
>  	mt76_worker_enable(&dev->usb.rx_worker);
> +	if (dev->napi_dev)
> +		napi_enable(&dev->napi[MT_RXQ_MAIN]);
> =20
>  	return 0;
>  }
> @@ -1051,6 +1076,13 @@ void mt76u_queues_deinit(struct mt76_dev *dev)
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
> @@ -1078,6 +1110,7 @@ int __mt76u_init(struct mt76_dev *dev, struct usb_i=
nterface *intf,
>  {
>  	struct usb_device *udev =3D interface_to_usbdev(intf);
>  	struct mt76_usb *usb =3D &dev->usb;
> +	struct mt76_dev **priv;
>  	int err;
> =20
>  	INIT_WORK(&usb->stat_work, mt76u_tx_status_data);
> @@ -1115,6 +1148,20 @@ int __mt76u_init(struct mt76_dev *dev, struct usb_=
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
> +
> +	priv =3D netdev_priv(dev->napi_dev);
> +	*priv =3D dev;
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

--JGPS4H9xpr7Na2Lc
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaigEjgAKCRA6cBh0uS2t
rDDyAQC59iLNUUdipKEXsN7KGqHxGdsGKLWbw1/ShPb68tdH4wEAyykEhxWhGHMz
212uXh4rmF1ozjNp4ceB3zhHOlh8vwo=
=E+Hr
-----END PGP SIGNATURE-----

--JGPS4H9xpr7Na2Lc--
