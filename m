Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2JOJnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 05:43:20 -0400
Date: Mon, 15 Oct 2012 15:10:24 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/12] ath9k_hw: Configure new switch table for AR9565
 BTCOEX
Message-ID: <20121015094022.GC21551@hemis.qca.qualcomm.com> (sfid-20121015_114323_669934_51AC2027)
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1350287738-18687-10-git-send-email-rmanohar@qca.qualcomm.com>
 <20603.54988.583810.352301@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20603.54988.583810.352301@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 02:56:36PM +0530, Sujith Manoharan wrote:
> Rajkumar Manoharan wrote:
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > index f3784eb..8621e37 100644
> > --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
> > @@ -3601,7 +3601,7 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
> >  	 *   7:4 R/W  SWITCH_TABLE_COM_SPDT_WLAN_IDLE
> >  	 * SWITCH_TABLE_COM_SPDT_WLAN_IDLE
> >  	 */
> > -	if (AR_SREV_9462_20_OR_LATER(ah)) {
> > +	if (AR_SREV_9462_20_OR_LATER(ah) || AR_SREV_9565(ah)) {
> >  		value = ar9003_switch_com_spdt_get(ah, is2ghz);
> >  		REG_RMW_FIELD(ah, AR_PHY_GLB_CONTROL,
> >  				AR_SWITCH_TABLE_COM_SPDT_ALL, value);
> 
> A cleaner way would be to fix the AR_SREV_9462_20_OR_LATER macro to resemble
> all the other *_LATER macros (based on the macVersion).
>
I hate *_LATER macros. Its always confusing. Since SPDT is applicable only for
9462 & 9565, I remove the _LATER in v2.

-Rajkumar
