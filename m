Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57988 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbcEIHNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 03:13:40 -0400
Subject: Re: [PATCH net-next 4/5] treewide: replace dev->trans_start update
 with helper
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
References: <1462285862-30946-1-git-send-email-fw@strlen.de>
 <1462285994-31983-1-git-send-email-fw@strlen.de>
Cc: user-mode-linux-devel@lists.sourceforge.net,
	linux-xtensa@linux-xtensa.org,
	linux1394-devel@lists.sourceforge.net, linux-rdma@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-can@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-hams@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	b.a.t.m.a.n@lists.open-mesh.org, linux-bluetooth@vger.kernel.org
From: Marc Kleine-Budde <mkl@pengutronix.de>
Message-ID: <57303873.5000108@pengutronix.de> (sfid-20160509_091354_727613_490630E4)
Date: Mon, 9 May 2016 09:12:51 +0200
MIME-Version: 1.0
In-Reply-To: <1462285994-31983-1-git-send-email-fw@strlen.de>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="fcr4wLrDMdGPahnJScwefNsWCeJgfIRNI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fcr4wLrDMdGPahnJScwefNsWCeJgfIRNI
Content-Type: multipart/mixed; boundary="GFLu7KIgkl64MDwwCs6gU46kBmw2cCDDs"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net,
 linux-xtensa@linux-xtensa.org, linux1394-devel@lists.sourceforge.net,
 linux-rdma@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-can@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org,
 devel@driverdev.osuosl.org, b.a.t.m.a.n@lists.open-mesh.org,
 linux-bluetooth@vger.kernel.org
Message-ID: <57303873.5000108@pengutronix.de>
Subject: Re: [PATCH net-next 4/5] treewide: replace dev->trans_start update
 with helper
References: <1462285862-30946-1-git-send-email-fw@strlen.de>
 <1462285994-31983-1-git-send-email-fw@strlen.de>
In-Reply-To: <1462285994-31983-1-git-send-email-fw@strlen.de>

--GFLu7KIgkl64MDwwCs6gU46kBmw2cCDDs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/03/2016 04:33 PM, Florian Westphal wrote:
> Replace all trans_start updates with netif_trans_update helper.
> change was done via spatch:
>=20
> struct net_device *d;
> @@
> - d->trans_start =3D jiffies
> + netif_trans_update(d)
>=20
> Compile tested only.
>=20
> Cc: user-mode-linux-devel@lists.sourceforge.net
> Cc: linux-xtensa@linux-xtensa.org
> Cc: linux1394-devel@lists.sourceforge.net
> Cc: linux-rdma@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: MPT-FusionLinux.pdl@broadcom.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-hams@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: linux-bluetooth@vger.kernel.org
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Checkpatch complains about whitespace damage, but
>  this extra whitespace already exists before this patch.
>=20
>  drivers/net/can/mscan/mscan.c                          | 4 ++--
>  drivers/net/can/usb/ems_usb.c                          | 4 ++--
>  drivers/net/can/usb/esd_usb2.c                         | 4 ++--
>  drivers/net/can/usb/peak_usb/pcan_usb_core.c           | 4 ++--

> diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/msca=
n.c
> index e36b740..acb708f 100644
> --- a/drivers/net/can/mscan/mscan.c
> +++ b/drivers/net/can/mscan/mscan.c
> @@ -276,7 +276,7 @@ static netdev_tx_t mscan_start_xmit(struct sk_buff =
*skb, struct net_device *dev)
>  	out_8(&regs->cantflg, 1 << buf_id);
> =20
>  	if (!test_bit(F_TX_PROGRESS, &priv->flags))
> -		dev->trans_start =3D jiffies;
> +		netif_trans_update(dev);
> =20
>  	list_add_tail(&priv->tx_queue[buf_id].list, &priv->tx_head);
> =20
> @@ -469,7 +469,7 @@ static irqreturn_t mscan_isr(int irq, void *dev_id)=

