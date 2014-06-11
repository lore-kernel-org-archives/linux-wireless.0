Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaFKPWq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 11:22:46 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: rtl8723au: Add compiler check for -Wtype-limits
References: <1402498666-5018-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 11 Jun 2014 17:22:36 +0200
In-Reply-To: <1402498666-5018-1-git-send-email-geert@linux-m68k.org> (Geert
	Uytterhoeven's message of "Wed, 11 Jun 2014 16:57:46 +0200")
Message-ID: <wrfjfvjb4gjn.fsf@ultrasam.lan.trained-monkey.org> (sfid-20140611_172251_216799_218110AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> writes:
> Gcc versions before 4.3 do not support -Wtype-limits:
>
> cc1: error: unrecognized command line option "-Wtype-limits"
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/staging/rtl8723au/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Museum support is fine with me :)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/Makefile
> b/drivers/staging/rtl8723au/Makefile
> index a6316af94b79..6b3f25555c74 100644
> --- a/drivers/staging/rtl8723au/Makefile
> +++ b/drivers/staging/rtl8723au/Makefile
> @@ -53,4 +53,5 @@ r8723au-$(CONFIG_8723AU_AP_MODE) += core/rtw_ap.o
>  
>  obj-$(CONFIG_R8723AU)	:= r8723au.o
>  
> -ccflags-y += -Wtype-limits -D__CHECK_ENDIAN__ -I$(src)/include
> +ccflags-y += $(call cc-option,-Wtype-limits,)
> +ccflags-y += -D__CHECK_ENDIAN__ -I$(src)/include
