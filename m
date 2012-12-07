Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39008 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2LGUWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 15:22:20 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so1768923wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 12:22:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C22CBB.5060704@etit.tu-chemnitz.de>
References: <1354680761-32703-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
 <CAG6hwVN3F+KY=LkrG0j8WfFczBJawTD5J4kbbsnPfSAGrX5dXA@mail.gmail.com> <50C22CBB.5060704@etit.tu-chemnitz.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 7 Dec 2012 12:21:59 -0800
Message-ID: <CAG6hwVOTdz6_NNVFfQjko7wNjnCYh2uUxxnP-fHmbWK5qwvSNQ@mail.gmail.com> (sfid-20121207_212224_080711_5F8040CA)
Subject: Re: [RFC] mac80211_hwsim: dont modify TBTT if beacon is already enabled
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 9:51 AM, Marco Porsch
<marco.porsch@etit.tu-chemnitz.de> wrote:
> On 12/05/2012 12:26 PM, Thomas Pedersen wrote:> On Tue, Dec 4, 2012 at 8:12
> PM, Marco Porsch
>
>> <marco.porsch@etit.tu-chemnitz.de> wrote:
>>> If the beacon is already enabled, do not modify the beacon timer. This
>>> causes
>>> a hard TBTT adjustment and may cause mischief for powersave or
>>> synchronization.j
>>
>> It might be clearer if you explain this patch actually defers "TBTT"
>> adjustment until the next beacon.
>
> This commit is supposed to not change the TBTT at all, if the beacon is not
> enabled/disabled. Or do I misunderstand you here? Please clarify.

That's right,  but I think in general you want to defer TBTT
adjustment until next beacon and that it's worth adding that fix to
this patch. See the comment below.

>>> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
>>> ---
>>>   drivers/net/wireless/mac80211_hwsim.c |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/mac80211_hwsim.c
>>> b/drivers/net/wireless/mac80211_hwsim.c
>>> index bc763d2..abfa7e6 100644
>>> --- a/drivers/net/wireless/mac80211_hwsim.c
>>> +++ b/drivers/net/wireless/mac80211_hwsim.c
>>> @@ -1174,7 +1174,7 @@ static int mac80211_hwsim_config(struct
>>> ieee80211_hw *hw, u32 changed)
>>>          data->power_level = conf->power_level;
>>>          if (!data->started || !data->beacon_int)
>>>                  del_timer(&data->beacon_timer);
>>> -       else
>>> +       else if (!timer_pending(&data->beacon_timer))
>>>                  mod_timer(&data->beacon_timer, jiffies +
>>> data->beacon_int);
>>
>> There is an immediate beacon timer adjustment in
>> mac80211_hwsim_bss_info_changed() as well.
>
> But that other one really has to change the TBTT because it changes the
> beacon interval.

Yes, but if you don't check whether the timer is already pending you
will beacon at a different TBTT than advertised in the last beacon. If
the beacon timer is not modified immediately, it will reschedule
itself based on the new beacon interval after the next beacon.

Thomas
