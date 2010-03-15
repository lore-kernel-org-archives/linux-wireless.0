Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58452 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab0COVfa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 17:35:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 14:35:30 -0700
Date: Mon, 15 Mar 2010 14:35:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v3 04/12] ath9k_hw: fix RF analog setup for AR9271
Message-ID: <20100315213528.GA4000@tux>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
 <1268459216-22372-5-git-send-email-lrodriguez@atheros.com>
 <20100313060516.GA6579@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100313060516.GA6579@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 12, 2010 at 10:05:16PM -0800, Luis Rodriguez wrote:
> On Fri, Mar 12, 2010 at 09:46:48PM -0800, Luis R. Rodriguez wrote:
> > From: Sujith <Sujith.Manoharan@atheros.com>
> > 
> > AR9271 is a single chip and as such does not have external radios.
> > Devices with external radio require additional programming, skip
> > this for AR9271 as we do for other single chips.
> > 
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.c  |    6 +++---
> >  drivers/net/wireless/ath/ath9k/phy.c |    6 +++---
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index b1a4a83..a0ef990 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -517,7 +517,7 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
> >  		  ah->eep_ops->get_eeprom_ver(ah),
> >  		  ah->eep_ops->get_eeprom_rev(ah));
> >  
> > -        if (!AR_SREV_9280_10_OR_LATER(ah)) {
> > +	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah)) {
> >  		ecode = ath9k_hw_rf_alloc_ext_banks(ah);
> >  		if (ecode) {
> >  			ath_print(ath9k_hw_common(ah), ATH_DBG_FATAL,
> > @@ -917,7 +917,7 @@ int ath9k_hw_init(struct ath_hw *ah)
> >  	ath9k_hw_init_cal_settings(ah);
> >  
> >  	ah->ani_function = ATH9K_ANI_ALL;
> > -	if (AR_SREV_9280_10_OR_LATER(ah)) {
> > +	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah)) {
> >  		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
> >  		ah->ath9k_hw_rf_set_freq = &ath9k_hw_ar9280_set_channel;
> >  		ah->ath9k_hw_spur_mitigate_freq = &ath9k_hw_9280_spur_mitigate;
> > @@ -1266,7 +1266,7 @@ void ath9k_hw_deinit(struct ath_hw *ah)
> >  	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
> >  
> >  free_hw:
> > -	if (!AR_SREV_9280_10_OR_LATER(ah))
> > +	if (!AR_SREV_9280_10_OR_LATER(ah) && !AR_SREV_9271(ah))
> >  		ath9k_hw_rf_free_ext_banks(ah);
> >  	kfree(ah);
> >  	ah = NULL;
> > diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
> > index c3b5939..b761330 100644
> > --- a/drivers/net/wireless/ath/ath9k/phy.c
> > +++ b/drivers/net/wireless/ath/ath9k/phy.c
> > @@ -839,7 +839,7 @@ int ath9k_hw_rf_alloc_ext_banks(struct ath_hw *ah)
> >  
> >  	struct ath_common *common = ath9k_hw_common(ah);
> >  
> > -	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
> > +	BUG_ON(AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah));
> >  
> >  	ATH_ALLOC_BANK(ah->analogBank0Data, ah->iniBank0.ia_rows);
> >  	ATH_ALLOC_BANK(ah->analogBank1Data, ah->iniBank1.ia_rows);
> > @@ -870,7 +870,7 @@ ath9k_hw_rf_free_ext_banks(struct ath_hw *ah)
> >  		bank = NULL; \
> >  	} while (0);
> >  
> > -	BUG_ON(AR_SREV_9280_10_OR_LATER(ah));
> > +	BUG_ON(AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah));
> >  
> >  	ATH_FREE_BANK(ah->analogBank0Data);
> >  	ATH_FREE_BANK(ah->analogBank1Data);
> > @@ -910,7 +910,7 @@ bool ath9k_hw_set_rf_regs(struct ath_hw *ah, struct ath9k_channel *chan,
> >  	 * for single chip devices, that is AR9280 or anything
> >  	 * after that.
> >  	 */
> > -	if (AR_SREV_9280_10_OR_LATER(ah))
> > +	if (AR_SREV_9280_10_OR_LATER(ah) || AR_SREV_9271(ah))
> >  		return true;
> >  
> >  	/* Setup rf parameters */
> > -- 
> 
> Hah actually now that I think about it, I bet the driver works just
> fine without this patch, its the same reason why AR_SREV_9280_10_OR_LATER(ah)
> adds AR9271...  please test without this patch. This should be one less
> code change.
> 
> When I reviewed the phy stuff last I meant to add an alias to
> AR_SREV_9280_10_OR_LATER() as "AR_SREV_SINGLE_CHIP(ah)" in hopes
> that it clarifies this code entry is usually meant for that,
> and then remove all the useless double checks spread all over
> the HAL.

Indeed, this is not needed.

  Luis
