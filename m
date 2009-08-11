Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38260 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZHKUXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:23:46 -0400
Date: Wed, 12 Aug 2009 00:23:04 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sergey Lapin <slapin@ossfans.org>
Subject: Re: [PATCH 1/2] mac802154: add a software MAC 802.15.4
 implementation
Message-ID: <20090811202304.GA6303@doriath.ww600.siemens.net>
References: <1249913800-10176-1-git-send-email-dbaryshkov@gmail.com>
 <1249913800-10176-2-git-send-email-dbaryshkov@gmail.com>
 <1249914466.32614.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249914466.32614.13.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 04:27:46PM +0200, Johannes Berg wrote:
> On Mon, 2009-08-10 at 18:16 +0400, Dmitry Eremin-Solenikov wrote:
> > + * @tx: Handler that 802.15.4 module calls for each transmitted frame.
> > + *      skb cntains the buffer starting from the IEEE 802.15.4 header.
> > + *      The low-level driver should send the frame based on available
> > + *      configuration.
> > + *      This function should return zero or negative errno.
> 
> That return value is strange.

The idea is that tx function can return info about errors during
transmit (busy channel, no ACK, etc).

> 
> > +++ b/net/Makefile
> > @@ -61,6 +61,7 @@ ifneq ($(CONFIG_DCB),)
> >  obj-y				+= dcb/
> >  endif
> >  obj-y				+= ieee802154/
> > +obj-y				+= mac802154/
> 
> I think you should use obj-$(CONFIG_MAC802154) as there's no need to
> recurse into the dir unless that's selected.

fixed.

> 
> But does it make sense to actually have this little code as a separate
> dir/module?

The submitted patch is only a part of written MAC code. And we still
aren't feature complete. Is there any sence in keeping mac80211
separate? IMHO yes. Same goes for mac802154.

> > +	struct net_device *netdev; /* mwpanX device */
> > +	int open_count;
> > +	/* As in mac80211 slaves list is modified:
> > +	 * 1) under the RTNL
> > +	 * 2) protected by slaves_mtx;
> > +	 * 3) in an RCU manner
> > +	 *
> > +	 * So atomic readers can use any of this protection methods
> > +	 */
> > +	struct list_head	slaves;
> 
> heh.

? C&p from mac80211 mostly :)

> 
> > +static int ieee802154_master_open(struct net_device *dev)
> > +{
> 
> We've had no end to trouble with the master netdev, I suggest you look
> into the current mac80211 code and see if you can get rid of it.

What troubles w/ master netdev did you have had? I do still see the
master devices in mac80211. IIUC, it's planned to replace (from
management point of view) the mdev with wiphy instance, isn't it?

> > +struct ieee802154_dev *ieee802154_alloc_device(size_t priv_size,
> > +		struct ieee802154_ops *ops)
> > +{
> 
> > +	if (!try_module_get(ops->owner)) {
> 
> That isn't necessary since the module is just calling your function. In
> fact, doing this removes the ability to rmmod any module using this
> which is bogus.

Hmm. I thought that one may be able to rmmod the module w/ ops while the
device is still hanging in the system. On the other hand, ops are
provided by the driver, so if one rmmods the driver and the device is
still there, it's a bug...
Removing now.

-- 
With best wishes
Dmitry

