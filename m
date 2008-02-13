Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936AbYBMQve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 11:51:34 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] iwl3945 rfkill regression
Date: Wed, 13 Feb 2008 08:48:54 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A7F599@orsmsx416.amr.corp.intel.com> (sfid-20080213_165140_061588_6F69394D)
In-Reply-To: <47B29F63.6050605@gmail.com>
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>	 <C07C4589BE74A34981C3C3525EE1F8010338CB35@hasmsx412.ger.corp.intel.com>	 <f6ca9fed0801221212k709f04dbx1f81cab4c724996a@mail.gmail.com>	 <C07C4589BE74A34981C3C3525EE1F8010338CB49@hasmsx412.ger.corp.intel.com>	 <f6ca9fed0801221224u7ddf1569qa29860466ac27d86@mail.gmail.com>	 <f6ca9fed0801261100j7939056dke661a422ec507fce@mail.gmail.com> <1ba2fa240801261411x7bb437c9s31aea593537afeba@mail.gmail.com> <47B29F63.6050605@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "drago01" <drago01@gmail.com>, "Tomas Winkler" <tomasw@gmail.com>
Cc: "Dan Williams" <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, February 12, 2008 11:42 PM, drago01  wrote:

> Tomas Winkler wrote:
>> On Jan 26, 2008 9:00 PM, drago01 <drago01@gmail.com> wrote:
>> 
>>> On Jan 22, 2008 9:24 PM, drago01 <drago01@gmail.com> wrote:
>>> 
>>>> On Jan 22, 2008 9:21 PM, Winkler, Tomas
> <tomas.winkler@intel.com> wrote:
>>>> 
>>>>> 
>>>>>> -----Original Message-----
>>>>>> From: drago01 [mailto:drago01@gmail.com]
>>>>>> Sent: Tuesday, January 22, 2008 10:12 PM
>>>>>> To: Winkler, Tomas
>>>>>> 
>>>>>> Cc: ipw3945-devel; Cahill, Ben M; Zhu, Yi; linux-wireless
>>>>>> Subject: Re: [ipw3945-devel] iwl3945 rfkill regression
>>>>>> 
>>>>>> On Jan 22, 2008 9:07 PM, Winkler, Tomas <tomas.winkler@intel.com>
>>>>>> 
>>>>> wrote:
>>>>> 
>>>>>>> I believe it's delaying uCode load to mac_start - still need to
>>>>>>> be polished. 
>>>>>>> 
>>>>>> ok, thx for the quick reply.
>>>>>> If you have any potential fixes I would be happy to test them ;)
>>>>>> 
>>>>> Can you get me the sequence it is happening? RF kill switch is off
>>>>> before you power up the laptop or after, during association or in
>>>>> unassociated state..etc Thanks
>>>>> 
>>>> I boot with rf kill off = device on
>>>> acciotate using NM
>>>> kill the card by pressing the rfkill (ie. setting it to on)
>>>> card is dead (like described in my first mail), until I relaod the
>>>> module the rfkill switch  does not have any effect at this time.
>>>> 
>>>> 
>>> OK, I investigated a bit and it seems to be the "disable interrupt
>>> when device goes down" is the problem.
>>> In my case NetworkManager detected the rfkill and brought the device
>>> down, which caused the interrupt to be disabled. Now after pressing
>>> the rfkill again nothing happend. But if I bring the device back up
>>> the interrupt is enabled again and rfkill and the card is back to
>>> live. So in short disabling the interrupt in mac_stop breaks the hw
>>> rfkill while the interface is down. 
>>> 
>>> 
>> 
>> Thanks for investigating this, still didn't have to time to dig into
>> it. 
>> 
>> 
> ping?

We are working on this.

Reinette
