Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54118 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaFKFvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 01:51:23 -0400
Received: by mail-pa0-f53.google.com with SMTP id kx10so1501263pab.26
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 22:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Uc0WD4sC65bgpCP=z+TYDmY87uMMdaoCgRgdOaCT9uhg@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-4-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6Wwv0y1cOZrpLe+yjZqHLmZpdJ3dYaLhLro==x4-t9UzA@mail.gmail.com>
 <CA+XVXfdFZAFih=YStSofJCaNgLQYDPxBsEPbovWufWt7O0vbPQ@mail.gmail.com>
 <CAB=NE6U2Uy8qjEzZu2ZZqP393=wGNk7wUPOe=VwhHBB6+x56Hg@mail.gmail.com>
 <CA+XVXfezx4VpycJybyQ3NgvTXSPTdXn5eAg8jj+yjy+HxZ-EKA@mail.gmail.com> <CAB=NE6Uc0WD4sC65bgpCP=z+TYDmY87uMMdaoCgRgdOaCT9uhg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 11 Jun 2014 08:51:07 +0300
Message-ID: <CA+XVXffNzm9GePGWRFyzCoEiZuF2MjqnRzPQ8Jdpngwvg5ZQJg@mail.gmail.com> (sfid-20140611_075126_772768_56FA785B)
Subject: Re: [PATCH 3/7] cfg80211: allow drivers to provide regulatory settings
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 12:43 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, May 20, 2014 at 5:00 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>>> The wiphy_apply_custom_regulatory() option is to be used before
>>>> registering the wiphy. We want to be able to accept country code
>>>> changes at runtime, with the driver supplying the regdomain.
>>>
>>> For which cases exactly at run time? This is already being handled on
>>> other drivers without changing APIs, so its unclear why you need this
>>> and to expose this to cfg80211. To be clear, a few drivers other than
>>> Intel already had this strategy and they managed to just use the
>>> reg_notifier() and do what it needs by using the flag that ignores
>>> country IEs, and doing everything else on the driver side. Please
>>> explore this avenue.
>>
>> The problem is not propagating the country setting the FW. I agree
>> this can be done via the notifier. The problem is propagating the
>> regulatory data from FW to userspace.
>> For instance we want P2P to be able to use 5Ghz channels in the US.
>> For this, wpa_s must have up to date information from the regulatory
>> DB for country=US. For Intel, the regulatory DB is in FW.
>
> Doesn't the custom regulatory flag allow you to do what you want
> already? Is the issue that the custom flag does not let dynamic run
> time updates and that's what you need?

Yes - we need runtime updates for platforms that can roam to different
countries.

The reg.c code explicitly assumes there will be no regd change if the
custom-regulatory flags is set..

The proposed patch seemed like a clean way to have regulatory data
come from the FW - register the wiphy normally, just replace crda with
a driver callback.


>>
>> This is no longer true. Some variants will now contain settings per county.
>
> OK thanks, I suppose there is more need for regulatory folks at
> companies to be talking.

I'm all for preventing duplicated labor.

>
>>>> I don't  have any say here. I think this is more legal than technology reasons.
>>>
>>> Asking these questions, understanding them, and addressing concerns
>>> are the questions that need to be asked to help advance wireless on
>>> Linux, it was not asking these questions that got us into trouble in
>>> the first place, we don't want to go back to that. So even if it is
>>> non technical and purely regulatory we obviously should ask why.
>>>
>>
>> I'm actually an advocate of the CRDA/regdb approach. Less work for us. :)
>> We presented it but ultimately the decision was theirs, not mine.
>
> I'm starting to think that having an organized group that does this
> for the community would be good, having different companies do this
> and come up with different conclusions seems rather a waste of time,
> energy and resources.

Agree. This would need to a be group of legal/regulatory folks, in
addition to developers.

>
>> For instance, one might replace the regdb and break
>> regulatory. So the FW has a regulatory checker that verifies correct
>> settings. Which in turn means it will hold the regulatory DB anyway.
>
> That's just brain dead, we're reverse engineered firmware before,
> firmware is no safe haven from modifications, what we should be
> striving for, and what I do need your help with is arguing back up to
> PHBs on the architectural issues with the firmware design, the fact
> that its proven over and over to have issues, and that it doesn't
> fucking scale.

Reverse-engineering the FW is one thing, changing the regulatory
settings inside it and signing it with an unknown private key is
entirely different. The verification of FW integrity can be done by
HW.
Of course we could verify the driver/kernel etc using TPM, but that's
mostly unfeasible. Therefore I tend to accept the argument the FW
regulatory data is more secure.

I've tried to make the counter-argument that CRDA/wireless-regdb is
good enough for platforms where the user doesn't have root access, but
it was rejected on the grounds that the solution needs to work on
everything.

>
> That said, if your PHBs want to shoot themselves on the foot we can
> let them, but we should at the very least be able to extract *all* the
> regulatory db from the damn firmware so that we can then properly
> implement a common solution upstream for all 802.11 drivers as we have
> been doing.

I guess the code I've already implemented should be used to extract
the data. Just a simple script iterating over countries vs. a live
card.
Asking for the data in other forms would likely bring the wrath of the
Intel legal folks upon us. :)

Arik
