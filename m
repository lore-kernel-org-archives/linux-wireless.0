Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965145AbaFXQyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 12:54:21 -0400
Date: Tue, 24 Jun 2014 22:25:16 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] ath9k_hw: fix tx gain table index for AR953x
Message-ID: <20140624165514.GA13362@qca.qualcomm.com> (sfid-20140624_185437_015560_84123641)
References: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1403609869-12901-4-git-send-email-rmanohar@qti.qualcomm.com>
 <53A968C4.1020302@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <53A968C4.1020302@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 02:02:12PM +0200, Felix Fietkau wrote:
> On 2014-06-24 13:37, Rajkumar Manoharan wrote:
> > Fix tx gain table index on fast channel change for AR953x.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_phy.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > index 8927fc3..1ef17e1 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
> > @@ -1552,12 +1552,15 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
> >  				      u8 *ini_reloaded)
> >  {
> >  	unsigned int regWrites = 0;
> > -	u32 modesIndex;
> > +	u32 modesIndex, txgain_index = 0;
> >  
> > -	if (IS_CHAN_5GHZ(chan))
> > +	if (IS_CHAN_5GHZ(chan)) {
> >  		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
> > -	else
> > +	} else {
> > +		if (AR_SREV_9531(ah))
> > +			txgain_index = 1;
> >  		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
> > +	}
> 
> How about putting this here:
> 	if (AR_SREV_9531(ah))
> 		txgain_index = 1;
> 	else
> 		txgain_index = modesIndex;
> 
> >  
> >  	if (modesIndex == ah->modes_index) {
> >  		*ini_reloaded = false;
> > @@ -1573,7 +1576,10 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
> >  		ar9003_hw_prog_ini(ah, &ah->ini_radio_post_sys2ant,
> >  				   modesIndex);
> >  
> > -	REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
> > +	if (AR_SREV_9531(ah))
> > +		REG_WRITE_ARRAY(&ah->iniModesTxGain, txgain_index, regWrites);
> > +	else
> > +		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
> And then we can change this part to always use txgain_index instead of
> modesIndex, without the extra SREV check.
>
Completely agree. That looks neat. Let me upload v2 set.

-Rajkumar
