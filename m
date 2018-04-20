Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58083 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754148AbeDTJML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 05:12:11 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Bernhard Gabler <Bernhard_Gabler@web.de>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] reg: Rename confusing 'country IE' in log output
In-Reply-To: <1524207356.23123.8.camel@sipsolutions.net>
References: <20180419091738.9068-1-toke@toke.dk> <8ced0b02-af10-4d9d-9a68-cc08643a5cda@web.de> <1524207356.23123.8.camel@sipsolutions.net>
Date: Fri, 20 Apr 2018 11:12:09 +0200
Message-ID: <87604mz1g6.fsf@toke.dk> (sfid-20180420_111215_144291_A8D9561B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2018-04-20 at 00:32 +0200, Bernhard Gabler wrote:
>
>> looking at the patch, I see more occurences of the outdated "IE" in a 
>> constant name and function name:
>> 
>>          case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>> or
>>          reg_process_hint_country_ie()
>
>
> Right. I searched for further strings that would show up to the user,
> but didn't see any, but the code still refers to it in many places.
>
>> Would it make sense to likewise fix these (and possibly more) 
>> occurrences too, to match the spec from 2016?
>> For the sake of readability and consistency of code ...
>
> I dunno. Country IE isn't the only place where "IE" is used, it's even
> used in struct names (struct ieee80211_tim_ie, and many others), so I
> would think that people who actually work on the code will have to be
> aware of the previous wording of "Information Element" (and the
> abbreviation IE) anyway. Changing *everything* here to be just _element
> instead of _ie or then probably the shorter _elem would IMHO be too much
> code churn.

Also, no one is going to think that reg_process_hint_country_ie() has
anything to do with Ireland. So it's just a matter of outdated
terminology...

-Toke
