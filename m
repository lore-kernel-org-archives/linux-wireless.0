Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsec105.isp.belgacom.be ([195.238.20.101]:25398 "EHLO
	mailsec105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724AbbFKFGd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 01:06:33 -0400
Date: Thu, 11 Jun 2015 07:06:31 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>,
	Jiri Slaby <jirislaby@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Message-ID: <1397966187.6193.1433999191450.open-xchange@webmail.nmp.proximus.be> (sfid-20150611_070639_356890_F05B8348)
In-Reply-To: <alpine.DEB.2.02.1506102228560.1986@localhost6.localdomain6>
References: <1433954015-24872-1-git-send-email-fabf@skynet.be> <1433965966.32331.25.camel@perches.com> <1121998377.24127.1433966378845.open-xchange@webmail.nmp.proximus.be> <alpine.DEB.2.02.1506102228560.1986@localhost6.localdomain6>
Subject: Re: [PATCH 1/1 linux-next] ath5k: use swap() in
 ath5k_hw_get_median_noise_floor()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On 10 June 2015 at 22:29 Julia Lawall <julia.lawall@lip6.fr> wrote:
>
>
>
>
> On Wed, 10 Jun 2015, Fabian Frederick wrote:
>
> >
> >
> > > On 10 June 2015 at 21:52 Joe Perches <joe@perches.com> wrote:
> > >
> > >
> > > On Wed, 2015-06-10 at 18:33 +0200, Fabian Frederick wrote:
> > > > Use kernel.h macro definition.
> > > >
> > > > Thanks to Julia Lawall for Coccinelle scripting support.
> > > []
> > > > diff --git a/drivers/net/wireless/ath/ath5k/phy.c
> > > > b/drivers/net/wireless/ath/ath5k/phy.c
> > > []
> > > > @@ -1566,17 +1566,13 @@ static s16
> > > >  ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
> > > >  {
> > > >     s16 sort[ATH5K_NF_CAL_HIST_MAX];
> > > > -   s16 tmp;
> > > >     int i, j;
> > > > 
> > > >     memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
> > > >     for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
> > > >             for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
> > > > -                   if (sort[j] > sort[j - 1]) {
> > > > -                           tmp = sort[j];
> > > > -                           sort[j] = sort[j - 1];
> > > > -                           sort[j - 1] = tmp;
> > > > -                   }
> > > > +                   if (sort[j] > sort[j - 1])
> > > > +                           swap(sort[j], sort[j]);
> > >
> > > swap(a, a) doesn't look useful.
> > Thanks a lot Joe, I'll fix this one :)
>
> How did it come out like that?
>
> julia

I used script for detection only and made updates manually.
I guess I was distracted by [j - 1] on line above.
It was based on linux-next; if maintainers prefer another branch, I'll
send the right version on top of it.

Regards,
Fabian
>
> >
> > Regards,
> > Fabian
> > >
> > >
> >
