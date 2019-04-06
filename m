Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03BDC282DA
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA5621855
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 09:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfDFJnV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 05:43:21 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:60729 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfDFJnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 05:43:21 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Apr 2019 05:43:19 EDT
Received: by mail.osadl.at (Postfix, from userid 1001)
        id 384AB5C36D6; Sat,  6 Apr 2019 11:35:34 +0200 (CEST)
Date:   Sat, 6 Apr 2019 11:35:34 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] staging: wilc1000: drop explicit conversion to bool
Message-ID: <20190406093534.GA3972@osadl.at>
References: <1554540030-12740-1-git-send-email-hofrat@osadl.org>
 <CAGRGNgUy1Gva7AcwkjoGP0KmJrduDQAk1aMWP0XC89HXz48hKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRGNgUy1Gva7AcwkjoGP0KmJrduDQAk1aMWP0XC89HXz48hKA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 06, 2019 at 08:11:55PM +1100, Julian Calaby wrote:
> Hi Nicholas,
> 
> On Sat, Apr 6, 2019 at 7:48 PM Nicholas Mc Guire <hofrat@osadl.org> wrote:
> >
> > As the expression evaluates to a boolean anyway (relational and logical
> > operators) conversion with the ternary operator is not needed here as
> > coccinelle notes (boolconv.cocci)
> >
> > Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> > ---
> >
> > V2: sent out the wrong version - the commit message was longer than 75
> >     chars - only change here is the commit message wrapping.
> >
> > scripts/coccinelle/misc/boolconv.cocci warned about:
> > drivers/staging/wilc1000/wilc_wlan.c:14:48-53: WARNING: conversion to bool not needed here
> >
> > Patch was compile tested with: x86_64_defconfig + Staging=y,
> > WILC1000_SDIO=m, WILC1000_SPI=m, WILC1000=m
> > (checkpatch, sparse and cocci clean otherwise)
> >
> > Patch is against 5.1-rc3 (localversion-next is -next-20190403)
> >
> >  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> > index c238969..6c9fd3a 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -11,7 +11,7 @@
> >
> >  static inline bool is_wilc1000(u32 id)
> >  {
> > -       return ((id & 0xfffff000) == 0x100000 ? true : false);
> > +       return ((id & 0xfffff000) == 0x100000);
> 
> Whilst you're here, you might as well remove the superfluous parentheses.
>

fine - there are a few other places though that this would need to be cleaned
up to be consistent e.g. entries = ((reg >> 3) & 0x3f); wilc_wlan.c
 
> Other than that,
> 
> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
> 

will resend with outer () dropped and Reviewed-by: added

thx!
hofrat

> Thanks,
> 
> -- 
> Julian Calaby
> 
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
