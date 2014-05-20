Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:40239 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETJxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 05:53:38 -0400
Received: by mail-la0-f45.google.com with SMTP id gl10so187909lab.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 02:53:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdFZAFih=YStSofJCaNgLQYDPxBsEPbovWufWt7O0vbPQ@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-4-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6Wwv0y1cOZrpLe+yjZqHLmZpdJ3dYaLhLro==x4-t9UzA@mail.gmail.com> <CA+XVXfdFZAFih=YStSofJCaNgLQYDPxBsEPbovWufWt7O0vbPQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 02:53:17 -0700
Message-ID: <CAB=NE6U2Uy8qjEzZu2ZZqP393=wGNk7wUPOe=VwhHBB6+x56Hg@mail.gmail.com> (sfid-20140520_115345_283347_6678D6C6)
Subject: Re: [PATCH 3/7] cfg80211: allow drivers to provide regulatory settings
To: Arik Nemtsov <arik@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 2:12 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, May 20, 2014 at 11:44 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Sun, May 11, 2014 at 1:50 AM, Emmanuel Grumbach
>> <emmanuel.grumbach@intel.com> wrote:
>>> From: Arik Nemtsov <arik@wizery.com>
>>> +       struct ieee80211_regdomain * (*get_regd)(struct wiphy *wiphy,
>>> +                                                const char *alpha2);
>>> +
>>>         /* fields below are read-only, assigned by cfg80211 */
>>>
>>>         const struct ieee80211_regdomain __rcu *regd;
>>
>> The driver should be able to dump a regdomain it needs when it needs
>> it and use the internal callbacks wiphy_apply_custom_regulatory()
>> which tons of drivers already use when it needs to upon
>> initialization. As for country IE data you can ignore country IEs,
>> there's a flag for this, and do what you want on firmware just as that
>> crappy non-upstream vendor qualcomm driver does. Apart from that its
>> unclear in this patch why instead any delta observed on wireless-regdb
>> is addressed publicly I'd like for this to be considered as a sane
>> alternative. Additionally keeping regulatory data in firmware is very
>> bug prone and it also doesn't let us grow mature the architecture on
>> cfg80211, Intel's firmware has historically only had a few world
>> regulatory domains, and historically this is why not much
>> contributions from Intel have gone into wireless-regdb, if there is a
>> need to support specific countries now on firmware I'd encourage the
>> firmware bloat strategy to be seriously reconsidered in light of the
>> issues that could arise.
>
> The wiphy_apply_custom_regulatory() option is to be used before
> registering the wiphy. We want to be able to accept country code
> changes at runtime, with the driver supplying the regdomain.

For which cases exactly at run time? This is already being handled on
other drivers without changing APIs, so its unclear why you need this
and to expose this to cfg80211. To be clear, a few drivers other than
Intel already had this strategy and they managed to just use the
reg_notifier() and do what it needs by using the flag that ignores
country IEs, and doing everything else on the driver side. Please
explore this avenue.

> As for why this was chosen - I think you're barking up the wrong tree :)
> The regulatory folks at Intel decided to store the data in FW,

This has been done for a long time but the main reason why this was
done that way was that Intel had no need to have tons of regulatory
domains, and instead had only 4 world regulatory domains, that's all,
if things have changed it'd be good to understand this and also the
reasons why things are being done.

> I don't  have any say here. I think this is more legal than technology reasons.

Asking these questions, understanding them, and addressing concerns
are the questions that need to be asked to help advance wireless on
Linux, it was not asking these questions that got us into trouble in
the first place, we don't want to go back to that. So even if it is
non technical and purely regulatory we obviously should ask why.

> Would this patch be acceptable with the documentation changed to kdoc format?
> Again, this is a different way of doing things, but it's largely
> compatible to the way reg.c already works.

Not yet, you have to explain if you've explored all other avenues
which others have before you have with similar architecture.

  Luis
