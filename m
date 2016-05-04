Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4730 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbcEDIQz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 04:16:55 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-xtensa@linux-xtensa.org,
	linux1394-devel@lists.sourceforge.net, linux-rdma@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-can@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-hams@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
	b.a.t.m.a.n@lists.open-mesh.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] treewide: replace dev->trans_start update with helper
In-Reply-To: <1462285994-31983-1-git-send-email-fw@strlen.de>
References: <1462285862-30946-1-git-send-email-fw@strlen.de> <1462285994-31983-1-git-send-email-fw@strlen.de>
Date: Wed, 04 May 2016 11:14:45 +0300
Message-ID: <87vb2udytm.fsf@intel.com> (sfid-20160504_101703_087604_555751EB)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Florian Westphal <fw@strlen.de> writes:
> Replace all trans_start updates with netif_trans_update helper.
> change was done via spatch:
>
> struct net_device *d;
> @@
> - d->trans_start =3D jiffies
> + netif_trans_update(d)
>
> Compile tested only.
>
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

for u_ether.c:

Acked-by: Felipe Balbi <felipe.balbi@linux.intel.com>

> diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/f=
unction/u_ether.c
> index 637809e..a3f7e7c 100644
> --- a/drivers/usb/gadget/function/u_ether.c
> +++ b/drivers/usb/gadget/function/u_ether.c
> @@ -597,7 +597,7 @@ static netdev_tx_t eth_start_xmit(struct sk_buff *skb,
>  		DBG(dev, "tx queue err %d\n", retval);
>  		break;
>  	case 0:
> -		net->trans_start =3D jiffies;
> +		netif_trans_update(net);
>  		atomic_inc(&dev->tx_qlen);
>  	}

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKa91AAoJEIaOsuA1yqREa0UP/35SFn4ZofIoB65PTj1xg8X/
n7p9jjvrvEml10E4POQ/ZKeKzNBobiZfTvPVQ5fJ3DeaxYRMFNldcoNvv3XLHgb1
J/A6NNdCBYPMo7cc/67RCJKC+NEMbplqQSrLyCL4N8KDaR0ToDvFOhDW5ENtYAFR
+hHewPpprXHex8FPax3PMuuNCRkV/hz3PxCXnF+1h5nKD3hsXZwzQQAVC4OkWkzo
f9pAczgygfMWpsdOK4lBqAf82sK9P/bOJoE7ag/6zJ3E8EvmiB2oqtBzWzpdpWgL
JAZ4O8g2q2eV+vXK8ZqMt/yUwdS+V0ouR+iReYAATahEXzu0XPRZSHwmL0qKbl/D
RN4cVtSHl9cYltkxEMUSNUWZhGDaAyOiYbWWXwDQvus915p5Nq41v2VJailJBQD0
w+K4gJAw+0igWKgvq1M/JwoJftk9cA75Dw18f+6T6j/e78k0ZCnj1F4WHjWAIAAm
b54FVVjKATCK8/vIl73vtUpgdAzYeue3mwfd+PP5UfMXRpcEZU2icEyvHgyvbU5U
ChlCb1NRYIJ01e+J5Ov/Xd6+Pln8EwV4W4imFjzcsLNjiVU0OumWVqFqPtlDd4tq
5rKSXFa4XdaMA0CAM48AjdQmE3ta+xFFe+Q0GqVTMgyc4QOvSmZuWmsdfTmgyqC+
DjWMdryqMVHstUt2mUPA
=NJVp
-----END PGP SIGNATURE-----
--=-=-=--
