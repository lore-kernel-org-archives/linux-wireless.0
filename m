Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35002 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2KpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 06:45:22 -0400
Received: by mail-lb0-f177.google.com with SMTP id u14so3767219lbd.8
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 03:45:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALhHN=oThh7HMW5cHQmW_U0yrzN5x3+ZW6a+yd9fc8fyjcuL+w@mail.gmail.com>
References: <1383027326-2635-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6W53b=uOkaVUFfKcszXPikS=ax6k_G+7Wmb7g_acpSTsA@mail.gmail.com> <CALhHN=oThh7HMW5cHQmW_U0yrzN5x3+ZW6a+yd9fc8fyjcuL+w@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 29 Oct 2013 11:45:00 +0100
Message-ID: <CAB=NE6VBx8rF6MNrmcx=aUfqky-89WE4n9Y6fRy1pV-qq1GoVw@mail.gmail.com> (sfid-20131029_114525_650604_7B47056D)
Subject: Re: [PATCH] cfg80211: allow beaconing after CAC
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 11:32 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 29 October 2013 11:25, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>> How do we know that prohibited_flags won't have IEEE80211_CHAN_RADAR
>> or IEEE80211_CHAN_NO_IBSS set?
>>
>> Also why is IEEE80211_CHAN_NO_IBSS used and not IEEE80211_CHAN_NO_IR
>> instead? I sent patches to help clarify this situation around usage of
>> both no-ibss and active scan flags, by merging them to no-ir. I'm not
>> sure of the status of those patches going in.
>>
>
> I am not sure.

OK please try to be for changes like these.

> Even without my patch seems  IEEE80211_CHAN_RADAR is
> added to prohibited_flags and have different meaning (I think).

IEEE80211_CHAN_RADAR has only one meaning, its not subjective.

> In orginal code we have:
>
> if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
>
> So, we skiping CHAN_RADAR anyway? I am not sure we should change
> prohibited_flags to different name or stop skiping CHAN_RADAR and
> modify upper layer - cfg80211_reg_can_beacon() in such case.

I took a look and I'd prefer that this be dealt with elsewhere, in
particular you are right that cfg80211_reg_can_beacon() seems like a
much more suitable place for this check now.

  Luis
