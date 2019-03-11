Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC69EC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9586B20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfCKODE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:03:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53742 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfCKODE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 10:03:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id e74so4642317wmg.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 07:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LQGO+0VZ7PqFW40Hnn9iS4zvmoYnb6a3D5oAWS4Hyj8=;
        b=l70uFEZFnFRk2hbA1yRarnXkzZayaRzV6FIzzpg4tYwTocIJK9PFOQbycUUxlwLXOz
         HfftgDczuwGJcCWgnqqLshXzRWKPhqABMc4GibWxPxKlm9jtqG+C38JghaEDR/Db3D39
         kLyRiluubQ7tpZpt0zmYh9OvVNuQYmyE1qYa/V4X9iaMoBNTCpNANeZ2W/nPT2IBcG0A
         M1NDabZ0zae8AXKdbz7kW/GNUO/+ts3/1yChbBbxxcLnb9DZYBjHTcHFpPrjAoVUSqzk
         +FWaiifd+ibaevWjfZae308hpRn2n49/US+2qbl865mekuc+vJ9s3u5PmVtI/jo+MgQx
         5xyQ==
X-Gm-Message-State: APjAAAXvA5wWFkwnRmk1HskgWp9qr2iCM/M8D/UiVbWGtizKgu7m77vK
        s5itdiwwZRwm0DTsss1l2JTu9Q==
X-Google-Smtp-Source: APXvYqxo5s92Qk4iyLZalC0gIHIbh6h3GZ5UQr1vHEi9L2+hyGYEVnXvPVRkYhChtOFTEsLt6LHX3Q==
X-Received: by 2002:a1c:7a1a:: with SMTP id v26mr16813496wmc.129.1552312982582;
        Mon, 11 Mar 2019 07:03:02 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a20sm9172213wmb.17.2019.03.11.07.03.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 07:03:01 -0700 (PDT)
Date:   Mon, 11 Mar 2019 15:02:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] mt76: move mt76x02_insert_hdr_pad in mt76-core module
Message-ID: <20190311140255.GA30882@localhost.localdomain>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <0ec618f40f6308f4da8c6a766519dfd66fa5ad57.1552306908.git.lorenzo@kernel.org>
 <20190311133058.GC6089@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20190311133058.GC6089@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 11, 2019 at 01:35:23PM +0100, Lorenzo Bianconi wrote:
> > +static inline int mt76_insert_hdr_pad(struct sk_buff *skb)
> > +{
> > +	int len =3D ieee80211_get_hdrlen_from_skb(skb);
> > +
> > +	if (len % 4 =3D=3D 0)
> > +		return 0;
> > +
> > +	skb_push(skb, 2);
> > +	memmove(skb->data, skb->data + 2, len);
> > +
> > +	skb->data[len] =3D 0;
> > +	skb->data[len + 1] =3D 0;
> > +	return 2;
> > +}
> <snip>
> > @@ -165,7 +165,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, v=
oid *txwi_ptr,
> >  	pid =3D mt76_tx_status_skb_add(mdev, wcid, skb);
> >  	txwi->pktid =3D pid;
> > =20
> > -	ret =3D mt76x02_insert_hdr_pad(skb);
> > +	ret =3D mt76_insert_hdr_pad(skb);
> >  	if (ret < 0)
> >  		return ret;
>=20
> Since you modify this you can make mt76_inser_hdr_pad() return
> void since we do not return error any longer.

ack, will do in v2

Regards,
Lorenzo

>=20
> Stanislaw

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIZqiwAKCRA6cBh0uS2t
rBgyAP9pKYDMcambobo/jrTWCDASjrQkyPYI5Ux7j4CB5UGHqQEA3N5BvhWi3bc9
bb5tzCIAaE0Cois8XjAnlvhymiZnWgk=
=ylfc
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
