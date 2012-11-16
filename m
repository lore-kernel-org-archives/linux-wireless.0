Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58462 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KPIvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 03:51:02 -0500
Received: by mail-vc0-f174.google.com with SMTP id fk26so2606709vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2012 00:51:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353055762.9490.0.camel@jlt4.sipsolutions.net>
References: <1353055599-8332-1-git-send-email-eliad@wizery.com>
	<1353055762.9490.0.camel@jlt4.sipsolutions.net>
Date: Fri, 16 Nov 2012 10:51:00 +0200
Message-ID: <CAB3XZEezU0DTkhQQsRs06GSbSnWTkMof_PYX9ppXjyMHkguF6g@mail.gmail.com> (sfid-20121116_095106_683453_DCEAC01E)
Subject: Re: [PATCH] mac80211: fix invalid kfree on sched scan
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2012 at 10:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-11-16 at 10:46 +0200, Eliad Peller wrote:
>> Commit 30dd3ed ("mac80211: don't hang on to sched_scan_ies")
>> converted sched_scan_ies to a local variable.
>> However, since it wasn't initialized, in a case of
>> unsupported band, sched_scan_ies.ie[] was uninitialized,
>> and freeing it could corrupt the memory.
>>
>> Fix it by simply initializing sched_scan_ies to 0.
>
> Yep, already have that in the tree :-)
>
> commit bca1e29fb54c51856dda6772d488d41b10ed91da
> Author: David Spinadel <david.spinadel@intel.com>
> Date:   Mon Oct 29 14:49:41 2012 +0200
>
>     mac80211: init sched_scan_ies
>
>
oops... sorry :)

Eliad.
