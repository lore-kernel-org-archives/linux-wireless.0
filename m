Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab2IDQSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 12:18:08 -0400
Message-ID: <1346775525.3737.36.camel@jlt4.sipsolutions.net> (sfid-20120904_181813_056853_2E1FE277)
Subject: Re: mac80211: support P2P Device abstraction
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 18:18:45 +0200
In-Reply-To: <20120904161319.GA11494@elgon.mountain> (sfid-20120904_181334_957253_117FCC5D)
References: <20120904161319.GA11494@elgon.mountain>
	 (sfid-20120904_181334_957253_117FCC5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> The patch f142c6b906da: "mac80211: support P2P Device abstraction" 
> from Jun 18, 2012, leads to the following Smatch complaint:
> 
> net/mac80211/iface.c:1168 ieee80211_setup_sdata()
> 	 error: we previously assumed 'sdata->dev' could be null (see line 1134)
> 
> net/mac80211/iface.c
>   1133		/* only monitor/p2p-device differ */
>   1134		if (sdata->dev) {
>                     ^^^^^^^^^^
> New test.
> 
>   1135			sdata->dev->netdev_ops = &ieee80211_dataif_ops;
>   1136			sdata->dev->type = ARPHRD_ETHER;
>   1137		}
> 
> [snip]
> 
>   1167		case NL80211_IFTYPE_MONITOR:
>   1168			sdata->dev->type = ARPHRD_IEEE80211_RADIOTAP;
>                         ^^^^^^^^^^^^
> Old dereference.

Thanks. I'm aware of the warning (I run smatch), but sdata->dev can only
be NULL in "case NL80211_IFTYPE_P2P_DEVICE", so adding an extra check in
the monitor case didn't seem worthwhile.

It might have been better to use sdata->vif.type != P2P_DEVICE in the
new test I guess, but then it wouldn't be extensible to new interface
types like Bluetooth AMP.

johannes

