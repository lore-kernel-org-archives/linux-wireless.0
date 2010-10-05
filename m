Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:37238 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753728Ab0JEDnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 23:43:47 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-093520224
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 12:43:45 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Putting APs into bridges?
Date: Tue, 5 Oct 2010 12:43:45 +0900
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CAA0D5E.2090700@candelatech.com> <1286216969.3620.44.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286216969.3620.44.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010051243.45190.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue October 5 2010 03:29:29 Johannes Berg wrote:
> On Mon, 2010-10-04 at 10:22 -0700, Ben Greear wrote:
> > It seems he put two VAPs into a bridge device, and got an
> > assert here (nevermind the printk, I just added that to
> > help debug the issue).
> > 
> > static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> > 
> > 				   enum queue_stop_reason reason)
> > 
> > {
> > 
> > 	struct ieee80211_local *local = hw_to_local(hw);
> > 	struct ieee80211_sub_if_data *sdata;
> > 	
> > 	trace_wake_queue(local, queue, reason);
> > 	
> > 	if (WARN_ON(queue >= hw->queues)) {
> > 	
> > 		printk(KERN_WARNING "%s:  queue: %i  hw->queues: %i\n",
> > 		
> > 		       sdata->name, queue, hw->queues);
> > 		
> > 		return;
> > 	
> > 	}
> > 
> > Before I try to reproduce this, it is valid to add APs to bridge
> > devices in the first place?
> 
> Yes, it's valid, we catch the invalid cases in cfg80211.
> 
> Hitting the assert there is rather strange though.

hey!

i'm seeing the same. i think it's due to a bug in ath5k concerning power save. 
we put frames in the CAB queue, but obviously we shouldn't tell mac80211 to 
wake this queue (number 6) since mac80211 knows nothing about it.

bruno
