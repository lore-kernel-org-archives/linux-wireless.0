Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:61090 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBSBZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 20:25:16 -0500
Received: by mail-lb0-f178.google.com with SMTP id u14so13041496lbd.9
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 17:25:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389108924.4645.14.camel@jlt4.sipsolutions.net>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
 <1387486399-4053-4-git-send-email-mcgrof@do-not-panic.com> <1389108924.4645.14.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 18 Feb 2014 17:24:55 -0800
Message-ID: <CAB=NE6UOT2s84ApFuBbZyjZfGNywV1WeZqHJ6eMtRHzY=15RYA@mail.gmail.com> (sfid-20140219_022521_078743_E2AE658D)
Subject: Re: [PATCH 3/3] cfg80211: processing regulatory requests on netdev notifier
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 7:35 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>> This adds a trigger to review any pending regulatory
>> requests whenever an 802.11 device interface is brought
>> down or up. We use this as an opportunistic trigger
>> for checking the regulatory work queues as otherwise
>> they they're only checked upon an initial regulatory
>> request or when beacon hints are found.
>>
>> This opportunistic mechanism can be used to trigger
>> kicking the queues regulatory queues at any time from
>> userspace without having to change the regulatory state.
>
> I don't like this. Can't we just have a self-contained timeout on the
> userspace request instead?

Sure I'll add this and send a v2 series.

  Luis
