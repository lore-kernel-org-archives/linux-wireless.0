Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58446 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3DAUQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 16:16:07 -0400
Date: Mon, 1 Apr 2013 16:01:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Stable <stable@vger.kernel.org>
Subject: Re: [FIX 3.3+][PATCH] ssb: implement spurious tone avoidance
Message-ID: <20130401200156.GF3526@tuxdriver.com> (sfid-20130401_221618_470740_BA762F38)
References: <1364487482-14642-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1364487482-14642-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 05:18:02PM +0100, Rafał Miłecki wrote:
> And make use of it in b43. This fixes a regression introduced with
> 49d55cef5b1925a5c1efb6aaddaa40fc7c693335
> b43: N-PHY: implement spurious tone avoidance
> This commit made BCM4322 use only MCS 0 on channel 13, which of course
> resulted in performance drop (down to 0.7Mb/s).
> 
> Reported-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Stable <stable@vger.kernel.org>
> ---
> John:
> While this is fix, unfortunately it's not a one-liner. I wish to see it
> in 3.9 and backported to stable kernels, but if you think it's too big,
> well, just take it for the next.

  CC      drivers/ssb/driver_chipcommon_pmu.o
drivers/ssb/driver_chipcommon_pmu.c: In function ‘ssb_pmu_spuravoid_pllupdate’:
drivers/ssb/driver_chipcommon_pmu.c:695:3: error: implicit declaration of function ‘ssb_err’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [drivers/ssb/driver_chipcommon_pmu.o] Error 1
make: *** [drivers/ssb/] Error 2

When building in wireless.git...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
