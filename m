Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43114 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbbEZNQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:16:44 -0400
Message-ID: <1432646202.5169.5.camel@sipsolutions.net> (sfid-20150526_151720_794429_FD099CA7)
Subject: Re: [PATCH wireless-next] mac80211: fix double flush workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: linux-wireless@vger.kernel.org, Varka Bhadram <varkab@cdac.in>
Date: Tue, 26 May 2015 15:16:42 +0200
In-Reply-To: <55629ECA.9050203@gmail.com> (sfid-20150525_060243_179517_FED893DC)
References: <1431671210-6761-1-git-send-email-varkab@cdac.in>
		 (sfid-20150515_082729_656523_7D208EC4) <1432020391.7437.2.camel@sipsolutions.net>
	 <55629ECA.9050203@gmail.com> (sfid-20150525_060243_179517_FED893DC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-25 at 09:32 +0530, Varka Bhadram wrote:

> Initially flushing of workqueue is done at [1], and also flushing of the same workqueue
> has done with ieee80211_stop_device() at [2].
> 
> [1]:https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/pm.c#n50
> [2]:https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211-next.git/tree/net/mac80211/pm.c#n154

I *know*, I wrote much of this code. But there are so many things
between these two points that you'll have to try FAR harder to convince
me that removing any one these calls is actually a good idea.

johannes

