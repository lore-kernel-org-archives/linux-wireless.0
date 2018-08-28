Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:55366 "EHLO
        6.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeH1U3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 16:29:36 -0400
Received: from player755.ha.ovh.net (unknown [10.109.146.20])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 91C621DF6F7
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 18:00:31 +0200 (CEST)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-2-alexander@wetzel-home.de>
 <1535446026.5895.5.camel@sipsolutions.net>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <4cc30aa2-6235-f76c-485f-48fac8af3c1a@wetzel-home.de> (sfid-20180828_183710_846724_5B268CDF)
Date: Tue, 28 Aug 2018 18:00:22 +0200
MIME-Version: 1.0
In-Reply-To: <1535446026.5895.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 28.08.18 um 10:47 schrieb Johannes Berg:
> On Tue, 2018-08-14 at 12:42 +0200, Alexander Wetzel wrote:
>> Drivers able to correctly replace a in-use key should set
>> NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to allow the userspace (e.g.
>> hostapd or wpa_supplicant) to rekey PTK keys.
>>
>> The userspace must detect a PTK rekey attempt and only go ahead with the
>> rekey when the driver has set this flag. If the driver is not supporting
>> the feature the userspace either must not replace the PTK key or perform
>> a full re-association.
>>
>> Ignoring this flag and continuing to rekey the connection can still
>> work but has to be considered insecure and broken. It can leak cleartext
>> packets or freeze the connection and is only supported to allow the
>> userspace to be updated.
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>  include/uapi/linux/nl80211.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 7acc16f34942..b41b9ade0449 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -5224,6 +5224,11 @@ enum nl80211_feature_flags {
>>   *	except for supported rates from the probe request content if requested
>>   *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
>>   *
>> + * @NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE: Driver/device confirm that they are
>> + *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
>> + *      if this flag is not set. Ignoring this can leak clear text packets and/or
>> + *      freeze the connection.
> 
> 
> If you have a flag here, why say "userspace must not" rather than just
> outright prevent userspace from doing it?

The userspace must not but currently of course is doing exactly that.
Enforcing the new requirement would therefore cause user visible
regressions till all drivers have been updated or the updated userspace
software is deployed on all systems... Both will take years.

So the current approach is keep backward compatibility to not break
rekeys for users it's currently working for.

Alexander
