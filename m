Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:36799 "EHLO
        6.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeHSCdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 22:33:08 -0400
Received: from player718.ha.ovh.net (unknown [10.109.160.143])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 7293E1CA0DC
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2018 22:54:20 +0200 (CEST)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
To: Denis Kenzior <denkenz@gmail.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-2-alexander@wetzel-home.de>
 <6ccc3055-02c4-8756-3926-ed8e247ba751@gmail.com>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <90d88655-0b0a-0b0f-9c4f-2535a0eaf75b@wetzel-home.de> (sfid-20180819_012444_247762_FA3A40E7)
Date: Sat, 18 Aug 2018 22:53:56 +0200
MIME-Version: 1.0
In-Reply-To: <6ccc3055-02c4-8756-3926-ed8e247ba751@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis

Am 16.08.18 um 18:30 schrieb Denis Kenzior:
> Hi Alexander,
> 
> On 08/14/2018 05:42 AM, Alexander Wetzel wrote:
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
>>   include/uapi/linux/nl80211.h | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
> 
> This looks good to me from a userspace perspective.  I will try to
> implement support for this in iwd soon to give you a prototype to play
> with.

Sounds promising, thank you!

I'm still unsure if we really need the API changes to fix that issue:
"Tagging" the new requirements to current set_key calls would also work.
With the downside that there would be no way to detect "broken"
drivers... replace_key is basically only there to differentiate between
audited/fixed drivers and those not.

But since my current impression is, that ptk rekeys are mostly broken
independent of mac80211 or even linux a driver flag signaling support
for it sounds like a good idea regardless how we want to fix the issue
in mac80211. Just wondering if we should name it differently for that
and I'm considering renaming it to NL80211_EXT_FEATURE_CAN_REKEY_PTK0 in
the next patch.

As for mac80211 driver status:
The only known "really broken" driver at the moment is ath9k. With
iwlwifi, - and less thorough tested - ath10k to be ok from a driver
point of view. (ath9k needs just a driver flush as minimal fix.)
rt2800usb is also working fine with this patch series, but I have not
looked into the driver to figure out if this is due to the additional
flush or not.

> Reviewed-by: Denis Kenzior <denkenz@gmail.com>
Again thanks. I've added that to my git tree and it will be in next
patch version.
I'll just wait some  days for more feedback to hopefully accumulate more
changes in the next series.

Alexander
