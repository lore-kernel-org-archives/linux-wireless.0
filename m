Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbbJMFrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 01:47:39 -0400
Date: Mon, 12 Oct 2015 21:05:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: remove
 WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Message-ID: <20151013040508.GA21778@kroah.com> (sfid-20151013_074756_320057_8C18845C)
References: <20151009182326.GV7340@mwanda>
 <1444480914-20269-1-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444480914-20269-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 10, 2015 at 03:41:54PM +0300, Stanislav Kholmanskikh wrote:
> The config option in the subject may be removed, because,
> indeed, it only serves as the 'n' value for
> CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER
> 
> Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
> ---
>  drivers/staging/wilc1000/Kconfig  | 15 ++-------------
>  drivers/staging/wilc1000/Makefile |  3 ---
>  2 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
> index 59ccecc..2701a01 100644
> --- a/drivers/staging/wilc1000/Kconfig
> +++ b/drivers/staging/wilc1000/Kconfig
> @@ -6,27 +6,16 @@ config WILC1000
>  	---help---
>  	  This module only support IEEE 802.11n WiFi.
>  
> -choice
> -        prompt "Memory Allocation"
> -        depends on WILC1000
> -        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
> -
>  config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
>  	bool "Preallocate memory at loading driver"
> +	depends on WILC1000
> +	default y

Hm, why have this now?  Both of these options should go away, please
work on fixing up the code to not need them and then delete the options,
right now you are just deleting config options which doesn't seem wise.

thanks,

greg k-h
