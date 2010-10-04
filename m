Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab0JDS3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:29:32 -0400
Subject: Re: Putting APs into bridges?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA0D5E.2090700@candelatech.com>
References: <4CAA0D5E.2090700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 20:29:29 +0200
Message-ID: <1286216969.3620.44.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 10:22 -0700, Ben Greear wrote:

> It seems he put two VAPs into a bridge device, and got an
> assert here (nevermind the printk, I just added that to
> help debug the issue).
> 
> static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> 				   enum queue_stop_reason reason)
> {
> 	struct ieee80211_local *local = hw_to_local(hw);
> 	struct ieee80211_sub_if_data *sdata;
> 
> 	trace_wake_queue(local, queue, reason);
> 
> 	if (WARN_ON(queue >= hw->queues)) {
> 		printk(KERN_WARNING "%s:  queue: %i  hw->queues: %i\n",
> 		       sdata->name, queue, hw->queues);
> 		return;
> 	}
> 
> 
> Before I try to reproduce this, it is valid to add APs to bridge
> devices in the first place?

Yes, it's valid, we catch the invalid cases in cfg80211.

Hitting the assert there is rather strange though.

johannes

