Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:43322 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbbAWM1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 07:27:08 -0500
Date: Fri, 23 Jan 2015 13:27:05 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: p54: add handling of the signal case
Message-ID: <20150123122705.GA26214@opentech.at> (sfid-20150123_132711_699317_58D4BBA0)
References: <1421731543-13290-1-git-send-email-der.herr@hofr.at> <12702639.FEnIjGW6UW@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <12702639.FEnIjGW6UW@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Jan 2015, Christian Lamparter wrote:

> On Tuesday, January 20, 2015 06:25:43 AM Nicholas Mc Guire wrote:
> > if(!wait_for_completion_interruptible_timeout(...))
> > only handles the timeout case - this patch adds handling the
> > signal case the same as timeout.
> > 
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> 
> > diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
> > index bc065e8..5367d51 100644
> > --- a/drivers/net/wireless/p54/fwio.c
> > +++ b/drivers/net/wireless/p54/fwio.c
> > @@ -249,9 +250,11 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
> >  
> >  	p54_tx(priv, skb);
> >  
> > -	if (!wait_for_completion_interruptible_timeout(
> > -	     &priv->eeprom_comp, HZ)) {
> > -		wiphy_err(priv->hw->wiphy, "device does not respond!\n");
> > +	timeout = wait_for_completion_interruptible_timeout(
> > +			&priv->eeprom_comp, HZ);
> > +	if (timeout <= 0) {
> > +		wiphy_err(priv->hw->wiphy,
> > +			"device does not respond or signal received!\n");
> >  		ret = -EBUSY;
> >  	}
> >  	priv->eeprom = NULL;
> > 
> 
> CHECK: Alignment should match open parenthesis
> #98: FILE: drivers/net/wireless/p54/fwio.c:257:
> +               wiphy_err(priv->hw->wiphy,
> +                       "device does not respond or signal received!\n");
> 
> total: 0 errors, 0 warnings, 1 checks, 21 lines checked
> 

Tried fixing this up - but simply no clue what coding style
rule that might have violated - and my attempts to fix this
did not succeed - allignment seems righta - the complete siequence is:

        timeout = wait_for_completion_interruptible_timeout(
                        &priv->eeprom_comp, HZ);
        if (timeout <= 0) {
                wiphy_err(priv->hw->wiphy,
                        "device does not respond or signal received!\n");
                ret = -EBUSY;
        }

what am I overlooking ?

thx!
hofrat
