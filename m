Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:54849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbdDKAD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 20:03:57 -0400
Date: Tue, 11 Apr 2017 10:03:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723bs: Add missing include <linux/of.h> to
 fix compile error
Message-ID: <20170411100355.6d204cbf@canb.auug.org.au> (sfid-20170411_020401_669636_8A581591)
In-Reply-To: <20170410191307.4137-1-hdegoede@redhat.com>
References: <20170410191307.4137-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

On Mon, 10 Apr 2017 21:13:07 +0200 Hans de Goede <hdegoede@redhat.com> wrote:
>
> As reported by Stephen Rothwell when merging staging-next,
> drivers/staging/rtl8723bs/core/rtw_ieee80211.c does not compile due
> to of_get_property not being declared.
> 
> Explicitly include <linux/of.h> to fix this compile error.
> 
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/staging/rtl8723bs/core/rtw_ieee80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
> index af44a8c..74f5ee0 100644
> --- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
> +++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
> @@ -16,7 +16,7 @@
>  
>  #include <drv_types.h>
>  #include <rtw_debug.h>
> -
> +#include <linux/of.h>
>  
>  u8 RTW_WPA_OUI_TYPE[] = { 0x00, 0x50, 0xf2, 1 };
>  u16 RTW_WPA_VERSION = 1;
> -- 
> 2.9.3

I will add this to linux-next today.
-- 
Cheers,
Stephen Rothwell
