Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32906 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdADUfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 15:35:12 -0500
Received: by mail-io0-f195.google.com with SMTP id 71so514330ioe.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:35:11 -0800 (PST)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id d25sm25240537ioj.25.2017.01.04.12.35.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2017 12:35:11 -0800 (PST)
Received: by mail-io0-f175.google.com with SMTP id d9so463174844ioe.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2017 12:35:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1483544433.7312.13.camel@sipsolutions.net>
References: <20161218002554.6362-1-andrew.zaborowski@intel.com> <1483544433.7312.13.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Wed, 4 Jan 2017 15:35:10 -0500
Message-ID: <CAOq732KZrpsjK96uwwe3hna2DPkwbN3CvJz+LFxJzXxWw08wRA@mail.gmail.com> (sfid-20170104_213515_572455_0998A0A9)
Subject: Re: [PATCH v4] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 January 2017 at 10:40, Johannes Berg <johannes@sipsolutions.net> wrote:
>> +++ b/net/wireless/mlme.c
>> @@ -340,6 +340,8 @@ int cfg80211_mlme_deauth(struct
>> cfg80211_registered_device *rdev,
>>
>>       ASSERT_WDEV_LOCK(wdev);
>>
>> +     wdev->conn_owner_nlportid = 0;
>
> Is this really correct? The deauth might not be to the current_bss, as
> you can see in the following if statement:
>
>>       if (local_state_change &&
>>           (!wdev->current_bss ||
>>            !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
>
> It seems that perhaps this should go into some other place, perhaps
> only be reset when current_bss is also reset to NULL?

In this case yes, I think I should perform the same bssid comparison.
But elsewhere we want conn_owner_nlportid to be set earlier than
current_bss, and reset earlier than current_bss because (1) we want to
be able to interrupt an ongoing attempt, and (2) we also don't want to
trigger another disconnect / deauth if one is already in progress.

>
>> @@ -14539,13 +14554,21 @@ static int nl80211_netlink_notify(struct
>> notifier_block * nb,
>>                               spin_unlock(&rdev-
>> >destroy_list_lock);
>>                               schedule_work(&rdev->destroy_work);
>>                       }
>> -             } else if (schedule_scan_stop) {
>> +
>> +                     continue;
>> +             }
>
> This also doesn't seem right - the same socket could possibly own both
> an interface and a connection? If the connection is on the same
> interface you might not really want to do both - though it shouldn't
> hurt if all the cancel_work is in the right place - but it could be a
> different interface?

This is only a syntactic change though.  The "continue" is now in the
"if (schedule_destroy_work)" block so the other actions will not be
scheduled is the interface is being destroyed.

Best regards
