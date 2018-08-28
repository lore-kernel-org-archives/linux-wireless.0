Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 6.mo179.mail-out.ovh.net ([46.105.56.76]:49933 "EHLO
        6.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbeH1Two (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 15:52:44 -0400
Received: from player718.ha.ovh.net (unknown [10.109.159.7])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id A7909ECCE3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 18:00:23 +0200 (CEST)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
To: Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-2-alexander@wetzel-home.de>
 <6ccc3055-02c4-8756-3926-ed8e247ba751@gmail.com>
 <90d88655-0b0a-0b0f-9c4f-2535a0eaf75b@wetzel-home.de>
 <1535445990.5895.4.camel@sipsolutions.net>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <96e1cc76-26c7-3550-4717-e80984bcb92b@wetzel-home.de> (sfid-20180828_180027_773415_6C54F488)
Date: Tue, 28 Aug 2018 18:00:09 +0200
MIME-Version: 1.0
In-Reply-To: <1535445990.5895.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 28.08.18 um 10:46 schrieb Johannes Berg:
> On Sat, 2018-08-18 at 22:53 +0200, Alexander Wetzel wrote:
> 
>>> This looks good to me from a userspace perspective.  I will try to
>>> implement support for this in iwd soon to give you a prototype to play
>>> with.
>>
>> Sounds promising, thank you!
>>
>> I'm still unsure if we really need the API changes to fix that issue:
>> "Tagging" the new requirements to current set_key calls would also work.
>> With the downside that there would be no way to detect "broken"
>> drivers... replace_key is basically only there to differentiate between
>> audited/fixed drivers and those not.
>>
>> But since my current impression is, that ptk rekeys are mostly broken
>> independent of mac80211 or even linux a driver flag signaling support
>> for it sounds like a good idea regardless how we want to fix the issue
>> in mac80211. Just wondering if we should name it differently for that
>> and I'm considering renaming it to NL80211_EXT_FEATURE_CAN_REKEY_PTK0 in
>> the next patch.
> 
> And then keep set_key() for both, rather than adding replace_key()?
> Seems reasonable to me, I guess.

Exactly. The complete replace_key patch will be dropped. I've the
patches for that nearly ready, only working on the commit messages and
docu updates. (To code changes were trivial.)

> 
>> As for mac80211 driver status:
>> The only known "really broken" driver at the moment is ath9k. With
>> iwlwifi, - and less thorough tested - ath10k to be ok from a driver
>> point of view. (ath9k needs just a driver flush as minimal fix.)
> 
> iwlwifi is also broken for CCMP-256/GCMP keys, so the situation is
> slightly more complex.

I was suspecting something like that, thanks for confirming.

Alexander
