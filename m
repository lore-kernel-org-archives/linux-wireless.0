Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43910 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbeFNSmx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 14:42:53 -0400
Received: by mail-lf0-f66.google.com with SMTP id n15-v6so10934383lfn.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2018 11:42:52 -0700 (PDT)
Date: Thu, 14 Jun 2018 20:42:49 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Govind Singh <govinds@codeaurora.org>, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: FW: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
Message-ID: <20180614184249.GA31553@centauri.lan> (sfid-20180614_204309_899308_F881F6BC)
References: <20180612113907.15043-1-niklas.cassel@linaro.org>
 <20180612113907.15043-2-niklas.cassel@linaro.org>
 <7058492257914633b55fcd423e4c0b59@aphydexm01b.ap.qualcomm.com>
 <47cf8ec1b11d727ea928a307a431d4a2@codeaurora.org>
 <20180612124403.GA26986@centauri.lan>
 <20180613132819.GA12603@centauri.ideon.se>
 <878t7ha29r.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878t7ha29r.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 14, 2018 at 05:09:04PM +0300, Kalle Valo wrote:
> Niklas Cassel <niklas.cassel@linaro.org> writes:
> 
> > On Tue, Jun 12, 2018 at 02:44:03PM +0200, Niklas Cassel wrote:
> >> On Tue, Jun 12, 2018 at 06:02:48PM +0530, Govind Singh wrote:
> >> > On 2018-06-12 17:45, Govind Singh wrote:
> >> > > 
> >> > > ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.
> >> > > 
> >> > > Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> >> > > ---
> >> > >  drivers/net/wireless/ath/ath10k/Kconfig | 3 ++-
> >> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> > > 
> >> > > diff --git a/drivers/net/wireless/ath/ath10k/Kconfig
> >> > > b/drivers/net/wireless/ath/ath10k/Kconfig
> >> > > index 54ff5930126c..6572a43590a8 100644
> >> > > --- a/drivers/net/wireless/ath/ath10k/Kconfig
> >> > > +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> >> > > @@ -42,7 +42,8 @@ config ATH10K_USB
> >> > > 
> >> > >  config ATH10K_SNOC
> >> > >  	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
> >> > > -	depends on ATH10K && ARCH_QCOM
> >> > > +	depends on ATH10K
> >> > > +	depends on ARCH_QCOM || COMPILE_TEST
> >> > >  	---help---
> >> > >  	  This module adds support for integrated WCN3990 chip connected
> >> > >  	  to system NOC(SNOC). Currently work in progress and will not
> >> > 
> >> > Thanks Niklas for enabling COMPILE_TEST. With QMI set of
> >> > changes(https://patchwork.kernel.org/patch/10448183/), we need to enable
> >> > COMPILE_TEST for
> >> > QCOM_SCM/QMI_HELPERS which seems broken today. Are you planning to fix the
> >> > same.
> >
> > This patch is good as is.
> >
> > However, Govind's QMI patch set together with this patch
> > resulted in build errors.
> >
> > FTR, these are fixed by:
> > https://marc.info/?l=linux-kernel&m=152880985402356
> > https://marc.info/?l=linux-kernel&m=152889452326350
> 
> So the problem is that if I apply this patch I can't apply Govind's QMI
> patchset (due to the build problems) until Niklas' fixes to qcom and
> rpmsg subsystems propogate back to my tree and that might take weeks, or
> even months. But I really would like to apply the QMI patchset ASAP so
> that we can complete the wcn3990 support and not unnecessarily delay it.
> 
> So what I propose is that I put this patch 2 as 'Awaiting Upstream' in
> patchwork and apply it once Niklas' patches get to my tree. Does that
> sound good?

Absolutely.

I didn't realize this until after sending the patch.


Kind regards,
Niklas
