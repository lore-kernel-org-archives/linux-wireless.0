Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:25327 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYFXJU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:20:29 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7539150rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 02:20:29 -0700 (PDT)
Message-ID: <a32f33a40806240220s3ef070bdr591d4775ee57cb81@mail.gmail.com> (sfid-20080624_112033_393550_9179C0E8)
Date: Tue, 24 Jun 2008 11:20:28 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: workqueue & RTNL lock
Cc: "Michael Buesch" <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214298658.8967.266.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
	 <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com>
	 <1214297515.8967.253.camel@johannes.berg>
	 <a32f33a40806240203w29d0caf7p6e2956d82d48e013@mail.gmail.com>
	 <1214298658.8967.266.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > Or if not, can you use schedule_work and cancel_work_sync to take care
>> > of things?
>>
>> I thought about that it cancel_work_sync will cause exactly the same
>> problem,
>> stop() holds the rtnl lock, rt2x00 work waits for rtnl lock, mac80211
>> calls stop(), rt2x00 waits until tasks are completed but one of those
>> is still waiting on the rtnl lock.
>>
>> However I could use the non-synchronized version for cancelling the work
>> and add a check to see if the work should be cancelled within the
>> rtnl-protected area.
>
> Oh, right, your work is actually taking the RTNL. We will not get the
> ->stop callback rtnl-free no matter what we do. And we can probably not
> even get it free of whatever lock we need for the netdev list either
> way...
>
> However, the interface iterator will simply not run at all if ->stop has
> already succeeded since no interfaces would be UP, so you don't really
> have to protect it against that, you only have to make sure it's not
> running when you unregister your hardware struct, and _that_ doesn't
> have the rtnl taken so you can use cancel_work_sync() there.

True, but the race condition happens when ieee80211_stop() is called,
and the rt2x00 work is triggered before before
rt2x00->remove_interface() or rt2x00>stop() is called. when stop() is
then called it cannot use cancel_work_sync() because
the work structure is waiting until stop() has completed which will
not end until cancel_work_sync() has completed.

>> > I would like to keep the mac80211 workqueue rtnl-free because
>> > otherwise locking is going to get ugly.
>>
>> We need a big warning in mac80211.h then that tells that the non-atomic
>> iterator
>> or any other rtnl locking cannot be used in the mac80211 workqueue.
>
> Agreed, care to prepare a patch?

Sure, as soon as get home I'll write the patch. :)

Ivo
