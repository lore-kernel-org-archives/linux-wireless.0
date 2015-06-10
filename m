Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:60564 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751550AbbFJT7l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 15:59:41 -0400
Date: Wed, 10 Jun 2015 21:59:38 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Kalle Valo <kvalo@codeaurora.org>
Message-ID: <1121998377.24127.1433966378845.open-xchange@webmail.nmp.proximus.be> (sfid-20150610_215946_993031_F27E03CF)
In-Reply-To: <1433965966.32331.25.camel@perches.com>
References: <1433954015-24872-1-git-send-email-fabf@skynet.be> <1433965966.32331.25.camel@perches.com>
Subject: Re: [PATCH 1/1 linux-next] ath5k: use swap() in
 ath5k_hw_get_median_noise_floor()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On 10 June 2015 at 21:52 Joe Perches <joe@perches.com> wrote:
>
>
> On Wed, 2015-06-10 at 18:33 +0200, Fabian Frederick wrote:
> > Use kernel.h macro definition.
> >
> > Thanks to Julia Lawall for Coccinelle scripting support.
> []
> > diff --git a/drivers/net/wireless/ath/ath5k/phy.c
> > b/drivers/net/wireless/ath/ath5k/phy.c
> []
> > @@ -1566,17 +1566,13 @@ static s16
> >  ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
> >  {
> >     s16 sort[ATH5K_NF_CAL_HIST_MAX];
> > -   s16 tmp;
> >     int i, j;
> > 
> >     memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
> >     for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
> >             for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
> > -                   if (sort[j] > sort[j - 1]) {
> > -                           tmp = sort[j];
> > -                           sort[j] = sort[j - 1];
> > -                           sort[j - 1] = tmp;
> > -                   }
> > +                   if (sort[j] > sort[j - 1])
> > +                           swap(sort[j], sort[j]);
>
> swap(a, a) doesn't look useful.
Thanks a lot Joe, I'll fix this one :)

Regards,
Fabian
>
>
