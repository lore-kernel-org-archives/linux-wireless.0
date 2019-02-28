Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE5DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB36214D8
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 11:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732599AbfB1Lhy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:37:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41017 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732576AbfB1Lhy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 06:37:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so21547677wrw.8
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2019 03:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1QDlnzymBC0IiSwF85DIRy07jRCv8qDAzg/chZQPldY=;
        b=ftpWVj7SXXpEUtalvWRINOrXQPOGLvRGy9QGTbFwx684kwiN6Kls0gbIvjCaLWaWhX
         fCcdxxFVG4WnczXsirAjEWv1N3J0SL6uy2tq9dS2gVfYWgoyVd9XHEIVeklFiLMcknJc
         f8imme53d+TaPn+LwaTWx/js1rVAHPppyWrJluGNRxYSmaOKAhohIi60F1hsII/vULY/
         Y0ctUWbKooC26zBvITIESGo6fFjRAlRS6GlHMSm/Eluus5VEHWKiZKPKj5jhWIuDEqNK
         vwwJAqQmCwJoRNbFlWeOaKkvR0KI0UTs73suYL/ddG8OmcYoWOXxgeZBRpQDHBmfGoi6
         1BuA==
X-Gm-Message-State: APjAAAVww2rlfyR8LwzTnMAsiGraf4M2m+VbZshrwsuU4Z/wd0jfJw+f
        COY2kZsQKs/PPJsLA+rw1hP7kCTLa0M=
X-Google-Smtp-Source: APXvYqzkT7x3Df9n3bEpL8tC2rbBJPBtXe9YMPPhcqVpvM87Q+MC7BNjgj6I+T8aXg1av10rrpWHuQ==
X-Received: by 2002:adf:ee82:: with SMTP id b2mr6513190wro.185.1551353872795;
        Thu, 28 Feb 2019 03:37:52 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c126sm8772149wma.0.2019.02.28.03.37.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 03:37:52 -0800 (PST)
Date:   Thu, 28 Feb 2019 12:37:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: grab rx_page_lock for legacy mode in
 mt76u_refill_rx
Message-ID: <20190228113746.GC2768@localhost.localdomain>
References: <cover.1551350717.git.lorenzo@kernel.org>
 <ec679a39f00e9f8fabc698ef3d977ff97c841873.1551350717.git.lorenzo@kernel.org>
 <20190228112445.GA6072@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <20190228112445.GA6072@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Feb 28, 2019 at 12:08:45PM +0100, Lorenzo Bianconi wrote:
> > Grab rx_page_lock in mt76u_refill_rx allocating rx buffer for 'legacy'
> > mode. Remove gfp from mt76u_refill_rx signature since we need to
> > use GFP_ATOMIC
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> I'm doing some cleanup/optimization work which amongs other things
> will remove rx_page_lock. Please drop this patch.

Oh, ok. IIRC we need rx_page_lock to fix this:
481bb0432414f790066205fe77226b7d1877385d. Is it still necessary?
Moreover maybe we need this patch for 5.1 since net-next is almost close, n=
o?

@Felix: are you planning to submit other patches for 5.1?

Regards,
Lorenzo

>=20
> Stanislaw

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXHfIBwAKCRA6cBh0uS2t
rPIXAPsFlM7QKnLDILR3SvQaveKvfLV4gfdRiVgvY1EeQVDB8gD/Sqq++QF63yyk
XcPcUWy5qY+1W3LsiX7FYUBDlpaHWQw=
=29Am
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
