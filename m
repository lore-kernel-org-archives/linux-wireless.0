Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44056 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1DFNUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 09:20:33 -0400
Message-ID: <4D9C689B.2020607@openwrt.org>
Date: Wed, 06 Apr 2011 15:20:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k_hw: Fix instable target power control b/w CCK/OFDM
References: <1302092092-11896-1-git-send-email-rmanoharan@atheros.com> <4D9C5EE1.3070105@openwrt.org> <20110406131128.GA2795@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110406131128.GA2795@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-06 3:11 PM, Rajkumar Manoharan wrote:
> On Wed, Apr 06, 2011 at 06:08:57PM +0530, Felix Fietkau wrote:
>>  On 2011-04-06 2:14 PM, Rajkumar Manoharan wrote:
>>  >  The problem is that when the attenuation is increased,
>>  >  the rate will start to drop from MCS7 ->   MCS6, and finally
>>  >  will see MCS1 ->   CCK_11Mbps. When the rate is changed b/w
>>  >  CCK and OFDM, it will use register desired_scale to calculate
>>  >  how much tx gain need to change.
>>  >
>>  >  The output power with the same tx gain for CCK and OFDM modulated
>>  >  signals are different. This difference is constant for AR9280
>>  >  but not AR9285/AR9271. It has different PA architecture
>>  >  a constant. So it should be calibrated against this PA
>>  >  characteristic.
>>  >
>>  >  The driver has to read the calibrated values from EEPROM and set
>>  >  the tx power registers accordingly.
>>  >
>>  >  Signed-off-by: Rajkumar Manoharan<rmanoharan@atheros.com>
>>  >  ---
>>  >  v2 : removed magic macro and a for loop
>>  >
>>  >    drivers/net/wireless/ath/ath9k/ar9002_phy.h |    6 +++++
>>  >    drivers/net/wireless/ath/ath9k/eeprom.h     |    6 ++++-
>>  >    drivers/net/wireless/ath/ath9k/eeprom_4k.c  |   33 +++++++++++++++++++++++++++
>>  >    3 files changed, 44 insertions(+), 1 deletions(-)
>>  >
>>  >  diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  >  index bc77a30..28851b5 100644
>>  >  --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  >  +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  >  @@ -781,6 +781,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
>>  >    {
>>  >    	struct modal_eep_4k_header *pModal;
>>  >    	struct ar5416_eeprom_4k *eep =&ah->eeprom.map4k;
>>  >  +	struct base_eep_header_4k *pBase =&eep->baseEepHeader;
>>  >    	u8 txRxAttenLocal;
>>  >    	u8 ob[5], db1[5], db2[5];
>>  >    	u8 ant_div_control1, ant_div_control2;
>>  >  @@ -1003,6 +1004,38 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
>>  >    				AR_PHY_SETTLING_SWITCH,
>>  >    				pModal->swSettleHt40);
>>  >    	}
>>  >  +	if (AR_SREV_9271(ah) || AR_SREV_9285(ah)) {
>>  >  +		u8 bb_desired_scale = (pModal->bb_scale_smrt_antenna&
>>  >  +				EEP_4K_BB_DESIRED_SCALE_MASK);
>>  >  +		if ((pBase->txGainType == 0)&&   (bb_desired_scale != 0)) {
>>  >  +			u32 pwrctrl, mask;
>>  >  +
>>  >  +			/* AR_PHY_TX_PWRCTRL8 */
>>  >  +			mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
>>  >  +			pwrctrl = mask * bb_desired_scale;
>>  >  +			REG_RMW(ah, AR_PHY_TX_PWRCTRL8, pwrctrl, 0x3fffffff);
>>  >  +
>>  >  +			/* AR_PHY_TX_PWRCTRL9 */
>>  >  +			mask = BIT(0)|BIT(5)|BIT(15);
>>  >  +			pwrctrl = mask * bb_desired_scale;
>>  >  +			REG_RMW(ah, AR_PHY_TX_PWRCTRL9, pwrctrl, 0xf83ff);
>>  >  +
>>  >  +			/* AR_PHY_TX_PWRCTRL10 */
>>  >  +			mask = BIT(0)|BIT(5)|BIT(10)|BIT(15)|BIT(20)|BIT(25);
>>  >  +			pwrctrl = mask * bb_desired_scale;
>>  >  +			REG_RMW(ah, AR_PHY_TX_PWRCTRL10, pwrctrl, 0x3fffffff);
>>  >  +
>>  The remaining ones below do not look correct to me - you're masking with
>>  0x3ff but setting the bits for 0x3fffffff. This does not match what the
>>  previous version of your patch did.
> mask           clr
> 0xc0000000 ->  0x3fffffff
> 0xfffffc00 ->  0x3ff
Yes, i meant clearing the bits in the register. Point still stands, 
though: Of the last three, two are using the wrong value for pwrctl.

That's why I suggested grouping the REG_RMW lines to simplify this (and 
also setting the _clr argument based on the field mask instead of 
hardcoding it in hex).

- Felix
