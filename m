Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3619 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1GSK3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 06:29:10 -0400
Message-ID: <4E255C6C.50507@broadcom.com> (sfid-20110719_122914_168463_A59A5AE9)
Date: Tue, 19 Jul 2011 12:29:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] compat-wireless: deactivate sido suspend for
 brcmfmac on older kernels.
References: <4E240E32.2020109@broadcom.com>
 <1311010573-17015-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1311010573-17015-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2011 07:36 PM, Hauke Mehrtens wrote:
> With this patch the build does not break any more because of this commit:
>
> commit da68c4eb258cd9f3f0b8aeb7e46b8118bb6358b6
> Author: Nicolas Pitre<nico@fluxnic.net>
> Date:   Fri Mar 5 13:43:31 2010 -0800
>
>      sdio: introduce API for special power management features
>
> This build error occurs without the patch on linux-2.6.32.
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c: In function ‘brcmf_sdio_suspend’:
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:2: error: ‘mmc_pm_flag_t’ undeclared (first use in this function)
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:2: note: each undeclared identifier is reported only once for each function it appears in
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1087:16: error: expected ‘;’ before ‘sdio_flags’
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1088:2: warning: ISO C90 forbids mixed declarations and code
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1092:2: error: ‘sdio_flags’ undeclared (first use in this function)
> /drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c:1092:2: error: implicit declaration of function ‘sdio_get_host_pm_caps’
>
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---

Thanks, Hauke

That clarifies it.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


