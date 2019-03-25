Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BF4C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A0920830
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:47:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfCYNrl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:47:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55081 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfCYNrk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 09:47:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id f3so9031111wmj.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 06:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fpfcGO5qQbjN5ISzJEcZe+Dqk5lROL9VuTs3Nhz//U8=;
        b=Wlodj5xBOuRcrR2lvFOMGlDUL6gUpAhpaOCBIo6q//PxLwI3xJQ3F6v48yygyc7cEb
         /K1c+k6aEoewlHLxQ9HnXQV8xCV03Jr7IRWTorUBfenx8jvS6AU74bduAgqRPlZGPPMz
         sVrGv1c0yDW13/Mr5TkmUmL3aWXwCcjbgxrbduO9gaXDoWaXh6i+ktO3Y1aEbko22E+5
         1bgRANf04HGHBVb76NYJtWcFfwLIQAU/elVXDHCPinHByRBgoWu0IPjPqQJLDGwm+qcc
         JPN+F2ZE0cdGutkqeUROGKRdhAF1UzzK7J/K29M9IBVTyxj9k2wAvd9dQ+HYJFHHMByj
         oMAQ==
X-Gm-Message-State: APjAAAUIERcQv/WnOt/98qCSTEJd0pX+KS9RvHQpaFYdsiiPzrrb4HXv
        a0AQLoT8Qapc2Io7KfLejuMVYwEDzGA=
X-Google-Smtp-Source: APXvYqyOoGI11Vc50jXceE788Mu4wV0bgShTXmfocZZUPYZJReBunIMfJwn+BJaJCP+UNAcrnqMVGg==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr11633983wmb.92.1553521658482;
        Mon, 25 Mar 2019 06:47:38 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t24sm2095628wmi.10.2019.03.25.06.47.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 06:47:37 -0700 (PDT)
Date:   Mon, 25 Mar 2019 14:47:35 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190325134734.GB12885@localhost.localdomain>
References: <cover.1553437543.git.lorenzo@kernel.org>
 <1f489df8bc635660a1d1fb72400e5562504c0555.1553437543.git.lorenzo@kernel.org>
 <20190325125032.GB17956@redhat.com>
 <20190325130035.GA12885@localhost.localdomain>
 <20190325131019.GA19204@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <20190325131019.GA19204@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 25, 2019 at 02:00:36PM +0100, Lorenzo Bianconi wrote:
> > > On Sun, Mar 24, 2019 at 03:51:43PM +0100, Lorenzo Bianconi wrote:
> > > > +		int idx;
> > > > +
> > > >  		sq =3D &dev->q_tx[i];
> > > >  		q =3D sq->q;
> > > > =20
> > > > -		spin_lock_bh(&q->lock);
> > > > -		while (true) {
> > > > -			if (!q->entry[q->head].done || !q->queued)
> > > > +		while (q->queued > n_queued) {
> > > > +			if (!q->entry[q->head].done)
> > > >  				break;
> > > If you place done =3D false here you will not need additional idx
> > > variable.
> >=20
> > As Felix suggested, I would set done to false at the end of the loop, a=
fter
> > tx_complete_skb
> Why this is needed?=20

logically I think it should be the last thing to do on the current skb but
probably moving it before tx_complete_skb will not make any difference

>=20
> > > >  			dev->drv->tx_complete_skb(dev, i, &entry);
> > > > -			spin_lock_bh(&q->lock);
> > > > +			q->entry[idx].done =3D false;
> > > >  		}
> > > > =20
> > > > +		spin_lock_bh(&q->lock);
> > > This patch does not apply for me as there is missing
> > > mt76_txq_schedule(dev, sq);
> >=20
> > Sorry I forgot to mention this patch is based on
> > https://patchwork.kernel.org/patch/10856027/. Have you applied it?
> No.
>=20
> Stanislaw
>=20

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJjb8wAKCRA6cBh0uS2t
rJUUAP9cheGDoyDRbGJVgKGBQ+B4eI8CGo9ALkZuZpYEhE66TQEAiUMU2kjIhjkh
OeE5yOAWGQ71KiBvWQuC06r88eB+AQs=
=Qgm5
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
