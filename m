Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36082 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933651AbeF2JsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:48:00 -0400
Message-ID: <1530265677.3481.56.camel@sipsolutions.net> (sfid-20180629_114823_171817_E4B8AB2A)
Subject: Re: [PATCH 4/4] mac80211: Implement functionality to monitor txrate
 cross event for a station
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:47:57 +0200
In-Reply-To: <1528887539-26821-5-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
         <1528887539-26821-5-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static void ieee80211_sta_mon_txrate_thold_check(struct sta_info *sta)
> +{
> +	struct rate_info rinfo;
> +	enum nl80211_sta_mon_txrate_threshold_event sta_txrate_event;
> +	int txrate;
> +
> +	if (!sta->txrate_high)
> +		return;
> +
> +	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
> +	txrate = cfg80211_calculate_bitrate(&rinfo);

These are quite expensive calculations, I think this is far too much to
do on every packet.

You need to find a way to do most of the calculations at configure time,
e.g. build a table of MCS configurations this station might use, and
mark bits in there that fall above/below the threshold, or something
like that?

johannes
