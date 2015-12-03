Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34159 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbbLCUVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 15:21:33 -0500
Message-ID: <1449174081.31265.3.camel@sipsolutions.net> (sfid-20151203_212138_334045_9AA12B0C)
Subject: Re: Can we increase IEEE80211_MAX_QUEUES
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 03 Dec 2015 21:21:21 +0100
In-Reply-To: <5660A31E.3010507@candelatech.com> (sfid-20151203_211637_306021_AF98F120)
References: <5660A31E.3010507@candelatech.com>
	 (sfid-20151203_211637_306021_AF98F120)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 12:16 -0800, Ben Greear wrote:
> ath10k wants to use vdev-id as a queue-id, and I want to support up
> to
> 64 vdevs.  In the 4.2 kernel, this is causing splats when using lots
> of
> vdevs because then queue is out of range.
> 
> Can we just increase IEEE80211_MAX_QUEUES to 64?
> 

I think not, that would likely cause a lot of data structures to grow
too much. We'd have to do more dynamic things in that case, I suppose.

Does the original premise even make sense though? A single queue for
each vdev seems a bit strange.

johannes
