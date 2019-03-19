Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7891AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 528252077B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfCSQXa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:23:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52374 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSQX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 12:23:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id a184so3553431wma.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 09:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LCoTqtrkG4LTxrt/OS4OECOiU609SZKQkonosNwiBtc=;
        b=j+pMw3PD6mr9m6bMK1ON2EyM28BuYNNRXMMLgFuAaq7JsGrvfJKSfJNZiNfl4iHgAY
         iJpDC9GmzS4F7h67pw4ATL+kIrHB641y9Dc2swrx8ZsgaCjETTlYIXRbvEV1l0gBpkYB
         a5l0q02jfiJJCp3pGrXDfM2/Lc/cW/r2ViWmlK+uKDomFbJyozBW8q0T5Ib/IlsIBcXU
         AwJudq/TUHY3tt8DItw+Kh1Gt/0F4i/SbBeBu2WGU1VXYOQ10rMRk38YIX1iZpPGexOX
         FNk4gbzf//nBGt3BJo0gg90/NYsQ0W2kTDhFLw5PJHDBr3Py9GlnN117Ah9MHwqz6ci8
         1iPA==
X-Gm-Message-State: APjAAAXz3W31YA/DBXV33lQE6mDSI/YQhNtsiCrjPYnDv5w2ZgEft5vy
        TQyrMpqOqaFM4tPrlByBDajvVA==
X-Google-Smtp-Source: APXvYqzMADP5VHgvKQLM9laCxOEN1ejycBkRQnr/FdE6FduEUD4cEVk1ADLSSyrO5FPwHyyEQlv3ew==
X-Received: by 2002:a7b:c3c5:: with SMTP id t5mr4320782wmj.110.1553012608222;
        Tue, 19 Mar 2019 09:23:28 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p10sm13614826wrs.5.2019.03.19.09.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 09:23:27 -0700 (PDT)
Date:   Tue, 19 Mar 2019 17:23:25 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190319162324.GB21821@localhost.localdomain>
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
 <20190319110708.GA5360@redhat.com>
 <20190319125812.GA21821@localhost.localdomain>
 <20190319160426.GA15616@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20190319160426.GA15616@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Mar 19, 2019 at 01:58:13PM +0100, Lorenzo Bianconi wrote:
> > > On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
> > > > Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
> > > > q->head is managed just in mt76u_tx_tasklet and q->queued is updated
> > > > holding q->lock
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
> > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net=
/wireless/mediatek/mt76/usb.c
> > > > index ac03acdae279..8cd70c32d77a 100644
> > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long da=
ta)
> > > >  	int i;
> > > > =20
> > > >  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
> > > > +		u32 n_queued =3D 0, n_sw_queued =3D 0;
> > > > +
> > > >  		sq =3D &dev->q_tx[i];
> > > >  		q =3D sq->q;
> > > > =20
> > > > -		spin_lock_bh(&q->lock);
> > > > -		while (true) {
> > > > +		while (q->queued > n_queued) {
> > > >  			buf =3D &q->entry[q->head].ubuf;
> > > > -			if (!buf->done || !q->queued)
> > > > +			if (!buf->done)
> > > >  				break;
> > >=20
> > > I'm still thinking if this is safe or not. Is somewhat tricky to
> > > read variable outside the lock because in such case there is no time
> > > guarantee when variable written on one CPU gets updated value on
> > > different CPU. And for USB is not only q->queued but also buf->done.
> >=20
> > Hi Stanislaw,
> >=20
> > I was wondering if this is safe as well, but q->queued is updated holdi=
ng q->lock
> > and I guess it will ensure to not overlap tx and status code path.
>=20
> Overlap will not happen, at worst what can happen is q->queued will be
> smaller on tx_tasklet than on tx_queue_skb.

Yes, that is the point :)

>=20
> > Regarding buf->done, it is already updated without holding the lock in =
mt76u_complete_tx
>=20
> That's actually a bug, but it's not important, if tx_tasklet will not
> see updated buf->done <- true value by mt76u_complete_tx on different
> cpu, it will not complete skb. It will be done on next tx_tasklet iterati=
on.
> Worse thing would be opposite situation.

Can this really occur? (since queued is update holding the lock)

>=20
> Stanislaw

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJEXeAAKCRA6cBh0uS2t
rEt4AP0cfjqxXES4IDJkZt7GndphGvW4/hDqleflzTLfVcYvcAEA9SNt9+MHppkG
NmLJGrgaYAiiM70uq6J1cQcGTi74GAg=
=ksld
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
