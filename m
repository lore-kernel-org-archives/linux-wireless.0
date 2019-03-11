Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1528BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4D09206BA
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfCKOZ1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:25:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35314 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfCKOZ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 10:25:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id t18so5322490wrx.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 07:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=miFuTGAH1GWDa/J+lk9T6UIQon2M1Gm+JGaSd5a2S+Q=;
        b=Q+OgM0p+gR1QgiNm/LCpGbCrFa08UVZrmuvAZsA2kQGJzBvaNJyPppWax5iLMMEGCb
         fzobE/eeTZ6RFqia3uLXWEbgDbioraqZ77gkMDlBqea2dU1ALqfc45h3tFR5kWMbDHxu
         1e4k4YsV52LffAzxgUN1yHAUSNYtrnXXBp9W01ELgo7oM6MNiySuthkw0s/S+83xiU4U
         JIDUk3JnZT7zHnLJLvLWPw65w5UXR04s8pyJ4kjcvbztiVGl/bPFfQjwNQyv44WStdsS
         jYibog+mxm2YGk3jrzYSHk4K8ugAkVXRgrZx0kOFwUYlbHM7r0DoZ0YewXiV8MxBOBpp
         Rmyw==
X-Gm-Message-State: APjAAAUtORXUpUlrBzGZep2Jqcn2HS8lNdrm0HvKNMFKf6SREeypivsu
        WAupK+QszKk5D6XCHYS1t5Hduw==
X-Google-Smtp-Source: APXvYqzLKjF3IUNjAgFsay1teogqIj4N/tEb9MCK6z1wPNYl2C8b+748HaBEQD4BhSqrpWEDmrYBWQ==
X-Received: by 2002:adf:9d89:: with SMTP id p9mr4995839wre.81.1552314324786;
        Mon, 11 Mar 2019 07:25:24 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id p16sm15859125wro.25.2019.03.11.07.25.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 07:25:24 -0700 (PDT)
Date:   Mon, 11 Mar 2019 15:25:18 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76: mmio: move mt76_insert_hdr_pad in
 mt76_dma_tx_queue_skb
Message-ID: <20190311142517.GB30882@localhost.localdomain>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
 <20190311133954.GD6089@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <20190311133954.GD6089@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mar 11, Stanislaw Gruszka wrote:
> On Mon, Mar 11, 2019 at 01:35:24PM +0100, Lorenzo Bianconi wrote:
> > Introduce tx_aligned4_skbs in mt76_driver_ops and move
> > mt76_insert_hdr_pad in mt76_dma_tx_queue_skb. This is a preliminary
> > patch in order to unify tx dma mapping for mt76x02 and new chipsets
> >=20
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/dma.c          |  3 +++
> >  drivers/net/wireless/mediatek/mt76/mt76.h         |  1 +
> >  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
> >  drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 13 +++++--------
> >  drivers/net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
> >  5 files changed, 11 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wir=
eless/mediatek/mt76/dma.c
> > index a66832a02281..14dd6585bab4 100644
> > --- a/drivers/net/wireless/mediatek/mt76/dma.c
> > +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> > @@ -300,6 +300,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt=
76_txq_id qid,
> >  	}
> > =20
> >  	skb->prev =3D skb->next =3D NULL;
> > +	if (dev->drv->tx_aligned4_skbs)
> > +		mt76_insert_hdr_pad(skb);
>=20
> We need 4 bytes aligned skbs for mt76x02 or we just need header
> lenght be multiple of 4 ? =20

I think IV/LLC should be 4 byte aligned

Regards,
Lorenzo

>=20
> Stanislaw
>=20

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIZvyQAKCRA6cBh0uS2t
rKb/AQCpafwKF5PFu4vxv4qLOeunGpGFzsK5Y+U2ot9PW79++wEA74N93qOT/x4R
frjBZPHDiSiR6x+O77WjMa++t5mKQAE=
=me+2
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
