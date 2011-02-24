Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab1BXT6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 14:58:24 -0500
Received: by fxm17 with SMTP id 17so922846fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2011 11:58:23 -0800 (PST)
Message-ID: <4D66B81E.8070009@lwfinger.net>
Date: Thu, 24 Feb 2011 13:57:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] rtl8192c: fix compilation errors
References: <1298576230.4251.5.camel@jlt3.sipsolutions.net> <1298576345.4251.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1298576345.4251.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2011 01:39 PM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> On my G5 this fails to compile with
>
> drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
> drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__rtl92c_phy_txpwr_idx_to_dbm causes a section type conflict
> drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict
> drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__rtl92c_phy_dbm_to_txpwr_Idx causes a section type conflict
>
> since you can't export static functions.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---

ACK.

Your V2 is better than the one I submitted last night as I missed the change in 
the header file.

Why does the PowerPC compiler flag this when the X86_64 one does not?

Larry

>   drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |   12 ++++++------
>   drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |   12 ++++++------
>   2 files changed, 12 insertions(+), 12 deletions(-)
>
> --- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c	2011-02-24 20:35:47.398280074 +0100
> +++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c	2011-02-24 20:35:58.536168754 +0100
> @@ -644,9 +644,9 @@ void rtl92c_phy_set_beacon_hw_reg(struct
>   }
>   EXPORT_SYMBOL(rtl92c_phy_set_beacon_hw_reg);
>
> -static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
> -				       enum wireless_mode wirelessmode,
> -				       long power_indbm)
> +u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
> +				enum wireless_mode wirelessmode,
> +				long power_indbm)
>   {
>   	u8 txpwridx;
>   	long offset;
> @@ -676,9 +676,9 @@ static u8 _rtl92c_phy_dbm_to_txpwr_Idx(s
>   }
>   EXPORT_SYMBOL(_rtl92c_phy_dbm_to_txpwr_Idx);
>
> -static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
> -					 enum wireless_mode wirelessmode,
> -					 u8 txpwridx)
> +long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
> +				  enum wireless_mode wirelessmode,
> +				  u8 txpwridx)
>   {
>   	long offset;
>   	long pwrout_dbm;
> --- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h	2011-02-24 20:37:58.401971070 +0100
> +++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h	2011-02-24 20:38:15.513800156 +0100
> @@ -228,12 +228,12 @@ void rtl92ce_phy_set_rf_on(struct ieee80
>   void rtl92c_phy_set_io(struct ieee80211_hw *hw);
>   void rtl92c_bb_block_on(struct ieee80211_hw *hw);
>   u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
> -static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
> -					 enum wireless_mode wirelessmode,
> -					 u8 txpwridx);
> -static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
> -				       enum wireless_mode wirelessmode,
> -				       long power_indbm);
> +long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
> +				  enum wireless_mode wirelessmode,
> +				  u8 txpwridx);
> +u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
> +				enum wireless_mode wirelessmode,
> +				long power_indbm);
>   void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
>   static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
>   					     u32 cmdtableidx, u32 cmdtablesz,
>
>
>

