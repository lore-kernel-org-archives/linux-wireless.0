Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42261 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbaCSKSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 06:18:11 -0400
Received: by mail-ie0-f180.google.com with SMTP id as1so8588136iec.39
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 03:18:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQnNXb=sm=k=fFmYd=e1pOVTRX3MhwMgmhUeWD=2Nuy_8A@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-4-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEcRwJ0H_rRSq0kaw8mWLJh2i2msZUmBRBFXZonZSua4kQ@mail.gmail.com>
	<CA+BoTQmNJoMa8p-DnjH9h-NdkTm=6DK2pztCFYGACe8BB5aJ=Q@mail.gmail.com>
	<CAB3XZEckstWFB-2CmWg7JeoyT0bTUgSh5bXqZxADUHiurZgnhw@mail.gmail.com>
	<CA+BoTQnNXb=sm=k=fFmYd=e1pOVTRX3MhwMgmhUeWD=2Nuy_8A@mail.gmail.com>
Date: Wed, 19 Mar 2014 12:18:09 +0200
Message-ID: <CAB3XZEe2ie8eHGrKLBkn6juQ5wGGfdOMirSj5vCEBAixZHHvuw@mail.gmail.com> (sfid-20140319_111815_007841_C50E75C7)
Subject: Re: [RFC 03/21] mac80211: add max channel calculation utility function
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2014 at 10:54 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 19 March 2014 09:43, Eliad Peller <eliad@wizery.com> wrote:
>> On Wed, Mar 19, 2014 at 10:32 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 18 March 2014 17:17, Eliad Peller <eliad@wizery.com> wrote:
>>>> hi,
>>>>
>>>> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>>>> The utility function has no uses yet. It is aimed
>>>>> at future chanctx reservation management and
>>>>> channel switching.
>>>>>
>>>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>>>> ---
>>>> [...]
>>>>
>>>>> +int ieee80211_max_num_channels(struct ieee80211_local *local)
>>>>> +{
>>>>> +       struct ieee80211_sub_if_data *sdata;
>>>>> +       int num[NUM_NL80211_IFTYPES] = {};
>>>>> +       struct ieee80211_chanctx *ctx;
>>>>> +       int num_different_channels = 0;
>>>>> +       u8 radar_detect = 0;
>>>>> +       u32 max_num_different_channels = 1;
>>>>> +       int err;
>>>>> +
>>>>> +       lockdep_assert_held(&local->chanctx_mtx);
>>>>> +
>>>>> +       list_for_each_entry(ctx, &local->chanctx_list, list) {
>>>>> +               num_different_channels++;
>>>>> +
>>>> this doesn't seem correct - i think we can have multiple channel
>>>> contexts with the same channel (e.g. due to exclusive mode)?
>>>
>>> Hmm, does it even make sense to consider chanctx mode here?
>>>
>> i don't think you should consider the chancx mode, but keep track of
>> the used channels.
>> if you have 2 different channel contexts with the same channel (e.g.
>> due to exclusive mode), you have to make sure you don't count the same
>> channel twice. you shouldn't care about the actual reason for it.
>
> I disagree. There's a reason why we have exclusive chanctx mode.
>
> If you insist on counting compatible chandefs you can lead to
> overcommit if your exclusive chanctx bound interface decides to switch
> to another channel.
>
ok. fair point. i guess you're right.

Eliad.
