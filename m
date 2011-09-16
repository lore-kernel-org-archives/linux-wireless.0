Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1IPOIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 10:08:37 -0400
Subject: Re: [PATCH] rfkill: properly assign a boolean type
From: Johannes Berg <johannes@sipsolutions.net>
To: mohammed <mohammed@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4E735701.9080609@qca.qualcomm.com>
References: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1316180237.4130.37.camel@jlt3.sipsolutions.net>
	 <4E7354D8.40507@qca.qualcomm.com>
	 <1316181679.4130.38.camel@jlt3.sipsolutions.net>
	 <4E735701.9080609@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Sep 2011 16:08:29 +0200
Message-ID: <1316182109.4130.39.camel@jlt3.sipsolutions.net> (sfid-20110916_160841_106227_78265597)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-16 at 19:32 +0530, mohammed wrote:
> On Friday 16 September 2011 07:31 PM, Johannes Berg wrote:
> > On Fri, 2011-09-16 at 19:23 +0530, mohammed wrote:
> >
> >>>> @@ -235,7 +235,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
> >>>>    	else
> >>>>    		rfkill->state&= ~RFKILL_BLOCK_HW;
> >>>>    	*change = prev != blocked;
> >>>> -	any = rfkill->state&   RFKILL_BLOCK_ANY;
> >>>> +	any = !!(rfkill->state&   RFKILL_BLOCK_ANY);
> >>>
> >>> I believe this is not necessary since "any" is a "bool" and as such
> >>> should cast correctly to 0/1.
> >
> >> I agree the older one works perfectly fine. I stumbled upon this when i
> >> was trying to understand rfkill. but will not this change make it look
> >> better ? if it looks like a too trivial please drop it. Thanks!
> >
> > Sure, whatever, I don't care; we can change it, but I think it'll
> > generate exactly the same code :)
> 
> oh ok, thanks.

Sure. I just wanted to clarify that it was to make the coder nicer, not
to fix a bug or so.

johannes

