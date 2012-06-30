Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53373 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab2F3JlA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 05:41:00 -0400
Message-ID: <4FEEC9A5.3010207@hauke-m.de> (sfid-20120630_114121_411912_54D8ED72)
Date: Sat, 30 Jun 2012 11:40:53 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] bcma: use custom printing functions
References: <1340971809-23703-1-git-send-email-zajec5@gmail.com> <4FEE3F90.7020409@hauke-m.de> <CACna6rx=4HJvRcCJWUdz3MSrZjdZgNmLZLeS6KDr4QQzv85Y2A@mail.gmail.com>
In-Reply-To: <CACna6rx=4HJvRcCJWUdz3MSrZjdZgNmLZLeS6KDr4QQzv85Y2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 11:24 AM, Rafał Miłecki wrote:
> 2012/6/30 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 06/29/2012 02:10 PM, Rafał Miłecki wrote:
>>> Having bus number printed makes it much easier to anaylze logs on
>>> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
>>> in total, which makes standard log really messy.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>> V2: don't create "bus" variable when it's not really helpful
>>> don't brak strings
>>>
>>> John: this applies on top of 5 patches accepted in the
>>> [PATCH 0/8] bcma misc updates
>>> patchset.
>>>
>>> So:
>>> wireless-testing +
>>>       bcma: extend workaround for bcm4331
>>>       bcma: add constants for chip ids
>>>       bcma: add PCI ID for BCM43224
>>>       bcma: complete workaround for BCMA43224 and BCM4313
>>>       bcma: add bcma_pmu_spuravoid_pllupdate()
>>>
>>> And then:
>>> bcma: use custom printing functions
>>> applies cleanly :)
>>
>> After applying your patch I still found some pr_ statements in the code,
>> just use "grep pr_ drivers/bcma/ -r", is this intended?
> 
> Yes, it is. Sometimes we don't have bus reference (or it doesn't
> exists at all yet). For such a situations I kept define of pr_fmt - it
> allows us to still have "bcma: " prefix when using standard pr_<level>
> functions.

Ok that makes sense.
But then you missed two in sprom.c, there are two pr_debug() calls in
sprom.c, where bus exists.
> 
> 
>> I just send a new version of my patches for bcma, they are now removing
>> some functions form driver_chipcommon_pmu.c so your patch will not apply
>> on them any more.
> 
> Yeah, I'll. John: drop this version of patch as it won't apply.
> 


