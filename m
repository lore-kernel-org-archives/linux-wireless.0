Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:52729 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaKLWve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 17:51:34 -0500
Received: by mail-la0-f48.google.com with SMTP id gq15so12023546lab.7
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 14:51:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcMhrHUhg4yj_dOf97XWu_HyvdQ-LqF4KbjXL4ewGn5PQ@mail.gmail.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
 <1414046257-22184-6-git-send-email-arik@wizery.com> <CAB=NE6WLnVcBtC5_HyVuDXJnrCUfhUKsPN_rAHL6VYEfek1TMA@mail.gmail.com>
 <CA+XVXfcMhrHUhg4yj_dOf97XWu_HyvdQ-LqF4KbjXL4ewGn5PQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 12 Nov 2014 14:51:12 -0800
Message-ID: <CAB=NE6WNtZOm-u0HxdCziuV7rZvQG=X=HN6r=FytVDKaaOmUnA@mail.gmail.com> (sfid-20141112_235138_391530_F0D436E8)
Subject: Re: [PATCH 5/5] cfg80211: Allow usermode to query wiphy specific regd info
To: Arik Nemtsov <arik@wizery.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2014 at 1:12 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Nov 5, 2014 at 5:23 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
>>> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
>>> + *     regulatory information came from the driver and not from the global
>>> + *     cfg80211 regulatory domain information.
>>
>> Awesome, can you also add another entry for those drivers that use
>> regulatory_hint() API given that the wiphy->regd will be set and then
>> that is a custom regdomain which I do think would be great to query as
>> well.
>
> Just to be sure we're on the same page.
> 1. You're asking for an attribute to be automatically sent to
> userspace whenever someone registers with REGULATORY_CUSTOM_REG.

Right now if REGULATORY_CUSTOM_REG is set you are expected to use
wiphy_apply_custom_regulatory() and the regd is not cached, instead we
rely on the orgi parameters to ensure that data is used as that
maximum set. These data structures are already part of the kernel so I
don't think its necessary to send them to userspace right now but
specially since it'd mean adding a new data structure and caching it
completely. That's possible but I was more looking for users of
regulatory_hint(), when that is used the wiphy->regd is set and so its
available and cached already.

> 2. And then if userspace sends a wiphy idx to the NL80211_CMD_GET_REG,
> we'll return wiphy->regd for that case as well?

That's right, for now we'd be able to send the regd when either
NL80211_ATTR_WIPHY_SELF_MANAGED_REG is set or when
NL80211_ATTR_WIPHY_SELF_MANAGED_REG is not set but regulatory_hint()
was used. Note that some users may have REGULATORY_CUSTOM_REG. and
then later use regulatory_hint(), this is done to for example set a
more restrictive custom world regdomain and then later use the CRDA
data for a specific alpha2.

 Luis
