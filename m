Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:57878 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754783AbdHYNzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 09:55:33 -0400
Message-ID: <1503669327.8480.3.camel@embedded.rocks> (sfid-20170825_155540_120912_C49FA15B)
Subject: Re: [PATCH 2/2] brcmfmac: Use separate firmware for revision 0 of
 the brcm43430 chip
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Jelle van der Waa <jelle@vdwaa.nl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Date: Fri, 25 Aug 2017 15:55:27 +0200
In-Reply-To: <20170616131449.12108-2-hdegoede@redhat.com>
References: <20170616131449.12108-1-hdegoede@redhat.com>
         <20170616131449.12108-2-hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2017-06-16 at 15:14 +0200, Hans de Goede wrote:
> The brcm43430 chip needs different firmware files for chip revision 0
> and 1. The file currently in linux-firmware is for revision 1 only.
> 
> This commit makes brcmfmac request brcmfmac43430a0-sdio.bin instead
> of brcmfmac43430-sdio.bin for revision 0 chips.
> 
> Note that the behavior for revision 1 chips is not changed, ideally those
> would load brcmfmac43430a1-sdio.bin, but that will break existing setups.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 4ed40c94bda9..5125aeeb5310 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -612,7 +612,9 @@ BRCMF_FW_NVRAM_DEF(43340, "brcmfmac43340-sdio.bin", "brcmfmac43340-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(4335, "brcmfmac4335-sdio.bin", "brcmfmac4335-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(43362, "brcmfmac43362-sdio.bin", "brcmfmac43362-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(4339, "brcmfmac4339-sdio.bin", "brcmfmac4339-sdio.txt");
> -BRCMF_FW_NVRAM_DEF(43430, "brcmfmac43430-sdio.bin", "brcmfmac43430-sdio.txt");
> +BRCMF_FW_NVRAM_DEF(43430A0, "brcmfmac43430a0-sdio.bin", "brcmfmac43430a0-sdio.txt");
> +/* Note the names are not postfixed with a1 for backward compatibility */
> +BRCMF_FW_NVRAM_DEF(43430A1, "brcmfmac43430-sdio.bin", "brcmfmac43430-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(43455, "brcmfmac43455-sdio.bin", "brcmfmac43455-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(4354, "brcmfmac4354-sdio.bin", "brcmfmac4354-sdio.txt");
>  BRCMF_FW_NVRAM_DEF(4356, "brcmfmac4356-sdio.bin", "brcmfmac4356-sdio.txt");
> @@ -630,7 +632,8 @@ static struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4335_CHIP_ID, 0xFFFFFFFF, 4335),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43362_CHIP_ID, 0xFFFFFFFE, 43362),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4339_CHIP_ID, 0xFFFFFFFF, 4339),
> -	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFF, 43430),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0x00000001, 43430A0),
> +	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_43430_CHIP_ID, 0xFFFFFFFE, 43430A1),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4345_CHIP_ID, 0xFFFFFFC0, 43455),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4354_CHIP_ID, 0xFFFFFFFF, 4354),
>  	BRCMF_FW_NVRAM_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356)

Unfortunately, there is no "brcmfmac43430a0-sdio.bin" in linux-
firmware. Therefore, my custom board fails:

# [   24.894241] brcmfmac mmc0:0001:1: Direct firmware load for
brcm/brcmfmac43430a0-sdio.bin failed with error -2
[   25.914322] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
clkctl 0x50
[   26.934186] brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000):
clkctl 0x50

Can someone provide the firmware file, please?
