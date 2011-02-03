Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab1BCKa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 05:30:28 -0500
Date: Thu, 3 Feb 2011 11:29:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	"'Zhaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 2/8] rtl8192cu: Add new driver code - Part 1
Message-ID: <20110203102905.GC3516@redhat.com>
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
 <1296411100-5675-3-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296411100-5675-3-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 12:11:34PM -0600, Larry.Finger@lwfinger.net wrote:
> +#define	C2H_RX_CMD_HDR_LEN				8
> +#define	GET_C2H_CMD_CMD_LEN(__prxhdr)			\
> +	LE_BITS_TO_4BYTE((__prxhdr), 0, 16)

This is not part of the patch, butall this LE_BITS_TO_4BYTE stuff
need to be rewritten. IIRC all related code from wifi.h can be replaced
by:

#define LE_BITS_TO_4BYTE(hdr, off, bits) (le32_to_cpu(hdr) >> off) & ((1 << bits) - 1)
#define LE_BITS_TO_2BYTE(hdr, off, bits) (le14_to_cpu(hdr) >> off) & ((1 << bits) - 1)
#define LE_BITS_TO_1BYTE(hdr, off, bits) (hdr >> off) & ((1 << bits) - 1)

Also name LE_BITS_TO_4BYTE to should be something different like
GET_LE32_FILED or similar.

> +#define IS_NORMAL_CHIP(version)		\
> +	(((version) & NORMAL_CHIP) ? true : false)
Other chips are abnormal :-)

> +#define IS_8723_SERIES(version)		\
> +	(((version) & CHIP_8723) ? true : false)
Not needed "cond ? true : false", only cond should be enough

> +struct phy_sts_cck_8192s_t {
> +	u8 adc_pwdb_X[4];
> +	u8 sq_rpt;
> +	u8 cck_agc_rpt;
> +};
Maybe this should be shared in with PCIe?

> +struct h2c_cmd_8192c {
> +	u8 element_id;
> +	u32 cmd_len;
> +	u8 *p_cmdbuffer;
> +};
Not used.

> +static inline u8 _rtl92c_get_chnl_group(u8 chnl)
> +{
> +	u8 group = 0;
Not needed initialization.

> +
> +	if (chnl < 3)
> +		group = 0;
> +	else if (chnl < 9)
> +		group = 1;
> +	else
> +		group = 2;
> +
> +	return group;
> +}
[snip]

> +/* NOTE: reference to rtl8192c_rates struct */
> +static inline int _rtl92c_rate_mapping(struct ieee80211_hw *hw, bool isHT,
> +				       u8 desc_rate, bool first_ampdu)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	int rate_idx = 0;
Here as well.

> +	if (first_ampdu) {
> +		if (false == isHT) {
> +			switch (desc_rate) {
> +			case DESC92C_RATE1M:
> +				rate_idx = 0;
> +				break;
> +			case DESC92C_RATE2M:
> +				rate_idx = 1;
> +				break;
> +			case DESC92C_RATE5_5M:
> +				rate_idx = 2;
> +				break;
> +			case DESC92C_RATE11M:
> +				rate_idx = 3;
> +				break;
> +			case DESC92C_RATE6M:
> +				rate_idx = 4;
> +				break;
> +			case DESC92C_RATE9M:
> +				rate_idx = 5;
> +				break;
> +			case DESC92C_RATE12M:
> +				rate_idx = 6;
> +				break;
> +			case DESC92C_RATE18M:
> +				rate_idx = 7;
> +				break;
> +			case DESC92C_RATE24M:
> +				rate_idx = 8;
> +				break;
> +			case DESC92C_RATE36M:
> +				rate_idx = 9;
> +				break;
> +			case DESC92C_RATE48M:
> +				rate_idx = 10;
> +				break;
> +			case DESC92C_RATE54M:
> +				rate_idx = 11;
> +				break;
> +			default:
> +				RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
> +					 ("Rate %d is not support, set to "
> +					"1M rate.\n", desc_rate));
> +				rate_idx = 0;
> +				break;
> +			}
> +		} else {
> +			rate_idx = 11;
> +		}
> +		return rate_idx;
> +	}
> +	switch (desc_rate) {
> +	case DESC92C_RATE1M:
> +		rate_idx = 0;
> +		break;
> +	case DESC92C_RATE2M:
> +		rate_idx = 1;
> +		break;
> +	case DESC92C_RATE5_5M:
> +		rate_idx = 2;
> +		break;
> +	case DESC92C_RATE11M:
> +		rate_idx = 3;
> +		break;
> +	case DESC92C_RATE6M:
> +		rate_idx = 4;
> +		break;
> +	case DESC92C_RATE9M:
> +		rate_idx = 5;
> +		break;
> +	case DESC92C_RATE12M:
> +		rate_idx = 6;
> +		break;
> +	case DESC92C_RATE18M:
> +		rate_idx = 7;
> +		break;
> +	case DESC92C_RATE24M:
> +		rate_idx = 8;
> +		break;
> +	case DESC92C_RATE36M:
> +		rate_idx = 9;
> +		break;
> +	case DESC92C_RATE48M:
> +		rate_idx = 10;
> +		break;
> +	case DESC92C_RATE54M:
> +		rate_idx = 11;
> +		break;
> +	/* TODO: How to mapping MCS rate? */
> +	/*  NOTE: referenc to __ieee80211_rx */
> +	default:
> +		rate_idx = 11;
> +		break;
> +	}
> +	return rate_idx;
> +}

Looks all that function can be written as:

