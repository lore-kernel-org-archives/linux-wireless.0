Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F5EC10F14
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 01:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D663C20883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 01:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfDIBho (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 21:37:44 -0400
Received: from 178.115.242.59.static.drei.at ([178.115.242.59]:35628 "EHLO
        mail.osadl.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfDIBhn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 21:37:43 -0400
Received: by mail.osadl.at (Postfix, from userid 1001)
        id 802B05C2174; Tue,  9 Apr 2019 03:36:56 +0200 (CEST)
Date:   Tue, 9 Apr 2019 03:36:56 +0200
From:   Nicholas Mc Guire <der.herr@hofr.at>
To:     Adham.Abozaeid@microchip.com
Cc:     hofrat@osadl.org, Ajay.Kathat@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] staging: wilc1000: give usleep_range a range
Message-ID: <20190409013656.GA22293@osadl.at>
References: <1554552067-15421-1-git-send-email-hofrat@osadl.org>
 <d38b17d8-5b0f-5b5e-2933-0626700e8546@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38b17d8-5b0f-5b5e-2933-0626700e8546@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 08, 2019 at 09:10:00PM +0000, Adham.Abozaeid@microchip.com wrote:
> Hi Nicholas
> 
> On 4/6/19 5:01 AM, Nicholas Mc Guire wrote:
> > External E-Mail
> >
> >
> > Someone that knows the motivation for setting the time to 2 millisecond
> > might need to check if the 2 milliseconds where seen as tollerable max or
> > min - I'm assuming it was the min so extending.
> 
> 2 msec is the time the chip takes to wake up from sleep.
> 
> Increasing the maximum to 5 msec will impact the throughput since this call is on the transmit path.
> 

ok - would it be tollerable to make it 2 - 2.5 ms ?
even that would allow for the hrtimer subsystem to optimize
a lot. In any case the min==max case gives you very little
if you run a test-case with usleep_range(1000,1000) and
a loop with usleep_range(1000,2000) and look at the distribution
you will have a hard time seeing any difference.

I doubt you would readily see the change from usleep_range(2000,2000)
to usleep_range(2000,3000) in benchmarks - maybe (2000,5000) would
be visible.

My assumption (I have not analyzed it in detail) is that if
you have a high re-use of existing timers that the setup of the timer
is faster and thats why increasing the range > 0 can actually result
in better jitter distribution.

thx!
hofrat

> > diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> > index c238969..42da533 100644
> > --- a/drivers/staging/wilc1000/wilc_wlan.c
> > +++ b/drivers/staging/wilc1000/wilc_wlan.c
> > @@ -408,7 +408,7 @@ void chip_wakeup(struct wilc *wilc)
> >  			wilc->hif_func->hif_write_reg(wilc, 1, reg & ~BIT(1));
> >  
> >  			do {
> > -				usleep_range(2 * 1000, 2 * 1000);
> > +				usleep_range(2 * 1000, 5 * 1000);
> >  				wilc_get_chipid(wilc, true);
> >  			} while (wilc_get_chipid(wilc, true) == 0);
> >  		} while (wilc_get_chipid(wilc, true) == 0);
> > @@ -423,7 +423,7 @@ void chip_wakeup(struct wilc *wilc)
> >  						     &clk_status_reg);
> >  
> >  			while ((clk_status_reg & 0x1) == 0) {
> > -				usleep_range(2 * 1000, 2 * 1000);
> > +				usleep_range(2 * 1000, 5 * 1000);
> >  
> >  				wilc->hif_func->hif_read_reg(wilc, 0xf1,
> >  							     &clk_status_reg);
> 
> 
> Thanks,
> 
> Adham
> 
