Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34124 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933042AbaGVW4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 18:56:08 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so6642125wiv.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 15:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405937608.32255.15.camel@jlt4.sipsolutions.net>
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405937608.32255.15.camel@jlt4.sipsolutions.net>
Date: Wed, 23 Jul 2014 00:56:07 +0200
Message-ID: <CAA2SeNKL1ZQq_G6My1Fz+vmptML1RwjTjzxBM5v8sbXCq8C0nQ@mail.gmail.com> (sfid-20140723_005628_391964_EE01097A)
Subject: Re: [PATCH 1/2] cfg80211: add enable_dynack API
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun, 2014-07-20 at 14:32 +0200, Lorenzo Bianconi wrote:
>
>> @@ -2192,6 +2193,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>>                       return result;
>>       }
>>
>> +     if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
>> +             result = rdev_enable_dynack(rdev);
>> +             if (result)
>> +                     return result;
>> +     }
>
> I think it may be better to handle this in the call that's normally used
> (coverage class setting), but allow the other attribute to make a sort
> of "dynamic coverage class". And internally, calling drivers, it seems
> fine to pass -1 or so since you can extend the datatype there, instead
> of introducing a new internal callback. External/internal doesn't always
> have to match perfectly.
>

So we can pass coverage class equal to -1 to lower drivers in order to
enable ack timeout estimation. In this case I have to modify driver
routine signature in p54, ath5k and ath9k drivers. Moreover in
cfg80211/mac80211 stack we can take into account dynamic coverage
class using s16 datatype instead of u8 for coverage_class in wiphy
data structure.

> Additionally, you'll need some capability flag I think.
>
> johannes
>

Best regards,
Lorenzo


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
