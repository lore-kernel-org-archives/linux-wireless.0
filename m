Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:26964 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbYFKTsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 15:48:46 -0400
Received: by ug-out-1314.google.com with SMTP id h2so182287ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 12:48:44 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: RT2X00_LIB_RFKILL should depend on INPUT
Date: Wed, 11 Jun 2008 22:01:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Randy Dunlap <randy.dunlap@oracle.com>
References: <200806112119.27586.IvDoorn@gmail.com>
In-Reply-To: <200806112119.27586.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806112201.00496.IvDoorn@gmail.com> (sfid-20080611_214915_868441_2CE9B818)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 June 2008, Ivo van Doorn wrote:
> rt2x00 requires the input-polldev driver for reporting rfkill events,
> selecting INPUT_POLLDEV is not correct since that option depends
> on the INPUT config option.
> Since RT2X00_LIB_RFKILL requires the input layer as well, we should
> make it depend on INPUT directly.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

John, you can drop this patch in exchange for the patch just send by Randy,
since that patch would be more correct.

Thanks,

Ivo

> ---
> John, this is for 2.6.26
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 0ace761..c4d1f67 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -36,6 +36,7 @@ config RT2X00_LIB_FIRMWARE
>  config RT2X00_LIB_RFKILL
>  	boolean
>  	depends on RT2X00_LIB
> +	depends on INPUT
>  	select RFKILL
>  	select INPUT_POLLDEV
>  
> 


