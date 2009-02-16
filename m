Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:3302 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZBPIOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 03:14:19 -0500
Received: by yx-out-2324.google.com with SMTP id 8so920180yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 00:14:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234695593.4219.47.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-6-git-send-email-lrodriguez@atheros.com>
	 <1234695593.4219.47.camel@johannes.local>
Date: Mon, 16 Feb 2009 00:14:17 -0800
Message-ID: <43e72e890902160014k11ba609lbe1340750771b6c0@mail.gmail.com> (sfid-20090216_091424_588796_BD96130C)
Subject: Re: [PATCH 05/10] cfg80211: add regulatory_hint_core() to separate
	the core reg hint
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 2:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:
>> This will allow us to clean up and make distinctions of who
>> needs locking or not.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/reg.c |   36 +++++++++++++++++++++++++++---------
>>  1 files changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index ba82312..679fded 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -1050,11 +1050,7 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
>>       case REGDOM_SET_BY_INIT:
>>               return -EINVAL;
>>       case REGDOM_SET_BY_CORE:
>> -             /*
>> -              * Always respect new wireless core hints, should only happen
>> -              * when updating the world regulatory domain at init.
>> -              */
>> -             return 0;
>> +             return -EINVAL;
>>       case REGDOM_SET_BY_COUNTRY_IE:
>>               if (unlikely(!is_an_alpha2(alpha2)))
>>                       return -EINVAL;
>> @@ -1183,6 +1179,26 @@ new_request:
>>       return call_crda(alpha2);
>>  }
>>
>> +static int regulatory_hint_core(const char *alpha2)
>> +{
>> +     struct regulatory_request *request;
>> +
>> +     BUG_ON(last_request);
>> +
>> +     request = kzalloc(sizeof(struct regulatory_request),
>> +                       GFP_KERNEL);
>> +     if (!request)
>> +             return -ENOMEM;
>> +
>> +     request->alpha2[0] = alpha2[0];
>> +     request->alpha2[1] = alpha2[1];
>> +     request->initiator = REGDOM_SET_BY_CORE;
>> +
>> +     last_request = request;
>
> So before you documented that cfg80211_mutex is used to protect this
> variable, but it's not used here.

This is only used during initialization, have any better ideas?

  Luis
