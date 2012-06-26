Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28729 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2FZEzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 00:55:38 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Message-ID: <4FE940C2.7030009@qca.qualcomm.com> (sfid-20120626_065543_068643_99C7FE02)
Date: Tue, 26 Jun 2012 10:25:30 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: Re: [PATCH v3 07/10] ath9k_hw: Add hardware code for WoW
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>	<1340633579-7514-8-git-send-email-mohammed@qca.qualcomm.com> <20456.45480.605936.5196@gargle.gargle.HOWL>
In-Reply-To: <20456.45480.605936.5196@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Tuesday 26 June 2012 12:14 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> +static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
>> +{
>> +	struct ath_common *common = ath9k_hw_common(ah);
>> +
>> +	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
>> +
>> +	/* set rx disable bit */
>> +	REG_WRITE(ah, AR_CR, AR_CR_RXD);
>> +
>> +	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0, AH_WAIT_TIMEOUT)) {
>> +		ath_err(common, "Failed to stop Rx DMA in 10ms AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
>> +			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
>> +		return;
>> +	} else {
>> +		if (!AR_SREV_9300_20_OR_LATER(ah))
>> +			REG_WRITE(ah, AR_RXDP, 0x0);
>> +	}
>> +
>> +	/* AR9280 WoW has sleep issue, do not set it to sleep */
>> +	if (AR_SREV_9280_20(ah))
>> +		return;
>> +
>> +	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_ON_INT);
>> +}
>
> This function needs proper error handling.

not sure, this seem to be ok while I was reviewing. thanks will check it 
out.


>
>> +#define KAL_FRAME_LEN		28
>> +#define KAL_FRAME_TYPE		0x2 /* data frame */
>> +#define KAL_FRAME_SUB_TYPE	0x4 /* null data frame */
>> +#define KAL_DURATION_ID		0x3d
>> +#define KAL_NUM_DATA_WORDS	6
>> +#define KAL_NUM_DESC_WORDS	12
>
> Move these to a header file ?

thought this was going to be used to the below function alone, will 
check it out. thanks.

>
>> +static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
>> +{
>> +	struct ath_common *common = ath9k_hw_common(ah);
>> +	u32 frame_len = KAL_FRAME_LEN;
>> +	u32 tpc = MAX_RATE_POWER;
>> +	u32 antenna_mode = 1;
>> +	u32 transmit_rate;
>> +	u32 frame_type = KAL_FRAME_TYPE; /* frame type ->  data */
>> +	u32 sub_type = KAL_FRAME_SUB_TYPE; /* subtype ->  NULL data */
>> +	u32 to_ds = 1;
>> +	u32 duration_id = KAL_DURATION_ID;
>> +	u8 sta_mac_addr[ETH_ALEN], ap_mac_addr[ETH_ALEN];
>> +	u32 ctl[13] = {0};
>> +	u32 data_word[KAL_NUM_DATA_WORDS];
>> +	u8 i;
>> +	u32 wow_ka_data_word0;
>
> Most of the variables can be replaced by direct usage of the macros.

thanks will check it out.

>
>> +	memcpy(sta_mac_addr, common->macaddr, ETH_ALEN);
>> +	memcpy(ap_mac_addr, common->curbssid, ETH_ALEN);
>
> These too, the variables from 'common' can be used directly.

ok. i thought it would be more readable by using the sta_mac_addr, 
ap_mac_addr, where these are used in data words, for constructing keep 
alive frames(source address, destination address).

>
>> +	if (ah->curchan->channelFlags&  CHANNEL_CCK)
>> +		transmit_rate = 0x1b; /* CCK_1M hardware value for this rate */
>> +	else
>> +		transmit_rate = 0xb; /* OFDM_6M hardware value for this rate */
>
> We don't use CHANNEL_CCK, so this can be trimmed and 'transmit_rate' removed.

ok will check this out.

>
>> +void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
>> +				u8 *user_mask, int pattern_count,
>> +				int pattern_len)
>> +{
>> +	int i;
>> +	u32 pattern_val, mask_val;
>> +	u32 set, clr;
>> +
>> +	/* FIXME: should check count by querying the hardware capability */
>> +	if (pattern_count>= MAX_NUM_PATTERN)
>> +		return;
>> +
>> +	REG_SET_BIT(ah, AR_WOW_PATTERN, BIT(pattern_count));
>> +
>> +	/* set the registers for pattern */
>> +	for (i = 0; i<  MAX_PATTERN_SIZE; i += 4) {
>> +		memcpy(&pattern_val, user_pattern, 4);
>> +		REG_WRITE(ah, (AR_WOW_TB_PATTERN(pattern_count) + i),
>> +			  pattern_val);
>> +		user_pattern += 4;
>> +	}
>> +
>> +	/* set the registers for mask */
>> +	for (i = 0; i<  MAX_PATTERN_SIZE; i += 4) {
>> +		memcpy(&mask_val, user_mask, 4);
>> +		REG_WRITE(ah, (AR_WOW_TB_MASK(pattern_count) + i), mask_val);
>> +		user_mask += 4;
>> +	}
>
> Shouldn't this use MAX_PATTERN_MASK_SIZE ? Also, better error checking for this
> function.

thanks, i missed it. will change this.

>
>> +	set = AR_PMCTRL_WOW_PME_CLR;
>> +	clr = AR_PMCTRL_PWR_STATE_D1D3;
>> +	/* do we need to check the bit value 0x01000000 (7-10) ?? */
>> +	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
>> +
>> +	/*
>> +	 * clear all events
>> +	 */
>> +	REG_WRITE(ah, AR_WOW_PATTERN,
>> +		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN)));
>> +
>> +	/*
>> +	 * tie reset register for AR9002 family of chipsets
>> +	 * NB: not tieing it back might have some repurcussions.
>> +	 */
>> +
>> +	if (!AR_SREV_9300_20_OR_LATER(ah)) {
>> +		set = AR_WA_UNTIE_RESET_EN |
>> +		      AR_WA_POR_SHORT |
>> +		      AR_WA_RESET_EN;
>> +		REG_SET_BIT(ah, AR_WA, set);
>> +	}
>
> What's the point in the set/clr variables ?

