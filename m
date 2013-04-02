Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49503 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639Ab3DBN4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 09:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130401200156.GF3526@tuxdriver.com>
References: <1364487482-14642-1-git-send-email-zajec5@gmail.com>
	<20130401200156.GF3526@tuxdriver.com>
Date: Tue, 2 Apr 2013 15:56:49 +0200
Message-ID: <CACna6rz0apBzEFKVw3EK=hfKVADFZKzM2G6D20BOtD97-NGCJA@mail.gmail.com> (sfid-20130402_155707_420438_03F74A43)
Subject: Re: [FIX 3.3+][PATCH] ssb: implement spurious tone avoidance
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/1 John W. Linville <linville@tuxdriver.com>:
> On Thu, Mar 28, 2013 at 05:18:02PM +0100, Rafał Miłecki wrote:
>> And make use of it in b43. This fixes a regression introduced with
>> 49d55cef5b1925a5c1efb6aaddaa40fc7c693335
>> b43: N-PHY: implement spurious tone avoidance
>> This commit made BCM4322 use only MCS 0 on channel 13, which of course
>> resulted in performance drop (down to 0.7Mb/s).
>>
>> Reported-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Cc: Stable <stable@vger.kernel.org>
>> ---
>> John:
>> While this is fix, unfortunately it's not a one-liner. I wish to see it
>> in 3.9 and backported to stable kernels, but if you think it's too big,
>> well, just take it for the next.
>
>   CC      drivers/ssb/driver_chipcommon_pmu.o
> drivers/ssb/driver_chipcommon_pmu.c: In function ‘ssb_pmu_spuravoid_pllupdate’:
> drivers/ssb/driver_chipcommon_pmu.c:695:3: error: implicit declaration of function ‘ssb_err’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [drivers/ssb/driver_chipcommon_pmu.o] Error 1
> make: *** [drivers/ssb/] Error 2
>
> When building in wireless.git...

I'm sorry for that. Tree wireless.git is based on 3.9-rc1, which
contains nouveau regression and I was too lazy to backport fix and
test it well. I could at least try compiling it :|

-- 
Rafał
