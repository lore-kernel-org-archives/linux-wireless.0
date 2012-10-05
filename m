Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32960 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab2JEPPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 11:15:10 -0400
Message-ID: <506EF975.7040909@openwrt.org> (sfid-20121005_171514_201091_566FE4C5)
Date: Fri, 05 Oct 2012 17:15:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <2475573.rN7d8lielt@bentobox> <506EDF89.5000805@openwrt.org> <1661867.OB0LbMnEW9@bentobox>
In-Reply-To: <1661867.OB0LbMnEW9@bentobox>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-05 5:03 PM, Sven Eckelmann wrote:
> On Friday 05 October 2012 15:24:25 Felix Fietkau wrote:
>> On 2012-10-05 3:07 PM, Sven Eckelmann wrote:
>> > On Friday 05 October 2012 14:34:28 Felix Fietkau wrote:
>> >> On 2012-10-05 1:08 PM, Sven Eckelmann wrote:
>> > [...]
>> > 
>> >> Please try this patch to see if it gets rid of these interrupts:
>> >> ---
>> >> --- a/drivers/net/wireless/ath/ath9k/ani.c
>> >> +++ b/drivers/net/wireless/ath/ath9k/ani.c
>> >> @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
>> >> 
>> >>  		if (IS_CHAN_2GHZ(chan)) {
>> >>  		
>> >>  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
>> >>  			
>> >>  					    ATH9K_ANI_FIRSTEP_LEVEL);
>> >> 
>> >> -			if (AR_SREV_9300_20_OR_LATER(ah))
>> >> +			if (AR_SREV_9300_20_OR_LATER(ah) &&
>> >> +			    ah->caps.rx_chainmask != 1)
>> >> 
>> >>  				ah->ani_function |= ATH9K_ANI_MRC_CCK;
>> >>  		
>> >>  		} else
>> >>  		
>> >>  			ah->ani_function = 0;
>> > 
>> > Looks partially good. At least this patch fixed parts my friday :D
>> > 
>> > I have more similar bugs, but at least this one is related to a bandwidth
>> > problem which I also wanted to check today. But it didn't fix _this_
>> > invalid register access on the client device (but I don't see it anymore
>> > on the AP device).
>> 
>> Are you sure that it's still the same register access on the client
>> side? I don't see how it could still access MRC related registers with
>> this part masked out.
> 
> Yes, I am sure. Let's read some code:
> 
> 	if (ah->opmode == NL80211_IFTYPE_AP) {
> 		if (IS_CHAN_2GHZ(chan)) {
> 			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
> 					    ATH9K_ANI_FIRSTEP_LEVEL);
> 			if (AR_SREV_9300_20_OR_LATER(ah) &&
> 			    ah->caps.rx_chainmask != 1)
> 				ah->ani_function |= ATH9K_ANI_MRC_CCK;
> 		} else
> 			ah->ani_function = 0;
> 	}
> 
> Now raise your hands when you see the "ah->opmode == NL80211_IFTYPE_AP". I've 
> just added following after this block
> 
> 	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
> 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
> 
> But maybe it is better to fix the test in __ath9k_hw_init
> 
> 	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
> 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
> 
> The problem in __ath9k_hw_init is the value of ah->caps.rx_chainmask ... which 
> is not yet initialized correctly (and therefore ends up as 0).
> 
> I've attached my "please don't enable MRC CCK" version of the patch. Feel free 
> to submit it because you've submitted the initial version... or other things 
> with it ;)
Thanks for testing, but for submitting I'd prefer something simple,
how about this:
---
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1035,6 +1035,10 @@ static bool ar9003_hw_ani_control(struct
 		 * is_on == 0 means MRC CCK is OFF (more noise imm)
 		 */
 		bool is_on = param ? 1 : 0;
+
+		if (ah->caps.rx_chainmask == 1)
+			break;
+
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_ENABLE, is_on);
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,

