Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57128 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab2GYK50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 06:57:26 -0400
Received: by obbuo13 with SMTP id uo13so909396obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 03:57:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343140469.4415.36.camel@jlt3.sipsolutions.net>
References: <1342703465-26703-1-git-send-email-eliad@wizery.com>
	<1343140469.4415.36.camel@jlt3.sipsolutions.net>
Date: Wed, 25 Jul 2012 13:57:25 +0300
Message-ID: <CAB3XZEc2Z20v2txO_B2H7iZXWsx+SWU_2YtCuRfdE6y7+ktGnA@mail.gmail.com> (sfid-20120725_125730_046252_68064F5E)
Subject: Re: [RFC] mac80211: add PS flag to bss_conf
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2012 at 5:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-07-19 at 16:11 +0300, Eliad Peller wrote:
>> Currently, ps mode is indicated per device (rather than
>> per interface), which doesn't make a lot of sense.
>>
>> Moreover, there are subtle bugs caused by the inability
>> to indicate ps change along with other changes
>> (e.g. when the AP deauth us, we'd like to indicate
>> CHANGED_PS | CHANGED_ASSOC, as changing PS before
>> notifying about disassociation will result in null-packets
>> being sent (if IEEE80211_HW_SUPPORTS_DYNAMIC_PS) while
>> the sta is already disconnected.)
>>
>> Keep the current per-device notifications, and add
>> additional per-vif notifications. In order to keep it
>> simple, these notifications are NOT called due to
>> (temporary) dynamic_ps/offchannel operations.
>
> So I think if we do this, it would make sense to not do it in recalc_ps,
> but like you did in disassoc:
>
>> @@ -1368,6 +1388,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>>       if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>>               local->hw.conf.flags &= ~IEEE80211_CONF_PS;
>>               ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>> +             sdata->vif.bss_conf.ps = false;
>> +             changed |= BSS_CHANGED_PS;
>>       }
>>       local->ps_sdata = NULL;
>
> set it directly in the relevant code.
>
>
> However, I'm not sure that we really should toggle it with association?
> For the original CONF_PS semantics where mac80211 actually woke up for
> dynamic PS etc. this made sense, but for smarter devices I think the PS
> flag could be solely mirroring the combination of
>  a) broken AP => no PS
>  b) user enable/disable
>
ok, i think i got your point.

> even when not associated?

we actually check for authorization, so i think it does make some
sense to leave this check.

thanks for the review.
i'll apply your comments and send it as a patch.

Eliad.
