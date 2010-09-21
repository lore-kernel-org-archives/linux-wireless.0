Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab0IUGdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 02:33:09 -0400
Subject: Re: [PATCH] mac80211: clear txflags for ps-filtered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201009210022.27383.chunkeey@googlemail.com>
References: <201009182133.50104.chunkeey@googlemail.com>
	 <1284978231.3688.2.camel@jlt3.sipsolutions.net>
	 <201009210022.27383.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:33:32 +0200
Message-ID: <1285050812.3710.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 00:22 +0200, Christian Lamparter wrote:

> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
>  			timer_to_tid[0]);
>  
>  	rcu_read_lock();
> -	spin_lock(&sta->lock);
>  	ieee80211_release_reorder_timeout(sta, *ptid);
> -	spin_unlock(&sta->lock);
>  	rcu_read_unlock();
>  }
>  

Ack, apart from this?

johannes

