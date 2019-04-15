Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BABEC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3E1206B6
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfDOPEM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:04:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44489 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfDOPEM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 11:04:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id y7so22376280wrn.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2019 08:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jx7Cd8eN7V3ZOVDb3nGfnAy+dv0WHUfx7cmJd8nOmgg=;
        b=TNAPqtKwQFRjfrbbiyWlRpJ2wkmsgF+D/GgbSJWh8c5e2UmW5ix3LDcwqjTZM97aXj
         6biziRe9886A0NUBfl5VmufkYi54w514qozncxKIv+eY1KgwNN0UgPtUM5sqt9bvFBrb
         iZjA2M1QL4/jjr/SyUAhX9jfd5Vc1EtDpG5pjrdQB4xEPWlkrFyTzamjFIEA7/xW/8Fm
         OKWl2E4OE5Ce6OotZOIaBZuMxKotyIrI7dOXqTfMO8Xm09gmoczW8d+ARL9tiEDOzzl+
         9Rn17LX9m13I7+FupCBZqW6uej1/pGu+lTL+5AyX0Lo1Dago9jx821lNzZqgwKQCbsJj
         6XvA==
X-Gm-Message-State: APjAAAU8z1oVarExe/9V7WVQYl/e+YJulee8MW+EcIqx3AyyMBn8qWj4
        r/GJqJCeAjiW9ughOIshnAUiYQ==
X-Google-Smtp-Source: APXvYqzex1rGDo01R6rLnc11bJmfQTf3me1wNQrDgg8p0GyTnDdUJMIq7CfLAbXcFgNoXhiDmCEOYw==
X-Received: by 2002:a5d:5188:: with SMTP id k8mr48753151wrv.183.1555340649612;
        Mon, 15 Apr 2019 08:04:09 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a126sm17554331wmh.4.2019.04.15.08.04.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 08:04:09 -0700 (PDT)
Date:   Mon, 15 Apr 2019 17:04:06 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190415150405.GA14449@localhost.localdomain>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
 <20190412162746.GC3156@localhost.localdomain>
 <20190413083050.GA7434@redhat.com>
 <20190413101056.GA7940@localhost.localdomain>
 <20190415115352.GA4143@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20190415115352.GA4143@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, Apr 13, 2019 at 12:10:59PM +0200, Lorenzo Bianconi wrote:
> > > On Fri, Apr 12, 2019 at 06:27:48PM +0200, Lorenzo Bianconi wrote:
> > > > > > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrot=
e:
> > > > > > > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in o=
rder to
> > > > > > > properly deallocate all pending skbs during suspend/resume ph=
ase
> > > > > >=20
> > > > > > On suspend/resume tx skb's are processed after tasklet_enable()
> > > > > > in resume callback. There is issue with device removal though
> > > > > > (during suspend or otherwise).
> > > > >=20
> > > > > Hi Stanislaw,
> > > > >=20
> > > > > I guess the right moment to deallocate the skbs is during suspend=
 since resume
> > > > > can happen in very far future
> > >=20
> > > Yes, it's better to free on suspend, but in practice does not really =
matter since
> > > system is disabled till resume.
> > >=20
> > > > > > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > ---
> > > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > >=20
> > > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drive=
rs/net/wireless/mediatek/mt76/usb.c
> > > > > > > index a3acc070063a..575207133775 100644
> > > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_d=
ev *dev)
> > > > > > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > > > > > >  {
> > > > > > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > > > > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > -
> > > > > > >  	mt76u_stop_rx(dev);
> > > > > > > +
> > > > > > >  	mt76u_stop_tx(dev);
> > > > > > > +	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > >=20
> > > > > > If tasklet is scheduled and we disable it and never enable, we =
end up
> > > > > > with infinite loop in tasklet_action_common(). This patch make =
the
> > > > > > problem less reproducible since tasklet_disable() is moved after
> > > > > > usb_kill_urb() -> tasklet_schedule(), but it is still possible.
> > > > >=20
> > > > > I can see the point here. Maybe we can just run tasklet_kill inst=
ead of
> > > > > tasklet_disable here (at least for tx one)
> > >=20
> > > I think you have right as tasklet_kill() will wait for scheduled task=
let .
> > > Originally in my patch (see below) I used wait_event as I thought
> > > tasklet_kill() may prevent scheduled tasklet to be executed (hence ca=
use
> > > leak) but that seems to be not true.
> >=20
> > I agree with rx side (good catch!!), but on tx one I guess usb_kill_urb=
()
> > is already waiting for tx pending so we just need to use tasklet_kill
> > at the end of mt76u_stop_queues, in this way we will free pending skbs =
during
> > suspend
>=20
> I looked more into that and there are some issues with this approach.
> tx_tasklet do mt76_txq_schedule() which can queue tx frames. Also we
> do not free skb's that require status check and dev->usb.stat_work=20
> is already (correctly) stopped on mac80211.stop.=20

right

>=20
> I'll use wait_event(dev->tx_wait) on mac80211 stop to handle those
> issues correctly.

ack

>=20
> Stanislaw

during device removal I guess we should also flush skbs in status queue, do=
ing
something like (after commit 0b5f71304cd9 (mt76: introduce mt76_free_device
routine))

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/=
wireless/mediatek/mt76/mt76x0/usb.c
index 1ef00e971cfa..d4d1eb003148 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -299,7 +299,7 @@ static void mt76x0_disconnect(struct usb_interface *usb=
_intf)
 	if (!initalized)
 		return;
=20
-	ieee80211_unregister_hw(dev->mt76.hw);
+	mt76_unregister_device(&dev->mt76);
 	mt76x0u_cleanup(dev);
=20
 	usb_set_intfdata(usb_intf, NULL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/=
wireless/mediatek/mt76/mt76x2/usb.c
index d08bb964966b..4394c7c10535 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -94,7 +94,7 @@ static void mt76x2u_disconnect(struct usb_interface *intf)
 	struct ieee80211_hw *hw =3D mt76_hw(dev);
=20
 	set_bit(MT76_REMOVED, &dev->mt76.state);
-	ieee80211_unregister_hw(hw);
+	mt76_unregister_device(&dev->mt76);
 	mt76x2u_cleanup(dev);
=20
 	ieee80211_free_hw(hw);

Regards,
Lorenzo

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLSdYgAKCRA6cBh0uS2t
rM55AQCmf28gYxnUaGYtXhNIK6CBgQ6Wzl1VtkvZFWdRYEw5nQEAr6uv5ex3uZTs
bG4msnakuHT5TE9Y8CfIUkVpxPr1Jg8=
=Kt3x
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
