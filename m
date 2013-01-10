Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3AJLl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 06:41:28 -0500
Message-ID: <1357818103.17902.3.camel@jlt4.sipsolutions.net> (sfid-20130110_124136_950627_B76C05A5)
Subject: Re: [PATCH v2] net: set default_ethtool_ops in register_netdevice
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: sgruszka@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
	greearb@candelatech.com, bjorn@mork.no,
	linux-wireless@vger.kernel.org, bhutchings@solarflare.com,
	mirqus@gmail.com
Date: Thu, 10 Jan 2013 12:41:43 +0100
In-Reply-To: <20130110.021202.232771737304117743.davem@davemloft.net> (sfid-20130110_111209_245287_89F0DC06)
References: <20130109.235738.467651533138068641.davem@davemloft.net>
	 <20130110083641.GA5637@redhat.com>
	 <20130110.020729.1358020934840866117.davem@davemloft.net>
	 <20130110.021202.232771737304117743.davem@davemloft.net>
	 (sfid-20130110_111209_245287_89F0DC06)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-10 at 02:12 -0800, David Miller wrote:

> >> On Wed, Jan 09, 2013 at 11:57:38PM -0800, David Miller wrote:
> >>> From: Stanislaw Gruszka <sgruszka@redhat.com>
> >>> Date: Tue, 8 Jan 2013 16:38:51 +0100
> >>> 
> >>> > Since:
> >>> > 
> >>> > commit 2c60db037034d27f8c636403355d52872da92f81
> >>> > Author: Eric Dumazet <edumazet@google.com>
> >>> > Date:   Sun Sep 16 09:17:26 2012 +0000
> >>> > 
> >>> >     net: provide a default dev->ethtool_ops
> >>> > 
> >>> > wireless core does not correctly assign ethtool_ops. In order to fix
> >>> > the problem, move assignement of default_ethtool_ops to
> >>> > register_netdevice(). This is safe because both register_netdevice()
> >>> > and dev_ethtool() are protected by RTNL lock.
> >>> > 
> >>> > Patch is besed on hint of Michał Mirosław.
> >>> > 
> >>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >>> > Cc: stable@vger.kernel.org # 3.7+
> >>> > ---
> >>> > v1 -> v2: change order of default_ethtool_ops initialization to avoid
> >>> > the problem. Change the subject accordingly.
> >>> 
> >>> I don't understand this.  Why is the assignment of default_ethtool_ops
> >>> at netdev allocation time not working?  Is wireless really not using
> >>> alloc_netdev*()?
> >> 
> >> It does. This is done on individual cfg80211 drivers , i.e. on mac80211
> >> or full mac drivers. After alloc_netdev*() call, some cfg80211 drivers
> >> provide they own ethtool_ops, but some do not. For them, wireless core
> >> provide generic cfg80211_ethtool_ops, which is assigned in
> >> NETDEV_REGISTER notify call: 
> >> 
> >>      if (!dev->ethtool_ops)
> >>              dev->ethtool_ops = &cfg80211_ethtool_ops;
> >> 
> >> But after Eric's commit, dev->ethtool_ops is no longer NULL (on cfg80211
> >> drivers without custom ethtool_ops), but points to &default_ethtool_ops.
> > 
> > The whole idea is to remove these kinds of NULL tests against
> > dev->ethtool_ops, thus creating the invariant that given any netdev
> > one must never be able to see a non-NULL value there.
> 
> Of course I meant that we should never see a NULL value in
> dev->ethtool_ops.
> 
> I would suggest fixing this by making the wireless core express it's
> intentions, that it wants to use a different default ethtool ops, to
> the netdev allocation layer.
> 
> You have two way to do this:
> 
> 1) Add default_ethtool_ops argument to alloc_netdev*().
> 
> 2) Add a "netdev_set_default_ethtool_ops(netdev, ops)"

Neither of these work as (I think) you think they would :-)

The core wireless code doesn't allocate/register the netdev itself, the
driver does. It has to follow some constraints, but the wireless core
then hooks into the netdev notifier chain to be informed. While in the
notifier chain, it attempts to set ethtool ops, but they've long been
set already to the defaults. So that means the second way you suggested
won't work at that point any more, short of having the wireless core
code export its ethtool ops and drivers setting them.

Now arguably the wireless core code could provide its own
alloc_netdev*() wrappers, but is that really worth it? There are a lot
of possibilities there that we'd have to wrap.

johannes


