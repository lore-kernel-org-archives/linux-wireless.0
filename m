Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2672 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab2C3MPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 08:15:00 -0400
Message-ID: <4F75A3B8.7040501@broadcom.com> (sfid-20120330_141504_340499_48FEF360)
Date: Fri, 30 Mar 2012 14:14:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat: crc8: undef pr_fmt
References: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
 <4F759DE4.6070201@broadcom.com>
 <1333108491.12545.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333108491.12545.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2012 01:54 PM, Johannes Berg wrote:
> On Fri, 2012-03-30 at 13:49 +0200, Arend van Spriel wrote:
>> On 03/30/2012 01:13 PM, Johannes Berg wrote:
>>>
>>> +#ifdef pr_fmt
>>> +#undef pr_fmt
>>> +#endif
>>>    #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>>>
>>>    #include<linux/module.h>
>>
>> Trivial remark. Not really necessary to do the #ifdef. #undef works fine
>> if pr_fmt has not been defined.
>
> Really? I thought it would give a warning then, but couldn't test it
> since it was defined for me.
>
> johannes
>
>

I made a little test program to confirm my thought, before sending my 
previous email. Retried compiling with '-W -Wall -ansi -pedantic' and no 
complaints about the #undef.

Gr. AvS

