Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D15FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 12:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15DD9213F2
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 12:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfCSM6T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 08:58:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33992 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfCSM6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 08:58:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id p10so2737909wrq.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 05:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=17wJ3CZbreRKymuGIcHE6Wv2mgJQXvCs7roQrg2HT28=;
        b=df9qZgcgWlWNTDNbBaYd/IpVxcfSgQ6FgYLPpYnQ41Cc8YgR9pBZQhDa9IB519K6TY
         vEBILpAHxNYW26w1dviqZf/8IKBZZ6WvsGAjoqs2UzYbbBJYZmt4wFZ0yiL4OUDkDdBO
         Sj7hhXakLBZSKwlNOhHzLk1BsIOE9x5BIK2BeGDOWR2wTRCxzMd9N9D3+Rv77Z8JsLIE
         wmyVnDr+UuYTg3DbfYRvTzoQ5TYY0x04kVj57Qino5GMLmishEHj2XP6+UiX36a5e+Hb
         48D+xs9yrVh/JiYQ+qaa8JKg16LYA+MD24sPULFQkz65Y/FXl3f4pIVDnY4wQ0QNlskW
         rqew==
X-Gm-Message-State: APjAAAWmJXvzkar3RAsK6kUkj2WLHg+JsPcEFeHRAJV1ogW1eurDcXjK
        ux0I92e768xuOUFKmxjBHxJaog==
X-Google-Smtp-Source: APXvYqxg4zz7QkWuQOKmFN0FplmnjhAhDZCxRnxAEr2e2x9j7xo+QNsffHWG61hP7IrGgKpqsGT7AA==
X-Received: by 2002:a5d:6981:: with SMTP id g1mr14611413wru.326.1553000297009;
        Tue, 19 Mar 2019 05:58:17 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 13sm1803758wmj.33.2019.03.19.05.58.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 05:58:16 -0700 (PDT)
Date:   Tue, 19 Mar 2019 13:58:13 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190319125812.GA21821@localhost.localdomain>
References: <cover.1552907276.git.lorenzo@kernel.org>
 <1ee5ce7818f9d45c9713ce99e810cb84f50dcf03.1552907276.git.lorenzo@kernel.org>
 <20190319110708.GA5360@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20190319110708.GA5360@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 18, 2019 at 12:09:32PM +0100, Lorenzo Bianconi wrote:
> > Similar to pci counterpart, reduce locking in mt76u_tx_tasklet since
> > q->head is managed just in mt76u_tx_tasklet and q->queued is updated
> > holding q->lock
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/usb.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wir=
eless/mediatek/mt76/usb.c
> > index ac03acdae279..8cd70c32d77a 100644
> > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > @@ -634,29 +634,33 @@ static void mt76u_tx_tasklet(unsigned long data)
> >  	int i;
> > =20
> >  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
> > +		u32 n_queued =3D 0, n_sw_queued =3D 0;
> > +
> >  		sq =3D &dev->q_tx[i];
> >  		q =3D sq->q;
> > =20
> > -		spin_lock_bh(&q->lock);
> > -		while (true) {
> > +		while (q->queued > n_queued) {
> >  			buf =3D &q->entry[q->head].ubuf;
> > -			if (!buf->done || !q->queued)
> > +			if (!buf->done)
> >  				break;
>=20
> I'm still thinking if this is safe or not. Is somewhat tricky to
> read variable outside the lock because in such case there is no time
> guarantee when variable written on one CPU gets updated value on
> different CPU. And for USB is not only q->queued but also buf->done.

Hi Stanislaw,

I was wondering if this is safe as well, but q->queued is updated holding q=
->lock
and I guess it will ensure to not overlap tx and status code path.
Regarding buf->done, it is already updated without holding the lock in mt76=
u_complete_tx

Regards,
Lorenzo

> =20
> Stanislaw
>=20

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJDnYQAKCRA6cBh0uS2t
rC8LAP9DuBTRm5pfAyhzVCzRcbDU5mEBJ3fqn3HIKLdbD4cYXgD/YlkKRh0OijGm
CCX2aIuCiWrH/xvPTzmtaByMpuiTBAs=
=Z3FH
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
