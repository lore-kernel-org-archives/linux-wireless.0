Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49180 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031920AbdAELqG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:46:06 -0500
Message-ID: <1483616763.4394.8.camel@sipsolutions.net> (sfid-20170105_124625_877979_DA3C9939)
Subject: Re: [PATCH] RFC: Universal scan proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Shmidt <dimitrysh@google.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 05 Jan 2017 12:46:03 +0100
In-Reply-To: <CAH7ZN-zenL8SsqUAzMH5-Hb1RmUDDwgqqUKWEbPX=qaPV7e3TA@mail.gmail.com> (sfid-20170104_213238_407654_9812F7E4)
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
         (sfid-20170104_213238_407654_9812F7E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If we go with approach to use parameters and let FW or MAC80211
> layer to decide what type of scan to do, 

At that point though, is it even meaningful to ask "what type of scan
is this"? Or put another way - what does "scan type" even mean?

> then in general the only
> difference between different types of scan is what to do with result:
> - Normal scan: ssid list, channel list, dwell params, etc...
> - Sched scan: ssid list, channel list, interval
> - BSSID scan: bssid list, channel list, interval
> Action: Report when suitable results are found (in case of Normal
> scan it will be at the end of scan)
> 
> - Roaming / Autojoin: ssid list, channel list, interval
> Action: Connect when suitable results are found
> 
> - History scan: bssid list, channel list, interval
> Action: Report when buffer is full / almost full

Exactly. But the type of action is something set by the entity that
triggered the scan, right? normal and roam would be equivalent anyway,
no? wpa_supplicant would make a decision to connect - after the results
are coming in.

Oh, then again, maybe you're thinking of full-MAC devices - does a
roam/autojoin scan really already *imply* a new connection? And if so,
do we have to do it that way, or can we remove that type of action and
make a connection decision in higher layers, so it's really the same as
"report when suitable results are found"?

> So we can literally distinguish scan types by final action.

Actually I think I'm just misinterpreting your wording - you mean that
we can use the different final actions for the different scan types,
not that we should actually say - in driver/firmware/... - "this is a
history scan because the action is to report buffer full", right?

> And for History scan we need new get_scan_results() command.
> 
> Does it sound reasonable?

I think it does.

There's a bit more complication wrt. the level of detail in results
though - sometimes the result may include all IEs (normal/sched scan),
sometimes it may not ("history scan") - are we sure we really only need
one new get_scan_results()?

johannes
