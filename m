Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48597 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758009Ab3DAVgx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 17:36:53 -0400
Message-ID: <5159FDE5.6060803@hauke-m.de> (sfid-20130401_233658_643002_999B132C)
Date: Mon, 01 Apr 2013 23:36:37 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Stable <stable@vger.kernel.org>
Subject: Re: [FIX 3.3+][PATCH] ssb: implement spurious tone avoidance
References: <1364487482-14642-1-git-send-email-zajec5@gmail.com> <20130401200156.GF3526@tuxdriver.com>
In-Reply-To: <20130401200156.GF3526@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/2013 10:01 PM, John W. Linville wrote:
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

ssb_err is only in wireless-next, it was added in this commit:
commit 33a606ac8020b47292bcfda30c7888c1ab5233e2
Author: Joe Perches <joe@perches.com>
Date:   Wed Feb 20 12:16:13 2013 -0800

    ssb: Convert ssb_printk to ssb_<level>

This version should go into wireless-next for kernel 3.10 and an other
version using ssb_printk(KERN_ERR PFX " instated should go into 3.9 and
stable.

Hauke
