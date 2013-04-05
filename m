Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4672 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162530Ab3DETTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 15:19:09 -0400
Message-ID: <515F23A4.3040906@broadcom.com> (sfid-20130405_211912_900729_FE70055D)
Date: Fri, 5 Apr 2013 21:19:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Greear" <greearb@candelatech.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V4] cfg80211: introduce critical protocol indication
 from user-space
References: <1365168312-14780-1-git-send-email-arend@broadcom.com>
 <515ED9BF.20203@candelatech.com>
In-Reply-To: <515ED9BF.20203@candelatech.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 04:03 PM, Ben Greear wrote:
> On 04/05/2013 06:25 AM, Arend van Spriel wrote:
>> Some protocols need a more reliable connection to complete
>> successful in reasonable time. This patch adds a user-space
>> API to indicate the wireless driver that a critical protocol
>> is about to commence and when it is done, using nl80211 primitives
>> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
>>
>> There can be only on critical protocol session started per
>> registered cfg80211 device. The driver can support this by
>> implementing the cfg80211 callbacks .crit_proto_start() and
>> .crit_proto_stop(). Examples of protocols that can benefit from
>> this are DHCP, EAPOL, APIPA. Exactly how the link can/should be
>> made more reliable is up to the driver. Things to consider are
>> avoid scanning, no multi-channel operations, and alter coexistence
>> schemes.
>>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---

>> +
>> +    duration = max_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);
>
> Maybe that should be min_t(....) ?

Yes, definitely.

>> cfg80211_registered_device *rdev,
>> +                    struct wireless_dev *wdev,
>> +                    enum nl80211_crit_proto_id protocol,
>> +                    u16 duration)
>> +{
>> +    int ret;
>> +
>> +    trace_rdev_crit_proto_start(&rdev->wiphy, wdev, protocol, duration);
>> +    ret = rdev->ops->crit_proto_start(&rdev->wiphy, wdev,
>> +                      protocol, duration);
>> +    rdev->crit_proto_started = !ret;
>> +    trace_rdev_return_int(&rdev->wiphy, ret);
>> +    return ret;
>> +}
>> +
>> +static inline int rdev_crit_proto_stop(struct
>> cfg80211_registered_device *rdev,
>> +                       struct wireless_dev *wdev)
>> +{
>> +    int ret = 0;
>> +
>> +    trace_rdev_crit_proto_stop(&rdev->wiphy, wdev);
>> +    if (rdev->crit_proto_started) {
>> +        ret = rdev->ops->crit_proto_stop(&rdev->wiphy, wdev);
>> +        rdev->crit_proto_started = ret != 0;
>
> Maybe:  rdev->crit_proto_started = !ret;

Maybe not. If ret == 0, crit_proto_started should be false. If ret != 0, 
ie. crit_proto_stop() failed, it should remain true. It is a bit of 
reverse logic. I could change it to !!ret or make it more clear using 
!ret ? false : true. Another idea is changing the return type of 
crit_proto_stop() to void and always set crit_proto_started to false.

Gr. AvS

