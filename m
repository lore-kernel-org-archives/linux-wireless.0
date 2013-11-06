Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:59826 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3KFQfr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 11:35:47 -0500
Received: by mail-la0-f53.google.com with SMTP id eh20so5567716lab.26
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 08:35:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383733459.14307.22.camel@jlt4.sipsolutions.net>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
 <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com> <1383733459.14307.22.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 6 Nov 2013 08:35:26 -0800
Message-ID: <CAB=NE6UuRf=Wsfe_uym1+r+Ay0eNoJKa6Fo1Hi0r-LA8wTddng@mail.gmail.com> (sfid-20131106_173550_660842_741E68A1)
Subject: Re: [PATCH 05/19] cfg80211: processing core regulatory hints on its own
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 6, 2013 at 2:24 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-11-05 at 09:18 -0800, Luis R. Rodriguez wrote:
>
>>       struct wiphy *wiphy = NULL;
>> +     enum reg_request_treatment treatment;
>
> This
>
>>       if (WARN_ON(!reg_request->alpha2))
>>               return;
>> @@ -1552,7 +1580,18 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>>               return;
>>       }
>>
>> -     switch (__regulatory_hint(wiphy, reg_request)) {
>> +     switch (reg_request->initiator) {
>> +     case NL80211_REGDOM_SET_BY_CORE:
>> +             reg_process_hint_core(reg_request);
>> +             return;

Note that for the core request we bail out early.

>> +     case NL80211_REGDOM_SET_BY_USER:
>> +     case NL80211_REGDOM_SET_BY_DRIVER:
>> +     case NL80211_REGDOM_SET_BY_COUNTRY_IE:
>> +             treatment = __regulatory_hint(wiphy, reg_request);
>> +             break;
>> +     }
>> +
>> +     switch (treatment) {
>
> is used uninitialized here

As I see it in the code we either bail early or its assigned to the
return value of __regulatory_hint() for the non-core case. Did I miss
something?

  Luis
