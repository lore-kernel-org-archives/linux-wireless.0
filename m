Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:36572 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756768Ab2EYUCr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:02:47 -0400
Message-ID: <1337976166.30100.6.camel@joe2Laptop> (sfid-20120525_220251_765822_1E019503)
Subject: Re: [RFC] mac80211: net_ratelimit few aggregation related messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 25 May 2012 13:02:46 -0700
In-Reply-To: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-25 at 21:07 +0530, Mohammed Shafi Shajakhan wrote:
> net_ratelimit few aggregation related messages,
[]
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
[]
> @@ -464,8 +464,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  		return -EINVAL;
>  
>  #ifdef CONFIG_MAC80211_HT_DEBUG
> -	printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
> -	       pubsta->addr, tid);
> +	if (net_ratelimit())
> +		printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
> +		       pubsta->addr, tid);

perhaps
	net_dbg_ratelimited(...)

etc...

