Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcBGGDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 01:03:00 -0500
Date: Sat, 6 Feb 2016 22:02:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH] staging: wilc1000: Fix compilation error when CONFIG_PM
 disabled
Message-ID: <20160207060259.GA26681@kroah.com> (sfid-20160207_070304_427532_5D66EAA0)
References: <1454650827-24961-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454650827-24961-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 05, 2016 at 02:40:27PM +0900, Glen Lee wrote:
> Commit 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in
> cfg80211") causes following compilation error. This patch fixes this by
> using suspend/resume under CONFIG_PM.
> 
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c: In function
> 'wilc_create_wiphy':
> >> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2833:13: error:
> 'struct wiphy' has no member named 'wowlan'
>      wdev->wiphy->wowlan = &wowlan_support;
> 
> Fixes: 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211")
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/wilc_sdio.c              | 4 ++++
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 ++++++++-
>  drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 ++
>  3 files changed, 14 insertions(+), 1 deletion(-)

Patch doesn't apply :(

