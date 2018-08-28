Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50668 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1MhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:37:17 -0400
Message-ID: <1535445990.5895.4.camel@sipsolutions.net> (sfid-20180828_104644_447780_E63A01C2)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>,
        Denis Kenzior <denkenz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 10:46:30 +0200
In-Reply-To: <90d88655-0b0a-0b0f-9c4f-2535a0eaf75b@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-2-alexander@wetzel-home.de>
         <6ccc3055-02c4-8756-3926-ed8e247ba751@gmail.com>
         <90d88655-0b0a-0b0f-9c4f-2535a0eaf75b@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-08-18 at 22:53 +0200, Alexander Wetzel wrote:

> > This looks good to me from a userspace perspective.  I will try to
> > implement support for this in iwd soon to give you a prototype to play
> > with.
> 
> Sounds promising, thank you!
> 
> I'm still unsure if we really need the API changes to fix that issue:
> "Tagging" the new requirements to current set_key calls would also work.
> With the downside that there would be no way to detect "broken"
> drivers... replace_key is basically only there to differentiate between
> audited/fixed drivers and those not.
> 
> But since my current impression is, that ptk rekeys are mostly broken
> independent of mac80211 or even linux a driver flag signaling support
> for it sounds like a good idea regardless how we want to fix the issue
> in mac80211. Just wondering if we should name it differently for that
> and I'm considering renaming it to NL80211_EXT_FEATURE_CAN_REKEY_PTK0 in
> the next patch.

And then keep set_key() for both, rather than adding replace_key()?
Seems reasonable to me, I guess.

> As for mac80211 driver status:
> The only known "really broken" driver at the moment is ath9k. With
> iwlwifi, - and less thorough tested - ath10k to be ok from a driver
> point of view. (ath9k needs just a driver flush as minimal fix.)

iwlwifi is also broken for CCMP-256/GCMP keys, so the situation is
slightly more complex.

johannes
