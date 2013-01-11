Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48504 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab3AKX7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 18:59:37 -0500
Date: Fri, 11 Jan 2013 15:59:36 -0800 (PST)
Message-Id: <20130111.155936.1799008114956712424.davem@davemloft.net> (sfid-20130112_005944_523430_B6782655)
To: bhutchings@solarflare.com
Cc: sgruszka@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, mirqus@gmail.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH v3] net, wireless: overwrite default_ethtool_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130111091909.GA2347@redhat.com>
	<1357934432.2643.4.camel@bwh-desktop.uk.solarflarecom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Fri, 11 Jan 2013 20:00:32 +0000

> On Fri, 2013-01-11 at 10:19 +0100, Stanislaw Gruszka wrote:
>> Since:
>> 
>> commit 2c60db037034d27f8c636403355d52872da92f81
>> Author: Eric Dumazet <edumazet@google.com>
>> Date:   Sun Sep 16 09:17:26 2012 +0000
>> 
>>     net: provide a default dev->ethtool_ops
>> 
>> wireless core does not correctly assign ethtool_ops.
>> 
>> After alloc_netdev*() call, some cfg80211 drivers provide they own
>> ethtool_ops, but some do not. For them, wireless core provide generic
>> cfg80211_ethtool_ops, which is assigned in NETDEV_REGISTER notify call:
>> 
>>         if (!dev->ethtool_ops)
>>                 dev->ethtool_ops = &cfg80211_ethtool_ops;
>> 
>> But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
>> drivers without custom ethtool_ops), but points to &default_ethtool_ops.
>> 
>> In order to fix the problem, provide function which will overwrite
>> default_ethtool_ops and use it by wireless core.
>> 
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> [...]
> 
> Acked-by: Ben Hutchings <bhutchings@solarflare.com>

Applied.
