Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:33528 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbXK0AbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 19:31:11 -0500
Received: by py-out-1112.google.com with SMTP id u77so1804857pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 16:31:10 -0800 (PST)
Message-ID: <43e72e890711261631g24c45b67s82befc1ff43d3097@mail.gmail.com> (sfid-20071127_003114_407214_608971DE)
Date: Mon, 26 Nov 2007 19:31:09 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 2/3] ath5k: noise calibration also for rf511x
Cc: "Bruno Randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com
In-Reply-To: <40f31dec0711230325tf751decr1b3a0ce8af95d68d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-3-git-send-email-bruno@thinktube.com>
	 <40f31dec0711230325tf751decr1b3a0ce8af95d68d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 6:25 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2007/11/23, Bruno Randolf <bruno@thinktube.com>:
> > also perform full noise calibration in ath5k_hw_rf511x_calibrate() instead of
> > just writing the bit.
> >
> > Changes-licensed-under: ISC
> > Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> > ---
> >  drivers/net/wireless/ath5k/phy.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> > index 9b91121..f250c2e 100644
> > --- a/drivers/net/wireless/ath5k/phy.c
> > +++ b/drivers/net/wireless/ath5k/phy.c
> > @@ -1702,8 +1702,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
> >                 ((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
> >
> >  done:
> > -       /* Start noise floor calibration */
> > -       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
> > +       ath5k_hw_noise_floor_calibration(ah, channel->freq);
> >
> >         /* Request RF gain */
> >         if (channel->val & CHANNEL_5GHZ) {
> > --
> > 1.5.3.4
> >
> >
>
> Actually just writing the bit enables nf calibration, what this patch
> does is that it also reads the value and check if it's ok.

Know why it wasn't done before? Have you guys tested this without
impact on performance on the affected hardware? Just curious.

  Luis
