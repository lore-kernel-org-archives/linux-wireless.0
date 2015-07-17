Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51766 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbbGQIxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 04:53:18 -0400
Message-ID: <1437123195.1933.1.camel@sipsolutions.net> (sfid-20150717_105432_511102_80A71FF7)
Subject: Re: [PATCH] Clear subdir_stations when stations directory is
 removed (was Re: Null pointer dereference when station associates
 [introduced by 4.0.5?])
From: Johannes Berg <johannes@sipsolutions.net>
To: Tom Hughes <tom@compton.nu>, linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org
Date: Fri, 17 Jul 2015 10:53:15 +0200
In-Reply-To: <5591916D.2080707@compton.nu>
References: <558EC27A.60804@compton.nu>
	 (sfid-20150627_181129_907073_7F8F41EE) <1435565678.2156.9.camel@sipsolutions.net>
	 <55910222.8020906@compton.nu> <55910DC8.9040700@compton.nu>
	 <55911375.3070003@compton.nu> <55911CEA.7010103@compton.nu>
	 <55911DD1.20606@compton.nu> <5591916D.2080707@compton.nu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-29 at 19:41 +0100, Tom Hughes wrote:
> On 29/06/15 11:28, Tom Hughes wrote:
> > On 29/06/15 11:24, Tom Hughes wrote:
> > 
> > > So I think this happens when hostapd switches the interface
> > > to AP mode, which causes the netdev to be torn down and then
> > > recreated, and the debugfs directory along with it.
> > > 
> > > Except that if the netlink message to change the mode was
> > > sent from a daemon whose selinux context prevents searching
> > > debugfs the recreation somehow fails and leaves an invalid
> > > state that later causes the null pointer deref.
> > 
> > Think I have it...
> > 
> > The teardown runs ieee80211_debugfs_remove_netdev
> > which clears sdata->vif.debugfs_dir but does not clear 
> > sdata->debugfs.subdir_stations so that when 
> > ieee80211_debugfs_add_netdev 
> > later fails to create the top level
> > netdev directory we are left with a bogus pointer for the stations 
> > directory.
> > 
> > Then when we try and add an entry to the stations directory things 
> > blow up.
> 
> Here's a proposed patch. I have booted 4.0.6 with this applied and so 
> far
> it hasn't failed even with selinux in enforcing mode.
> 
> commit 30624496e9f411081d7ea1a407deabe0e32d0c62
> Author: Tom Hughes <tom@compton.nu>
> Date:   Mon Jun 29 11:31:04 2015 +0100
> 
>     Clear subdir_stations when stations directory is removed
>     
>     If we don't do this, and we then fail to recreate the debugfs
>     directory during a mode change, then we will fail later trying
>     to add stations to this now bogus directory:
>     
>     BUG: unable to handle kernel NULL pointer dereference at 0000006c
>     IP: [<c0a92202>] mutex_lock+0x12/0x30
>     Call Trace:
>     [<c0678ab4>] start_creating+0x44/0xc0
>     [<c0679203>] debugfs_create_dir+0x13/0xf0
>     [<f8a938ae>] ieee80211_sta_debugfs_add+0x6e/0x490 [mac80211]
>     
>     Signed-off-by: Tom Hughes <tom@compton.nu>
> 

Applied.

johannes
