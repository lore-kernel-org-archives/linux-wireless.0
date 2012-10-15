Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4096 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2JOJkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:40:09 -0400
Date: Mon, 15 Oct 2012 15:04:49 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/12] ath9k_hw: program radio_post_sys2ant initval for
 AR9565
Message-ID: <20121015093447.GB21551@hemis.qca.qualcomm.com> (sfid-20121015_114014_572895_5A3C449E)
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1350287738-18687-8-git-send-email-rmanohar@qca.qualcomm.com>
 <20603.54708.380383.108551@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20603.54708.380383.108551@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 02:51:56PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > index 759f5f5..1d6d6ce 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > @@ -749,7 +749,8 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
> >  		ar9003_hw_prog_ini(ah, &ah->iniMac[i], modesIndex);
> >  		ar9003_hw_prog_ini(ah, &ah->iniBB[i], modesIndex);
> >  		ar9003_hw_prog_ini(ah, &ah->iniRadio[i], modesIndex);
> > -		if (i == ATH_INI_POST && AR_SREV_9462_20(ah))
> > +		if (i == ATH_INI_POST &&
> > +		    (AR_SREV_9462_20(ah) || AR_SREV_9565(ah)))
> >  			ar9003_hw_prog_ini(ah,
> >  					   &ah->ini_radio_post_sys2ant,
> >  					   modesIndex);
> > @@ -1424,7 +1425,7 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
> >  	ar9003_hw_prog_ini(ah, &ah->iniBB[ATH_INI_POST], modesIndex);
> >  	ar9003_hw_prog_ini(ah, &ah->iniRadio[ATH_INI_POST], modesIndex);
> >  
> > -	if (AR_SREV_9462_20(ah))
> > +	if (AR_SREV_9462_20(ah) || AR_SREV_9565(ah))
> >  		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
> >  				   modesIndex);
> 
> ah->ini_radio_post_sys2ant() is not initialized for AR9565...
>
Nice. Will drop this in v2.

-Rajkumar
