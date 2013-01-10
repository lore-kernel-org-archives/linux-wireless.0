Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab3AJIg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 03:36:57 -0500
Date: Thu, 10 Jan 2013 09:36:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, bhutchings@solarflare.com,
	mirqus@gmail.com
Subject: Re: [PATCH v2] net: set default_ethtool_ops in register_netdevice
Message-ID: <20130110083641.GA5637@redhat.com> (sfid-20130110_093705_585160_D074AE80)
References: <20130108153850.GA10464@redhat.com>
 <20130109.235738.467651533138068641.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130109.235738.467651533138068641.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 09, 2013 at 11:57:38PM -0800, David Miller wrote:
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Tue, 8 Jan 2013 16:38:51 +0100
> 
> > Since:
> > 
> > commit 2c60db037034d27f8c636403355d52872da92f81
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Sun Sep 16 09:17:26 2012 +0000
> > 
> >     net: provide a default dev->ethtool_ops
> > 
> > wireless core does not correctly assign ethtool_ops. In order to fix
> > the problem, move assignement of default_ethtool_ops to
> > register_netdevice(). This is safe because both register_netdevice()
> > and dev_ethtool() are protected by RTNL lock.
> > 
> > Patch is besed on hint of Michał Mirosław.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > Cc: stable@vger.kernel.org # 3.7+
> > ---
> > v1 -> v2: change order of default_ethtool_ops initialization to avoid
> > the problem. Change the subject accordingly.
> 
> I don't understand this.  Why is the assignment of default_ethtool_ops
> at netdev allocation time not working?  Is wireless really not using
> alloc_netdev*()?

It does. This is done on individual cfg80211 drivers , i.e. on mac80211
or full mac drivers. After alloc_netdev*() call, some cfg80211 drivers
provide they own ethtool_ops, but some do not. For them, wireless core
provide generic cfg80211_ethtool_ops, which is assigned in
NETDEV_REGISTER notify call: 

	if (!dev->ethtool_ops)
		dev->ethtool_ops = &cfg80211_ethtool_ops;

But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
drivers without custom ethtool_ops), but points to &default_ethtool_ops.

Stanislaw
