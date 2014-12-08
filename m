Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38746 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaLHH1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 02:27:17 -0500
Message-ID: <1418023628.2001.0.camel@sipsolutions.net> (sfid-20141208_082720_904935_779F35BA)
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 08 Dec 2014 08:27:08 +0100
In-Reply-To: <1417947627-2329-1-git-send-email-vadim4j@gmail.com> (sfid-20141207_113014_452875_30F56FC6)
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20141207_113014_452875_30F56FC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-07 at 12:20 +0200, Vadim Kochan wrote:

> +++ b/net/mac80211/iface.c

> @@ -1624,6 +1625,10 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
>  	mutex_unlock(&local->iflist_mtx);
>  }
>  
> +static struct rtnl_link_ops wireless_link_ops __read_mostly = {
> +	.kind = "wlan",
> +};

I think it would make sense to set it - if not already set - in the
netdev notifier in cfg80211.

johannes

