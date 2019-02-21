Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22577C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 07:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E15CF2148D
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 07:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550733343;
	bh=Lz7eY7/zPSEtyynxnNfK73bzk7hWLh0DOYEytq3J2P0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GQsrOPtT0hbYOMS3WVOVg1ADtjJj+HPgWBsZRojcQsBZPTKt9HqAA8exXhbFH/lKZ
	 QmxY9GlTAuoaGWPguUC9dA+hvsnosv1VQ525ES1sxcXdyx1zLiyyRXoFg0sBc8OHMd
	 Vok2mAaVQY81e0QIhzgmaZ29ujBvYVy7ZxfvpsdQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfBUHPl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 02:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfBUHPl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 02:15:41 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A30320838;
        Thu, 21 Feb 2019 07:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550733340;
        bh=Lz7eY7/zPSEtyynxnNfK73bzk7hWLh0DOYEytq3J2P0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0w8RKGZFJ/qBARfkaPfms9FHcb5BFLsvkbKKnnRFkhYekMMbHmwnPkJUQj0rjObiw
         MNL9Hx8qpZqqswyKKTWGm9pvdOAoiKDOkIM9pK9Taxr9W4AEp98iqkkJ5hl4lIBW1P
         fkQqYnle9olhCm1CUAory4X+bac7K6Ehk4x4aqdU=
Date:   Thu, 21 Feb 2019 08:15:35 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] mt76: usb: fix warning in mt76u_buf_free
Message-ID: <20190221071534.GA7457@lore-desk.lan>
References: <cover.1550706341.git.lorenzo@kernel.org>
 <bfd5659680fb3ef89554a48ff950d74dd88240dd.1550706341.git.lorenzo@kernel.org>
 <87bm3520bq.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <87bm3520bq.fsf@purkki.adurom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> lorenzo@kernel.org writes:
>=20
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > Fix following static checker warning in mt76u_buf_free:
> >   drivers/net/wireless/mediatek/mt76/usb.c:372 mt76u_buf_free()
> >   warn: address of 'urb->sg[i]' is non-NULL
> >
> > There is no need to check sg page pointer since urb->num_sgs
> > has been already validated in mt76u_fill_rx_sg
> >
> > Fixes: cb83585e1121 ("mt76: usb: fix possible memory leak in mt76u_buf_=
free")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> The merge window is really close, should I take this directly to
> wireless-drivers-next?

Hi Kalle,

I think this patch can go in Felix's tree for the moment since it just fixe=
s the warning,
the intended behaviour is to run skb_free_frag()

Regards,
Lorenzo

>=20
> BTW, Lorenzo please add your name to SMTP From line to make threading
> cleaner:
>=20
> From:   lorenzo@kernel.org
>=20
> --=20
> Kalle Valo


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXG5QFgAKCRA6cBh0uS2t
rEkoAPsEGgLjsmyJj08o5dZeInDB+R0zMb0FXVYg0EGFIaG0fQEAmHnDeUno+9UY
Ls/z7h8eiHwRy1Q/GsLJ/4VIZOneyA4=
=jY7M
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
