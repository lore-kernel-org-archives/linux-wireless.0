Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52301 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaKUJRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:17:22 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so11319503wiv.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 01:17:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141120202700.GO24486@wotan.suse.de>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
 <1415895219-19848-3-git-send-email-arik@wizery.com> <20141113231137.GF24486@wotan.suse.de>
 <CA+XVXfd5ZsC3-6eEy=JYbvwm=S5ocdv=Mj1E7=sLMkwcba_x_w@mail.gmail.com> <20141120202700.GO24486@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 21 Nov 2014 11:17:03 +0200
Message-ID: <CA+XVXfejO9arNqm+11+JeMCb=7VUfrKjEMYX1DUy_3Uajrmqjw@mail.gmail.com> (sfid-20141121_101739_847579_51D65894)
Subject: Re: [PATCH v2 3/4] cfg80211: allow wiphy specific regdomain management
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 10:27 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Sun, Nov 16, 2014 at 01:06:00PM +0200, Arik Nemtsov wrote:
>> On Fri, Nov 14, 2014 at 1:11 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> >> index a4d2792..656a1b1 100644
>> >> --- a/net/wireless/core.c
>> >> +++ b/net/wireless/core.c
>> >> @@ -541,6 +541,13 @@ int wiphy_register(struct wiphy *wiphy)
>> >>                   !wiphy->wowlan->tcp))
>> >>               return -EINVAL;
>> >>  #endif
>> >> +     if (WARN_ON((wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
>> >> +                 (wiphy->regulatory_flags &
>> >> +                  (REGULATORY_CUSTOM_REG | REGULATORY_STRICT_REG |
>> >> +                   REGULATORY_COUNTRY_IE_FOLLOW_POWER |
>> >> +                   REGULATORY_COUNTRY_IE_IGNORE |
>> >> +                   REGULATORY_DISABLE_BEACON_HINTS))))
>> >> +             return -EINVAL;
>> >
>> > Look at all those heuristics go away... That's alot. The documetnation should
>> > reflect all this not being used because of this decision. I also want you to
>> > think of the issues that may come up when combining devices that, one that
>> > uses this feature and one that does not.
>>
>> Since this is a private regdomain, I guess this just means the
>> cfg80211 using device will be alone in the system for all regulatory
>> purposes.
>> I don't really see possible interoperability issues here. Am I missing
>> something?
>
> It means you can technically end up with two devices that operate with
> different interpretation of rules, this can mean for example that some
> expectations of having two devices may fail and since this will be all hard
> coded you can't fix it.  The worst of the issues will be caused by the fact
> that we simply won't know what issues will creep up until the two data sets
> conflict and create an unexpected user facing issue. This is precicely why
> having support for querying information about all regulatory data is critical,
> and I'm glad you are doing that work.
>
> What will happen when say a user / user interface wants to restrict all devices
> to say a country like Israel, 'iw reg set IL' is used, so the cfg80211 regulatory
> abiding devices follow the rules, but this Intel device does not?

It's nice that you've used IL in your example :)

An Intel device would basically stay in mode "00" until the FW decides
via a modem or other indication that it is in IL. At that point we
will send regulatory_hint_regd() notification.
The Intel device doesn't use/trust other devices.

Arik
