Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:49294 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBSSIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 13:08:36 -0500
Received: by mail-la0-f43.google.com with SMTP id pv20so556115lab.2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 10:08:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UOT2s84ApFuBbZyjZfGNywV1WeZqHJ6eMtRHzY=15RYA@mail.gmail.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
 <1387486399-4053-4-git-send-email-mcgrof@do-not-panic.com>
 <1389108924.4645.14.camel@jlt4.sipsolutions.net> <CAB=NE6UOT2s84ApFuBbZyjZfGNywV1WeZqHJ6eMtRHzY=15RYA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 19 Feb 2014 10:08:14 -0800
Message-ID: <CAB=NE6Wb0cY=6pmEMvEhLY_CxRjojfTQjAE9sPQh4WWHtbi=QQ@mail.gmail.com> (sfid-20140219_190840_061183_027F9E07)
Subject: Re: [PATCH 3/3] cfg80211: processing regulatory requests on netdev notifier
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 18, 2014 at 5:24 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, Jan 7, 2014 at 7:35 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>>> This adds a trigger to review any pending regulatory
>>> requests whenever an 802.11 device interface is brought
>>> down or up. We use this as an opportunistic trigger
>>> for checking the regulatory work queues as otherwise
>>> they they're only checked upon an initial regulatory
>>> request or when beacon hints are found.
>>>
>>> This opportunistic mechanism can be used to trigger
>>> kicking the queues regulatory queues at any time from
>>> userspace without having to change the regulatory state.
>>
>> I don't like this. Can't we just have a self-contained timeout on the
>> userspace request instead?
>
> Sure I'll add this and send a v2 series.

Come to think of it -- I am not a fan of the timer. What time do we
set for it? What is reasonable? This is what made me instead want to
use the notifier hooks. You shouldn't be able to bring up an interface
without firmware so hence the hook there, the other one upon register
was just another opportunistic one.

Please consider this and if you still think a timer is best let me
know what the timer value should be :D

  Luis
