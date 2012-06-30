Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43282 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2F3JYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 05:24:03 -0400
Received: by wibhr14 with SMTP id hr14so1668896wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2012 02:24:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEE3F90.7020409@hauke-m.de>
References: <1340971809-23703-1-git-send-email-zajec5@gmail.com>
	<4FEE3F90.7020409@hauke-m.de>
Date: Sat, 30 Jun 2012 11:24:01 +0200
Message-ID: <CACna6rx=4HJvRcCJWUdz3MSrZjdZgNmLZLeS6KDr4QQzv85Y2A@mail.gmail.com> (sfid-20120630_112408_189136_7B56093A)
Subject: Re: [PATCH V2] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/30 Hauke Mehrtens <hauke@hauke-m.de>:
> On 06/29/2012 02:10 PM, Rafał Miłecki wrote:
>> Having bus number printed makes it much easier to anaylze logs on
>> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
>> in total, which makes standard log really messy.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> V2: don't create "bus" variable when it's not really helpful
>> don't brak strings
>>
>> John: this applies on top of 5 patches accepted in the
>> [PATCH 0/8] bcma misc updates
>> patchset.
>>
>> So:
>> wireless-testing +
>>       bcma: extend workaround for bcm4331
>>       bcma: add constants for chip ids
>>       bcma: add PCI ID for BCM43224
>>       bcma: complete workaround for BCMA43224 and BCM4313
>>       bcma: add bcma_pmu_spuravoid_pllupdate()
>>
>> And then:
>> bcma: use custom printing functions
>> applies cleanly :)
>
> After applying your patch I still found some pr_ statements in the code,
> just use "grep pr_ drivers/bcma/ -r", is this intended?

Yes, it is. Sometimes we don't have bus reference (or it doesn't
exists at all yet). For such a situations I kept define of pr_fmt - it
allows us to still have "bcma: " prefix when using standard pr_<level>
functions.


> I just send a new version of my patches for bcma, they are now removing
> some functions form driver_chipcommon_pmu.c so your patch will not apply
> on them any more.

Yeah, I'll. John: drop this version of patch as it won't apply.

-- 
Rafał
