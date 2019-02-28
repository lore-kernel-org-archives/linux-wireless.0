Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1DEC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 12:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 752272171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 12:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbfB1Mb7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 07:31:59 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53225 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfB1Mb6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 07:31:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so9100272wml.2
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2019 04:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dBantj8TjJg7wm8MkuJPsbPKarEAn3NbErUVvDZyMQM=;
        b=YHgJfLvyttlYY8MIuXLnrnOGhg3d3MOdzICAYj3aoX7H+EwKKQPHukzC4z4+0QE8cM
         GK9G8T5P9at4MUSaI7RLe0Eo9xP1nJHdwZDbRVf1JI/bw30kPXLuEHKx+XuKbIMMhZsY
         af9hyE2o7W/TaEcQgCymNza4PotU7NlN4YQT9oOqSYnUwEoCsbd8uPguDm8dMw+mQnNc
         eH6EZzGwnlPHuxlD3Pv/kkZHWkMdwNLxVw8ps2ar7OwZuRL1mhb1gGiz06jNzQ42r1tj
         27ODPPg9oG5XTDCeYkMbTeQrvFoNWzx2wsWV7jVHUQTe8IBbWUOh6i4NtJ8DFXpgC3uN
         qRjg==
X-Gm-Message-State: AHQUAuZUhVld4RJn/wT9KUUe/7FTknwjy4W1Sq0TYLFbPmKv0dqxRRz3
        GWXCGCLA4diVKtcxKrycUnulYg==
X-Google-Smtp-Source: APXvYqxvAh+VqrjZqtWrjSIKAv2ms+FfpUcv8jBYQUqmDz70+BRH4h2jNl5c8vbDepV8tXnjZVm+Qg==
X-Received: by 2002:a1c:4884:: with SMTP id v126mr2846108wma.118.1551357116672;
        Thu, 28 Feb 2019 04:31:56 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q135sm9104889wme.43.2019.02.28.04.31.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 04:31:56 -0800 (PST)
Date:   Thu, 28 Feb 2019 13:31:52 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: introduce q->stopped parameter
Message-ID: <20190228123151.GD2768@localhost.localdomain>
References: <cover.1551301983.git.lorenzo@kernel.org>
 <ec189b4ec030646d4dbfd0b7c41944ab383edc4e.1551301983.git.lorenzo@kernel.org>
 <20190228114551.GB6072@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Content-Disposition: inline
In-Reply-To: <20190228114551.GB6072@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Feb 27, 2019 at 10:40:41PM +0100, Lorenzo Bianconi wrote:
> > @@ -289,9 +290,14 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta=
 *sta,
> >  	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
> >  	dev->queue_ops->kick(dev, q);
> > =20
> > -	if (q->queued > q->ndesc - 8)
> > -		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
> > +	stop =3D q->queued > q->ndesc - 8 && !q->stopped;
> > +	if (stop)
> > +		q->stopped =3D true;
> > +
> >  	spin_unlock_bh(&q->lock);
> > +
> > +	if (stop)
> > +		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
>=20
> I don't think taking this outside of spin_lock section is beneficial.
> Actually is better to do this faster than slower to prevent enqueue
> frames by mac80211 and then dropped them due to lack of space in
> mt76 queue.

ack, I will send a v2 moving it back.

Regards,
Lorenzo

>=20
> Stanislaw

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXHfUswAKCRA6cBh0uS2t
rNayAQC4ottbpej4Gda56pJ0mdzmiNroM+GUdJaLHiPhhP80fgD/cmcqQI49fzgj
4T4NzpyJu1FtBJgofT6g8TZDrYnYZAo=
=9Hl+
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
