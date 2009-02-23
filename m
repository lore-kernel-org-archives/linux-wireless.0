Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:32494 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZBWNXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 08:23:15 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1487520fkf.5
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 05:23:13 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ieee80211_scan_completed() calling config() and possible deadlock
References: <87vdr1717z.fsf@litku.valot.fi> <200902231413.49289.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 23 Feb 2009 15:23:09 +0200
In-Reply-To: <200902231413.49289.mb@bu3sch.de> (Michael Buesch's message of "Mon\, 23 Feb 2009 14\:13\:49 +0100")
Message-ID: <87r61p70ea.fsf@litku.valot.fi> (sfid-20090223_142318_819575_FF4888FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

>> I'm just wondering what's the right way(tm) to handle this. I see
>> two options:
>> 
>> 1. Consider the (possible) deadlock as a feature, document it and
>> let the drivers handle it. This is relatively easy.
>> 
>> 2. Handle this in mac80211 (eg. schedule a workqueue) and drivers
>> don't need to care. This might complicate mac80211 implementation a
>> bit, but easier for the drivers.
>> 
>> I myself cannot decide which one is better. What do people think?
>> 
>
> I think drivers should not be able to call ieee80211_scan_completed()
> directly. Instead they should call a function which schedules
> ieee80211_scan_completed() on a workqueue.

Yes, that was my option two.

> In general I consider it broken behavior, if a function called by
> the driver can recurse into the driver. We had that behavior in
> ieee80211-softmac and it was one of the main reasons it sucked so
> much.

Ok, this is a very strong argument in favor of option 2.

> The wq schedule code is trivial to implement in mac80211 and it's also
> OK to do so. The function is not required to execute synchronously.

I'm leaning on option two then. Thanks for the feedback!

-- 
Kalle Valo
