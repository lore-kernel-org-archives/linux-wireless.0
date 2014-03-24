Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44073 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaCXOwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 10:52:45 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so5888513oag.23
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 07:52:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5330420E.7020204@broadcom.com>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-4-git-send-email-michal.kazior@tieto.com>
	<5330420E.7020204@broadcom.com>
Date: Mon, 24 Mar 2014 15:52:44 +0100
Message-ID: <CA+BoTQm2eJFNTN06RdDVGmnLKyOyJaiuwGZ3+t1TgOCnxyQNbw@mail.gmail.com> (sfid-20140324_155255_861544_896C1870)
Subject: Re: [PATCH v2 3/4] cfg80211: export interface stopping function
From: Michal Kazior <michal.kazior@tieto.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 15:32, Arend van Spriel <arend@broadcom.com> wrote:
> On 21/03/14 14:31, Michal Kazior wrote:

[...]

>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -748,23 +748,23 @@ void cfg80211_update_iface_num(struct
>> cfg80211_registered_device *rdev,
>>                 rdev->num_running_monitor_ifaces += num;
>>   }
>>
>> -void cfg80211_leave(struct cfg80211_registered_device *rdev,
>> -                   struct wireless_dev *wdev)
>> +void __cfg80211_leave(struct cfg80211_registered_device *rdev,
>> +                     struct wireless_dev *wdev)
>>   {
>>         struct net_device *dev = wdev->netdev;
>>
>>         ASSERT_RTNL();
>
>
> If you have the assert check here do you need to do it from the call sites
> as well?

I just tend to propagate lockdeps asserts up. It's easier to get the
idea of locking at a quick glance and it causes lockdep to splat
sooner if you have lots of conditionals (i.e. before you hit a very
specific if-else-codepath). I'll remove this redundancy when I re-spin
unless someone objects?


>> +       ASSERT_WDEV_LOCK(wdev);
>
>
> So you are changing behaviour here by requiring the wdev to be locked.

It doesn't change much in practice. Notice that prior to the patch all
switch-cases performed wdev_lock() already (either on site, or callees
did that immediately). This simply moves the locking outside the
__cfg80211_leave() so it's possible to call it from the event worker.
__cfg80211_stop_sched_scan() doesn't care about wdev lock so it's okay
I guess?


Michał
