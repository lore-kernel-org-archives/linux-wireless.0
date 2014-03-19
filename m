Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51607 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbaCSIc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:32:56 -0400
Received: by mail-ob0-f174.google.com with SMTP id wo20so7892507obc.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 01:32:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEcRwJ0H_rRSq0kaw8mWLJh2i2msZUmBRBFXZonZSua4kQ@mail.gmail.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
	<1395150804-24090-4-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEcRwJ0H_rRSq0kaw8mWLJh2i2msZUmBRBFXZonZSua4kQ@mail.gmail.com>
Date: Wed, 19 Mar 2014 09:32:55 +0100
Message-ID: <CA+BoTQmNJoMa8p-DnjH9h-NdkTm=6DK2pztCFYGACe8BB5aJ=Q@mail.gmail.com> (sfid-20140319_093301_466636_80B26534)
Subject: Re: [RFC 03/21] mac80211: add max channel calculation utility function
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 March 2014 17:17, Eliad Peller <eliad@wizery.com> wrote:
> hi,
>
> On Tue, Mar 18, 2014 at 3:53 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> The utility function has no uses yet. It is aimed
>> at future chanctx reservation management and
>> channel switching.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
> [...]
>
>> +int ieee80211_max_num_channels(struct ieee80211_local *local)
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +       int num[NUM_NL80211_IFTYPES] = {};
>> +       struct ieee80211_chanctx *ctx;
>> +       int num_different_channels = 0;
>> +       u8 radar_detect = 0;
>> +       u32 max_num_different_channels = 1;
>> +       int err;
>> +
>> +       lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +       list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +               num_different_channels++;
>> +
> this doesn't seem correct - i think we can have multiple channel
> contexts with the same channel (e.g. due to exclusive mode)?

Hmm, does it even make sense to consider chanctx mode here?


Michał
