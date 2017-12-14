Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdLNMfT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:35:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Tsang-Shian Lin <thlin@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 2/3] rtlwifi: Add beacon check mechanism to check if AP settings changed.
References: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
        <20171209173710.9879-3-Larry.Finger@lwfinger.net>
Date: Thu, 14 Dec 2017 14:35:12 +0200
In-Reply-To: <20171209173710.9879-3-Larry.Finger@lwfinger.net> (Larry Finger's
        message of "Sat, 9 Dec 2017 11:37:09 -0600")
Message-ID: <87fu8dcwsf.fsf@purkki.adurom.net> (sfid-20171214_133523_810234_E6B27F60)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> From: Tsang-Shian Lin <thlin@realtek.com>
>
> AP WiFi settings are changed(channel, bandwidth), but deauth may not
> received by STA. For these cases, we need to detect and handle beacon
> changes.
>
> Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Cc: Birming Chiu <birming@realtek.com>
> Cc: Shaofu <shaofu@realtek.com>
> Cc: Steven Ting <steventing@realtek.com>

[...]

> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
> @@ -2360,6 +2360,185 @@ struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
>  	return skb;
>  }
>  
> +bool rtl_check_beacon_key(struct ieee80211_hw *hw, void *data, unsigned int len)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
> +	struct rtl_phy *rtlphy = &rtlpriv->phy;
> +	struct ieee80211_hdr *hdr = data;
> +	struct ieee80211_ht_cap *ht_cap_ie;
> +	struct ieee80211_ht_operation *ht_oper_ie = NULL;
> +	struct rtl_beacon_keys bcn_key = {0};
> +	struct rtl_beacon_keys *cur_bcn_key;
> +	u8 *ht_cap;
> +	u8 ht_cap_len;
> +	u8 *ht_oper;
> +	u8 ht_oper_len;
> +	u8 *ds_param;
> +	u8 ds_param_len;
> +
> +	if (mac->opmode != NL80211_IFTYPE_STATION)
> +		return false;
> +
> +	/* check if this really is a beacon*/
> +	if (!ieee80211_is_beacon(hdr->frame_control))
> +		return false;
> +
> +	/* min. beacon length + FCS_LEN */
> +	if (len <= 40 + FCS_LEN)
> +		return false;
> +
> +	cur_bcn_key = &mac->cur_beacon_keys;
> +
> +	if (rtlpriv->mac80211.link_state == MAC80211_NOLINK) {
> +		if (cur_bcn_key->valid) {
> +			cur_bcn_key->valid = false;
> +			RT_TRACE(rtlpriv, COMP_BEACON, DBG_LOUD,
> +				 "Reset cur_beacon_keys.valid to false!\n");
> +		}
> +		return false;
> +	}
> +
> +	/* and only beacons from the associated BSSID, please */
> +	if (!ether_addr_equal(hdr->addr3, rtlpriv->mac80211.bssid))
> +		return false;
> +
> +	/***** Parsing DS Param IE ******/
> +	ds_param = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_DS_PARAMS);
> +
> +	if (ds_param && !(ds_param[1] < sizeof(*ds_param)))
> +		ds_param_len = ds_param[1];
> +	else
> +		ds_param = NULL;
> +
> +	/***** Parsing HT Cap. IE ******/
> +	ht_cap = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_HT_CAPABILITY);
> +
> +	if (ht_cap && !(ht_cap[1] < sizeof(*ht_cap))) {
> +		ht_cap_len = ht_cap[1];
> +		ht_cap_ie = (struct ieee80211_ht_cap *)&ht_cap[2];
> +	} else  {
> +		ht_cap = NULL;
> +		ht_cap_ie = NULL;
> +	}
> +
> +	/***** Parsing HT Info. IE ******/
> +	ht_oper = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_HT_OPERATION);
> +
> +	if (ht_oper && !(ht_oper[1] < sizeof(*ht_oper))) {
> +		ht_oper_len = ht_oper[1];
> +		ht_oper_ie = (struct ieee80211_ht_operation *)&ht_oper[2];
> +	} else {
> +		ht_oper = NULL;
> +	}
> +
> +	/* update bcn_key */
> +	memset(&bcn_key, 0, sizeof(bcn_key));
> +
> +	if (ds_param)
> +		bcn_key.bcn_channel = ds_param[2];
> +	else if (ht_oper && ht_oper_ie)
> +		bcn_key.bcn_channel = ht_oper_ie->primary_chan;
> +
> +	if (ht_cap_ie)
> +		bcn_key.ht_cap_info = ht_cap_ie->cap_info;
> +
> +	if (ht_oper && ht_oper_ie)
> +		bcn_key.ht_info_infos_0_sco = ht_oper_ie->ht_param & 0x03;
> +
> +	bcn_key.valid = true;
> +
> +	/* update cur_beacon_keys or compare beacon key */
> +	if (rtlpriv->mac80211.link_state != MAC80211_LINKED &&
> +	    rtlpriv->mac80211.link_state != MAC80211_LINKED_SCANNING)
> +		return true;
> +
> +	if (!cur_bcn_key->valid) {
> +		/* update cur_beacon_keys */
> +		memset(cur_bcn_key, 0, sizeof(bcn_key));
> +		memcpy(cur_bcn_key, &bcn_key, sizeof(bcn_key));
> +		cur_bcn_key->valid = true;
> +
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_LOUD,
> +			 "Beacon key update!ch=%d, ht_cap_info=0x%x, sco=0x%x\n",
> +			 cur_bcn_key->bcn_channel,
> +			 cur_bcn_key->ht_cap_info,
> +			 cur_bcn_key->ht_info_infos_0_sco);
> +
> +		return true;
> +	}
> +
> +	/* compare beacon key */
> +	if (!memcmp(cur_bcn_key, &bcn_key, sizeof(bcn_key))) {
> +		/* same beacon key */
> +		mac->new_beacon_cnt = 0;
> +		goto chk_exit;
> +	}
> +
> +	if (cur_bcn_key->bcn_channel == bcn_key.bcn_channel &&
> +	    cur_bcn_key->ht_cap_info == bcn_key.ht_cap_info) {
> +		/* Beacon HT info IE, secondary channel offset check */
> +		/* 40M -> 20M */
> +		if (cur_bcn_key->ht_info_infos_0_sco >
> +		    bcn_key.ht_info_infos_0_sco) {
> +			/* Not a new beacon */
> +			RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +				 "Beacon BW change! sco:0x%x -> 0x%x\n",
> +				 cur_bcn_key->ht_info_infos_0_sco,
> +				 bcn_key.ht_info_infos_0_sco);
> +
> +			cur_bcn_key->ht_info_infos_0_sco =
> +					bcn_key.ht_info_infos_0_sco;
> +		} else {
> +			/* 20M -> 40M */
> +			if (rtlphy->max_ht_chan_bw >= HT_CHANNEL_WIDTH_20_40) {
> +				/* Not a new beacon */
> +				RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +					 "Beacon BW change! sco:0x%x -> 0x%x\n",
> +					 cur_bcn_key->ht_info_infos_0_sco,
> +					 bcn_key.ht_info_infos_0_sco);
> +
> +				cur_bcn_key->ht_info_infos_0_sco =
> +					bcn_key.ht_info_infos_0_sco;
> +			} else {
> +				mac->new_beacon_cnt++;
> +			}
> +		}
> +	} else {
> +		mac->new_beacon_cnt++;
> +	}
> +
> +	if (mac->new_beacon_cnt == 1) {
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +			 "Get new beacon.\n");
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +			 "Cur : ch=%d, ht_cap=0x%x, sco=0x%x\n",
> +			 cur_bcn_key->bcn_channel,
> +			 cur_bcn_key->ht_cap_info,
> +			 cur_bcn_key->ht_info_infos_0_sco);
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +			 "New RX : ch=%d, ht_cap=0x%x, sco=0x%x\n",
> +			 bcn_key.bcn_channel,
> +			 bcn_key.ht_cap_info,
> +			 bcn_key.ht_info_infos_0_sco);
> +
> +	} else if (mac->new_beacon_cnt > 1) {
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +			 "new beacon cnt: %d\n",
> +			 mac->new_beacon_cnt);
> +	}
> +
> +	if (mac->new_beacon_cnt > 3) {
> +		ieee80211_connection_loss(rtlpriv->mac80211.vif);
> +		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
> +			 "new beacon cnt >3, disconnect !\n");
> +	}
> +
> +chk_exit:
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(rtl_check_beacon_key);

Why do all this in the driver? I would expect something like this to be
done in mac80211, not in the driver.

> +struct rtl_beacon_keys {
> +	/*u8 ssid[32];*/
> +	/*u32 ssid_len;*/

Commented out fields, please drop.

-- 
Kalle Valo
