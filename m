Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60264 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924AbaFCT7L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:59:11 -0400
Message-ID: <1401825537.4157.43.camel@jlt4.sipsolutions.net> (sfid-20140603_215914_628343_4AD2B8DE)
Subject: Re: [PATCH] mac80211: allow tx via monitor iface when DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Jun 2014 21:58:57 +0200
In-Reply-To: <1401443081-10277-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140530_114451_903305_71F74C94)
References: <1401443081-10277-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140530_114451_903305_71F74C94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-30 at 11:44 +0200, Janusz Dziedzic wrote:

> +	struct cfg80211_chan_def chandef;
>  	u16 len_rthdr;
>  	int hdrlen;
>  
> @@ -1721,9 +1721,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
>  	}
>  
>  	if (chanctx_conf)
> -		chan = chanctx_conf->def.chan;
> +		chandef = chanctx_conf->def;
>  	else if (!local->use_chanctx)
> -		chan = local->_oper_chandef.chan;
> +		chandef = local->_oper_chandef;

Why are you making a copy of the chandef - wouldn't a pointer work just
as well?

johannes

