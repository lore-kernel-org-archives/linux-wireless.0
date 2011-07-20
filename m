Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40207 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab1GTBLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 21:11:30 -0400
Received: by qwk3 with SMTP id 3so2280403qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 18:11:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311010573-17015-1-git-send-email-hauke@hauke-m.de>
References: <4E240E32.2020109@broadcom.com> <1311010573-17015-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jul 2011 18:11:10 -0700
Message-ID: <CAB=NE6Xzameyc0+xJfqrBJqOzLGQnAZ2eR2L1NUzymZNbOEupA@mail.gmail.com> (sfid-20110720_031133_962756_3C34C6E1)
Subject: Re: [PATCH v2 2/2] compat-wireless: deactivate sido suspend for
 brcmfmac on older kernels.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 10:36 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> With this patch the build does not break any more because of this commit:
>
> commit da68c4eb258cd9f3f0b8aeb7e46b8118bb6358b6
> Author: Nicolas Pitre <nico@fluxnic.net>
> Date:   Fri Mar 5 13:43:31 2010 -0800
>
>    sdio: introduce API for special power management features
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
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>
> If someone wants to backport the the SDIO API for special power management features it will be nice.
>
>  patches/29-sdio_no_suspend.patch |   38 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 38 insertions(+), 0 deletions(-)
>

thanks, applied both and pushed!

  Luis
