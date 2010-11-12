Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51696 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0KLT1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 14:27:01 -0500
Received: by qwi2 with SMTP id 2so109908qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 11:27:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <13896234.1151289487498939.JavaMail.wlan@CHBU500181>
References: <22942120.791289486697022.JavaMail.wlan@CHBU500181>
	<13896234.1151289487498939.JavaMail.wlan@CHBU500181>
Date: Fri, 12 Nov 2010 14:26:59 -0500
Message-ID: <AANLkTinoANxSOiBJpa2hDk7V=ScSa66rcj-f1HfQGV1u@mail.gmail.com>
Subject: Re: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
From: Bob Copeland <me@bobcopeland.com>
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 9:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
>
> AHB specific functions are now in ahb.c file. There is no common
> init functions which tries first pci and then ahb becasue on some

'because'

> --- a/drivers/net/wireless/ath/ath5k/Makefile
> +++ b/drivers/net/wireless/ath/ath5k/Makefile
> @@ -15,5 +15,5 @@ ath5k-y                               += rfkill.o
>  ath5k-y                                += ani.o
>  ath5k-y                                += sysfs.o
>  ath5k-$(CONFIG_ATH5K_DEBUG)    += debug.o
> -ath5k-y                                += pci.o
> +ath5k-y                                += $(if $(CONFIG_ATHEROS_AR231X),ahb,pci).o
>  obj-$(CONFIG_ATH5K)            += ath5k.o

This is not the right way.. what if someone wants both in one kernel?

-- 
Bob Copeland %% www.bobcopeland.com
