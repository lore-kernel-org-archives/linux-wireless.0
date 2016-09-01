Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39748 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751020AbcIAWBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 18:01:50 -0400
Message-ID: <1472752911.9608.11.camel@sipsolutions.net> (sfid-20160902_000155_251386_5F283A52)
Subject: Re: Ath10k probe response error related to mac80211 commit.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 01 Sep 2016 20:01:51 +0200
In-Reply-To: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com> (sfid-20160901_182956_271900_20A93AB4)
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
         (sfid-20160901_182956_271900_20A93AB4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If someone has any idea of why this patch might trigger it, please
> let me know.
> I'll keep digging in the meantime...
> 
>      Revert "mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE"
> 

With a sufficiently recent hostapd/wpa_supplicant, the patch will cause
a station entry to be added to the firmware before sending the
authentication frame.

Why, of all frames, probe response frames should be corrupted I don't
know - I could imagine auth/assoc replies being treated differently
since they are now with a station entry rather than without.

> This only breaks AP mode (station mode works fine).

It also has no impact on anything but AP mode, as even indicated by the
name of the flag :)


Anyway, I was pretty sure this was safe and it does help other drivers
to have the full state, but I guess you can make the driver opt out of
the flag again (just unset it before register_hw).

johannes
