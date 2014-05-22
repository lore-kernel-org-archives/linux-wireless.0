Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39735 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaEVNxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:53:49 -0400
Received: by mail-we0-f175.google.com with SMTP id t61so3490377wes.34
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400766195.4174.13.camel@jlt4.sipsolutions.net>
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	<1400765294-14732-2-git-send-email-michal.kazior@tieto.com>
	<1400766195.4174.13.camel@jlt4.sipsolutions.net>
Date: Thu, 22 May 2014 15:53:47 +0200
Message-ID: <CA+BoTQmw6taxwxHtK99BQXgGugu6aDrGUOCz+-MvUo52JoWrpw@mail.gmail.com> (sfid-20140522_155352_561137_B50D3412)
Subject: Re: [PATCH 1/3] mac80211: move csa counters from sdata to beacon/presp
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 15:43, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
>> Having csa counters part of beacon and probe_resp
>> structures makes it easier to get rid of possible
>> reaces between setting a beacon and updating

>> reaces

-_- grr


>> counters on SMP systems by guaranteeing counters
>> are always consistent against given beacon struct.
>
> This makes a lot of sense.
>
>>  static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
>> -                                struct cfg80211_beacon_data *params)
>> +                                struct cfg80211_beacon_data *params,
>> +                                const u16 *csa_counter_offset_beacon,
>> +                                int n_csa_counter_offset_beacon,
>> +                                const u16 *csa_counter_offset_presp,
>> +                                int n_csa_counter_offset_presp,
>> +                                u8 csa_count)
>
> But that seems overkill. Maybe those CSA-related arguments could be in
> some new struct so you don't have to pass "..., NULL, 0, NULL, 0, 0"?

I didn't want to invent a structure just to pass a bunch of arguments.

Hmm.. maybe we can move counter offsets into cfg80211_beacon_data?
This would apply to cfg80211_csa_settings as well.


Michał
