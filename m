Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38941 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753449Ab2ISDku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 23:40:50 -0400
Message-ID: <1348026049.11276.17.camel@joe2Laptop> (sfid-20120919_054053_845531_32947CD1)
Subject: Re: [PATCH NEXT V2 01/15] rtlwifi: rtl8723ae: Add new driver - Part
 1
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Date: Tue, 18 Sep 2012 20:40:49 -0700
In-Reply-To: <1348019243-18016-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1348019243-18016-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1348019243-18016-2-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-18 at 20:47 -0500, Larry Finger wrote:
> This patch is part 1 of the addition of files for a new driver to handle
> the Realtek RTL8723AE wireless device.
[]
> diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/def.h b/drivers/net/wireless/rtlwifi/rtl8723ae/def.h
[]
> +#define GET_CVID_MANUFACTUER(version)	((version) & MANUFACTUER_MASK)

spelling manufacturer (here and other uses)

> +#define GET_CVID_ROM_VERSION(version)	((version) & ROM_VERSION_MASK)
> +#define GET_CVID_CUT_VERSION(version)	((version) & CUT_VERSION_MASK)
> +
> +#define IS_81XXC(version)		((GET_CVID_IC_TYPE(version) == 0) ?\
> +					true : false)

Don't need ?:

> +#define IS_8723_SERIES(version)						\
> +		((GET_CVID_IC_TYPE(version) == CHIP_8723) ? true : false)

here too etc...

> diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c

[]

> +static u8 rtl8723ae_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
> +	long rssi_val_min = 0;
> +
> +	if ((dm_digtable->curmultista_connectstate == DIG_MULTISTA_CONNECT) &&
> +	    (dm_digtable->cursta_connectstate == DIG_STA_CONNECT)) {
> +		if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb != 0)
> +			rssi_val_min =
> +			    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb >

when variable names exceed a certain length, keeping things readable
within 80 columns becomes impossible.

> +			     rtlpriv->dm.undecorated_smoothed_pwdb) ?
> +			    rtlpriv->dm.undecorated_smoothed_pwdb :
> +			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;

	if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb != 0)
		rssi_val_min = min(rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb,
				   rtlpriv->dm.undecorated_smoothed_pwdb);

[]

> +static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
> +	u8 value_igi = dm_digtable->cur_igvalue;
> +
> +	if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH0)
> +		value_igi--;
> +	else if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH1)
> +		value_igi += 0;
> +	else if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH2)
> +		value_igi++;
> +	else if (rtlpriv->falsealm_cnt.cnt_all >= DM_DIG_FA_TH2)
> +		value_igi += 2;

A style error, just an else would be fine.

> +	if (value_igi > DM_DIG_FA_UPPER)
> +		value_igi = DM_DIG_FA_UPPER;
> +	else if (value_igi < DM_DIG_FA_LOWER)
> +		value_igi = DM_DIG_FA_LOWER;

clamp

I think this is pretty difficult code to read, so I stopped.

