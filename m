Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56524 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZHKUaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:30:15 -0400
Date: Wed, 12 Aug 2009 00:29:29 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Sergey Lapin <slapin@ossfans.org>
Subject: Re: [PATCH 1/2] mac802154: add a software MAC 802.15.4
 implementation
Message-ID: <20090811202929.GB6303@doriath.ww600.siemens.net>
References: <1249913800-10176-1-git-send-email-dbaryshkov@gmail.com>
 <1249913800-10176-2-git-send-email-dbaryshkov@gmail.com>
 <20090810172843.GD6791@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090810172843.GD6791@linux.vnet.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 10:28:43AM -0700, Paul E. McKenney wrote:
> On Mon, Aug 10, 2009 at 06:16:39PM +0400, Dmitry Eremin-Solenikov wrote:
> > Some of available devices are just dump radios implementing IEEE 802.15.4
> > PHY layer. This commit adds a common library that acts like an intermediate
> > layer between our socket family and drivers for those dumb devices.
> > 
> > Currently this is data-only part (no commands, no beacons). Control
> > interfaces will follow up shortly.
> > 
> > Note this implementaion is neither certified, nor feature complete!
> 
> One question below, otherwise looks plausible.  (I am not entirely sure
> which lists are which...)
> 
> 							Thanx, Paul

[skipped]

> 
> > +
> > +/*
> > + * This is for hw unregistration only, as it doesn't do RCU locking
> 
> So this list is different than the RCU-protected one, and readers
> always hold locks when traversing it?
> 
> I am not familiar with this code, so might be missing something, but
> it looks to me like the same list that RCU readers traverse.  If so,
> need list_del_rcu() and synchronize_rcu().

On the first glance, yes. On the second glance, list_del instead of
list_del_rcu should be safe as there should be now other list traversals
at the same time. I'll think about it however.

> 
> > + */
> > +void ieee802154_drop_slaves(struct ieee802154_dev *hw)
> > +{
> > +	struct ieee802154_priv *priv = ieee802154_to_priv(hw);
> > +	struct ieee802154_sub_if_data *sdata, *next;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	list_for_each_entry_safe(sdata, next, &priv->slaves, list) {
> > +		mutex_lock(&sdata->hw->slaves_mtx);
> > +		list_del(&sdata->list);
> > +		mutex_unlock(&sdata->hw->slaves_mtx);
> > +
> > +		dev_put(sdata->hw->netdev);
> > +
> > +		unregister_netdevice(sdata->dev);
> > +	}
> > +}

-- 
With best wishes
Dmitry

