Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:53131 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaAHMt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 07:49:27 -0500
Received: by mail-qe0-f48.google.com with SMTP id k5so442694qej.7
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 04:49:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389174573-5204-1-git-send-email-arend@broadcom.com>
References: <1389174573-5204-1-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Jan 2014 23:49:04 +1100
Message-ID: <CAGRGNgWySMpEecaPFL0NuynSwCik17xGRPk44z5cw+AAckaBvA@mail.gmail.com> (sfid-20140108_134930_870892_EAD4E41A)
Subject: Re: [linux-sunxi] [PATCH] brcmfmac: add support for bcm43362 device
To: linux-sunxi@googlegroups.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Wed, Jan 8, 2014 at 8:49 PM, Arend van Spriel <arend@broadcom.com> wrote:
> This patch adds support for the bcm43362 1x1 11n chipset. This
> chipset is used in AP6210 wifi module found on Cubieboard [1].
>
> [1] http://cubieboard.org/
>
> Reviewed-by: Franky Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi John,
>
> Here a straggler for new device support that people
> playing with Cubieboards have been asking for. Intended
> for v3.14 kernel.
>
> Regards,
> Arend
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    1 +
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    5 +++
>  .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   33 ++++++++++++++++++++
>  .../net/wireless/brcm80211/include/brcm_hw_ids.h   |    1 +
>  4 files changed, 40 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> index 2bf4757..9c7f08a 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> @@ -509,6 +509,8 @@ enum brcmf_sdio_frmtype {
>  #define BCM4334_NVRAM_NAME             "brcm/brcmfmac4334-sdio.txt"
>  #define BCM4335_FIRMWARE_NAME          "brcm/brcmfmac4335-sdio.bin"
>  #define BCM4335_NVRAM_NAME             "brcm/brcmfmac4335-sdio.txt"
> +#define BCM43362_FIRMWARE_NAME         "brcm/brcmfmac43362-sdio.bin"
> +#define BCM43362_NVRAM_NAME            "brcm/brcmfmac43362-sdio.txt"

I haven't been following the discussion so this may be redundant, but
is this firmware is presently winging it's way towards Linux-firmware?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
