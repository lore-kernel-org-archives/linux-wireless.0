Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40842 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752788AbYJGWwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 18:52:46 -0400
Date: Tue, 7 Oct 2008 17:52:45 -0500
From: Robin Holt <holt@sgi.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Robin Holt <holt@sgi.com>, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
Message-ID: <20081007225245.GN8534@sgi.com> (sfid-20081008_005250_512572_9CA8F916)
References: <20081004103144.GI8534@sgi.com> <1223165956.24551.76.camel@johannes.berg> <20081005023143.GJ8534@sgi.com> <1223195921.24551.79.camel@johannes.berg> <20081006064509.GK8534@sgi.com> <1223283470.24551.86.camel@johannes.berg> <20081006133045.GM8534@sgi.com> <1223330976.3778.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223330976.3778.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 12:09:36AM +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 08:30 -0500, Robin Holt wrote:
> 
> > I didn't really need to do much for the printk's in
> > ieee80211_sta_debugfs_add().  My printk's in sta_info_debugfs_add_work()
> > already told me that sta->local->debugfs.stations is NULL.  
> 
> Well yes, but I wanted to know why ieee80211_sta_debugfs_add() doesn't
> set debugfs.stations to non-NULL.
> 
> > Again, this
> > is iwl3945 only after a suspend of a few minutes followed by a resume.
> > It happens about 1/3 of the time.
> 
> Ok, I have a new suspicion: there seems to be a race condition between
> destroying a station (sta_info_destroy) which removes it from debugfs,
> and creating a new one with the same MAC address which will ask the
> workqueue to add it to debugfs. It clearly is actually possible to run
> sta_info_insert(sta2) and consequently sta_info_debugfs_add_work before
> sta_info_destroy(sta1), but when they both have the same MAC address
> then ieee80211_sta_debugfs_add has to fail.
> 
> I don't see much we can do against this, the patch I posted is
> definitely needed just in case debugfs gets a new failure mode any time
> in the future so I'll post it for inclusion, and the race condition I
> described just means that the sta2 won't be in debugfs at all...

That race seems more plausible.

On a seperate note, I got a panic with your earlier patch applied at:
IP: [<f8c669df>] :mac80211:netdev_notify+0x5f/0x90

Not sure if that is just exposed by the hangs being out of the way.  I
hand wrote that part.  Nothing else got captured in the logs :(

Thanks,
Robin
