Return-Path: <SRS0=mdyG=NV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F120C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 14:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F79F2081C
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 14:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="Q3FQVhH4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F79F2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbeKJXwq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 18:52:46 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:58210 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbeKJXwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 18:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=KmeoHV8S6Sy664IeyBSeY1xSV/v02vLWwLvw4fyUN9w=;
        b=Q3FQVhH4zP8ICeJxNQLNyQDIbiOApQcGN3ops9/bKTjHc1fTXGn6V8VkeJSuyXvSUT9Vvwk2yrye1zMs2NLbN7QysOAtFNyIbeOOaEPh0FGCsG3Gj3JzuQOnMpoTsg+OIq33sZ2GA+JlDhIZd5cHyGx/QJLxZGO6FftHdhjryZI=;
Subject: Re: [PATCH] ath10k: Disable 4addr source port learning in 10.4 FW by
 default
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
References: <20181109061121.4184-1-murugana@codeaurora.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
Date:   Sat, 10 Nov 2018 15:07:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181109061121.4184-1-murugana@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gLTvC-0003KG-RM; Sat, 10 Nov 2018 15:07:34 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

after tested 2 WDS devices (one WDS AP, one WDS STA) with 9984 (netgear 
r7800) i found out that the issue persists. gtk rekeying fails, so 
disconnect and reconnect after 60 minutes.
but the issue is not present with other classic atheros 802.11n WDS STA 
devices. so there is still a issue with 9984 WDS STA

Sebastian

