Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58476 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbeICMwp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 08:52:45 -0400
Message-ID: <1535963610.3437.10.camel@sipsolutions.net> (sfid-20180903_103407_414254_305DBF17)
Subject: Re: [PATCH] mac80211: fix TX status reporting for ieee80211s
From: Johannes Berg <johannes@sipsolutions.net>
To: Yuan-Chi Pang <fu3mo6goo@gmail.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Sep 2018 10:33:30 +0200
In-Reply-To: <1535699575-5672-1-git-send-email-fu3mo6goo@gmail.com> (sfid-20180831_091323_224304_305F21B4)
References: <1535699575-5672-1-git-send-email-fu3mo6goo@gmail.com>
         (sfid-20180831_091323_224304_305F21B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-08-31 at 15:12 +0800, Yuan-Chi Pang wrote:

>  void ieee80211s_init(void);
>  void ieee80211s_update_metric(struct ieee80211_local *local,
> -			      struct sta_info *sta, struct sk_buff *skb);
> +			struct sta_info *sta, struct ieee80211_tx_status *st);

please keep things indented properly

>  void ieee80211s_update_metric(struct ieee80211_local *local,
> -		struct sta_info *sta, struct sk_buff *skb)
> +		struct sta_info *sta, struct ieee80211_tx_status *st)

and maybe fix the indentation here while you're changing it

>  {
> -	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
> -	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct ieee80211_tx_info *txinfo = st->info;
>  	int failed;
>  
> -	if (!ieee80211_is_data(hdr->frame_control))
> -		return;

Why are you removing this condition? You didn't say anything about that.

I sort of see why (you no longer even have the skb/hdr), but you should
indicate why this is OK.
 
>  		rate_control_tx_status(local, sband, status);
> +		if (ieee80211_vif_is_mesh(&sta->sdata->vif))
> +			ieee80211s_update_metric(local, sta, status)

This is the only "real" change I guess, some more description about it
would be good.

I can sort of reverse engineer it from your commit log, but you should
be more explicit.

johannes
