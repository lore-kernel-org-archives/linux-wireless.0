Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:63169 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3AKUAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 15:00:36 -0500
Message-ID: <1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20130111_210047_649790_56495E6E)
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ben Greear <greearb@candelatech.com>,
	=?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	<linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 11 Jan 2013 20:00:32 +0000
In-Reply-To: <20130111091909.GA2347@redhat.com>
References: <20130111091909.GA2347@redhat.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 10:19 +0100, Stanislaw Gruszka wrote:
> Since:
> 
> commit 2c60db037034d27f8c636403355d52872da92f81
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Sun Sep 16 09:17:26 2012 +0000
> 
>     net: provide a default dev->ethtool_ops
> 
> wireless core does not correctly assign ethtool_ops.
> 
> After alloc_netdev*() call, some cfg80211 drivers provide they own
> ethtool_ops, but some do not. For them, wireless core provide generic
> cfg80211_ethtool_ops, which is assigned in NETDEV_REGISTER notify call:
> 
>         if (!dev->ethtool_ops)
>                 dev->ethtool_ops = &cfg80211_ethtool_ops;
> 
> But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
> drivers without custom ethtool_ops), but points to &default_ethtool_ops.
> 
> In order to fix the problem, provide function which will overwrite
> default_ethtool_ops and use it by wireless core.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
[...]

Acked-by: Ben Hutchings <bhutchings@solarflare.com>

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

