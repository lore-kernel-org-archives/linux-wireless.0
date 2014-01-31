Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:47946 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaAaOTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 09:19:34 -0500
Received: by mail-bk0-f52.google.com with SMTP id e11so2167888bkh.11
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jan 2014 06:19:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391176316.4141.16.camel@jlt4.sipsolutions.net>
References: <1391001747-9442-1-git-send-email-michal.kazior@tieto.com>
	<1391176316.4141.16.camel@jlt4.sipsolutions.net>
Date: Fri, 31 Jan 2014 15:13:36 +0100
Message-ID: <CA+BoTQmwbKetzLB7Y9ZHC-Ez84RHAofLP2+3U6MpnV3kJty-FA@mail.gmail.com> (sfid-20140131_151947_235894_CBC0D474)
Subject: Re: [PATCH] cfg80211: consider existing DFS interfaces
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 January 2014 14:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-29 at 14:22 +0100, Michal Kazior wrote:
>> It was possible to break interface combinations in
>> the following way:
>>
>>  combo 1: iftype = AP, num_ifaces = 2, num_chans = 2,
>>  combo 2: iftype = AP, num_ifaces = 1, num_chans = 1, radar = HT20
>>
>> With the above interface combinations it was
>> possible to:
>>
>>  step 1. start AP on DFS channel by matching combo 2
>>  step 2. start AP on non-DFS channel by matching combo 1
>>
>> This was possible beacuse (step 2) did not consider
>> if other interfaces require radar detection.
>>
>> The patch changes how cfg80211 tracks channels -
>> instead of channel itself now a complete chandef
>> is stored.
>
> Applied.
>
> Do you also want to take this a little further and actually check
> compatibility when checking for channel availability in
> cfg80211_can_use_iftype_chan()? Right now it only checks the channel,
> but cfg80211_get_chan_state() should really not have a channel argument
> but a chandef instead.

I briefly looked at the issue and have seen challenges. Although I'm
not actively implementing it I may end up doing it at some point.


Michał
