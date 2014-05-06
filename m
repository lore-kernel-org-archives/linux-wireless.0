Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48939 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394AbaEFAPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 20:15:10 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] cfg80211: allow restricting supported dfs regions
References: <1399283320-66468-1-git-send-email-nbd@openwrt.org>
Date: Tue, 06 May 2014 03:15:09 +0300
In-Reply-To: <1399283320-66468-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Mon, 5 May 2014 11:48:40 +0200")
Message-ID: <87iopj4vaq.fsf@purkki.adurom.net> (sfid-20140506_021519_847996_1FB62AEB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
> radar patterns.
> Add a bitmap in the interface combinations, indicating which DFS regions
> are supported by the detector. If unset, support for all regions is
> assumed.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

[...]

> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3688,6 +3688,8 @@ enum nl80211_iface_limit_attrs {
>   *	different channels may be used within this group.
>   * @NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS: u32 attribute containing the bitmap
>   *	of supported channel widths for radar detection.
> + * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
> + *	of supported regulatory regions for radar detection.
>   * @NUM_NL80211_IFACE_COMB: number of attributes
>   * @MAX_NL80211_IFACE_COMB: highest attribute number
>   *
> @@ -3721,6 +3723,7 @@ enum nl80211_if_combination_attrs {
>  	NL80211_IFACE_COMB_STA_AP_BI_MATCH,
>  	NL80211_IFACE_COMB_NUM_CHANNELS,
>  	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
> +	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,

How is the bitmap mapped with regions? That's not clear for me. It would
be good to document that in the comment.

-- 
Kalle Valo
