Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30950 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab0B0FFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 00:05:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 21:05:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19336.44155.838629.240683@gargle.gargle.HOWL>
Date: Sat, 27 Feb 2010 10:54:11 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
In-Reply-To: <1267209201.30426.8.camel@mj>
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
	<1267209201.30426.8.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> > @@ -1240,7 +1228,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
> >  {
> >       struct ath_common *common = ath9k_hw_common(ah);
> >
> > -     if (common->state <= ATH_HW_INITIALIZED)
> > +     if (common->state < ATH_HW_INITIALIZED)
> >               goto free_hw;
> >
> >       if (!AR_SREV_9100(ah))
> 
> There are some non-trivial parts like this one that could be submitted
> separately.
> 
> > @@ -1249,10 +1237,8 @@ void ath9k_hw_deinit(struct ath_hw *ah)
> >       ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
> >
> >  free_hw:
> > -     if (!AR_SREV_9280_10_OR_LATER(ah))
> > +     if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
> >               ath9k_hw_rf_free_ext_banks(ah);
> > -     kfree(ah);
> > -     ah = NULL;
> 
> Another one.  Actually, it is trivial, but not ath9k_htc related.
> 
> It would be really nice to fast track the ath9k_htc driver to 2.6.34,
> but the changes affecting other devices should be separate, I believe.

I'll submit this fix as a separate patch.

Sujith
