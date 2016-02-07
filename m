Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbcBGGDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 01:03:55 -0500
Date: Sat, 6 Feb 2016 22:03:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Glen Lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] staging: wilc1000: fix compilation without CONFIG_PM
Message-ID: <20160207060354.GA2714@kroah.com> (sfid-20160207_070415_844262_BC7302BA)
References: <1454685729-3663377-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454685729-3663377-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 05, 2016 at 04:21:50PM +0100, Arnd Bergmann wrote:
> After the addition of the wakeup code in wilc1000, it no longer
> builds when CONFIG_PM is disabled:
> 
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c: In function 'wilc_create_wiphy':
> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2632:13: error: 'struct wiphy' has no member named 'wowlan'
>   wdev->wiphy->wowlan = &wowlan_support;
> 
> This marks the wowlan_support variable as __maybe_unused and hides
> the reference when CONFIG_PM is disabled to avoid the build error.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 73584a40d748 ("staging: wilc1000: add ops resuem/suspend/wakeup in cfg80211")
> ---
>  drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

A different patch was sent just before yours.  Actually 2 different
ones...

thanks,

greg k-h
