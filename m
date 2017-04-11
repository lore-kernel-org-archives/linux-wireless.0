Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35412 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdDKLaT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 07:30:19 -0400
Received: by mail-wm0-f50.google.com with SMTP id w64so60987955wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Apr 2017 04:30:18 -0700 (PDT)
Subject: Re: [PATCH] staging: rtl8188eu: force driver to be built as a module
To: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170411091953.25069-1-hdegoede@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fb9b6ee4-ae69-282a-5c69-558b0810cf2f@broadcom.com> (sfid-20170411_133031_570339_5D20A808)
Date: Tue, 11 Apr 2017 13:30:16 +0200
MIME-Version: 1.0
In-Reply-To: <20170411091953.25069-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-4-2017 11:19, Hans de Goede wrote:
> The rtl8188eu driver defines a ton of global symbols which tend to
> conflict with other realtek wifi drivers, force it to be built as
> a module.

Or get rid of those globals as we did to get out of staging :-p

Regards,
Arend

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/staging/rtl8188eu/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/rtl8188eu/Kconfig b/drivers/staging/rtl8188eu/Kconfig
> index 94f3879..cb836c5 100644
> --- a/drivers/staging/rtl8188eu/Kconfig
> +++ b/drivers/staging/rtl8188eu/Kconfig
> @@ -1,6 +1,7 @@
>  config R8188EU
>  	tristate "Realtek RTL8188EU Wireless LAN NIC driver"
>  	depends on WLAN && USB && CFG80211
> +	depends on m
>  	select WIRELESS_EXT
>  	select WEXT_PRIV
>  	---help---
> 
