Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60000 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeIDNjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 09:39:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wen Gong <wgong@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
Date: Tue, 04 Sep 2018 12:15:28 +0300
In-Reply-To: <1534402113-14337-1-git-send-email-wgong@codeaurora.org> (Wen
        Gong's message of "Thu, 16 Aug 2018 14:48:33 +0800")
Message-ID: <877ek18vyn.fsf@kamboji.qca.qualcomm.com> (sfid-20180904_111536_491620_E71276F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> writes:

> For WoWLAN support, it expect to support wake up based on discovery of
> one or more known SSIDs. This is the WIPHY_WOWLAN_NET_DETECT feature,
> which shows up as an NL80211 feature flag.
>
> With an upgrade iw, this shows up in 'iw phy' as:
> WoWLAN support:
> * wake up on network detection, up to 16 match sets
> And it can use command:
> "iw phy0 wowlan enable net-detect interval 5000 delay 30 freqs 2412
> matches ssid foo" to configure the parameters of net detect.
>
> Firmware will do scan by the configured parameters after suspend and
> wakeup if it found matched SSIDs. Tested with QCA6174 hw3.0 with
> firmware WLAN.RM.4.4.1-00110-QCARMSWPZ-1.
>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>

[...]

> +/* Request FW to start PNO operation */
> +static struct sk_buff *ath10k_wmi_tlv_op_gen_config_pno_start
> +				(struct ath10k *ar,
> +				u32 vdev_id,
> +				struct wmi_pno_scan_req *pno)
> +{
> +	struct wmi_tlv_wow_nlo_config_cmd *cmd;
> +	struct wmi_tlv *tlv;
> +	struct sk_buff *skb;
> +	struct nlo_configured_parameters *nlo_list;
> +	u32 *channel_list;

[...]

> +	channel_list = (u32 *)ptr;
> +	for (i = 0; i < cmd->num_of_channels; i++)
> +		channel_list[i] = pno->a_networks[0].channels[i];

channel_list does not look endian safe to me, I'll change this to use
__le32.

> +enum wmi_nlo_cipher_algorithm {
> +	WMI_NLO_CIPHER_ALGO_NONE           = 0x00,
> +	WMI_NLO_CIPHER_ALGO_WEP40          = 0x01,
> +	WMI_NLO_CIPHER_ALGO_TKIP           = 0x02,
> +	WMI_NLO_CIPHER_ALGO_CCMP           = 0x04,
> +	WMI_NLO_CIPHER_ALGO_WEP104         = 0x05,
> +	WMI_NLO_CIPHER_ALGO_BIP            = 0x06,
> +	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  = 0x100,
> +	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  = 0x100,

Two defines with the same value 0x100, is this really correct?

-- 
Kalle Valo
