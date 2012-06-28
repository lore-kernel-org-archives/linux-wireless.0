Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4780 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2F1VYp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 17:24:45 -0400
Message-ID: <4FECCB91.7090609@broadcom.com> (sfid-20120628_232451_783762_4EBE8D5C)
Date: Thu, 28 Jun 2012 14:24:33 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Jon Hunter" <jon-hunter@ti.com>
cc: "Kevin Hilman" <khilman@ti.com>, b-cousson@ti.com,
	tony@atomide.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	grant.likely@secretlab.ca, santosh.shilimkar@ti.com,
	linux-omap@vger.kernel.org, tarun.kanti@ti.com,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Panda ES board hang when using GPIO as interrupt
References: <4FE8CF77.5080400@broadcom.com> <87txxxs9we.fsf@ti.com>
 <4FEBA854.5010508@broadcom.com> <4FEC7B48.8040402@ti.com>
In-Reply-To: <4FEC7B48.8040402@ti.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2012 08:42 AM, Jon Hunter wrote:
>
> On 06/27/2012 07:41 PM, Franky Lin wrote:
>> On 06/26/2012 08:37 PM, Kevin Hilman wrote:
>>> "Franky Lin" <frankyl@broadcom.com> writes:
>>>> I noticed Kevin raised some similar cases on other platforms and also
>>>> provided two patches in the patch mail thread. But unfortunately those
>>>> two patches doesn't help in our case. I tested the driver with 3.5-rc3
>>>> mainline kernel and the issue is still there. I can only "fix" the
>>>> hang by either reverting the commit or disabling
>>>> CONFIG_PM_RUNTIME. Also, the hang only happens on Panda ES board. Old
>>>> Panda with 4430 works good.
>>>>
>>>> Any thoughts and suggestions?
>>>
>>> If reverting the patch fixes your problem, can you isolate down to which
>>> part of that patch causes the problem?  IOW, can you fix your problem if
>>> you undo just the hunk added in runtime_suspend or undo just the moved
>>> hunk runtime_resume?  Or is reverting both required?
>>>
>>> I suspect the added runtime_suspend hunk is causing the problems, so can
>>> you see if just undoing that part works[1].  If that works, I will give
>>> a bit more of a thinking on it tomorrow.
>>
>> runtime_suspend hunk is fine. The hang still exist after reverting it.
>> The culprit is the moved hunk in runtime_resume. Reverting it makes the
>> hang disappear.
>
> Thanks. From reviewing the code the only thing that appears suspect based
> upon your findings is the return if we find the context has not been lost.
> We are not checking if "workaround_enabled" is set before we return.
>
> Could you try the following change on top of v3.5-rc3?
>

The patch doesn't help. And I also managed to probe the signal. It's 
active when it hung.

> Also, could you add a print in the runtime_suspend/resume() functions so
> we can see how often these are being called. In my case, I really don't see
> these being exercised and I am wondering how often you see suspend/resume
> being called in your setup.

Well, the runtime_suspend/resume never get called during the test.

Thanks,
Franky

