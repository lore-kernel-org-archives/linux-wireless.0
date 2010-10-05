Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:42050 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753717Ab0JED41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 23:56:27 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-053746984
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 12:56:25 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Putting APs into bridges?
Date: Tue, 5 Oct 2010 12:56:25 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CAA0D5E.2090700@candelatech.com> <201010051243.45190.br1@einfach.org> <4CAA9F60.9030207@candelatech.com>
In-Reply-To: <4CAA9F60.9030207@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010051256.25246.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue October 5 2010 12:45:36 Ben Greear wrote:
> On 10/04/2010 08:43 PM, Bruno Randolf wrote:
> > On Tue October 5 2010 03:29:29 Johannes Berg wrote:
> >> On Mon, 2010-10-04 at 10:22 -0700, Ben Greear wrote:
> >>> It seems he put two VAPs into a bridge device, and got an
> >>> assert here (nevermind the printk, I just added that to
> >>> help debug the issue).
> >>> 
> >>> static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
> >>> 
> >>> 				   enum queue_stop_reason reason)
> >>> 
> >>> {
> >>> 
> >>> 	struct ieee80211_local *local = hw_to_local(hw);
> >>> 	struct ieee80211_sub_if_data *sdata;
> >>> 	
> >>> 	trace_wake_queue(local, queue, reason);
> >>> 	
> >>> 	if (WARN_ON(queue>= hw->queues)) {
> >>> 	
> >>> 		printk(KERN_WARNING "%s:  queue: %i  hw->queues: %i\n",
> >>> 		
> >>> 		       sdata->name, queue, hw->queues);
> >>> 		
> >>> 		return;
> >>> 	
> >>> 	}
> >>> 
> >>> Before I try to reproduce this, it is valid to add APs to bridge
> >>> devices in the first place?
> >> 
> >> Yes, it's valid, we catch the invalid cases in cfg80211.
> >> 
> >> Hitting the assert there is rather strange though.
> > 
> > hey!
> > 
> > i'm seeing the same. i think it's due to a bug in ath5k concerning power
> > save. we put frames in the CAB queue, but obviously we shouldn't tell
> > mac80211 to wake this queue (number 6) since mac80211 knows nothing
> > about it.
> 
> Interesting...we couldn't reproduce it at all (two APs in a bridge worked
> as expected, as far as we could tell).

i think this has nothing to do with bridges. i can get the same problem with a 
single AP interface. i can reproduce it by connecting 2 STA, one of which has 
to use power-save. i'll come up with a simple patch soon.

bruno
