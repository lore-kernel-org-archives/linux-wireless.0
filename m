Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1666 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab2CULF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 07:05:58 -0400
Message-ID: <4F69B604.4030303@broadcom.com> (sfid-20120321_120608_474074_3D3D53C3)
Date: Wed, 21 Mar 2012 12:05:40 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
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
 <20120320220706.GA17272@thinkpad-t410>
In-Reply-To: <20120320220706.GA17272@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2012 11:07 PM, Seth Forshee wrote:
> On Thu, Mar 08, 2012 at 01:06:57PM -0800, Luis R. Rodriguez wrote:
>>> Hi, Seth
>>>
>>> Noticed your email yesterday, but did not get to chime into the
>>> conversation. brcmsmac does indeed provide a regulatory hint, which is
>>> either from SPROM or hard-coded to "US". Since "X0" is not a known
>>> regulatory domain for crda it does not make sense to pass it as a regulatory
>>> hint. However, the "full" story is told on linuxwireless.org (see [1]).
>>
>> The Linux kernel allows you to define custom regulatory domains, the
>> ath module uses these, it defines 13 of them. You can review that code
>> for an example of how to use them. So your X0 can still be used, you
>> just have to define the data structure.
>
> I took a shot at implementing custom regulatory domain support for
> brcmsmac. I've got it working to the point of letting me see APs on the
> DFS channels at least. The patch is below. A number of issues
> undoubtedly remain to be resolved. Some that I can think of:

Hi Seth,

Thanks for looking into this. I also did some tinkering over here, but 
not sure which way to go here, ie. 1) define and use custom regulatory 
domains, or 2) be happy with world regulatory domain as is and do not 
pass the custom codes if found in sprom.

>   - I set up two custom domains, X0 and X2, which are identical. I'm not
>     sure precisely how each needs to be set up, but I took a reasonable
>     guess.

There are 9 custom domains in the proprietary driver. X0 only allows 
using channels 1-11. X2 allows 1-13. There are other parameters like 
rates and txpower that may differ.

>   - I tried to integrate with the existing X2 domain support, but this
>     could probably be improved. I avoided making large changes because
>     there's some complexity in the current code that doesn't seem to
>     serve a purpose currently, but I assume it's there for a reason.

The code in channel.c was taken from our proprietary driver. Basically, 
the LOCALES hold the same information as the rules in regdomain.

>   - The flow of the initialization and organization of the code make it
>     necessary to search through the list of custom regulatory domains
>     many times. It would be nice to improve upon this.
>
> Does this look to be on the right track?
>

Looks good. I will see if I can map the LOCALES for these to regdomain 
rules.

Gr. AvS

