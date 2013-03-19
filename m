Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2602 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab3CSJBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 05:01:50 -0400
Message-ID: <5148296E.4080200@broadcom.com> (sfid-20130319_100155_749899_7EB03C06)
Date: Tue, 19 Mar 2013 10:01:34 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org,
	"David Spinadel" <dvdspndl@gmail.com>
Subject: Re: BUG: problem while tracing cfg80211
References: <51476F35.9040909@broadcom.com>
 <1363636984.8260.17.camel@jlt4.sipsolutions.net>
 <51478F06.9000506@broadcom.com> <514790A5.90004@broadcom.com>
 <1363681103.8336.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363681103.8336.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2013 09:18 AM, Johannes Berg wrote:
> On Mon, 2013-03-18 at 23:09 +0100, Arend van Spriel wrote:
>> On 03/18/2013 11:02 PM, Arend van Spriel wrote:
>>> On 03/18/2013 09:03 PM, Johannes Berg wrote:
>>>> On Mon, 2013-03-18 at 20:47 +0100, Arend van Spriel wrote:
>>>>> Hi Johannes,
>>>>>
>>>>> While testing David Spinadel's P2P device support functionality I got
>>>>> the following blurb, which is probably caused by cfg80211 tracing given
>>>>> the instruction pointer address.
>>>>>
>>>>> brcmfmac returns ERR_PTR(-ENOENT) and I think the trace code/macros do
>>>>> not take this into account.
>>>>
>>>> I guess this should fix it?
>>>>
>>>> http://p.sipsolutions.net/fdea39f2a56aff67.txt
>>>
>>> Did not test it, but that would be my guess to. Just another
>>> observation: Is the wdev identifier not defined as u64?
>
> Mind testing it? :-)

Left my test equipment at work. Just tested it and it works fine so:

Tested-by: Arend van Spriel <arend@broadcom.com>

>> Found the answer. In nl80211 API the wdev identifier is 64 bits, which
>> got me confused.
>
> Yes, externally it's a u64 but the high 32 bits are just the wiphy ID.
> Makes it easier to look things up based on the wdev index :-)

Thanks,
Arend


