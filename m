Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36859 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdADUjh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 15:39:37 -0500
Received: by mail-io0-f172.google.com with SMTP id p127so17764805iop.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:39:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483536510.7312.5.camel@sipsolutions.net>
References: <94eb2c110db85c2379054172dad0@google.com> <1480948100.31788.15.camel@sipsolutions.net>
 <CAH7ZN-wcvoJLTr_zYMwpbjuvMBGwmNhuVYx-MuNU1pOPTf9HEA@mail.gmail.com>
 <1481093061.4092.17.camel@sipsolutions.net> <CAH7ZN-wP+9AGrXFUS4RY65-RyfP-J46svBvLdytP2c=QPtiaug@mail.gmail.com>
 <93d4475c-58bd-d497-3347-a988d551f374@broadcom.com> <CAH7ZN-wGseBVzV3Vuq+6=kgaSL7e0UnndGXPdu4PQKZw8H47YQ@mail.gmail.com>
 <1481645205.20412.32.camel@sipsolutions.net> <CAH7ZN-zm-CUv=QzoUojdyrcONRAHtTG18PiwGZ4sYY0qqft1BA@mail.gmail.com>
 <1483536510.7312.5.camel@sipsolutions.net>
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Wed, 4 Jan 2017 12:32:36 -0800
Message-ID: <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com> (sfid-20170104_213941_251797_2C9C50F2)
Subject: Re: [PATCH] RFC: Universal scan proposal
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 4, 2017 at 5:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2017-01-03 at 12:45 -0800, Dmitry Shmidt wrote:
>>
>> We can either use alternative structure in kernel wireless stack,
>> or alternative structure in userspace (in wpa_supplicant), and we
>> will most likely need special command for this case at least to
>> retrieve results.
>
> Yes, I tend to agree - we need to have some new structure (and netlink
> attributes etc.) to report the aggregated/partial results. But it seems
> to me that it'll have to be very obvious which way of obtaining results
> must be used for a given scan?

If we go with approach to use parameters and let FW or MAC80211
layer to decide what type of scan to do, then in general the only
difference between different types of scan is what to do with result:
- Normal scan: ssid list, channel list, dwell params, etc...
- Sched scan: ssid list, channel list, interval
- BSSID scan: bssid list, channel list, interval
Action: Report when suitable results are found (in case of Normal
scan it will be at the end of scan)

- Roaming / Autojoin: ssid list, channel list, interval
Action: Connect when suitable results are found

- History scan: bssid list, channel list, interval
Action: Report when buffer is full / almost full

So we can literally distinguish scan types by final
action. And for History scan we need new get_scan_results()
command.

Does it sound reasonable?

> johannes
