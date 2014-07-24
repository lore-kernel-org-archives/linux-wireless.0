Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:44570 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGXMVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 08:21:19 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so2667030wes.24
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 05:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406200256.14675.17.camel@jlt4.sipsolutions.net>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406200256.14675.17.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Jul 2014 14:21:17 +0200
Message-ID: <CAA2SeN+zR_CUp4S7Vs0THpaMBKJqkwAPJdrDddhsxL4E1hhV3g@mail.gmail.com> (sfid-20140724_142122_250002_415A66E5)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:
>
>> @@ -2242,10 +2243,15 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>>               changed |= WIPHY_PARAM_COVERAGE_CLASS;
>>       }
>>
>> +     if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
>> +             coverage_class = -1;
>> +             changed |= WIPHY_PARAM_COVERAGE_CLASS;
>> +     }
>
> I think you should also reject having both dyn and fixed attributes.
>

Currently iw does not allow to set both attribute at the same time,
but I can use "if-else if" statement in order to exclude that
condition.

> You should also have a feature flag that drivers set that you test here
> and refuse dynamic if it's not supported, I guess?
>

I would rely on lower drivers to fail (returning -EOPNOTSUPP to
set_coverage_class caller) if dynack it is not supported and user is
trying to enable it. Does it sound good for you?

> johannes
>

Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
