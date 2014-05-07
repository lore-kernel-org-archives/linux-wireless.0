Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:52229 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaEGJKu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:10:50 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so687277wes.27
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 02:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399453163.10517.4.camel@jlt4.sipsolutions.net>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	<1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
	<1399382148.4218.28.camel@jlt4.sipsolutions.net>
	<CA+BoTQnx8EzBGwYKV-ZmR+zf=iv3YOaT7BPPsYKrrNG=tJkXmQ@mail.gmail.com>
	<1399453163.10517.4.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 11:10:48 +0200
Message-ID: <CA+BoTQkL7O6aq-dj2XXL_RbLd-nzbT5KABZk2Dc_zh4s19ydKA@mail.gmail.com> (sfid-20140507_111054_826665_E445DCB4)
Subject: Re: [PATCH v4 0/4] mac80211/cfg80211: CSA fixes/cleanups
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 10:59, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 09:04 +0200, Michal Kazior wrote:
>
>> > However, there's one more thing - one caller of ieee80211_csa_finalize()
>> > doesn't check the return value now, I think it probably should. Mind
>> > taking a look at that? It should *probably* be the same as the other
>> > caller (and not propagate the error), I'd say, so maybe that should be
>> > rolled into the function?
>>
>> Right - the return value of ieee80211_csa_finalize() in
>> __ieee80211_channel_switch() should be checked against. I think it
>> should be like:
>>
>>  err = ieee80211_csa_finalize(sdata);
>>  if (err) {
>>   sdata_info(sdata, "failed to finalize immediate CSA, disconnecting\n");
>>   cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev, GFP_KERNEL);
>>
>>   /* don't propagate the error here - stop the iface instead since
>> there's no way to revert CS now */
>>   err = 0;
>>  }
>>
>> Should I re-post the patch(set?), post a follow up, or are you going
>> to update the patch yourself?
>
> Can you post a separate patch on top? I already have it in my tree, but
> I can squash it I guess if I really want to.
>
>> I'm not sure what you mean by rolling "that" into the function. You
>> want to put the stop_iface() in csa_finalize()? I think it's going to
>> look a bit ugly that way.
>
> Well, the only other caller of it right now does the same thing:
>
>        err = ieee80211_csa_finalize(sdata);
>        if (err) {
>                sdata_info(sdata, "failed to finalize CSA, disconnecting
> \n");
>                cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev,
> GFP_KERNEL);
>                goto unlock;
>        }
>
> so it seems it would make sense to have that as common code, maybe in
> the ieee80211_csa_finalize() function or maybe by changing
> ieee80211_csa_finalize() to be __ieee80211_csa_finalize() and making a
> new ieee80211_csa_finalize() that does this step?

Yeah, this sounds reasonable.

At times I'm just out of ideas on function naming for CSA. There's
like 5 functions that perform various phases of CSA finalization :-)


> In fact, then we could get rid of the int return value again, so maybe
> better post a new version of this particular patch after all.

I'll re-spin the patch later then.


Michał
