Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:45011 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYFXJDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:03:25 -0400
Received: by py-out-1112.google.com with SMTP id p76so1294497pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 02:03:24 -0700 (PDT)
Message-ID: <a32f33a40806240203w29d0caf7p6e2956d82d48e013@mail.gmail.com> (sfid-20080624_110354_390878_8C1820A5)
Date: Tue, 24 Jun 2008 11:03:24 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: workqueue & RTNL lock
Cc: "Michael Buesch" <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214297515.8967.253.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806230042.41219.IvDoorn@gmail.com>
	 <200806230030.42776.mb@bu3sch.de>
	 <a32f33a40806230130t11022b31p3d9997ab5e449fe6@mail.gmail.com>
	 <200806231120.41519.mb@bu3sch.de>
	 <a32f33a40806230417i68e4d19aj76a481d7dbf2c611@mail.gmail.com>
	 <1214297515.8967.253.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/24/08, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-23 at 13:17 +0200, Ivo Van Doorn wrote:
>
>> Well it was caused by the recent introduction of the interface iterator.
>> Question now is if we need to restrict the usage, remove the
>> flush_workqueue,
>> or change the locking in the interface iterator. :S
>
> Ouch. Any way you can use the atomic iterator there?

No because of rt2500usb and rt73usb who need scheduling,
and this bug is in exactly the same function as before where we had
the scheduling while atomic problem when you introduced the atomic iterator. ;)

> Or if not, can you use schedule_work and cancel_work_sync to take care
> of things?

I thought about that it cancel_work_sync will cause exactly the same problem,
stop() holds the rtnl lock, rt2x00 work waits for rtnl lock, mac80211
calls stop(), rt2x00 waits until tasks are completed but one of those
is still waiting on the rtnl lock.

However I could use the non-synchronized version for cancelling the work
and add a check to see if the work should be cancelled within the
rtnl-protected area.

> I would like to keep the mac80211 workqueue rtnl-free because
> otherwise locking is going to get ugly.

We need a big warning in mac80211.h then that tells that the non-atomic iterator
or any other rtnl locking cannot be used in the mac80211 workqueue.

Ivo
