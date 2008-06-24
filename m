Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:34089 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbYFXJdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:33:07 -0400
Received: by py-out-1112.google.com with SMTP id p76so1301986pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 02:33:07 -0700 (PDT)
Message-ID: <a32f33a40806240233i7bb61a3tc88732a837f7666c@mail.gmail.com> (sfid-20080624_113312_415599_3D0C0CA2)
Date: Tue, 24 Jun 2008 11:33:06 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: workqueue & RTNL lock
Cc: "Michael Buesch" <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214299693.8967.273.camel@johannes.berg>
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
	 <a32f33a40806240220s3ef070bdr591d4775ee57cb81@mail.gmail.com>
	 <1214299693.8967.273.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > However, the interface iterator will simply not run at all if ->stop has
>> > already succeeded since no interfaces would be UP, so you don't really
>> > have to protect it against that, you only have to make sure it's not
>> > running when you unregister your hardware struct, and _that_ doesn't
>> > have the rtnl taken so you can use cancel_work_sync() there.
>>
>> True, but the race condition happens when ieee80211_stop() is called,
>> and the rt2x00 work is triggered before before
>> rt2x00->remove_interface() or rt2x00>stop() is called. when stop() is
>> then called it cannot use cancel_work_sync() because
>> the work structure is waiting until stop() has completed which will
>> not end until cancel_work_sync() has completed.
>
> No, but I'm saying that ->stop doesn't need to cancel_work_sync(). You
> should have a work struct that you exclusively use for whatever you need
> to do with interfaces, so the code looks something like this:
>
> void work(...)
> {
> 	iterate_interfaces();
> }
>
> maybe with some additional locking. You also use schedule_work() and not
> the mac80211-provided workqueue.
>
> This work will do exactly nothing if triggered before ->stop and running
> after ->stop because all interfaces will be gone. Hence, you don't need
> to cancel it in ->stop, you don't care whether it'll run or not.
>
> Hence, the only thing you need to take care of is that it's canceled
> before unregister_hw(), and for that you can use cancel_work_sync().

Ah yes, I understand what you mean now. That would indeed work, I'll get
a patch ready that does exactly that.

> Am I missing something?

Nope, I was missing something. ;)

Thanks.

Ivo