Am 09.11.2018 um 07:11 schrieb Sathishkumar Muruganandam:
> Currently in 10.4 FW, all the received 4addr frames are processed for
> source port learning which is enabled by default. This learning can't
> be disabled by default in FW since it breaks backward compatibility.
>
> Since ath10k uses mac80211 based 4addr mode, source port learning done
> in 10.4 FW is redundant and also causes issues when 3addr frames are
> transmitted/received for a 4addr station.
>
> One such visible functional impact is when GTK rekey frame from
> hostapd based AP to 4addr STA is dropped in AP's 10.4 FW. This is since
> GTK rekey EAPOL frame is 3addr frame on AP interface and STA enabled
> with 4addr is already allowed for receiving 3addr EAPOL frames.
>
> Source port learning implementation in 10.4 FW drops this 3addr GTK rekey
> frame in AP destinated for 4addr STA causing disassociation and
> re-association for every GTK rekey session. GTK rekey issue is not seen
> when learning is disabled in FW.
>
> To prevent such issues without breaking backward compatibility, FW
> advertises new service bit making the source port learning configurable and
> this learning is being currently disabled during ath10k vdev creation.
>
> * Tested HW: QCA9984
> * Tested FW: 10.4-3.6.0.1-00003
>
> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c | 11 +++++++++++
>   drivers/net/wireless/ath/ath10k/wmi.c |  2 ++
>   drivers/net/wireless/ath/ath10k/wmi.h | 21 ++++++++++++++++++++-
>   3 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index c5130fa264eb..aac4d842d504 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -5154,6 +5154,17 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>   		goto err;
>   	}
>   
> +	if (test_bit(WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
> +		     ar->wmi.svc_map)) {
> +		vdev_param = ar->wmi.vdev_param->disable_4addr_src_lrn;
> +		ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id, vdev_param,
> +						WMI_VDEV_DISABLE_4_ADDR_SRC_LRN);
> +		if (ret && ret != -EOPNOTSUPP) {
> +			ath10k_warn(ar, "failed to disable 4addr src lrn vdev %i: %d\n",
> +				    arvif->vdev_id, ret);
> +		}
> +	}
> +
>   	ar->free_vdev_map &= ~(1LL << arvif->vdev_id);
>   	spin_lock_bh(&ar->data_lock);
>   	list_add(&arvif->list, &ar->arvifs);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 659513bf4ddc..8757ae297084 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -825,6 +825,7 @@ static struct wmi_vdev_param_map wmi_vdev_param_map = {
>   	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
>   	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
>   	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
> +	.disable_4addr_src_lrn = WMI_VDEV_PARAM_UNSUPPORTED,
>   };
>   
>   /* 10.X WMI VDEV param map */
> @@ -900,6 +901,7 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
>   	.meru_vc = WMI_VDEV_PARAM_UNSUPPORTED,
>   	.rx_decap_type = WMI_VDEV_PARAM_UNSUPPORTED,
>   	.bw_nss_ratemask = WMI_VDEV_PARAM_UNSUPPORTED,
> +	.disable_4addr_src_lrn = WMI_VDEV_PARAM_UNSUPPORTED,
>   };
>   
>   static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index 58e33ab9e0e9..3e17be938420 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -205,6 +205,7 @@ enum wmi_service {
>   	WMI_SERVICE_SPOOF_MAC_SUPPORT,
>   	WMI_SERVICE_TX_DATA_ACK_RSSI,
>   	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
> +	WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
>   
>   	/* keep last */
>   	WMI_SERVICE_MAX,
> @@ -359,6 +360,9 @@ enum wmi_10_4_service {
>   	WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
>   	WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
>   	WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
> +	WMI_10_4_SERVICE_HTT_ASSERT_TRIGGER_SUPPORT,
> +	WMI_10_4_SERVICE_VDEV_FILTER_NEIGHBOR_RX_PACKETS,
> +	WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
>   };
>   
>   static inline char *wmi_service_name(int service_id)
> @@ -786,6 +790,8 @@ static inline void wmi_10_4_svc_map(const __le32 *in, unsigned long *out,
>   	       WMI_SERVICE_TX_DATA_ACK_RSSI, len);
>   	SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
>   	       WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
> +	SVCMAP(WMI_10_4_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
> +	       WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT, len);
>   }
>   
>   #undef SVCMAP
> @@ -5065,6 +5071,7 @@ struct wmi_vdev_param_map {
>   	u32 bw_nss_ratemask;
>   	u32 inc_tsf;
>   	u32 dec_tsf;
> +	u32 disable_4addr_src_lrn;
>   };
>   
>   #define WMI_VDEV_PARAM_UNSUPPORTED 0
> @@ -5404,7 +5411,19 @@ enum wmi_10_4_vdev_param {
>   	WMI_10_4_VDEV_PARAM_ATF_SSID_SCHED_POLICY,
>   	WMI_10_4_VDEV_PARAM_DISABLE_DYN_BW_RTS,
>   	WMI_10_4_VDEV_PARAM_TSF_DECREMENT,
> -};
> +	WMI_10_4_VDEV_PARAM_SELFGEN_FIXED_RATE,
> +	WMI_10_4_VDEV_PARAM_AMPDU_SUBFRAME_SIZE_PER_AC,
> +	WMI_10_4_VDEV_PARAM_NSS_VHT160,
> +	WMI_10_4_VDEV_PARAM_NSS_VHT80_80,
> +	WMI_10_4_VDEV_PARAM_AMSDU_SUBFRAME_SIZE_PER_AC,
> +	WMI_10_4_VDEV_PARAM_DISABLE_CABQ,
> +	WMI_10_4_VDEV_PARAM_SIFS_TRIGGER_RATE,
> +	WMI_10_4_VDEV_PARAM_TX_POWER,
> +	WMI_10_4_VDEV_PARAM_ENABLE_DISABLE_RTT_RESPONDER_ROLE,
> +	WMI_10_4_VDEV_PARAM_DISABLE_4_ADDR_SRC_LRN,
> +};
> +
> +#define WMI_VDEV_DISABLE_4_ADDR_SRC_LRN 1
>   
>   #define WMI_VDEV_PARAM_TXBF_SU_TX_BFEE BIT(0)
>   #define WMI_VDEV_PARAM_TXBF_MU_TX_BFEE BIT(1)
