Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35514 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaJVQfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 12:35:10 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so2012870pad.7
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 09:35:09 -0700 (PDT)
Message-ID: <5447DCBB.9020009@lwfinger.net> (sfid-20141022_183516_273305_6818454C)
Date: Wed, 22 Oct 2014 11:35:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Karsten Wiese <fzuuzf@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] rtl8192cu: Prevent Ooops under rtl92c_set_fw_rsvdpagepkt
References: <1413985654-25070-1-git-send-email-fzuuzf@googlemail.com> <1413985654-25070-4-git-send-email-fzuuzf@googlemail.com>
In-Reply-To: <1413985654-25070-4-git-send-email-fzuuzf@googlemail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2014 08:47 AM, Karsten Wiese wrote:
> rtl92c_set_fw_rsvdpagepkt is used by rtl8192cu and its pci sibling rtl8192ce.
> rtl_cmd_send_packet crashes when called inside rtl8192cu because it works on
> memory allocated only by rtl8192ce.
> Fix the crash by calling a dummy function when used in rtl8192cu.
> Comparision with the realtek vendor driver makes me think, something is missing in
> the dummy function.
> Short test as WPA2 station show good results connected to an 802.11g basestation.
> Traffic stops after few MBytes as WPA2 station connected to an 802.11n basestation.
>
> Signed-off-by: Karsten Wiese <fzuuzf@googlemail.com>

This one needs to be applied; however, I will be taking another look at it after 
I finish my traveling.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry


> ---
>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |  8 ++++++--
>   drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h |  4 +++-
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |  2 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       | 17 ++++++++++++++++-
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.h       |  1 -
>   5 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> index a00861b..29983bc 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
> @@ -656,7 +656,8 @@ static u8 reserved_page_packet[TOTAL_RESERVED_PKT_LEN] = {
>   	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
>   };
>
> -void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
> +void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
> +	 bool (*cmd_send_packet)(struct ieee80211_hw *, struct sk_buff *))
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
> @@ -722,7 +723,10 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
>   	memcpy((u8 *)skb_put(skb, totalpacketlen),
>   	       &reserved_page_packet, totalpacketlen);
>
> -	rtstatus = rtl_cmd_send_packet(hw, skb);
> +	if (cmd_send_packet)
> +		rtstatus = cmd_send_packet(hw, skb);
> +	else
> +		rtstatus = rtl_cmd_send_packet(hw, skb);
>
>   	if (rtstatus)
>   		b_dlok = true;
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
> index a815bd6..b64ae45 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
> @@ -109,7 +109,9 @@ void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
>   			 u32 cmd_len, u8 *p_cmdbuffer);
>   void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
>   void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
> -void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
> +void rtl92c_set_fw_rsvdpagepkt
> +	(struct ieee80211_hw *hw,
> +	 bool (*cmd_send_packet)(struct ieee80211_hw *, struct sk_buff *));
>   void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
>   void usb_writeN_async(struct rtl_priv *rtlpriv, u32 addr, void *data, u16 len);
>   void rtl92c_set_p2p_ps_offload_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> index 8ec0f03..55357d6 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> @@ -459,7 +459,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   				rtl_write_byte(rtlpriv, REG_FWHW_TXQ_CTRL + 2,
>   					       tmp_reg422 & (~BIT(6)));
>
> -				rtl92c_set_fw_rsvdpagepkt(hw, 0);
> +				rtl92c_set_fw_rsvdpagepkt(hw, NULL);
>
>   				_rtl92ce_set_bcn_ctrl_reg(hw, BIT(3), 0);
>   				_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(4));
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> index 04aa0b5..873363a 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1592,6 +1592,20 @@ void rtl92cu_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   	}
>   }
>
> +bool usb_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
> +{
> +  /* Currently nothing happens here.
> +   * Traffic stops after some seconds in WPA2 802.11n mode.
> +   * Maybe because rtl8192cu chip should be set from here?
> +   * If I understand correctly, the realtek vendor driver sends some urbs
> +   * if its "here".
> +   *
> +   * This is maybe necessary:
> +   * rtlpriv->cfg->ops->fill_tx_cmddesc(hw, buffer, 1, 1, skb);
> +   */
> +	return true;
> +}
> +
>   void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   {
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
> @@ -1939,7 +1953,8 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
>   					recover = true;
>   				rtl_write_byte(rtlpriv, REG_FWHW_TXQ_CTRL + 2,
>   					       tmp_reg422 & (~BIT(6)));
> -				rtl92c_set_fw_rsvdpagepkt(hw, 0);
> +				rtl92c_set_fw_rsvdpagepkt(hw,
> +							  &usb_cmd_send_packet);
>   				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(3), 0);
>   				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
>   				if (recover)
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> index 0f7812e..c1e33b0 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
> @@ -104,7 +104,6 @@ bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
>   void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
>   int rtl92c_download_fw(struct ieee80211_hw *hw);
>   void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
> -void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished);
>   void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
>   void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
>   			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
>

