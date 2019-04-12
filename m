Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3847AC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 125F42082E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfDLPfQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:35:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41427 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfDLPfP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 11:35:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id r4so12476636wrq.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 08:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+jrzdc1x9pBzGPBFKq5B1VUa2NDnY5aeZl70zpzrV04=;
        b=WK+gWVHmjY0bMRD7dAiWdzXQigxP6P7K39H75tVeQ/A3HeWc7+TF1VzyYWNbkks+dB
         bTYyvLTy7eSBE7nrd1eBOLOi10Yj+0lOAlfpnsf3r8Gt8+Nngz/9V59RJDwmgajXMgf+
         jqdkSP8V0GNn6Ci5ukiZ/NHUqTatdpT8/o0NJ0Ra5lXGs4TEq0IyjC9nNPAlz8XZhypC
         R/21tGcyHbf7hOxUt9vcuBW4noy/G9eIZ0yKOeTJGcHEE1itE3mWPCS4ebwZhyppH/J3
         7zS6WHn+IVv28POr7+iAqUMwZLm3NI4gD+cxEMcA3oXoseljPR4lp/0jLRDG3MeHCI+k
         Hm9A==
X-Gm-Message-State: APjAAAXallxQZhRRO4ezdBEmCPgIDQRIUNfZnTvkiY+SU125C7hOgEfs
        myVCAyPcKh7Zg/85rJsqQFOXdA==
X-Google-Smtp-Source: APXvYqwWcLhabmBwZjzSamAGH1xcvsCDEZlUnM0NnTXFqY+t3couN7612UiVSlh9MjDkc45YfcqZcg==
X-Received: by 2002:adf:e889:: with SMTP id d9mr20814230wrm.162.1555083314092;
        Fri, 12 Apr 2019 08:35:14 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f10sm49709847wrs.17.2019.04.12.08.35.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 08:35:13 -0700 (PDT)
Date:   Fri, 12 Apr 2019 17:35:10 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190412153509.GB3156@localhost.localdomain>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <20190412145442.GA2539@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrote:
> > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order to
> > properly deallocate all pending skbs during suspend/resume phase
>=20
> On suspend/resume tx skb's are processed after tasklet_enable()
> in resume callback. There is issue with device removal though
> (during suspend or otherwise).

Hi Stanislaw,

I guess the right moment to deallocate the skbs is during suspend since res=
ume
can happen in very far future

>=20
> > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wir=
eless/mediatek/mt76/usb.c
> > index a3acc070063a..575207133775 100644
> > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
> >  void mt76u_stop_queues(struct mt76_dev *dev)
> >  {
> >  	tasklet_disable(&dev->usb.rx_tasklet);
> > -	tasklet_disable(&dev->usb.tx_tasklet);
> > -
> >  	mt76u_stop_rx(dev);
> > +
> >  	mt76u_stop_tx(dev);
> > +	tasklet_disable(&dev->usb.tx_tasklet);
>=20
> If tasklet is scheduled and we disable it and never enable, we end up
> with infinite loop in tasklet_action_common(). This patch make the
> problem less reproducible since tasklet_disable() is moved after
> usb_kill_urb() -> tasklet_schedule(), but it is still possible.

I can see the point here. Maybe we can just run tasklet_kill instead of
tasklet_disable here (at least for tx one)

Regards,
Lorenzo

>=20
> I comprehansive have fix for that, but giving it more testing.
> Please drop this patch.
>=20
> Stanislaw

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLCwKgAKCRA6cBh0uS2t
rD67AP42d+jxBH3wT8jlgZBm2VeZIAF0XQXeIasnbVn0MtUd/wEAzPl3gJYQ1Mdm
f9CwV8nYH1GBfCjLPDQY9JDf0j1EZAQ=
=wraq
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
