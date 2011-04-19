Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52724 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1DSHpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 03:45:17 -0400
Date: Tue, 19 Apr 2011 09:48:09 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 1/4] mwl8k: Do not stop tx queues
Message-ID: <20110419074809.GJ1897@wantstofly.org>
References: <1303191772-4299-1-git-send-email-nishants@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303191772-4299-1-git-send-email-nishants@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 11:12:49AM +0530, Nishant Sarmukadam wrote:

> From: Pradeep Nemavat <pnemavat@marvell.com>
> 
> This is in preparation to support life time expiry of packets in the
> hardware to avoid head-of-line blocking where a slow client can
> hog a tx queue and affect the traffic to a faster client from the same
> queue. Time stamp the packets in driver to allow dropping them in the
> hardware if they are queued for more than 500ms.
> 
> Since queues are not being stopped now, we need to be prepared for
> a situation where packets hit the driver after the queues are full.
> Drop all such packets in the driver itself.

What this patch seems to do is: don't propagate queue start/stop
indications to mac80211, and if a packet is handed to mwl8k for
transmission while a TX queue is full, just drop it in the driver.
(This doesn't seem to correspond with the commit message.)

But since the driver still has an accurate idea of TX queue fullness
(i.e. it's not as if at transmit time, you go and transparently reclaim
TX queue entries), why do you need to start/stop mac80211 TX queues at
all?  Won't it still work fine without deleting that logic?
