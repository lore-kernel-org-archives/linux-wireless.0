Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:45639 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759847AbYHEMZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 08:25:14 -0400
Date: Tue, 5 Aug 2008 08:24:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] wireless : cpu stuck for 61s
Message-ID: <20080805122408.GA5000@hash.localnet> (sfid-20080805_142521_101194_2FE7F309)
References: <20080729055731.GA3265@darkstar> <1217334724.10489.47.camel@johannes.berg> <20080730020820.8bcc00e2.akpm@linux-foundation.org> <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com> <20080730031047.54e13e2d.akpm@linux-foundation.org> <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com> <4896D34A.1000005@gmail.com> <a8e1da0808041829sac34939yd9163b02e6b8b515@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a8e1da0808041829sac34939yd9163b02e6b8b515@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 05, 2008 at 09:29:26AM +0800, Dave Young wrote:
> With the patch I cann't reproduce the bug with 27-rc1 now.
> 
> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
> >  [<c02375a6>] ? debugfs_create_file+0x46/0x210
> >  [<c02375a6>] debugfs_create_file+0x46/0x210
> >  [<c02377f1>] debugfs_create_dir+0x21/0x30
> >  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
> >  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
> >  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]

I wonder if there were two separate problems here.  I looked into
this with some detail yesterday and agree with Johannes that the above 
trace is on locking the parent directory's i_mutex, but I too couldn't
see any problems with sta_info_debugfs_add_work.  Other stuff could also 
modify the directory with or without rtnl_lock, but not in a way that 
to my untrained eyes would lead to deadlock.

Or is the trace just wrong?

-- 
Bob Copeland %% www.bobcopeland.com

