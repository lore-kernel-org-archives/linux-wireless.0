Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33529 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab3AJVA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 16:00:26 -0500
Date: Thu, 10 Jan 2013 13:00:24 -0800 (PST)
Message-Id: <20130110.130024.1675024063662393029.davem@davemloft.net> (sfid-20130110_220036_000968_797CCF2E)
To: johannes@sipsolutions.net
Cc: sgruszka@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, bhutchings@solarflare.com,
	mirqus@gmail.com
Subject: Re: [PATCH v2] net: set default_ethtool_ops in register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <1357818103.17902.3.camel@jlt4.sipsolutions.net>
References: <20130110.020729.1358020934840866117.davem@davemloft.net>
	<20130110.021202.232771737304117743.davem@davemloft.net>
	<1357818103.17902.3.camel@jlt4.sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 10 Jan 2013 12:41:43 +0100

> On Thu, 2013-01-10 at 02:12 -0800, David Miller wrote:
> 
>> >> On Wed, Jan 09, 2013 at 11:57:38PM -0800, David Miller wrote:
>> >>> From: Stanislaw Gruszka <sgruszka@redhat.com>
>> >>> Date: Tue, 8 Jan 2013 16:38:51 +0100
>> >>> 
>> >>> > Since:
>> >>> > 
>> >>> > commit 2c60db037034d27f8c636403355d52872da92f81
>> >>> > Author: Eric Dumazet <edumazet@google.com>
>> >>> > Date:   Sun Sep 16 09:17:26 2012 +0000
>> >>> > 
>> >>> >     net: provide a default dev->ethtool_ops
>> >>> > 
>> >>> > wireless core does not correctly assign ethtool_ops. In order to fix
>> >>> > the problem, move assignement of default_ethtool_ops to
>> >>> > register_netdevice(). This is safe because both register_netdevice()
>> >>> > and dev_ethtool() are protected by RTNL lock.
>> >>> > 
>> >>> > Patch is besed on hint of Micha©© Miros©©aw.
>> >>> > 
>> >>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> >>> > Cc: stable@vger.kernel.org # 3.7+
>> >>> > ---
>> >>> > v1 -> v2: change order of default_ethtool_ops initialization to avoid
>> >>> > the problem. Change the subject accordingly.
>> >>> 
>> >>> I don't understand this.  Why is the assignment of default_ethtool_ops
>> >>> at netdev allocation time not working?  Is wireless really not using
>> >>> alloc_netdev*()?
>> >> 
>> >> It does. This is done on individual cfg80211 drivers , i.e. on mac80211
>> >> or full mac drivers. After alloc_netdev*() call, some cfg80211 drivers
>> >> provide they own ethtool_ops, but some do not. For them, wireless core
>> >> provide generic cfg80211_ethtool_ops, which is assigned in
>> >> NETDEV_REGISTER notify call: 
>> >> 
>> >>      if (!dev->ethtool_ops)
>> >>              dev->ethtool_ops = &cfg80211_ethtool_ops;
>> >> 
>> >> But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
>> >> drivers without custom ethtool_ops), but points to &default_ethtool_ops.
>> > 
>> > The whole idea is to remove these kinds of NULL tests against
>> > dev->ethtool_ops, thus creating the invariant that given any netdev
>> > one must never be able to see a non-NULL value there.
>> 
>> Of course I meant that we should never see a NULL value in
>> dev->ethtool_ops.
>> 
>> I would suggest fixing this by making the wireless core express it's
>> intentions, that it wants to use a different default ethtool ops, to
>> the netdev allocation layer.
>> 
>> You have two way to do this:
>> 
>> 1) Add default_ethtool_ops argument to alloc_netdev*().
>> 
>> 2) Add a "netdev_set_default_ethtool_ops(netdev, ops)"
> 
> Neither of these work as (I think) you think they would :-)

2) works because all netdev_set_ethtool_ops() is going to do is
compare netdev->ops against &default_ethtool_ops as the test,
and therefore you can replace the above cfg80211 test and
assignment with a call to it.
