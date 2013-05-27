Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3265 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3E0Rka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 13:40:30 -0400
Message-ID: <51A39A7F.1070806@broadcom.com> (sfid-20130527_194033_493212_AC2E026A)
Date: Mon, 27 May 2013 19:40:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Jouni Malinen" <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jithu Jance" <jithu@broadcom.com>
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface
 option
References: <51A09F43.5030004@broadcom.com>
 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
 <51A36603.7020403@broadcom.com>
 <1369663161.14740.13.camel@jlt4.sipsolutions.net>
 <51A367CB.9080503@broadcom.com>
 <1369669990.14740.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369669990.14740.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2013 05:53 PM, Johannes Berg wrote:
> On Mon, 2013-05-27 at 16:03 +0200, Arend van Spriel wrote:
>> On 05/27/2013 03:59 PM, Johannes Berg wrote:
>>> On Mon, 2013-05-27 at 15:56 +0200, Arend van Spriel wrote:
>>>
>>>>> I don't think I'd do either of those. Not creating P2P_DEVICE will
>>>>> simply not work with drivers expecting it, and changing iftype to/from
>>>>> P2P-Device isn't supported since it would delete/create the netdev.
>>>>
>>>> So should we check that in cfg80211 upon wiphy_register().
>>>
>>> Check what?
>>
>> Check that the interface combinations contain a iface limit with only
>> P2P_DEVICE:
>>
>> 	{
>> 		.max = 1,
>> 		.types = BIT(NL80211_IFTYPE_P2P_DEVICE)
>> 	}
>
> We have that, right?
>
> wiphy_verify_combinations:
>                          /* Only a single P2P_DEVICE can be allowed */
>                          if (WARN_ON(types &
> BIT(NL80211_IFTYPE_P2P_DEVICE) &&
>                                      c->limits[j].max > 1))
>                                  return -EINVAL;

I see. I did not search the code. my bad.

Gr. AvS


