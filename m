Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39422 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab2HJMyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 08:54:52 -0400
Message-ID: <50250494.5090009@hauke-m.de> (sfid-20120810_145456_282384_4F4D688C)
Date: Fri, 10 Aug 2012 14:54:44 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: check for flash presentence
References: <1344447424-30020-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1344447424-30020-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2012 07:37 PM, Rafał Miłecki wrote:
> We can not assume parallel flash is always present, there are boards
> with *serial* flash and probably some without flash at all.
> Define some bits by the way.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/ssb/driver_mipscore.c             |   28 +++++++++++++++++++++-------
>  include/linux/ssb/ssb_driver_chipcommon.h |    4 +++-
>  2 files changed, 24 insertions(+), 8 deletions(-)

I haven't tested this patch on my devices, but it looks good to me.
In an additional patch we also need a bool or something like this to
indicate if there is a parallel, serial or no flash present on the SoC.
For serial and parallel flash it is not possible to have both of them.

Reviewed-by: Hauke Mehrtens <hauke@hauke-m.de>
