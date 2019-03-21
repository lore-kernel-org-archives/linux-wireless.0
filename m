Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230B7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 09:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6038218A2
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 09:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553158976;
	bh=UK3uPF5uAqiDF9PIcS09/2inL++YKR1UzowKbYazUdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=zv8MVx3vQ0KrOvaqkuecBeqihNSUPwdrxdoQMi3bVmo5HrdvCFMVLJowoF4eUk6Gz
	 J6xCzJy7s7Z3NNMzKnA63H5ZTupKlsUqWtpUqXrr3qT27ZomP8MyZS3qH++Rz99gat
	 QqFkvy9UCkpoPH/dfkKxv+OjPQ8SD/YQ4FWlPU6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfCUJCv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 05:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbfCUJCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 05:02:50 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E67320811;
        Thu, 21 Mar 2019 09:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553158969;
        bh=UK3uPF5uAqiDF9PIcS09/2inL++YKR1UzowKbYazUdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0gswQ6VtqvYd1oVS1JC2tbvSXiV/sYv/hDlQR5xYKUdK1DL8i53rmFPBuB5dcVQwy
         xQ/iS4kAnFZjefGZxwEQciyMkCkcwBohzSpMHsxtvHl8NvlnfkgTZQvWRKAGnZ/gMp
         sFZjfh4/+CXQFoBSbb6aW1y1HscDDefvMBYJLrDU=
Date:   Thu, 21 Mar 2019 10:02:44 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190321090243.GA15941@localhost.localdomain>
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
 <20190319110708.GA5360@redhat.com>
 <20190319125812.GA21821@localhost.localdomain>
 <20190319160426.GA15616@redhat.com>
 <20190319162324.GB21821@localhost.localdomain>
 <20190320081127.GA17841@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20190320081127.GA17841@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Mar 19, 2019 at 05:23:25PM +0100, Lorenzo Bianconi wrote:
> > > On Tue, Mar 19, 2019 at 01:58:13PM +0100, Lorenzo Bianconi wrote:
> > > > > On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
> > > > > > Similar to pci counterpart, reduce locking in mt76u_tx_tasklet =
since
> > > > > > q->head is managed just in mt76u_tx_tasklet and q->queued is up=
dated
> > > > > > holding q->lock
> > > > > >=20
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > ---
> > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-----=
--
> > > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > > >=20
> > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers=
/net/wireless/mediatek/mt76/usb.c
> > > > > > index ac03acdae279..8cd70c32d77a 100644
> > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned lon=
g data)
> > > > > >  	int i;
> > > > > > =20
> > > > > >  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
> > > > > > +		u32 n_queued =3D 0, n_sw_queued =3D 0;
> > > > > > +
> > > > > >  		sq =3D &dev->q_tx[i];
> > > > > >  		q =3D sq->q;
> > > > > > =20
> > > > > > -		spin_lock_bh(&q->lock);
> > > > > > -		while (true) {
> > > > > > +		while (q->queued > n_queued) {
> > > > > >  			buf =3D &q->entry[q->head].ubuf;
> > > > > > -			if (!buf->done || !q->queued)
> > > > > > +			if (!buf->done)
> > > > > >  				break;
> > > > >=20
> > > > > I'm still thinking if this is safe or not. Is somewhat tricky to
> > > > > read variable outside the lock because in such case there is no t=
ime
> > > > > guarantee when variable written on one CPU gets updated value on
> > > > > different CPU. And for USB is not only q->queued but also buf->do=
ne.
> > > >=20
> > > > Hi Stanislaw,
> > > >=20
> > > > I was wondering if this is safe as well, but q->queued is updated h=
olding q->lock
> > > > and I guess it will ensure to not overlap tx and status code path.
> > >=20
> > > Overlap will not happen, at worst what can happen is q->queued will be
> > > smaller on tx_tasklet than on tx_queue_skb.
> >=20
> > Yes, that is the point :)
> >=20
> > >=20
> > > > Regarding buf->done, it is already updated without holding the lock=
 in mt76u_complete_tx
> > >=20
> > > That's actually a bug, but it's not important, if tx_tasklet will not
> > > see updated buf->done <- true value by mt76u_complete_tx on different
> > > cpu, it will not complete skb. It will be done on next tx_tasklet ite=
ration.
> > > Worse thing would be opposite situation.
> >=20
> > Can this really occur?
> I was thinking about that and yes it can occur. If q->queued and
> buf->done writes/read will be reordered by CPUs. To prevent that you=20
> will need to use smp_wmb/smp_rmb pair, but it's just simpler and more
> convenient to use lock.

good point, I will go through it.

Regards,
Lorenzo

>=20
> > (since queued is update holding the lock)
> Holding the lock on one thread without holding it on concurrent thread
> is irrelevant, it's the same as not holding any lock at all.
>=20
> Stanislaw

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJNTMAAKCRA6cBh0uS2t
rG80AQD2/Svv7ZMgF1Gkk3bD1/u9QGxSp/QOyMnH54w1N5cEigD9EKA6nw+kXWIq
Ob6UcYSDrZLa0fuTe+2jcRJLwT0UrA0=
=jWk/
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
