Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53227 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031621Ab2COTPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:15:34 -0400
Received: by yhmm54 with SMTP id m54so3473210yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 12:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331837984.3432.42.camel@jlt3.sipsolutions.net>
References: <4F6236D0.40505@candelatech.com>
	<1331836777.3432.31.camel@jlt3.sipsolutions.net>
	<CAB3XZEeDtJKpSbYB8sMM35rRT7KH5dVuKOWntDBhDp+unRkWGA@mail.gmail.com>
	<1331837984.3432.42.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Mar 2012 21:15:33 +0200
Message-ID: <CAB3XZEf9oq5GQO_F6zjdo8qTHoDX8-CPozfDouuw7GVzipJpww@mail.gmail.com> (sfid-20120315_201538_941801_362D3175)
Subject: Re: compiler warning in wireless-testing.
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 8:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-03-15 at 20:53 +0200, Eliad Peller wrote:
>> On Thu, Mar 15, 2012 at 8:39 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2012-03-15 at 11:37 -0700, Ben Greear wrote:
>> >> Looks like this is the compiler's fault to me..but might be
>> >> worth explicitly initializing the sta variable just to make
>> >> it quiet.
>> >
>> > I disagree, doing that will only hide legitimate warnings if somebody
>> > changes the code. Initializing for compiler happiness is almost always
>> > the worst thing you can do.
>> >
>> what about
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 6cb5361..96fc201 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -3094,7 +3094,6 @@ static int ieee80211_prep_connection(struct
>> ieee80211_sub_if_data *sdata,
>>         struct ieee80211_local *local = sdata->local;
>>         struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>>         struct ieee80211_bss *bss = (void *)cbss->priv;
>> -       struct sta_info *sta;
>>         bool have_sta = false;
>>         int err;
>>
>> @@ -3107,12 +3106,6 @@ static int ieee80211_prep_connection(struct
>> ieee80211_sub_if_data *sdata,
>>                 rcu_read_unlock();
>>         }
>>
>> -       if (!have_sta) {
>> -               sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
>> -               if (!sta)
>> -                       return -ENOMEM;
>> -       }
>> -
>>         mutex_lock(&local->mtx);
>>         ieee80211_recalc_idle(sdata->local);
>>         mutex_unlock(&local->mtx);
>> @@ -3123,10 +3116,15 @@ static int ieee80211_prep_connection(struct
>> ieee80211_sub_if_data *sdata,
>>
>>         if (!have_sta) {
>>                 struct ieee80211_supported_band *sband;
>> +               struct sta_info *sta;
>>                 u32 rates = 0, basic_rates = 0;
>>                 bool have_higher_than_11mbit;
>>                 int min_rate = INT_MAX, min_rate_index = -1;
>>
>> +               sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
>> +               if (!sta)
>> +                       return -ENOMEM;
>> +
>>                 sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
>>
>>                 ieee80211_get_rates(sband, bss->supp_rates,
>>
>>
>> it also makes the code more clear, imho.
>
> Yeah, I thought about that for a second, but I'm working on changes in
> this area that would essentially require me to revert this again ...
>
> I really want to do the allocation first so the failure path for that is
> easy. On the other hand, I'm adding channel type switching (see my RFC
> patchset) in the middle of this, and unwinding that would be a larger
> change that even touches the device.
>
> What may be possible instead is to replace the second have_sta in the
> second if with "if (sta)", which may make Ben's compiler a bit happier,
> but I have no way of even testing that since my compiler doesn't
> complain to start with.
>
that's possible, but then you'll have to initialize sta anyway :)

Eliad.