if (desc_rate <= DESC92C_RATE54M)
	return desc_rate
else
	return 11;

Or even simpler, if we can trust desc_rate

	return desc_rate;

> +static struct ps_t 
Don't name structs like that.

> +static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	u8 value_igi = dm_digtable.cur_igvalue;
> +
> +	if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH0)
> +		value_igi--;
> +	else if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH1)
> +		value_igi += 0;
Heh, perhaps /* no change */ comment would be better?

> +
> +static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
> +{
> +	static u8 binitialized; /*  = false; */
It's u8, not bool.

> +static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
> +
> +	if (dm_digtable.cursta_connectctate == DIG_STA_CONNECT) {
> +		dm_digtable.rssi_val_min = rtl92c_dm_initial_gain_min_pwdb(hw);
> +
> +		if (dm_digtable.pre_cck_pd_state == CCK_PD_STAGE_LowRssi) {
> +			if (dm_digtable.rssi_val_min <= 25)
> +				dm_digtable.cur_cck_pd_state =
> +				    CCK_PD_STAGE_LowRssi;
> +			else
> +				dm_digtable.cur_cck_pd_state =
> +				    CCK_PD_STAGE_HighRssi;
> +		} else {
> +			if (dm_digtable.rssi_val_min <= 20)
> +				dm_digtable.cur_cck_pd_state =
> +				    CCK_PD_STAGE_LowRssi;
> +			else
> +				dm_digtable.cur_cck_pd_state =
> +				    CCK_PD_STAGE_HighRssi;
> +		}
> +	} else {
> +		dm_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
> +	}
All looks pretty the same as dm.c from pcie driver, this evidently 
should be merged, only bt coexistent code should stay in pcie.

> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	u8	index;
> +	u32	power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
[snip]
> +static void _rtl92c_dm_restore_power_index(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	u8	index;
> +	u32	power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
[snip]
> +static void _rtl92c_dm_write_power_index(struct ieee80211_hw *hw, u8 value)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	u8	index;
> +	u32 power_index_reg[6] = {0xc90, 0xc91, 0xc92, 0xc98, 0xc99, 0xc9a};
Don't duplicate power_index_reg, make it static file variable.

> +static void rtl92c_dm_pwdb_monitor(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	long tmpentry_max_pwdb = 0, tmpentry_min_pwdb = 0xff;
Swapped min and max ?

> +
> +	u8 h2c_parameter[3] = { 0 };
Such _array_ initializations are dangerous.

> +
> +	if (tmpentry_max_pwdb != 0) {
> +		rtlpriv->dm.entry_max_undecoratedsmoothed_pwdb =
> +		    tmpentry_max_pwdb;
> +	} else {
> +		rtlpriv->dm.entry_max_undecoratedsmoothed_pwdb = 0;
> +	}
> +
> +	if (tmpentry_min_pwdb != 0xff) {
> +		rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb =
> +		    tmpentry_min_pwdb;
> +	} else {
> +		rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb = 0;
> +	}
> +	h2c_parameter[2] = (u8) (rtlpriv->dm.undecorated_smoothed_pwdb & 0xFF);
> +	h2c_parameter[0] = 0;
missed h2c_parameter[1] ?

> +void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw)
Beside what dm mean? It's not Device Mapper, is it ? :-)

> +		if (rtlpriv->dm.bcurrent_turbo_edca) {
> +			u8 tmp = AC0_BE;
> +			rtlpriv->cfg->ops->set_hw_reg(hw,
> +						      HW_VAR_AC_PARAM,
> +						      (u8 *) (&tmp));
Since tmp is u8 we don't need a cast, this need to be cleaned up
all over the driver.

> +				if (memcmp((void *)&temp_cck,
> +					   (void *)&cckswing_table_ch14[i][2],
> +					   4) == 0) {
> +					cck_index_old = (u8) i;
> +					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
> +						 DBG_LOUD,
> +						 ("Initial reg0x%x = 0x%lx, "
> +						  "cck_index=0x%x, ch 14 %d\n",
> +						  RCCK0_TXFILTER2, temp_cck,
> +						  cck_index_old,
> +						  rtlpriv->dm.b_cck_inch14));
> +					break;
> +				}
> +			} else {
> +				if (memcmp((void *)&temp_cck,
> +					   (void *)
> +					   &cckswing_table_ch1ch13[i][2],
> +					   4) == 0) {
Please, please. Don't do things like that. 80 characters line limit is for
making code more readable not less. If you have to break lines too many
times, that pretty much means you need to create separate function.

Even leaving line more than 80 character would  be better and easiest
to understand. Beside (void *) casts seems to be unneeded.

> +				if ((val_x & 0x00000200) != 0)
> +					val_x = val_x | 0xFFFFFC00;
> +				ele_a = ((val_x * ele_d) >> 8) & 0x000003FF;
> +				if ((val_y & 0x00000200) != 0)
!= not needed.

> +			}
> +			if (!rtlpriv->dm.b_cck_inch14) {
> +				rtl_write_byte(rtlpriv, 0xa22,
> +					       cckswing_table_ch1ch13[cck_index]
> +					       [0]);
> +				rtl_write_byte(rtlpriv, 0xa23,
> +					       cckswing_table_ch1ch13[cck_index]
> +					       [1]);
> +				rtl_write_byte(rtlpriv, 0xa24,
> +					       cckswing_table_ch1ch13[cck_index]
> +					       [2]);
Again, breaking lines like this  

				cckswing_table_ch1ch13[cck_index]
				[2]);

does not help to understand the code.
