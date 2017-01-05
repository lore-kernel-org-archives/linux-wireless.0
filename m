Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f175.google.com ([209.85.210.175]:33864 "EHLO
        mail-wj0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936093AbdAENj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 08:39:28 -0500
Received: by mail-wj0-f175.google.com with SMTP id tn15so35292595wjb.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2017 05:39:18 -0800 (PST)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Johannes Berg <johannes@sipsolutions.net>,
        Dmitry Shmidt <dimitrysh@google.com>
References: <94eb2c110db85c2379054172dad0@google.com>
 <1480948100.31788.15.camel@sipsolutions.net>
 <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
 <1481093061.4092.17.camel@sipsolutions.net>
 <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
 <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com>
 <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
 <1481645205.20412.32.camel@sipsolutions.net>
 <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
 <1483536510.7312.5.camel@sipsolutions.net>
 <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com>
 <1483616763.4394.8.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <cd31be64-579a-a702-c642-b80690aac5b2@broadcom.com> (sfid-20170105_143933_596384_1BB8F80D)
Date: Thu, 5 Jan 2017 14:39:15 +0100
MIME-Version: 1.0
In-Reply-To: <1483616763.4394.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merging my draft reply in this one. Hope it still makes sense :-p

On 5-1-2017 12:46, Johannes Berg wrote:
> 
>> If we go with approach to use parameters and let FW or MAC80211
>> layer to decide what type of scan to do, 
> 
> At that point though, is it even meaningful to ask "what type of scan
> is this"? Or put another way - what does "scan type" even mean?
> 
>> then in general the only
>> difference between different types of scan is what to do with result:
>> - Normal scan: ssid list, channel list, dwell params, etc...
>> - Sched scan: ssid list, channel list, interval
>> - BSSID scan: bssid list, channel list, interval
>> Action: Report when suitable results are found (in case of Normal
>> scan it will be at the end of scan)
>>
>> - Roaming / Autojoin: ssid list, channel list, interval
>> Action: Connect when suitable results are found
>>
>> - History scan: bssid list, channel list, interval
>> Action: Report when buffer is full / almost full
> 
> Exactly. But the type of action is something set by the entity that
> triggered the scan, right? normal and roam would be equivalent anyway,
> no? wpa_supplicant would make a decision to connect - after the results
> are coming in.
> 
> Oh, then again, maybe you're thinking of full-MAC devices - does a
> roam/autojoin scan really already *imply* a new connection? And if so,
> do we have to do it that way, or can we remove that type of action and
> make a connection decision in higher layers, so it's really the same as
> "report when suitable results are found"?

Today we already have roaming offload, right? Roaming scan would indeed
be the same if roaming offload is not used unless you would want
cfg80211 to make the decision, but then I would expect parameters for
making that decision in the request. Same/similar for autojoin.

>> So we can literally distinguish scan types by final action.
> 
> Actually I think I'm just misinterpreting your wording - you mean that
> we can use the different final actions for the different scan types,
> not that we should actually say - in driver/firmware/... - "this is a
> history scan because the action is to report buffer full", right?

Do we care? The scan engine in our firmware does have use a scan type
concept, but that is hidden by the firmware api. I guess your point
would be that if user-space would prefer scan types and driver/firmware
uses that as well, we might do the same in cfg80211/mac80211. How can we
assure the scan types we come up with match those employed in any and
all wireless devices/firmwares.

>> And for History scan we need new get_scan_results() command.
>>
>> Does it sound reasonable?
> 
> I think it does.

I think so too, but what I am missing in this is who is responsible for
the actions above. I mean do we want to consider option for offloading
from the start or add it later. We may use the new "history scan"
storage in cfg80211 only for devices that do not support offloading it
and provide a .get_scan_results() callback for those that do.

As Johannes points out it needs to be clear to user-space what its next
step should be in obtaining results. Does it make sense to have a
separate notification for the history scan results (not calling it that
of course :-p ) triggered by the action "Report when buffer is full /
almost full" or should user-space determine what to do based on request
id that would be included in the (scheduled) scan results notification.

> There's a bit more complication wrt. the level of detail in results
> though - sometimes the result may include all IEs (normal/sched scan),
> sometimes it may not ("history scan") - are we sure we really only need
> one new get_scan_results()?

So could the "all IEs" case not be handled by the existing BSS storage?
Is it still our intention to handle normal scan (no interval provided?)
as well in the universal scan approach.

Regards,
Arend
