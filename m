Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbbISCpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 22:45:15 -0400
Message-ID: <55FCCC37.9000503@linux.intel.com> (sfid-20150919_044541_949693_B44D7C14)
Date: Sat, 19 Sep 2015 10:45:11 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: David Miller <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] net/wireless: enable wiphy device to suspend/resume asynchronously
References: <55B9B3BA.6080406@linux.intel.com>		 <CANUX_P3PMsvWCWWciwCsRvf5PqLVEK9d9S=2Gbq+EotVGffEow@mail.gmail.com>		 <55D13D66.1050500@linux.intel.com>	 <1439796553.2451.1.camel@sipsolutions.net> <55D19F57.4070605@broadcom.com>	 <55DA9374.2060909@linux.intel.com> <1440401918.3735.0.camel@sipsolutions.net>
In-Reply-To: <1440401918.3735.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015/8/24 15:38, Johannes Berg wrote:
> On Mon, 2015-08-24 at 11:45 +0800, Fu, Zhonghui wrote:
>> On 2015/8/17 16:46, Arend van Spriel wrote:
>>> + Rafael
>>>
>>> On 08/17/2015 09:29 AM, Johannes Berg wrote:
>>>> On Mon, 2015-08-17 at 09:48 +0800, Fu, Zhonghui wrote:
>>>>> The suspend/resume timing of wiphy device and related devices 
>>>>> will be
>>>>> ensured by their parent/child relationship. So, enabling wiphy 
>>>>> device
>>>>> to suspend/resume asynchronously does not change any 
>>>>>  dependency. It
>>>>> can only take advantage of multicore and improve system
>>>>> suspend/resume speed.
>>>>>
>>>> You're going to have to explain that to me, because I don't see 
>>>> that.
>>>> All I see is that when looking at a device, if async is possible, 
>>>> it
>>>> gets added to an async work, and if async is not possible then it 
>>>> gets
>>>> done immediately. Even putting aside the question of whether or 
>>>> not
>>>> async is ordered or not (I don't know), if the wiphy is async and 
>>>> the
>>>> PCI (or other bus) device isn't, then it seems they could get 
>>>> handled
>>>> out of order, no? Or is there some magic code somewhere that I'm
>>>> missing that explicitly waits for the async of the parent/child
>>>> relationship?
>>> This patch got me worried as well. Can't find the magic either. 
>>> Maybe Rafael can give some hints here.
>> "dpm_wait_for_children" function will be invoked in 
>> "__device_suspend", "__device_suspend_late", and 
>> "__device_suspend_noirq" functions to synchronize the child 
>> relationship. "dpm_wait" function will be invoked in 
>> "device_resume_noirq", "device_resume_early", and "device_resume" 
>> functions to synchronize the parent relationship. If two devices have 
>> parent/child relationship, but different suspend/resume mode(sync or 
>> async), this will have no impact to PM timing order between them. 
>> Because all devices will use "__device_suspend", 
>> "__device_suspend_late" ... functions to complete their PM 
>> transition.
>>
> Ok, good point. For the unaware here, can you please resend with a
> commit message amended with some of this information?
I take some leaves these days, so very sorry for late reply.

I have resent this patch with your advices - "[PATCH v2] net/wireless: enable wiphy device to suspend/resume asynchronously".


Thanks,
Zhonghui
>
> thanks,
> johannes

