Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51372 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753135AbYJFNar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:30:47 -0400
Date: Mon, 6 Oct 2008 08:30:45 -0500
From: Robin Holt <holt@sgi.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Robin Holt <holt@sgi.com>, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
Message-ID: <20081006133045.GM8534@sgi.com> (sfid-20081006_153055_191918_490CEC31)
References: <20081004103144.GI8534@sgi.com> <1223165956.24551.76.camel@johannes.berg> <20081005023143.GJ8534@sgi.com> <1223195921.24551.79.camel@johannes.berg> <20081006064509.GK8534@sgi.com> <1223283470.24551.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223283470.24551.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 10:57:50AM +0200, Johannes Berg wrote:
> Your config doesn't seem anything out of the ordinary, would you add a
> few printks to ieee80211_sta_debugfs_add to see where it drops out?
> Either way though, we should handle errors from debugfs_create_dir()
> which this patch boils down to.

I didn't really need to do much for the printk's in
ieee80211_sta_debugfs_add().  My printk's in sta_info_debugfs_add_work()
already told me that sta->local->debugfs.stations is NULL.  Again, this
is iwl3945 only after a suspend of a few minutes followed by a resume.
It happens about 1/3 of the time.

Thanks,
Robin
