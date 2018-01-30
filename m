Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbeA3Hp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 02:45:26 -0500
Message-ID: <1517298324.2189.34.camel@sipsolutions.net> (sfid-20180130_084529_202640_89BB8447)
Subject: Re: [PATCHv2 2/2] mac80211: Add support to notify ht/vht opmode
 modification.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 30 Jan 2018 08:45:24 +0100
In-Reply-To: <1516904493-4310-2-git-send-email-tamizhr@codeaurora.org>
References: <1516904493-4310-1-git-send-email-tamizhr@codeaurora.org>
         <1516904493-4310-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-25 at 23:51 +0530, Tamizh chelvam wrote:
> 
> +++ b/net/mac80211/vht.c
> @@ -447,6 +447,7 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
>  				  enum nl80211_band band)
>  {
>  	enum ieee80211_sta_rx_bandwidth new_bw;
> +	struct sta_opmode_info sta_opmode;
>  	u32 changed = 0;
>  	u8 nss;
>  
> @@ -460,7 +461,9 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
>  
>  	if (sta->sta.rx_nss != nss) {
>  		sta->sta.rx_nss = nss;
> +		sta_opmode.rx_nss = nss;
>  		changed |= IEEE80211_RC_NSS_CHANGED;
> +		sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;

This obviously cannot work properly, please respin.

johannes
