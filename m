Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43436 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1FATBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 15:01:13 -0400
Date: Wed, 1 Jun 2011 14:58:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] mac80211: stop queues before rate control updation
Message-ID: <20110601185859.GF2509@tuxdriver.com> (sfid-20110601_210117_967685_89E4D264)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
 <1305894135-14036-6-git-send-email-rmanoharan@atheros.com>
 <1306823717.9366.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1306823717.9366.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 08:35:17AM +0200, Johannes Berg wrote:
> On Fri, 2011-05-20 at 17:52 +0530, Rajkumar Manoharan wrote:
> > Stop tx queues before updating rate control to ensure
> > proper rate selection. Otherwise packets can be transmitted
> > in 40 Mhz whereas hw is configured in HT20.
> 
> Looks like I completely missed this since you hid it in an ath9k
> patchset. DON'T DO THAT.
> 
> Anyway, John, please revert. This is completely useless. Not only is
> abusing the CSA stop reason a show-stopper, the whole patch is also just
> not right, it seems like a workaround around a rate control algorithm
> that isn't able to do an atomic HT change by itself. Also, it won't even
> do what you want, there may be packets being processed concurrently
> while stopping the queue -- calling stop_queues() is no guarantee that
> no packet will be processed afterwards.

Rajkumar, do you have an alternative fix to propose?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
