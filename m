Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYKRCGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 21:06:45 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1226973473.2548.97.camel@debian.sh.intel.com>
References: <1226969241.4014.24.camel@johannes.berg>
	 <1226973473.2548.97.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TbtyJYRj2AIr4b/+B7lj"
Date: Tue, 18 Nov 2008 03:05:50 +0100
Message-Id: <1226973950.4014.37.camel@johannes.berg> (sfid-20081118_030649_458619_22F63EF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TbtyJYRj2AIr4b/+B7lj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-18 at 09:57 +0800, Zhu Yi wrote:

> We do suspect the 256 alignment requirement will be an issue. Thus we do
> let people can reproduce this problem check with it. See comment #21,
> #22, #23 in bug
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1703. The
> result is people still see this problem even the DMA address is 256
> bytes aligned.

Ok. Reading those comments, I wouldn't be too sure that he still ran
into it without the alignment warning, since he said he missed some
messages. Remember that the driver posts a whole bunch of RX buffers at
init time (I saw this, it filled way more than my screen when printing
just a line for each buffer) and then doesn't do much for quite a while
until you turn on wireless, and the driver might init earlier than other
things so he may have missed those messages. Anyway, hard to tell, hence
me asking if this patch fixes it.

Thanks for the review, you're right about the two missing +256.

Anyone who wants to try it before one of us posts a fixed version should
fix their version as below, I need to get some sleep.

> > @@ -302,7 +305,7 @@ void iwl_rx_queue_free(struct iwl_priv *
> >  	for (i =3D 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
> >  		if (rxq->pool[i].skb !=3D NULL) {
> >  			pci_unmap_single(priv->pci_dev,
> > -					 rxq->pool[i].dma_addr,
> > +					 rxq->pool[i].real_dma_addr,
> >  					 priv->hw_params.rx_buf_size,
>=20
> priv->hw_params.rx_buf_size + 256.
>=20
> >  					 PCI_DMA_FROMDEVICE);
> >  			dev_kfree_skb(rxq->pool[i].skb);
> > @@ -370,7 +373,7 @@ void iwl_rx_queue_reset(struct iwl_priv=20
> >  		 * to an SKB, so we need to unmap and free potential storage */
> >  		if (rxq->pool[i].skb !=3D NULL) {
> >  			pci_unmap_single(priv->pci_dev,
> > -					 rxq->pool[i].dma_addr,
> > +					 rxq->pool[i].real_dma_addr,
> >  					 priv->hw_params.rx_buf_size,
> >  					 PCI_DMA_FROMDEVICE);
> >  			priv->alloc_rxb_skb--;
>=20
> ditto.

johannes

--=-TbtyJYRj2AIr4b/+B7lj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIiL6AAoJEKVg1VMiehFYLYkP/iA28HFBnoNrm0jZmnJXZ87T
WDppniR2tbyvW11v/FrLYiqu7adXCc/VOK52Zmw86lI+f+Djsx0e8huVJ+WDPHvT
iyixLVf3k2I3tw6nJh+ocw0WRmvf8r/PaIA/cMBKnYFuG1DWjLFZi8Yhp6g/8TYL
iBDJ1hF+GB7f9QxeLwFKr1GPidVvvMnVgfrfMM3kYaOyxVBgAZJ/mcEW+RdMLo8h
tL7PGi+T+HdNzNCK+H8ZpQC5CV9X+eexTXzNWyW6YEopq9F/udllwt6QXGoUGWDb
w88zeA3P9NX4roQLaOsYm1igKcvVHbGXpy7AZ9xCoxHIbMZ/Uhi4yzCyrjHpvRRt
fDTDJYazqmBpKL24yPyA8VbtfE2Bza/E3pbWLYBHmCchAmV45kQb2IyLFUabACv2
kVLOlNNsA1bqOJdjyNBXWc49BYzvJyZlFLl1226PjLgZsjOVODRWg+gnKU35BqfC
kuiIK/h117ol29THKhfpYBhJk36q3c9EHoxbHSn45JFKd8EtLuLLi0+BD2WeHc7p
gk4QkyUaI2ZlbzSTRGKjeYhFNIKbDnNL7533O+Fwqw5FuQ1se6UHO8VvRPhvcInz
k7bn3zsBgWPUxH9Bnagl2iHLSQ7lLaznA2zZVyle2c6D20T5BjNtLqrmis//O2Zw
+wBATHkbK1X+rnW42XLb
=GOjZ
-----END PGP SIGNATURE-----

--=-TbtyJYRj2AIr4b/+B7lj--

