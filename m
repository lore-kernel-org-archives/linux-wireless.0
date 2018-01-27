Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:44535 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbeA0TWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 14:22:47 -0500
Received: by mail-oi0-f68.google.com with SMTP id j15so2435597oii.11
        for <linux-wireless@vger.kernel.org>; Sat, 27 Jan 2018 11:22:47 -0800 (PST)
Subject: Re: [PATCH 09/10] rtlwifi: btcoex: add routine to set default port id
To: pkshih@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
References: <20180126074645.27201-1-pkshih@realtek.com>
 <20180126074645.27201-10-pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <496ad7f6-3630-7ffe-2a1f-7e72ac23ffe6@lwfinger.net> (sfid-20180127_202304_915584_186914FC)
Date: Sat, 27 Jan 2018 13:22:45 -0600
MIME-Version: 1.0
In-Reply-To: <20180126074645.27201-10-pkshih@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 01:46 AM, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> Tell wifi and BT firmware the default port ID to set multiports' state
> properly, but only 8822be needs this function currently.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> ---

This patch results in the following compiler warnings:

   CC [M]  drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.o
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1052:13: warning: 
‘halbtc_set_default_port_id_cmd’ defined but not used [-Wunused-function]
  static void halbtc_set_default_port_id_cmd(void *bt_context)
              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1042:13: warning: 
‘halbtc_send_wifi_port_id_cmd’ defined but not used [-Wunused-function]
  static void halbtc_send_wifi_port_id_cmd(void *bt_context)
              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Something seems to be wrong. As these routines will likely be needed later, you 
need to remove the static notation and put their prototypes in a header to quiet 
Sparse.

Larry


>   .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 22 ++++++++++++++++++++++
>   drivers/net/wireless/realtek/rtlwifi/wifi.h        |  5 +++++
>   2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> index 1404729441a2..5e41b204f7c0 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
> @@ -1039,6 +1039,28 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
>   					cmd_len, cmd_buf);
>   }
>   
> +static void halbtc_send_wifi_port_id_cmd(void *bt_context)
> +{
> +	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	u8 cmd_buf[1] = {0};	/* port id [2:0] = 0 */
> +
> +	rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, H2C_BT_PORT_ID,
> +					1, cmd_buf);
> +}
> +
> +static void halbtc_set_default_port_id_cmd(void *bt_context)
> +{
> +	struct btc_coexist *btcoexist = (struct btc_coexist *)bt_context;
> +	struct rtl_priv *rtlpriv = btcoexist->adapter;
> +	struct ieee80211_hw *hw = rtlpriv->mac80211.hw;
> +
> +	if (!rtlpriv->cfg->ops->set_default_port_id_cmd)
> +		return;
> +
> +	rtlpriv->cfg->ops->set_default_port_id_cmd(hw);
> +}
> +
>   static
>   void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
>   {
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index 0e8aae0c05c1..1c9ed28b42da 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -153,6 +153,10 @@ enum rtl8192c_h2c_cmd {
>   	MAX_H2CCMD
>   };
>   
> +enum {
> +	H2C_BT_PORT_ID = 0x71,
> +};
> +
>   #define GET_TX_REPORT_SN_V1(c2h)	(c2h[6])
>   #define GET_TX_REPORT_ST_V1(c2h)	(c2h[0] & 0xC0)
>   #define GET_TX_REPORT_RETRY_V1(c2h)	(c2h[2] & 0x3F)
> @@ -2256,6 +2260,7 @@ struct rtl_hal_ops {
>   	void (*bt_coex_off_before_lps) (struct ieee80211_hw *hw);
>   	void (*fill_h2c_cmd) (struct ieee80211_hw *hw, u8 element_id,
>   			      u32 cmd_len, u8 *p_cmdbuffer);
> +	void (*set_default_port_id_cmd)(struct ieee80211_hw *hw);
>   	bool (*get_btc_status) (void);
>   	bool (*is_fw_header)(struct rtlwifi_firmware_header *hdr);
>   	u32 (*rx_command_packet)(struct ieee80211_hw *hw,
> 
