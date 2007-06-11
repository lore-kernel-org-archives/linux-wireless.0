Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbXFKV1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 17:27:54 -0400
Subject: Re: Please pull libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070611201222.GI10397@tuxdriver.com>
References: <1181102122.18061.8.camel@xo-28-0B-88.localdomain>
	 <1181396495.23205.0.camel@xo-28-0B-88.localdomain>
	 <20070611201222.GI10397@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 17:31:51 -0400
Message-Id: <1181597511.6131.2.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-06-11 at 16:12 -0400, John W. Linville wrote:
> On Sat, Jun 09, 2007 at 09:41:35AM -0400, Dan Williams wrote:
> > On Tue, 2007-06-05 at 23:55 -0400, Dan Williams wrote:
> > > Hi,
> > > 
> > > Changes since you last pulled are mainly Christoph-inspired cleanups, a
> > > few bug fixes, mesh scanning, and a few more mesh-specific knobs (though
> > > most likely general to 802.11s implementations, not just the CozyBit
> > > one).
> > > 
> > > Per the email thread with jgarzik from the last pull, everything from
> > > libertas-2.6 'master' branch is currently targeted at _2.6.22_.
> > 
> > Any comments here John?
> 
> Sorry, last week was rather busy...
> 
> > > Dan Williams (24):
> > >       libertas: actually remove version.h
> > >       libertas: kill wlan_scan_process_results
> > >       libertas: kill ieeetypes_capinfo bitfield, use ieee80211.h types
> > >       libertas: rename WLAN_802_11_KEY to enc_key and clean up usage
> > >       libertas: clean up indentation in libertas_association_worker
> > >       libertas: clean up 802.11 IE post-scan handling
> > >       libertas: rename private ioctl constants and clean up ioctl handling
> > >       libertas: remove if_bootcmd.c
> > >       libertas: fix mixed-case abuse in cmd_ds_802_11_scan
> > >       libertas: fix mixed-case abuse in cmd_ds_802_11_ad_hoc_result
> > >       libertas: fix mixed-case abuse in cmd_ds_802_11_ad_hoc_start
> > >       libertas: re-uppercase command defines and other constants
> > >       libertas: fix debug build breakage due to field rename
> > >       libertas: remove thread.h and make kthread usage clearer
> > >       libertas: new mesh control knobs
> > >       libertas: bump version to 322.p1
> > >       libertas: wlan_ -> libertas_ rename in ioctl.c
> > >       libertas: fix more mixed-case abuse
> > >       libertas: move generic firmware reset command to common code
> > >       libertas: wlan_ -> libertas_ function prefix renames for main.c
> > >       libertas: simplify and clean up data rate handling
> > >       libertas: fix MESH_[GET/SET]_BCASTR ioctl, clean up ioctl subcmd handling
> > >       libertas: actually send mesh frames to mesh netdev
> > > 
> > > Luis Carlos Cobo (1):
> > >       libertas: specific mesh scan for mshX interface
> > > 
> > > Luis Carlos Cobo Rus (2):
> > >       libertas: pull current channel from firmware on mesh autostart
> > >       libertas: deauthenticate from AP in channel switch
> 
> Jeff had expressed a willingness to accept the previous batch
> of libertas patches and pass them to Linus for 2.6.22.  However,
> judging by the titles above this patch looks more like clean-ups and
> new development.  Any objection to this batch being targeted at 2.6.23?

Some are pretty important (the 3 from Luis and the bottom 2 from me, and
the "anycast mask" patch from HEAD, for example).  I guess if Jeff
wouldn't mind accepting this set, I'd prefer to push them all for 2.6.22
and be be done with 2.6.22 except for bugfixes.  Otherwise I can give
you a list of commit IDs to cherry-pick or something like that.

Dan


