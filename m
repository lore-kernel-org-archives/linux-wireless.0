Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58112 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbaCYIha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:37:30 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so152481obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 01:37:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395734367.28231.57.camel@dubbel>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1395409651-26120-4-git-send-email-michal.kazior@tieto.com>
	<1395734367.28231.57.camel@dubbel>
Date: Tue, 25 Mar 2014 09:37:30 +0100
Message-ID: <CA+BoTQ=35sXg-ZLJoSLXdqrNnVO0ey1hBQxs2XALOtr3F4Hghw@mail.gmail.com> (sfid-20140325_093744_820873_6D72695D)
Subject: Re: [PATCH v2 03/13] mac80211: prevent chanctx overcommit
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2014 08:59, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-03-21 at 14:47 +0100, Michal Kazior wrote:
>> Do not allocate more channel contexts than a
>> driver is capable for currently matching interface
>> combination.
>>
>> This allows the ieee80211_vif_reserve_chanctx() to
>> act as a guard against breaking interface
>> combinations.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> [...]
>> @@ -745,13 +764,16 @@ int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>>                        * context, reserve our current context
>>                        */
>>                       new_ctx = curr_ctx;
>> -             } else {
>> +             } else if (ieee80211_can_create_new_chanctx(local)) {
>>                       /* create a new context and reserve it */
>>                       new_ctx = ieee80211_new_chanctx(local, chandef, mode);
>>                       if (IS_ERR(new_ctx)) {
>>                               ret = PTR_ERR(new_ctx);
>>                               goto out;
>>                       }
>> +             } else {
>> +                     ret = -EBUSY;
>> +                     goto out;
>
> I'm not sure about this whole allowed channels counting thing.  Does it
> really matter what is the total number of allowed channels? I think the
> actual combinations is what should be checked here.
>
> Let's say the driver supports these combinations:
>
> 1. num_different_channels = 2; limits max 2 APs;
> 2. num_different_channels = 1; limits 1 AP, 1 STA;
>
> Then you're running on a single-channel with 1 AP and 1 STA.  The STA
> gets a CSA to move to a new channel.  If you only consider the
> max_num_channels you calculated, you will think that it is okay to
> switch, but it is not, because you cannot have 1 AP and 1 STA on
> different channels.
>
> Or am I missing something?

Yes. You're missing the fact, that ieee80211_max_num_channels() uses
current iftype set to narrow down matching combinations.

In the above example you provided ieee80211_max_num_channels() returns 1.


Michał
