Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37744 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935642AbeFMN2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 09:28:23 -0400
Received: by mail-lf0-f65.google.com with SMTP id g21-v6so3967778lfb.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2018 06:28:22 -0700 (PDT)
Date: Wed, 13 Jun 2018 15:28:19 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Govind Singh <govinds@codeaurora.org>, bjorn.andersson@linaro.org
Cc: kvalo@codeaurora.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: FW: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
Message-ID: <20180613132819.GA12603@centauri.ideon.se> (sfid-20180613_152848_926053_B6BBECED)
References: <20180612113907.15043-1-niklas.cassel@linaro.org>
 <20180612113907.15043-2-niklas.cassel@linaro.org>
 <7058492257914633b55fcd423e4c0b59@aphydexm01b.ap.qualcomm.com>
 <47cf8ec1b11d727ea928a307a431d4a2@codeaurora.org>
 <20180612124403.GA26986@centauri.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180612124403.GA26986@centauri.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 12, 2018 at 02:44:03PM +0200, Niklas Cassel wrote:
> On Tue, Jun 12, 2018 at 06:02:48PM +0530, Govind Singh wrote:
> > On 2018-06-12 17:45, Govind Singh wrote:
> > > -----Original Message-----
> > > From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Niklas
> > > Cassel
> > > Sent: Tuesday, June 12, 2018 5:09 PM
> > > To: Kalle Valo <kvalo@codeaurora.org>; David S. Miller
> > > <davem@davemloft.net>
> > > Cc: Niklas Cassel <niklas.cassel@linaro.org>; netdev@vger.kernel.org;
> > > linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > ath10k@lists.infradead.org
> > > Subject: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
> > > 
> > > ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.
> > > 
> > > Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> > > ---
> > >  drivers/net/wireless/ath/ath10k/Kconfig | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/ath10k/Kconfig
> > > b/drivers/net/wireless/ath/ath10k/Kconfig
> > > index 54ff5930126c..6572a43590a8 100644
> > > --- a/drivers/net/wireless/ath/ath10k/Kconfig
> > > +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> > > @@ -42,7 +42,8 @@ config ATH10K_USB
> > > 
> > >  config ATH10K_SNOC
> > >  	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
> > > -	depends on ATH10K && ARCH_QCOM
> > > +	depends on ATH10K
> > > +	depends on ARCH_QCOM || COMPILE_TEST
> > >  	---help---
> > >  	  This module adds support for integrated WCN3990 chip connected
> > >  	  to system NOC(SNOC). Currently work in progress and will not
> > 
> > Thanks Niklas for enabling COMPILE_TEST. With QMI set of
> > changes(https://patchwork.kernel.org/patch/10448183/), we need to enable
> > COMPILE_TEST for
> > QCOM_SCM/QMI_HELPERS which seems broken today. Are you planning to fix the
> > same.
> 
> 

This patch is good as is.

However, Govind's QMI patch set together with this patch
resulted in build errors.

FTR, these are fixed by:
https://marc.info/?l=linux-kernel&m=152880985402356
https://marc.info/?l=linux-kernel&m=152889452326350


Regards,
Niklas
