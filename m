Return-Path: <SRS0=xn0B=OS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E905C07E85
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Dec 2018 20:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6C520645
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Dec 2018 20:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F6C520645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbeLIUIr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Dec 2018 15:08:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39888 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbeLIUIr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Dec 2018 15:08:47 -0500
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 83BFE8078D; Sun,  9 Dec 2018 21:08:41 +0100 (CET)
Date:   Sun, 9 Dec 2018 21:08:44 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: trigger named just "tx" in
 drivers/net/wireless/atmel/at76c50x-usb.c
Message-ID: <20181209200844.GA12756@amd>
References: <20181201143144.GC31631@amd>
 <87lg57f182.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <87lg57f182.fsf@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-12-03 10:45:01, Kalle Valo wrote:
> Pavel Machek <pavel@ucw.cz> writes:
>=20
> > While grepping something else, I came across LED trigger that is named
> > just "tx".
> >
> > That's a bit too generic afaict?
> >
> > +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
> > @@ -520,7 +520,7 @@ static int at76_usbdfu_download(struct usb_device
> > *udev, u8 *buf, u32 size,
> >  static int tx_activity;
> >   static void at76_ledtrig_tx_timerfunc(struct timer_list *unused);
> >    static DEFINE_TIMER(ledtrig_tx_timer, at76_ledtrig_tx_timerfunc);
> >    -DEFINE_LED_TRIGGER(ledtrig_tx);
> >    +DEFINE_LED_TRIGGER(ledtrig_tx); /* Hey! "tx" is a bit too generic
> >    name for a trigger! */
>=20
> This is an ancient driver, my guess is that nobody uses it anymore. I
> should orphan it and maybe even remove it at some point.

Are you willing to add a fixme there? I really don't want people to
copy that example.
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlwNdkwACgkQMOfwapXb+vIFugCgruCm9/ACguL9fMeJjswzFgCt
3TcAnjJ60I+ja4xwG1FqHLvHc33BuucN
=oWTy
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
