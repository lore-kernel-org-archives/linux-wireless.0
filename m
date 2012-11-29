Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34549 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2K2Qxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 11:53:34 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so12384692iea.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2012 08:53:34 -0800 (PST)
Message-ID: <50B79309.4080600@lwfinger.net> (sfid-20121129_175338_594517_A8CD337A)
Date: Thu, 29 Nov 2012 10:53:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Stamer <daniel@stamer.info>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtlwifi: rtl8192se: Fixed coding style issues in the
 driver
References: <1354205366-22629-1-git-send-email-daniel@stamer.info>
In-Reply-To: <1354205366-22629-1-git-send-email-daniel@stamer.info>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 10:09 AM, Daniel Stamer wrote:
> This patch fixes almost all coding issues in the rtl8192se driver. Only
> exception is putting trailing */ on separate lines.
>
> Signed-off-by: Daniel Stamer <daniel@stamer.info>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192se/def.h |  3 +--
>   drivers/net/wireless/rtlwifi/rtl8192se/dm.c  | 20 ++++++++++----------
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  3 ++-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.h  |  2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |  9 +++------
>   5 files changed, 17 insertions(+), 20 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net> for V2

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> index 20afec6..2d255e0 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> @@ -522,8 +522,7 @@ enum fwcmd_iotype {
>   	FW_CMD_IQK_ENABLE = 30,
>   };
>
> -/*
> - * Driver info contain PHY status
> +/* Driver info contain PHY status
>    * and other variabel size info
>    * PHY Status content as below
>    */
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
> index bf79a52..e551fe5 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
> @@ -465,8 +465,8 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
>   				digtable->cur_igvalue =
>   						digtable->rx_gain_range_min;
>   			else
> -				digtable->cur_igvalue = digtable->rssi_val + 10 -
> -						digtable->back_val;
> +				digtable->cur_igvalue = digtable->rssi_val + 10
> +					- digtable->back_val;
>
>   			if (falsealm_cnt->cnt_all > 10000)
>   				digtable->cur_igvalue =
> @@ -518,7 +518,7 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
>   static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct dig_t *digtable = &rtlpriv->dm_digtable;
> +	struct dig_t *dig = &rtlpriv->dm_digtable;
>
>   	if (rtlpriv->mac80211.act_scanning)
>   		return;
> @@ -526,17 +526,17 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
>   	/* Decide the current status and if modify initial gain or not */
>   	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED ||
>   	    rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
> -		digtable->cur_sta_cstate = DIG_STA_CONNECT;
> +		dig->cur_sta_cstate = DIG_STA_CONNECT;
>   	else
> -		digtable->cur_sta_cstate = DIG_STA_DISCONNECT;
> +		dig->cur_sta_cstate = DIG_STA_DISCONNECT;
>
> -	digtable->rssi_val = rtlpriv->dm.undec_sm_pwdb;
> +	dig->rssi_val = rtlpriv->dm.undec_sm_pwdb;
>
>   	/* Change dig mode to rssi */
> -	if (digtable->cur_sta_cstate != DIG_STA_DISCONNECT) {
> -		if (digtable->dig_twoport_algorithm ==
> +	if (dig->cur_sta_cstate != DIG_STA_DISCONNECT) {
> +		if (dig->dig_twoport_algorithm ==
>   		    DIG_TWO_PORT_ALGO_FALSE_ALARM) {
> -			digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
> +			dig->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
>   			rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_MODE_SS);
>   		}
>   	}
> @@ -544,7 +544,7 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
>   	_rtl92s_dm_false_alarm_counter_statistics(hw);
>   	_rtl92s_dm_initial_gain_sta_beforeconnect(hw);
>
> -	digtable->pre_sta_cstate = digtable->cur_sta_cstate;
> +	dig->pre_sta_cstate = dig->cur_sta_cstate;
>   }
>
>   static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> index 1d72779..28526a7 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> @@ -1089,8 +1089,9 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
>   	return err;
>   }
>
> -void rtl92se_set_mac_addr(struct rtl_io *io, const u8 * addr)
> +void rtl92se_set_mac_addr(struct rtl_io *io, const u8 *addr)
>   {
> +	/* This is a stub. */
>   }
>
>   void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> index 1886c26..a8e068c 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> @@ -54,7 +54,7 @@ void rtl92se_disable_interrupt(struct ieee80211_hw *hw);
>   int rtl92se_set_network_type(struct ieee80211_hw *hw,
>   			     enum nl80211_iftype type);
>   void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
> -void rtl92se_set_mac_addr(struct rtl_io *io, const u8 * addr);
> +void rtl92se_set_mac_addr(struct rtl_io *io, const u8 *addr);
>   void rtl92se_set_qos(struct ieee80211_hw *hw, int aci);
>   void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw);
>   void rtl92se_set_beacon_interval(struct ieee80211_hw *hw);
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> index ad4b480..c725133 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> @@ -50,8 +50,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
>   	/*close ASPM for AMD defaultly */
>   	rtlpci->const_amdpci_aspm = 0;
>
> -	/*
> -	 * ASPM PS mode.
> +	/* ASPM PS mode.
>   	 * 0 - Disable ASPM,
>   	 * 1 - Enable ASPM without Clock Req,
>   	 * 2 - Enable ASPM with Clock Req,
> @@ -67,8 +66,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
>   	/*Setting for PCI-E bridge */
>   	rtlpci->const_hostpci_aspm_setting = 0x02;
>
> -	/*
> -	 * In Hw/Sw Radio Off situation.
> +	/* In Hw/Sw Radio Off situation.
>   	 * 0 - Default,
>   	 * 1 - From ASPM setting without low Mac Pwr,
>   	 * 2 - From ASPM setting with low Mac Pwr,
> @@ -77,8 +75,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
>   	 */
>   	rtlpci->const_hwsw_rfoff_d3 = 2;
>
> -	/*
> -	 * This setting works for those device with
> +	/* This setting works for those device with
>   	 * backdoor ASPM setting such as EPHY setting.
>   	 * 0 - Not support ASPM,
>   	 * 1 - Support ASPM,
>

