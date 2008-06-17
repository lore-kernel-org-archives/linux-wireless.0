Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43198 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbYFQHdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 03:33:10 -0400
Date: Tue, 17 Jun 2008 10:32:27 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Management frame protection and packet injection from hostapd
Message-ID: <20080617073227.GA4974@jm.kir.nu> (sfid-20080617_093314_431761_3E599CEB)
References: <20080616143308.GB18479@jm.kir.nu> <1213627991.3803.38.camel@johannes.berg> <20080616153421.GC18479@jm.kir.nu> <1213634684.3803.43.camel@johannes.berg> <1213634868.3803.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213634868.3803.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 06:47:48PM +0200, Johannes Berg wrote:

> > > Yes, that sounds likely since the changes I did for debugfs were very
> > > trivial copies from CCMP/data-default-key processing. I'll debug this
> > > more and try to figure if there is need to re-order something or make
> > > the debugfs entry removal able to handle such a case.
> > 
> > Ok. I don't know right now, and it does seem to work correctly here, but
> > maybe it doesn't when the application doesn't explicitly remove the key
> > or something, I'll take a look.
> 
> It's definitely done, from ieee80211_free_keys() calling
> ieee80211_debugfs_key_remove_default(), maybe you missed something
> there?

I did.. I added another set of functions for default management key and
did not remember to call the removal function from
ieee80211_free_keys(). However, adding that call did not change
anything.

It looks like we end up trying to remove the netdev directory in debugfs
before removing the default key symlinks. Consequently, debugfs_remove()
fails since there is still a file in the directory. This is what happens
when removing the monitor interface:

cfg.c: ieee80211_del_iface() ->
iface.c: ieee80211_if_remove() ->
iface.c: __ieee80211_if_del() ->
debugfs_netdev.c: ieee80211_debugfs_remove_netdev()
    [too early; symlink still there]
unregister_netdevice(dev) -> [dev->uninit]
iface.c: ieee80211_if_reinit() ->
key.c: ieee80211_free_keys() ->
debugfs_key.c: ieee80211_debugfs_key_remove_default()


Any idea how to fix this? Why is ieee80211_debugfs_remove_netdev() call
in __ieee80211_if_del()? Could it be moved into ieee80211_if_reinit(),
so that it would happen only after the ieee80211_free_keys() call? Since
ieee80211_if_reinit() is called from other places, too, it might be
cleaner to define a new dev->uninit function that is a wrapper for call
to ieee80211_if_reinit() followed by call to
ieee80211_debugfs_remove_netdev().. However, since ieee80211_if_reinit()
calls ieee80211_if_sdata_deinit(), it might be necessary to call
ieee80211_debugfs_remove_netdev() before this call (or from it?); I did
not yet look into details of what would be the required order for these.

-- 
Jouni Malinen                                            PGP id EFC895FA
