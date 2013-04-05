Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34517 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162581Ab3DET3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 15:29:49 -0400
Message-ID: <515F2627.4050908@candelatech.com> (sfid-20130405_212953_784995_F6A1FC1A)
Date: Fri, 05 Apr 2013 12:29:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V4] cfg80211: introduce critical protocol indication from
 user-space
References: <1365168312-14780-1-git-send-email-arend@broadcom.com> <515ED9BF.20203@candelatech.com> <515F23A4.3040906@broadcom.com>
In-Reply-To: <515F23A4.3040906@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 12:19 PM, Arend van Spriel wrote:

>>> +    trace_rdev_crit_proto_stop(&rdev->wiphy, wdev);
>>> +    if (rdev->crit_proto_started) {
>>> +        ret = rdev->ops->crit_proto_stop(&rdev->wiphy, wdev);
>>> +        rdev->crit_proto_started = ret != 0;
>>
>> Maybe:  rdev->crit_proto_started = !ret;
>
> Maybe not. If ret == 0, crit_proto_started should be false. If ret != 0, ie. crit_proto_stop() failed, it should remain true. It is a bit of reverse logic. I
> could change it to !!ret or make it more clear using !ret ? false : true. Another idea is changing the return type of crit_proto_stop() to void and always set
> crit_proto_started to false.

Well, I had a hard time figuring out what that code was supposed to do (obviously).

Maybe just:
	if (ret == 0)
		rdev->crit_proto_started = false;

Or just require that the driver not fail this operation ever and always set crit_proto_started to false.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

