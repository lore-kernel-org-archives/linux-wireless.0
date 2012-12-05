Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48360 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2LEMaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 07:30:19 -0500
Message-ID: <1354710644.9972.11.camel@jlt4.sipsolutions.net> (sfid-20121205_133023_864184_5176EE7F)
Subject: Re: [PATCH] mac80211: fix the multiple warnings for budding
 chipsets without ampdu_action defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya <chaitanyatk@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 13:30:44 +0100
In-Reply-To: <50BF3DBB.90000@posedge.com>
References: <50BF3DBB.90000@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 17:57 +0530, Chaitanya wrote:

> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -445,7 +445,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>  
>      trace_api_start_tx_ba_session(pubsta, tid);
>  
> -    if (WARN_ON(!local->ops->ampdu_action))
> +    if (WARN_ON_ONCE(!local->ops->ampdu_action))
>          return -EINVAL;

Hm, no tabs it seems, so this doesn't apply either.

I'd just fix it myself for this simple a thing, but you'll probably
eventually want to submit more complicated patches ...

johannes

