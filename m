Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:48421 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab0HYSmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 14:42:18 -0400
Message-ID: <4C7563FE.10301@redfish-solutions.com>
Date: Wed, 25 Aug 2010 11:42:06 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
References: <4C746F74.70401@redfish-solutions.com>	 <1282723861.3685.4.camel@jlt3.sipsolutions.net> <1282724412.3685.5.camel@jlt3.sipsolutions.net> <4C7551A4.4040605@redfish-solutions.com>
In-Reply-To: <4C7551A4.4040605@redfish-solutions.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/25/10 10:23 AM, Philip Prindeville wrote:
>  On 8/25/10 1:20 AM, Johannes Berg wrote:
>> On Wed, 2010-08-25 at 10:11 +0200, Johannes Berg wrote:
>>
>>>> authentication: STA=f8:1e:df:1e:c2:23 auth_alg=35510 auth_transaction=79 status_code=21688 wep=1
>>>> Unsupported authentication algorithm (35510)
>>>>
>>>>
>>>> I'm wondering if some messages that are passed up to user-space via
>>>> netlink from the driver might have changed their schema, i.e. adding
>>>> new fields in the middle of a structure or moving fields around within
>>>> a structure.
>>> Looks more like a crypto problem to me, as this should be the encrypted
>>> challenge in your shared key handshake. IOW, it looks like the frame
>>> isn't getting decrypted by mac80211 for some reason.
>> Works fine here in hwsim, so likely to be either a driver problem (hw
>> decrypts frame, but driver doesn't tell us so), something that has been
>> fixed between then and now, or a compat specific problem.
>>
>> johannes
>
> I'll bump to yesterday's baking, apply your patch, and retry.  Maybe it was a spurious issue.
>
> If that doesn't work, I'll try forcing h/w decryption off in the NIC.


Retried with yesterday's baking.  No joy.  Also reloaded the module with nohwcrypt=1 and same result (except that the value in the auth_alg field changed from 6421 to 44995).


