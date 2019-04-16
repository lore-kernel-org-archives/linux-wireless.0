Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4A1C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB7420821
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfDPIMs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:12:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37498 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbfDPIMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:12:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id w10so25701395wrm.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 01:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZveMAaWan1ZRbniOqU3BZQ9JaAKN/WPKgCWZS7oTdko=;
        b=lxhMiesPyHHccSvs3qEkNHTxSRmhXjsNgIGhqyEac/Gz4/AoDKFGfZvIZmSZWaBmiP
         AAIQohPtc7Kz4trl+84Mw+OkKeOkTarBpLXnwotfyDKBS5X7BxYnQMH1Bvcw9p2FOZMR
         bdf5SP7PMqFAlufXtSJcMH0V1/U+VPwr6dKmunS4dEdh7SSrymigK4uQCyd2kiL63a1y
         4XFs4k4a34vZR2rDRq8K1LWVw7sR9B6avhwkyexnYWXa3UrhfSxnUGWNvH2xQCsz9vom
         1id9qesLUQ+mdcBuQ8vee0LTtExtNc5zZogUgxifJTsJvetg+cLwaj79As5nOtexxTim
         auRA==
X-Gm-Message-State: APjAAAV4QzRsURzdyKfR33n5Kz+iMygik+TNjfh4qVELy0s75H2e4JSE
        u8ADXHTYJEThns+7Lk/0p1lVeOFPGnM=
X-Google-Smtp-Source: APXvYqwpMELJ51RgQET190is5gcoMjI/NuKNPJ+/2+YH2MNQx9PLuMLkRkg4FBwkY/4F+m/cTin/kQ==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr38526109wrq.209.1555402365510;
        Tue, 16 Apr 2019 01:12:45 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x18sm21358787wmi.6.2019.04.16.01.12.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 01:12:44 -0700 (PDT)
Date:   Tue, 16 Apr 2019 10:12:42 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190416081241.GA11046@localhost.localdomain>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
 <20190412162746.GC3156@localhost.localdomain>
 <20190413083050.GA7434@redhat.com>
 <20190413101056.GA7940@localhost.localdomain>
 <20190415115352.GA4143@redhat.com>
 <20190415150405.GA14449@localhost.localdomain>
 <20190416080436.GA2833@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20190416080436.GA2833@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Apr 15, 2019 at 05:04:06PM +0200, Lorenzo Bianconi wrote:
> > > On Sat, Apr 13, 2019 at 12:10:59PM +0200, Lorenzo Bianconi wrote:
> > > > > On Fri, Apr 12, 2019 at 06:27:48PM +0200, Lorenzo Bianconi wrote:
> > > > > > > > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi =
wrote:
> > > > > > > > > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues =
in order to
> > > > > > > > > properly deallocate all pending skbs during suspend/resum=
e phase
> > > > > > > >=20
> > > > > > > > On suspend/resume tx skb's are processed after tasklet_enab=
le()
> > > > > > > > in resume callback. There is issue with device removal thou=
gh
> > > > > > > > (during suspend or otherwise).
> > > > > > >=20
> > > > > > > Hi Stanislaw,
> > > > > > >=20
> > > > > > > I guess the right moment to deallocate the skbs is during sus=
pend since resume
> > > > > > > can happen in very far future
> > > > >=20
> > > > > Yes, it's better to free on suspend, but in practice does not rea=
lly matter since
> > > > > system is disabled till resume.
> > > > >=20
> > > > > > > > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer=
")
> > > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > > > ---
> > > > > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > >=20
> > > > > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/d=
rivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > index a3acc070063a..575207133775 100644
> > > > > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt=
76_dev *dev)
> > > > > > > > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > > > > > > > >  {
> > > > > > > > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > > > > > > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > > > -
> > > > > > > > >  	mt76u_stop_rx(dev);
> > > > > > > > > +
> > > > > > > > >  	mt76u_stop_tx(dev);
> > > > > > > > > +	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > >=20
> > > > > > > > If tasklet is scheduled and we disable it and never enable,=
 we end up
> > > > > > > > with infinite loop in tasklet_action_common(). This patch m=
ake the
> > > > > > > > problem less reproducible since tasklet_disable() is moved =
after
> > > > > > > > usb_kill_urb() -> tasklet_schedule(), but it is still possi=
ble.
> > > > > > >=20
> > > > > > > I can see the point here. Maybe we can just run tasklet_kill =
instead of
> > > > > > > tasklet_disable here (at least for tx one)
> > > > >=20
> > > > > I think you have right as tasklet_kill() will wait for scheduled =
tasklet .
> > > > > Originally in my patch (see below) I used wait_event as I thought
> > > > > tasklet_kill() may prevent scheduled tasklet to be executed (henc=
e cause
> > > > > leak) but that seems to be not true.
> > > >=20
> > > > I agree with rx side (good catch!!), but on tx one I guess usb_kill=
_urb()
> > > > is already waiting for tx pending so we just need to use tasklet_ki=
ll
> > > > at the end of mt76u_stop_queues, in this way we will free pending s=
kbs during
> > > > suspend
> > >=20
> > > I looked more into that and there are some issues with this approach.
> > > tx_tasklet do mt76_txq_schedule() which can queue tx frames. Also we
> > > do not free skb's that require status check and dev->usb.stat_work=20
> > > is already (correctly) stopped on mac80211.stop.=20
> >=20
> > right
> >=20
> > >=20
> > > I'll use wait_event(dev->tx_wait) on mac80211 stop to handle those
> > > issues correctly.
> >=20
> > ack
> >=20
> > >=20
> > > Stanislaw
> >=20
> > during device removal I guess we should also flush skbs in status queue=
, doing
> > something like (after commit 0b5f71304cd9 (mt76: introduce mt76_free_de=
vice
> > routine))
> >=20
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/=
net/wireless/mediatek/mt76/mt76x0/usb.c
> > index 1ef00e971cfa..d4d1eb003148 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > @@ -299,7 +299,7 @@ static void mt76x0_disconnect(struct usb_interface =
*usb_intf)
> >  	if (!initalized)
> >  		return;
> > =20
> > -	ieee80211_unregister_hw(dev->mt76.hw);
> > +	mt76_unregister_device(&dev->mt76);
>=20
> mt76_unregister_device() free mmio dma. I've added mt76_tx_status_check()
> on mt76u_stop_tx() routine instead.

nope, after commit 0b5f71304cd98fb7b3b5b3a633e470bea979fe94
(https://github.com/nbd168/wireless/commit/0b5f71304cd98fb7b3b5b3a633e470be=
a979fe94)
it can be used even for usb

Lorenzo

>=20
> Stanislaw
>=20

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLWOdgAKCRA6cBh0uS2t
rB5/AQDzKP4nE+lqer5qKKa5NTKx7SNf/HctnBJENJgRySmNXgD9GRvEOGc85tyL
53ydQJTc+fKlIRcVtHR1uJRAxQ2o9wU=
=vBpr
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
