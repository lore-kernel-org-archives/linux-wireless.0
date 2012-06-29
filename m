Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52640 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2F2Xvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:51:50 -0400
Message-ID: <4FEE3F90.7020409@hauke-m.de> (sfid-20120630_015153_956016_5CED5485)
Date: Sat, 30 Jun 2012 01:51:44 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] bcma: use custom printing functions
References: <1340971809-23703-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1340971809-23703-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2012 02:10 PM, Rafał Miłecki wrote:
> Having bus number printed makes it much easier to anaylze logs on
> systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
> in total, which makes standard log really messy.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: don't create "bus" variable when it's not really helpful
> don't brak strings
> 
> John: this applies on top of 5 patches accepted in the
> [PATCH 0/8] bcma misc updates
> patchset.
> 
> So:
> wireless-testing +
> 	bcma: extend workaround for bcm4331
> 	bcma: add constants for chip ids
> 	bcma: add PCI ID for BCM43224
> 	bcma: complete workaround for BCMA43224 and BCM4313
> 	bcma: add bcma_pmu_spuravoid_pllupdate()
> 
> And then:
> bcma: use custom printing functions
> applies cleanly :)

After applying your patch I still found some pr_ statements in the code,
just use "grep pr_ drivers/bcma/ -r", is this intended?

I just send a new version of my patches for bcma, they are now removing
some functions form driver_chipcommon_pmu.c so your patch will not apply
on them any more.

Hauke
