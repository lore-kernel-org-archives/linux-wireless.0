Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55601 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaGTL1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:27:25 -0400
Date: Sun, 20 Jul 2014 13:26:34 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
Message-ID: <20140720132634.2cb9e916@wiggum> (sfid-20140720_132728_748531_A8B609B9)
In-Reply-To: <1405854022-11833-2-git-send-email-zajec5@gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
 <1405854022-11833-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7EShwIf7fac1RLgAWns2Xe3"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/7EShwIf7fac1RLgAWns2Xe3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jul 2014 13:00:22 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> +	/* Apply */
> +	tx_pwr_state =3D nphy->txpwrctrl;
> +	b43_mac_suspend(dev);
> +	b43_nphy_tx_power_ctl_setup(dev);
> +	if (dev->dev->core_rev =3D=3D 11 || dev->dev->core_rev =3D=3D 12) {
> +		b43_maskset32(dev, B43_MMIO_MACCTL, ~0, B43_MACCTL_PHY_LOCK);
> +		b43_read32(dev, B43_MMIO_MACCTL);
> +		udelay(1);
> +	}

You could probably write a function b43_phy_lock/unlock() similar to b43_ma=
c_suspend/enable
to make this more readable.
The PHY_LOCK bit is related to the mac-suspend bit, after all. These are bo=
th used to lock
the firmware in one way or the other.

> +	b43_nphy_tx_power_ctrl(dev, nphy->txpwrctrl);
> +	if (dev->dev->core_rev =3D=3D 11 || dev->dev->core_rev =3D=3D 12)
> +		b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PHY_LOCK, 0);
> +	b43_mac_enable(dev);
> +
> +	nphy->tx_pwr_last_recalc_freq =3D channel->center_freq;
> +	nphy->tx_pwr_last_recalc_limit =3D phy->desired_txpower;
> +
> +	return B43_TXPWR_RES_DONE;
> +}

> @@ -6656,5 +6721,4 @@ const struct b43_phy_operations b43_phyops_n =3D {
>  	.switch_channel		=3D b43_nphy_op_switch_channel,
>  	.get_default_chan	=3D b43_nphy_op_get_default_chan,
>  	.recalc_txpower		=3D b43_nphy_op_recalc_txpower,
> -	.adjust_txpower		=3D b43_nphy_op_adjust_txpower,

recalc_txpower once was designed to just recalculate the txpower and not wr=
ite it
to hardware. adjust_txpower was supposed to write it to hardware afterwards.
That had to do with some locking foo and stuff I forgot (AFAIR these callba=
cks are called
in different contexts, but I may be wrong).
But I don't think it really matters. Just as a general hint here.

--=20
Michael

--Sig_/7EShwIf7fac1RLgAWns2Xe3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy6dqAAoJEPUyvh2QjYsOa98P/3PnmzA8e/5QoFKqBZEjGr1j
53gGgGSRJ8tO5b3qP3EpwyuLYyNjFEtM9DqEPPrUtZuJuopRkUjs2fugOBBR/cMC
684PokPcYh2ZH75HOImc1txZLDvklmX1HXNxs+Z2PM0P01F3RwXRqXJ2fjDOdDME
ARXoZpn+a9uIrpNIbfaJ/7sVtzK13hXqbOmmzdMsn3kNBIxf5dw/NRPQHuU4jCfO
R2uiPor5rBB56x8T2QgQKZrsOq3N99ex86TnbBQdbemvDooFXJvy2TGI+YgzeUgi
8+ujkPvwrW7qPLVPl/9ZelkCU8bpD9yja5hOje6LtMxjPLvLB7oRMtgiRlRMSgCH
LJJg8Nb5BNG1C5h6MNVnWj1WTE9LO7Vog6JtU6aDtSiJe4cC5k93Us4vwUiLHe7r
l9HyTyvSV0i2TzIxKV44vk46x+GXt0jsAOL9UBgCjZQsPN7ZGTjb4r5C48c16w7H
mCvSltzJGh1mZ17R0wl6Q+bF5f29wSpB+GedxNNhB35LkFTQaVaIFqGSe3o69MQy
LOuwTdC8FKyP2zKSoa0eNg+oEWSk8tbRXd575YqUUDMFuyvnAHx7CGbdNdh40VN3
BUPLcyKb+89hhc0wTTFdOX3JTz07sog9Gz817DzI2+K+EdPKyautYToTLDT1w7D1
W8Kx7SOIgA7o85pGk/C4
=ffat
-----END PGP SIGNATURE-----

--Sig_/7EShwIf7fac1RLgAWns2Xe3--
