Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58004 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAVGvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:51:09 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so4616988eek.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:51:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390316761.6199.27.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	<1390316761.6199.27.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 07:51:08 +0100
Message-ID: <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com> (sfid-20140122_075114_139752_88E4FB38)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2014 16:06, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
>> The patch improves channel switch related locking
>> (STA, IBSS, AP, mesh).
>>
>> Now read access to sdata->vif.csa_active is
>> protected by wdev.mtx and local->mtx so holding
>> either is enough for read access but both are
>> required for write access. Keep in mind sdata lock
>> must be taken before local->mtx. Taking them in
>> reverse order creates a deadlock situation.
>>
>> The only exception is ieee80211_beacon_get_tim()
>> but it's safe to leave it as is and it doesn't
>> influence mac80211 state in any way.
>>
>> The patch adds a few lockdep assertions along for
>> easier code/locking maintenance.
> ---
>> This also prepares for multi-interface CSA.
>
> There's only one or two lines for that preparation as far as I can tell,
> but I think you should separate it (or maybe make that part of another
> patch)... or did I miss something?

True. I'll remove the sentence.


> I mean this:
>
>> +       sdata->csa_chandef = params.chandef;
>
> doesn't seem to belong here.

I mistakenly left that while rebasing. I'll fix that. I think that's
the only thing that shouldn't be in this patch?


> It would also be good to explain why you're doing this?

You mean the whole locking patch? Basically to be able safely assess
CSA state. Taking a bunch of wdev->mtx seems like a bad idea. Due to
how the locks are ordered and organized I've came up with using
local->mtx as an extra CSA-related variable protection. Using
local->mtx makes it possible to iterate over interfaces and check
for/update CSA state in an atomic way.

Is this a satisfactory explanation?


Michał