>  			clear_bit(F_TX_PROGRESS, &priv->flags);
>  			priv->cur_pri =3D 0;
>  		} else {
> -			dev->trans_start =3D jiffies;
> +			netif_trans_update(dev);
>  		}
> =20
>  		if (!test_bit(F_TX_WAIT_ALL, &priv->flags))
> diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_us=
b.c
> index 3400fd1..71f0e79 100644
> --- a/drivers/net/can/usb/ems_usb.c
> +++ b/drivers/net/can/usb/ems_usb.c
> @@ -521,7 +521,7 @@ static void ems_usb_write_bulk_callback(struct urb =
*urb)
>  	if (urb->status)
>  		netdev_info(netdev, "Tx URB aborted (%d)\n", urb->status);
> =20
> -	netdev->trans_start =3D jiffies;
> +	netif_trans_update(netdev);
> =20
>  	/* transmission complete interrupt */
>  	netdev->stats.tx_packets++;
> @@ -835,7 +835,7 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buf=
f *skb, struct net_device *ne
>  			stats->tx_dropped++;
>  		}
>  	} else {
> -		netdev->trans_start =3D jiffies;
> +		netif_trans_update(netdev);
> =20
>  		/* Slow down tx path */
>  		if (atomic_read(&dev->active_tx_urbs) >=3D MAX_TX_URBS ||
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_u=
sb2.c
> index 113e64f..784a900 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -480,7 +480,7 @@ static void esd_usb2_write_bulk_callback(struct urb=
 *urb)
>  	if (urb->status)
>  		netdev_info(netdev, "Tx URB aborted (%d)\n", urb->status);
> =20
> -	netdev->trans_start =3D jiffies;
> +	netif_trans_update(netdev);
>  }
> =20
>  static ssize_t show_firmware(struct device *d,
> @@ -820,7 +820,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_bu=
ff *skb,
>  		goto releasebuf;
>  	}
> =20
> -	netdev->trans_start =3D jiffies;
> +	netif_trans_update(netdev);
> =20
>  	/*
>  	 * Release our reference to this URB, the USB core will eventually fr=
ee
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net=
/can/usb/peak_usb/pcan_usb_core.c
> index 5a2e341..bfb91d8 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -274,7 +274,7 @@ static void peak_usb_write_bulk_callback(struct urb=
 *urb)
>  		netdev->stats.tx_bytes +=3D context->data_len;
> =20
>  		/* prevent tx timeout */
> -		netdev->trans_start =3D jiffies;
> +		netif_trans_update(netdev);
>  		break;
> =20
>  	default:
> @@ -373,7 +373,7 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct s=
k_buff *skb,
>  			stats->tx_dropped++;
>  		}
>  	} else {
> -		netdev->trans_start =3D jiffies;
> +		netif_trans_update(netdev);
> =20
>  		/* slow down tx path */
>  		if (atomic_read(&dev->active_tx_urbs) >=3D PCAN_USB_MAX_TX_URBS)

For the drivers/can part:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--GFLu7KIgkl64MDwwCs6gU46kBmw2cCDDs--

--fcr4wLrDMdGPahnJScwefNsWCeJgfIRNI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJXMDhzAAoJED07qiWsqSVqY58H/ix0AbZ+YrFYM2PIOprS2fXE
aX27+KlnttkKPZwwfFINkn2/zij9PmEHqTEIhWIQW+jkvzw3wk2+4r7S6RgCasja
uYAWpyo35ikxuaRPe9rzVseGZfULqW5rGxx5I9fp9eC4WFjyU66mwhWI08YY2apl
W1Lqfgzz2Op2wykMdjjjW9bjnDQLigGgdvjsvg03u0hyPhfWol23c3UexJU13qXJ
blCUgZ3l3JJeh3FsZlb1wJ08j4imD54l2H+/y3uDNEh9V3k40pTtDxWoRwx3wc1C
Q6gJ1MowW9/sLy+VOcMrFLy4JG652SUKe1B0pNocQX7QjHvQkt7pTtdx3reGwmM=
=cJdV
-----END PGP SIGNATURE-----

--fcr4wLrDMdGPahnJScwefNsWCeJgfIRNI--
