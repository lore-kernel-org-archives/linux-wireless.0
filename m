Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2173 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2CHVcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 16:32:03 -0500
Message-ID: <4F592542.7000005@broadcom.com> (sfid-20120308_223208_292428_5A574D59)
Date: Thu, 8 Mar 2012 22:31:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
cc: "Seth Forshee" <seth.forshee@canonical.com>,
	"Quan, David" <dquan@qca.qualcomm.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problems with regulatory domain support and BCM43224
References: <20120307194001.GA2506@ubuntu-macmini>
 <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308200734.GC28133@ubuntu-macmini> <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
In-Reply-To: <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2012 10:06 PM, Luis R. Rodriguez wrote:
> On Thu, Mar 8, 2012 at 1:01 PM, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 03/08/2012 09:07 PM, Seth Forshee wrote:
>>>
>>> On Thu, Mar 08, 2012 at 11:51:03AM -0800, Luis R. Rodriguez wrote:
>>>>
>>>> On Thu, Mar 8, 2012 at 11:45 AM, Quan, David<dquan@qca.qualcomm.com>
>>>>   wrote:
>>>>>
>>>>> I think there is to it more than SW.
>>>>> Where ever you get this card, is the card tested and regulatory approved
>>>>> for those countries, DFS or not?
>>>>
>>>>
>>>> Seth, what driver are you using? I know you are using a BCM43224 card.
>>>
>>>
>>> brcmsmac
>>>
>>>>> It is possible that this card is only regulatory tested for non DFS
>>>>> channels, but now you enable them for passive.
>>>>
>>>>
>>>> That's a good point.
>>>>
>>>>> This means that yes, you are save and not violate DFS rules because you
>>>>> are in passive mode. However, you are in complete violation if the STA finds
>>>>> an AP on that DFS channel and then connects and transmits as this STA is not
>>>>> allow to transmit on that channel since it is not approved.
>>>>
>>>>
>>>> If the driver being used is a supported vendor driver then I'll punt
>>>> this to the vendor (Broadcom). If this is the reversed engineered
>>>> driver (b43) that Broadcom to this day seems to blindly ignore even
>>>> for regulatory, then I'm happy to recommend based on your input to
>>>> leave the regulatory domain as-is given that we cannot guarantee what
>>>> the vendor meant as they have not done any work on releasing either
>>>> documentation or code to help with their regulatory situation.
>>>
>>>
>>> It would be nice if Broadcom could weigh in. Cc-ing Arend.
>>
>>
>> Hi, Seth
>>
>> Noticed your email yesterday, but did not get to chime into the
>> conversation. brcmsmac does indeed provide a regulatory hint, which is
>> either from SPROM or hard-coded to "US". Since "X0" is not a known
>> regulatory domain for crda it does not make sense to pass it as a regulatory
>> hint. However, the "full" story is told on linuxwireless.org (see [1]).
>
> The Linux kernel allows you to define custom regulatory domains, the
> ath module uses these, it defines 13 of them. You can review that code
> for an example of how to use them. So your X0 can still be used, you
> just have to define the data structure.
>

Thanks, Luis

I will dive into that.

Gr. AvS


