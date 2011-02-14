Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1BNKHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:07:44 -0500
Subject: Re: [PATCH 2/2] mac80211: add support for showing the last rx
 bitrate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1297351797-35031-2-git-send-email-nbd@openwrt.org>
References: <1297351797-35031-1-git-send-email-nbd@openwrt.org>
	 <1297351797-35031-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:07:41 +0100
Message-ID: <1297678061.3785.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 16:29 +0100, Felix Fietkau wrote:

> @@ -1166,14 +1166,23 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
>  	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
>  		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
>  						NL80211_IFTYPE_ADHOC);
> -		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0)
> +		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0) {
>  			sta->last_rx = jiffies;
> +			if (ieee80211_is_data(hdr->frame_control)) {
> +				sta->last_rx_rate_idx = status->rate_idx;
> +				sta->last_rx_rate_flag = status->flag;
> +			}

... and in fact you do that here. Please document this expectation in
nl80211 :-)

johannes

