Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:41524 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab3KGArl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:47:41 -0500
Received: by mail-qc0-f172.google.com with SMTP id c9so281853qcz.31
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 16:47:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UuRf=Wsfe_uym1+r+Ay0eNoJKa6Fo1Hi0r-LA8wTddng@mail.gmail.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
 <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com>
 <1383733459.14307.22.camel@jlt4.sipsolutions.net> <CAB=NE6UuRf=Wsfe_uym1+r+Ay0eNoJKa6Fo1Hi0r-LA8wTddng@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 7 Nov 2013 11:47:20 +1100
Message-ID: <CAGRGNgXdnwYnNYncPQGp=NNF1FxY3sFMSSf7arWYeX3v=PFAzw@mail.gmail.com> (sfid-20131107_014744_479874_153810E6)
Subject: Re: [PATCH 05/19] cfg80211: processing core regulatory hints on its own
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Thu, Nov 7, 2013 at 3:35 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Wed, Nov 6, 2013 at 2:24 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Tue, 2013-11-05 at 09:18 -0800, Luis R. Rodriguez wrote:
>>
>>>       struct wiphy *wiphy = NULL;
>>> +     enum reg_request_treatment treatment;
>>
>> This
>>
>>>       if (WARN_ON(!reg_request->alpha2))
>>>               return;
>>> @@ -1552,7 +1580,18 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>>>               return;
>>>       }
>>>
>>> -     switch (__regulatory_hint(wiphy, reg_request)) {
>>> +     switch (reg_request->initiator) {
>>> +     case NL80211_REGDOM_SET_BY_CORE:
>>> +             reg_process_hint_core(reg_request);
>>> +             return;
>
> Note that for the core request we bail out early.
>
>>> +     case NL80211_REGDOM_SET_BY_USER:
>>> +     case NL80211_REGDOM_SET_BY_DRIVER:
>>> +     case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>>> +             treatment = __regulatory_hint(wiphy, reg_request);
>>> +             break;
>>> +     }
>>> +
>>> +     switch (treatment) {
>>
>> is used uninitialized here
>
> As I see it in the code we either bail early or its assigned to the
> return value of __regulatory_hint() for the non-core case. Did I miss
> something?

I think Johannes just wants you to assign something to it so that
paranoid static checkers / compilers won't complain that it's unset in
the potential case where we make it through the switch without hitting
any of the cases. (Adding a default: case to the switch statement
would also work, but as you've been very very careful to spell out all
the cases here that'd tempt developers to remove all the careful
spelling out in some crazed cleanup binge.)

Of course this will never happen if reg_request->initiator is an enum
and all it's possible values are covered in the switch statement, but
some compilers (and developers like me) need it spelled out for them.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
