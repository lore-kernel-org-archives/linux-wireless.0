Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8859C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B61112073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfDPIdL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:33:11 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40122 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfDPIdK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:33:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so25758389wre.7
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 01:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IZfSPhA3lEc3Uf0RptdSqvWFqFzg1WygDL0iBmThJu0=;
        b=UKct5YJdnwO1ZuVBFlBmnXMpiFixflRkFaIBloFNpCjpWiEZ3HEG3WzjHI0Eabk3Od
         eDFHgD2gCiLImbIaFHlEnLGZnMFmeHkwag+UpLIa61n9GaERATR2W71o2eLMqYXMWjnz
         hcS2A76Tp0xOjGb6hEQ5imLcC1tIED6v1WSVkq3TjvCU7NUUTzi6q5WqMazjjGLc0QcD
         OCXg3uC2l/GcuNlbLkncZcQyTtWxaQhgvb3wsIW9W1A5qg543ik2SdiXeayeWUVYq8M0
         Dc67ESEe5aXdmn3+7DXAyrnFzCxk63Bs61BM3Frjh3o3cSUGAD1WdYq7APb4cUoAY2q8
         iCqg==
X-Gm-Message-State: APjAAAU94rKMZcL/LSbfMsoLjdlNgehdhpHbyp8I/bwUrarlJZq13QFV
        /4IUO2PYGO3tZ9IqcTlCMrVoag==
X-Google-Smtp-Source: APXvYqz6SoeFyUK5682hYUIK8w4GevSbRvUJ8eTWUwRSJt7G2sI2TNS3jRXTKkKMYR+ch146eN+vCA==
X-Received: by 2002:adf:b6a3:: with SMTP id j35mr48579029wre.25.1555403588745;
        Tue, 16 Apr 2019 01:33:08 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s2sm18206339wmc.7.2019.04.16.01.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 01:33:08 -0700 (PDT)
Date:   Tue, 16 Apr 2019 10:33:05 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190416083304.GB11046@localhost.localdomain>
References: <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
 <20190412162746.GC3156@localhost.localdomain>
 <20190413083050.GA7434@redhat.com>
 <20190413101056.GA7940@localhost.localdomain>
 <20190415115352.GA4143@redhat.com>
 <20190415150405.GA14449@localhost.localdomain>
 <20190416080436.GA2833@redhat.com>
 <20190416081241.GA11046@localhost.localdomain>
 <20190416082708.GB2833@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20190416082708.GB2833@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr 16, Stanislaw Gruszka wrote:
> On Tue, Apr 16, 2019 at 10:12:42AM +0200, Lorenzo Bianconi wrote:
> > > On Mon, Apr 15, 2019 at 05:04:06PM +0200, Lorenzo Bianconi wrote:
> > > > > On Sat, Apr 13, 2019 at 12:10:59PM +0200, Lorenzo Bianconi wrote:
> > > > > > > On Fri, Apr 12, 2019 at 06:27:48PM +0200, Lorenzo Bianconi wr=
ote:
> > > > > > > > > > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianc=
oni wrote:
> > > > > > > > > > > Disable mt76u_tx_tasklet at the end of mt76u_stop_que=
ues in order to
> > > > > > > > > > > properly deallocate all pending skbs during suspend/r=
esume phase
> > > > > > > > > >=20
> > > > > > > > > > On suspend/resume tx skb's are processed after tasklet_=
enable()
> > > > > > > > > > in resume callback. There is issue with device removal =
though
> > > > > > > > > > (during suspend or otherwise).
> > > > > > > > >=20
> > > > > > > > > Hi Stanislaw,
> > > > > > > > >=20
> > > > > > > > > I guess the right moment to deallocate the skbs is during=
 suspend since resume
> > > > > > > > > can happen in very far future
> > > > > > >=20
> > > > > > > Yes, it's better to free on suspend, but in practice does not=
 really matter since
> > > > > > > system is disabled till resume.
> > > > > > >=20
> > > > > > > > > > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 l=
ayer")
> > > > > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > > > > > ---
> > > > > > > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > > > > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > > > >=20
> > > > > > > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c=
 b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > > > index a3acc070063a..575207133775 100644
> > > > > > > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > > > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struc=
t mt76_dev *dev)
> > > > > > > > > > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > > > > > > > > > >  {
> > > > > > > > > > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > > > > > > > > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > > > > > -
> > > > > > > > > > >  	mt76u_stop_rx(dev);
> > > > > > > > > > > +
> > > > > > > > > > >  	mt76u_stop_tx(dev);
> > > > > > > > > > > +	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > > > >=20
> > > > > > > > > > If tasklet is scheduled and we disable it and never ena=
ble, we end up
> > > > > > > > > > with infinite loop in tasklet_action_common(). This pat=
ch make the
> > > > > > > > > > problem less reproducible since tasklet_disable() is mo=
ved after
> > > > > > > > > > usb_kill_urb() -> tasklet_schedule(), but it is still p=
ossible.
> > > > > > > > >=20
> > > > > > > > > I can see the point here. Maybe we can just run tasklet_k=
ill instead of
> > > > > > > > > tasklet_disable here (at least for tx one)
> > > > > > >=20
> > > > > > > I think you have right as tasklet_kill() will wait for schedu=
led tasklet .
> > > > > > > Originally in my patch (see below) I used wait_event as I tho=
ught
> > > > > > > tasklet_kill() may prevent scheduled tasklet to be executed (=
hence cause
> > > > > > > leak) but that seems to be not true.
> > > > > >=20
> > > > > > I agree with rx side (good catch!!), but on tx one I guess usb_=
kill_urb()
> > > > > > is already waiting for tx pending so we just need to use taskle=
t_kill
> > > > > > at the end of mt76u_stop_queues, in this way we will free pendi=
ng skbs during
> > > > > > suspend
> > > > >=20
> > > > > I looked more into that and there are some issues with this appro=
ach.
> > > > > tx_tasklet do mt76_txq_schedule() which can queue tx frames. Also=
 we
> > > > > do not free skb's that require status check and dev->usb.stat_wor=
k=20
> > > > > is already (correctly) stopped on mac80211.stop.=20
> > > >=20
> > > > right
> > > >=20
> > > > >=20
> > > > > I'll use wait_event(dev->tx_wait) on mac80211 stop to handle those
> > > > > issues correctly.
> > > >=20
> > > > ack
> > > >=20
> > > > >=20
> > > > > Stanislaw
> > > >=20
> > > > during device removal I guess we should also flush skbs in status q=
ueue, doing
> > > > something like (after commit 0b5f71304cd9 (mt76: introduce mt76_fre=
e_device
> > > > routine))
> > > >=20
> > > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/driv=
ers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > > > index 1ef00e971cfa..d4d1eb003148 100644
> > > > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > > > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > > > @@ -299,7 +299,7 @@ static void mt76x0_disconnect(struct usb_interf=
ace *usb_intf)
> > > >  	if (!initalized)
> > > >  		return;
> > > > =20
> > > > -	ieee80211_unregister_hw(dev->mt76.hw);
> > > > +	mt76_unregister_device(&dev->mt76);
> > >=20
> > > mt76_unregister_device() free mmio dma. I've added mt76_tx_status_che=
ck()
> > > on mt76u_stop_tx() routine instead.
> >=20
> > nope, after commit 0b5f71304cd98fb7b3b5b3a633e470bea979fe94
> > (https://github.com/nbd168/wireless/commit/0b5f71304cd98fb7b3b5b3a633e4=
70bea979fe94)
> > it can be used even for usb
>=20
> Ok, but as you pointed before 'right moment to deallocate the skbs is
> during suspend' so I still preffer to flush statuses there.
>=20

I agree

Lorenzo

> Stanislaw

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLWTPQAKCRA6cBh0uS2t
rLdRAP9e0LDPy+bgsX3hrifKZNqWpxe6B1PqfS8GhaB1oy6IxAEA3PQ5Jogc5Vrz
loQB8pLnyt/n1NW6I4THSuyoATIHrA8=
=r6rn
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
