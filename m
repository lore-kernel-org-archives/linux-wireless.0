Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E91C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEA2120830
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 13:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfCYNAl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:00:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53133 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbfCYNAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 09:00:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id a184so8807629wma.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 06:00:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KaWAUhHYNQc14LKQSmqnCc3UjRNszUQwTL1pzN7Fvt4=;
        b=dPhQ5xvnXzceD6Yfw9oRcp6jhVhT1YYzMpgSg6EvB6/iuzGBwGAd3TpahONx2OsyA8
         BiVCxSY5bWCBAmBRJZgUjzXTjqYz66EeweGfgY4bSedTSDm2IUFZl3RS8DSGBXP82QZf
         Ny8cCikYfFV7iKNaG07HbMRkGlZ2bhDwsbTMXD6A8oynP6NHg/4mz8tk9FEEa8cL1M33
         wB2VVPftlT9HcbCpfNATZaWJcwVOIkIOGJStXFOMR6Qxuco0RZLSc/pX7XxUyNMMARel
         9WGo8LcgHIChemLqCpPd9/UmPo6WPTMKn3HTPvIVAjZiqpbp4FV5XAa1ZMU1bZfvP88j
         FBRA==
X-Gm-Message-State: APjAAAVgqA1LjKX4MWoW4++sRVzb5UPuIm7LILS0LZnfgR+lp3fxVt9s
        fdAeLD7c0XV03Uqyl/DVsHQfAg==
X-Google-Smtp-Source: APXvYqxqlUwJgHJkotKZbN2eMUDlOleB3DiWscvhkMnELnDQcM2sgllLXwfsScbvB+HwdE5ULDgzcA==
X-Received: by 2002:a05:600c:22cd:: with SMTP id 13mr4964955wmg.109.1553518839703;
        Mon, 25 Mar 2019 06:00:39 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 93sm36665642wrh.15.2019.03.25.06.00.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 06:00:38 -0700 (PDT)
Date:   Mon, 25 Mar 2019 14:00:36 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: reduce locking in mt76u_tx_tasklet
Message-ID: <20190325130035.GA12885@localhost.localdomain>
References: <cover.1553437543.git.lorenzo@kernel.org>
 <1f489df8bc635660a1d1fb72400e5562504c0555.1553437543.git.lorenzo@kernel.org>
 <20190325125032.GB17956@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20190325125032.GB17956@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Mar 24, 2019 at 03:51:43PM +0100, Lorenzo Bianconi wrote:
> > +		int idx;
> > +
> >  		sq =3D &dev->q_tx[i];
> >  		q =3D sq->q;
> > =20
> > -		spin_lock_bh(&q->lock);
> > -		while (true) {
> > -			if (!q->entry[q->head].done || !q->queued)
> > +		while (q->queued > n_queued) {
> > +			if (!q->entry[q->head].done)
> >  				break;
> If you place done =3D false here you will not need additional idx
> variable.

As Felix suggested, I would set done to false at the end of the loop, after
tx_complete_skb

>=20
> >  			dev->drv->tx_complete_skb(dev, i, &entry);
> > -			spin_lock_bh(&q->lock);
> > +			q->entry[idx].done =3D false;
> >  		}
> > =20
> > +		spin_lock_bh(&q->lock);
> This patch does not apply for me as there is missing
> mt76_txq_schedule(dev, sq);

Sorry I forgot to mention this patch is based on
https://patchwork.kernel.org/patch/10856027/. Have you applied it?

>=20
> > +
> > +		sq->swq_queued -=3D n_sw_queued;
> > +		q->queued -=3D n_queued;
> > +
> Naming is confusing, it should rather be n_dequeued, n_sw_dequeued.

I just followed dma counterpart naming convention, but I can modify it.

Regards,
Lorenzo

>=20
> Stanislaw

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXJjQ7wAKCRA6cBh0uS2t
rDLTAP9QR5kWHnALtuQ9H7Ul5ky4Hyhvfmp8j30/lyIe1nYbogD/S2v7rqc1b1Xg
RW9ZoxdQN3IkQwudTtyNR/Wb1t6vRQQ=
=IQup
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