this is being to done to use REG_RMW_* and REG_SET_BIT* with a quite
few of values being set or cleared. I would just see if i have a better 
option.

>
>> +	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
>
> This doesn't seem right, you are overwriting the value that is set when a
> station is associated.


thanks, i was thinking how can i bring in
  REG_RMW_FIELD(ah, AR_RSSI_THR,
                       AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
i believe we would do a re-connection and update the same value. will 
check it out. i think it would be 7 or 5.

>
>> +void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
>> +{
>> +	/*
>> +	 * set the power states appropriately and enable PME
>> +	 */
>> +	set = AR_PMCTRL_HOST_PME_EN | AR_PMCTRL_PWR_PM_CTRL_ENA |
>> +	      AR_PMCTRL_AUX_PWR_DET | AR_PMCTRL_WOW_PME_CLR;
>> +
>> +	/*
>> +	 * set and clear WOW_PME_CLEAR registers for the chip
>> +	 * to generate next wow signal.
>> +	 */
>> +	REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
>> +	clr = AR_PMCTRL_WOW_PME_CLR;
>> +	REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
>> +
>> +	/*
>> +	 * Setup for:
>> +	 *	- beacon misses
>> +	 *	- magic pattern
>> +	 *	- keep alive timeout
>> +	 *	- pattern matching
>> +	 */
>> +
>> +	/*
>> +	 * Program default values for pattern backoff, aifs/slot/KAL count,
>> +	 * beacon miss timeout, KAL timeout, etc.
>> +	 */
>> +
>> +	set = AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF);
>> +	REG_SET_BIT(ah, AR_WOW_PATTERN, set);
>> +
>> +	set = AR_WOW_AIFS_CNT(AR_WOW_CNT_AIFS_CNT) |
>> +	      AR_WOW_SLOT_CNT(AR_WOW_CNT_SLOT_CNT) |
>> +	      AR_WOW_KEEP_ALIVE_CNT(AR_WOW_CNT_KA_CNT);
>> +	REG_SET_BIT(ah, AR_WOW_COUNT, set);
>> +
>> +	if (pattern_enable&  AH_WOW_BEACON_MISS)
>> +		set = AR_WOW_BEACON_TIMO;
>> +	/* We are not using beacon miss, program a large value */
>> +	else
>> +		set = AR_WOW_BEACON_TIMO_MAX;
>> +
>> +	REG_WRITE(ah, AR_WOW_BCN_TIMO, set);
>> +
>> +	/*
>> +	 * Keep alive timo in ms except AR9280
>> +	 */
>> +	if (!pattern_enable || AR_SREV_9280(ah))
>> +		set = AR_WOW_KEEP_ALIVE_NEVER;
>> +	else
>> +		set = KAL_TIMEOUT * 32;
>> +
>> +	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO, set);
>> +
>> +	/*
>> +	 * Keep alive delay in us. based on 'power on clock',
>> +	 * therefore in usec
>> +	 */
>> +	set = KA_DELAY * 1000;
>> +	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_DELAY, set);
>> +
>> +	/*
>> +	 * Create keep alive pattern to respond to beacons
>> +	 */
>> +	ath9k_wow_create_keep_alive_pattern(ah);
>> +
>> +	/*
>> +	 * Configure MAC WoW Registers
>> +	 */
>> +
>> +	set = 0;
>> +	/* Send keep alive timeouts anyway */
>> +	clr = AR_WOW_KEEP_ALIVE_AUTO_DIS;
>> +
>> +	if (pattern_enable&  AH_WOW_LINK_CHANGE)
>> +		wow_event_mask |= AR_WOW_KEEP_ALIVE_FAIL;
>> +	else
>> +		set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
>> +
>> +	/*
>> +	 * FIXME: For now disable keep alive frame
>> +	 * failure. This seems to sometimes trigger
>> +	 * unnecessary wake up with AR9485 chipsets.
>> +	 */
>> +	set = AR_WOW_KEEP_ALIVE_FAIL_DIS;
>> +
>> +	REG_RMW(ah, AR_WOW_KEEP_ALIVE, set, clr);
>> +
>> +
>> +	/*
>> +	 * we are relying on a bmiss failure. ensure we have
>> +	 * enough threshold to prevent false positives
>> +	 */
>> +	REG_RMW_FIELD(ah, AR_RSSI_THR, AR_RSSI_THR_BM_THR,
>> +		      AR_WOW_BMISSTHRESHOLD);
>> +
>> +	set = 0;
>> +	clr = 0;
>> +
>> +	if (pattern_enable&  AH_WOW_BEACON_MISS) {
>> +		set = AR_WOW_BEACON_FAIL_EN;
>> +		wow_event_mask |= AR_WOW_BEACON_FAIL;
>> +	} else {
>> +		clr = AR_WOW_BEACON_FAIL_EN;
>> +	}
>> +
>> +	REG_RMW(ah, AR_WOW_BCN_EN, set, clr);
>> +
>> +	set = 0;
>> +	clr = 0;
>> +	/*
>> +	 * Enable the magic packet registers
>> +	 */
>> +	if (pattern_enable&  AH_WOW_MAGIC_PATTERN_EN) {
>> +		set = AR_WOW_MAGIC_EN;
>> +		wow_event_mask |= AR_WOW_MAGIC_PAT_FOUND;
>> +	} else {
>> +		clr = AR_WOW_MAGIC_EN;
>> +	}
>> +	set |= AR_WOW_MAC_INTR_EN;
>> +	REG_RMW(ah, AR_WOW_PATTERN, set, clr);
>> +
>> +	/*
>> +	 * For AR9285 and later version of chipsets
>> +	 * enable WoW pattern match for packets less
>> +	 * than 256 bytes for all patterns
>> +	 */
>> +	if (AR_SREV_9285_12_OR_LATER(ah))
>> +		REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B,
>> +			  AR_WOW_PATTERN_SUPPORTED);
>> +
>> +	/*
>> +	 * Set the power states appropriately and enable PME
>> +	 */
>> +	clr = 0;
>> +	set = AR_PMCTRL_PWR_STATE_D1D3 | AR_PMCTRL_HOST_PME_EN |
>> +	      AR_PMCTRL_PWR_PM_CTRL_ENA;
>> +	/*
>> +	 * This is needed for AR9300 chipsets to wake-up
>> +	 * the host.
>> +	 */
>> +	if (AR_SREV_9300_20_OR_LATER(ah))
>> +		clr = AR_PCIE_PM_CTRL_ENA;
>> +
>> +	REG_RMW(ah, AR_PCIE_PM_CTRL, set, clr);
>> +
>> +	if (AR_SREV_9462(ah)) {
>> +		/*
>> +		 * this is needed to prevent the chip waking up
>> +		 * the host within 3-4 seconds with certain
>> +		 * platform/BIOS. the fix it to enable
>> +		 * D1&  D3 to match original definition and
>> +		 * also match the OTP value. Anyway this
>> +		 * is more related to SW WOW.
>> +		 */
>> +		clr = AR_PMCTRL_PWR_STATE_D1D3;
>> +		REG_CLR_BIT(ah, AR_PCIE_PM_CTRL, clr);
>> +
>> +		set = AR_PMCTRL_PWR_STATE_D1D3_REAL;
>> +		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, set);
>> +	}
>> +
>> +
>> +
>> +	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PRESERVE_SEQNUM);
>> +
>> +	if (AR_SREV_9300_20_OR_LATER(ah)) {
>> +		/* to bring down WOW power low margin */
>> +		set = BIT(13);
>> +		REG_SET_BIT(ah, AR_PCIE_PHY_REG3, set);
>> +		/* HW WoW */
>> +		clr = BIT(5);
>> +		REG_CLR_BIT(ah, AR_PCU_MISC_MODE3, clr);
>> +	}
>> +
>> +	ath9k_hw_set_powermode_wow_sleep(ah);
>> +	ah->wow_event_mask = wow_event_mask;
>> +}
>> +EXPORT_SYMBOL(ath9k_hw_wow_enable);
>
> This function badly needs a cleanup. The set/clr variables are kinda ugly and
> the routine would become quite simpler if the various registers are programmed
> directly.

will check it out if it can be done better.


>
> Sujith


-- 
thanks,
shafi
