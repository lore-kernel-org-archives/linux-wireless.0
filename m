Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A687C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 16:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1613B2077C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 16:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfDLQ1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 12:27:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52997 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbfDLQ1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 12:27:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id a184so11994217wma.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 09:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lm4R7guUQHiNox0Hs92cRf7lpLP1SU50Wg1ZlbP7uDM=;
        b=jnoIi7F3Tekj4ibmojOgKvkzKGh/K3PguaWkx03LmZHW5t3gDGw9w/tyaEqPmFmhbE
         ApXlEmuGlpXpHfZwOvfyjrbsAv4ejA1llFjvCmmtQjZMgkvoQ7QTBO/8G0Ih1OBaUfVT
         Jojx1k28pAdtb9LHBxomN/cxPsawWCgHSEwqYenyN6LlXj7Vcowpe+W6Kvu6q6pvf28Y
         Q4QN+g5sfmP3YVlIJQJzhHbXiih1L3ihZxT2fQy46AZ4I/We64bIen7P1ycnOqimXcPa
         CO0xgqVE3IpT5vQ3APpJioFripT15zc1/9snSvbfGja7LOJ2C9zRj7xvSuSWKMEs3Npb
         u4Og==
X-Gm-Message-State: APjAAAX6bIF0DJCE/K+GG+fLSInU5Lmzdxi8gRuSclwO9WABEg3KvUV7
        jgoF8ICL+zT+ZhXwEfXrKV1cDUS0cEU=
X-Google-Smtp-Source: APXvYqy+xLpjGdcHYorNXvUJS8HVP4t9oIxTUz/tLDw8S8xhDIxGvZhGKWqfR6hExIhxxXC7NQ/81w==
X-Received: by 2002:a1c:c186:: with SMTP id r128mr11562448wmf.100.1555086470972;
        Fri, 12 Apr 2019 09:27:50 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a11sm7214999wmm.35.2019.04.12.09.27.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 09:27:50 -0700 (PDT)
Date:   Fri, 12 Apr 2019 18:27:48 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190412162746.GC3156@localhost.localdomain>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <20190412153509.GB3156@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrote:
> > > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order to
> > > properly deallocate all pending skbs during suspend/resume phase
> >=20
> > On suspend/resume tx skb's are processed after tasklet_enable()
> > in resume callback. There is issue with device removal though
> > (during suspend or otherwise).
>=20
> Hi Stanislaw,
>=20
> I guess the right moment to deallocate the skbs is during suspend since r=
esume
> can happen in very far future
>=20
> >=20
> > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/w=
ireless/mediatek/mt76/usb.c
> > > index a3acc070063a..575207133775 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
> > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > >  {
> > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > -
> > >  	mt76u_stop_rx(dev);
> > > +
> > >  	mt76u_stop_tx(dev);
> > > +	tasklet_disable(&dev->usb.tx_tasklet);
> >=20
> > If tasklet is scheduled and we disable it and never enable, we end up
> > with infinite loop in tasklet_action_common(). This patch make the
> > problem less reproducible since tasklet_disable() is moved after
> > usb_kill_urb() -> tasklet_schedule(), but it is still possible.
>=20
> I can see the point here. Maybe we can just run tasklet_kill instead of
> tasklet_disable here (at least for tx one)

I think it is enough even for rx side since usb_kill_urb() will wait the en=
d of
mt76u_complete_rx() and tasklet_kill() will wait for the completion of
mt76u_rx_tasklet(). We will need to remove tasklet_enable in resume routine=
s.

Regards,
Lorenzo

>=20
> Regards,
> Lorenzo
>=20
> >=20
> > I comprehansive have fix for that, but giving it more testing.
> > Please drop this patch.
> >=20
> > Stanislaw



--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLC8fAAKCRA6cBh0uS2t
rA/rAP0VIBuEaw2UHVhdkX18gkzGHn3ST+cE0vAZZXLh+wlv8gD/f/pg2+fsgoNu
E+8o+OhG05mVRN7Ow1iGyWd8DnK+EAs=
=ezj9
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
