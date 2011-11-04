Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1KDOmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:42:55 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB2DACE.2000707@candelatech.com>
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAFAA7.8090403@candelatech.com>
	 (sfid-20111028_205543_472872_4928ADE0) <1320220415.3950.1.camel@jlt3.sipsolutions.net>
	 <4EB17103.70506@candelatech.com>
	 <1320256263.7846.3.camel@jlt3.sipsolutions.net>
	 <4EB22EE6.3030100@candelatech.com>
	 <1320309058.3950.7.camel@jlt3.sipsolutions.net>
	 <4EB2DACE.2000707@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 15:42:51 +0100
Message-ID: <1320417771.3969.90.camel@jlt3.sipsolutions.net> (sfid-20111104_154257_724298_B074BE2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 11:17 -0700, Ben Greear wrote:

> So back to the capabilities flag like I added in the -v2 patch?
> Do you want one flag for each thing (set-mcs, disable-ht,
> disable-ht40, set-mpdu, set-msdu), or maybe one flag for all of
> this:  set-ht-cap

I think maybe a single one would be sufficient, but you'd still have no
way of knowing what is actually supported for changing. Maybe you could
advertise an ht_mask of things that can be changed?

> My opinion remains that we should silently ignore un-supported
> values..this way user-space works with the same config on old and new
> kernels.  In future patches, we can report the actual settings via
> netlink or similar.
> 
> But, I can add logic in user-space to detect kernel versions and
> such and deal with this.

Then you also wouldn't have to muck around with kernel version detection
etc. you could just query the mask of things that can be changed.

johannes

