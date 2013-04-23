Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2147 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab3DWHcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 03:32:10 -0400
Message-ID: <517638DA.1070505@broadcom.com> (sfid-20130423_093214_915098_9A3B5535)
Date: Tue, 23 Apr 2013 09:31:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V7 1/3] cfg80211: introduce critical protocol
 indication from user-space
References: <1366292942-21038-1-git-send-email-arend@broadcom.com>
 <1366638588.8637.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366638588.8637.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/22/2013 03:49 PM, Johannes Berg wrote:
> On Thu, 2013-04-18 at 15:49 +0200, Arend van Spriel wrote:
>> Some protocols need a more reliable connection to complete
>> successful in reasonable time. This patch adds a user-space
>> API to indicate the wireless driver that a critical protocol
>> is about to commence and when it is done, using nl80211 primitives
>> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
>>
>> There can be only on critical protocol session started per
>> registered cfg80211 device.
>>
>> The driver can support this by implementing the cfg80211 callbacks
>> .crit_proto_start() and .crit_proto_stop(). Examples of protocols
>> that can benefit from this are DHCP, EAPOL, APIPA. Exactly how the
>> link can/should be made more reliable is up to the driver. Things
>> to consider are avoid scanning, no multi-channel operations, and
>> alter coexistence schemes.
>
> Applied.

Thanks,

I do not see the brcmfmac patches so I guess you dropped those, right. 
They probably did not apply after merging wireless-next. I will rebase 
and submit them to John.

Regards,
Arend


