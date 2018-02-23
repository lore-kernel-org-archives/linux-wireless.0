Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:46359 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751580AbeBWQXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 11:23:36 -0500
Received: by mail-lf0-f54.google.com with SMTP id r80so13122049lfe.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Feb 2018 08:23:35 -0800 (PST)
Subject: Re: [PATCH v2] cfg80211/nl80211: add DFS offload flag
To: Johannes Berg <johannes@sipsolutions.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
References: <20180222091513.25456-1-sergey.matyukevich.os@quantenna.com>
 <1519385531.2231.12.camel@sipsolutions.net>
From: Dmitry Lebed <lebed.dmitry@gmail.com>
Message-ID: <1a3a0b4d-a20b-a53f-1a38-808ba062973e@gmail.com> (sfid-20180223_172340_411508_AD327598)
Date: Fri, 23 Feb 2018 19:23:32 +0300
MIME-Version: 1.0
In-Reply-To: <1519385531.2231.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

23.02.2018 14:32, Johannes Berg wrote:
> On Thu, 2018-02-22 at 12:15 +0300, Sergey Matyukevich wrote:
>> + * @NL80211_EXT_FEATURE_DFS_OFFLOAD: HW/driver will offload DFS actions.
>> + *	Device or driver will do all DFS-related actions by itself,
>> + *	informing user-space about CAC progress, radar detection event,
>> + *	channel change triggered by radar detection event.
>> + *	No need to start CAC from user-space, no need to react to
>> + *	"radar detected" event.
> The "channel change" part bothers me a bit - isn't normally hostapd
> very much in control of the channel? How does it even get notified of
> the new channel? How can you configure the parameters like how many
> beacons to include the (E)CSA IE for, and whether to add ECSA or not
> etc?
>
> johannes

hostapd will be notified with NL80211_CMD_CH_SWITCH_NOTIFY event
and it already has a handler for this event and looks like it works as 
expected.
In case of radar detection, userspace (hostapd) should receive two 
events (with DFS offload enabled):
1. RADAR_DETECT - and in case of DFS_OFFLOAD flag turned on don't do any CSA
2. CH_SWITCH_NOTIFY - at the moment when HW will switch channel as a 
reaction
     to radar event

Currently, all CSA will be sent with default parameters. If it's crucial 
to tune e.g. TBTT
count, then let's add it with a separate commit later, when DFS offload 
will be
implemented in the whole SW stack (driver/kernel/userspace).

DFS offload should be quite useful and should fix some issues in a 
repeater configuration.
There are a number of issues which are hard to fix without DFS offload 
feature:
e.g. if repeater has detected a radar and sent radar report frame to 
master AP,
master AP will reply with CSA, but hostapd will try to change channel to 
different channel.

Regards,
Dmitry
