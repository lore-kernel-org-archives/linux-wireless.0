Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30493 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbJOJjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 05:39:09 -0400
Message-ID: <561F7439.5020704@broadcom.com> (sfid-20151015_113914_460545_A28290F5)
Date: Thu, 15 Oct 2015 11:39:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Eric Caruso <ejcaruso@google.com>, <brudley@broadcom.com>,
	<frankyl@broadcom.com>, <meuleman@broadcom.com>,
	<kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <leizh@broadcom.com>,
	<joe@perches.com>
Subject: Re: [PATCH v3] brcm80211: Add support for brcm4371
References: <1444851251-25368-1-git-send-email-ejcaruso@google.com>
In-Reply-To: <1444851251-25368-1-git-send-email-ejcaruso@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/14/2015 09:34 PM, Eric Caruso wrote:
> This is a new Broadcom chip and we should be able to recognize it.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Eric Caruso <ejcaruso@google.com>
> ---
> v2: rebased.
> v3: added back break that got lost in v2.
>
>   drivers/net/wireless/brcm80211/brcmfmac/chip.c       | 1 +
>   drivers/net/wireless/brcm80211/brcmfmac/pcie.c       | 9 +++++++++
>   drivers/net/wireless/brcm80211/include/brcm_hw_ids.h | 2 ++
>   3 files changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> index ffc3ace..f04833d 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
> @@ -682,6 +682,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
>   	case BRCM_CC_43570_CHIP_ID:
>   	case BRCM_CC_4358_CHIP_ID:
>   	case BRCM_CC_43602_CHIP_ID:
> +	case BRCM_CC_4371_CHIP_ID:
>   		return 0x180000;
>   	case BRCM_CC_4365_CHIP_ID:
>   	case BRCM_CC_4366_CHIP_ID:
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> index 30baf35..ebd7f2d 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> @@ -59,6 +59,8 @@ enum brcmf_pcie_state {
>   #define BRCMF_PCIE_4365_NVRAM_NAME		"brcm/brcmfmac4365b-pcie.txt"
>   #define BRCMF_PCIE_4366_FW_NAME			"brcm/brcmfmac4366b-pcie.bin"
>   #define BRCMF_PCIE_4366_NVRAM_NAME		"brcm/brcmfmac4366b-pcie.txt"
> +#define BRCMF_PCIE_4371_FW_NAME			"brcm/brcmfmac4371-pcie.bin"
> +#define BRCMF_PCIE_4371_NVRAM_NAME		"brcm/brcmfmac4371-pcie.txt"
>
>   #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
>
> @@ -212,6 +214,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_4365_FW_NAME);
>   MODULE_FIRMWARE(BRCMF_PCIE_4365_NVRAM_NAME);
>   MODULE_FIRMWARE(BRCMF_PCIE_4366_FW_NAME);
>   MODULE_FIRMWARE(BRCMF_PCIE_4366_NVRAM_NAME);
> +MODULE_FIRMWARE(BRCMF_PCIE_4371_FW_NAME);
> +MODULE_FIRMWARE(BRCMF_PCIE_4371_NVRAM_NAME);
>
>
>   struct brcmf_pcie_console {
> @@ -1456,6 +1460,10 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
>   		fw_name = BRCMF_PCIE_4366_FW_NAME;
>   		nvram_name = BRCMF_PCIE_4366_NVRAM_NAME;
>   		break;
> +	case BRCM_CC_4371_CHIP_ID:
> +		fw_name = BRCMF_PCIE_4371_FW_NAME;
> +		nvram_name = BRCMF_PCIE_4371_NVRAM_NAME;
> +		break;
>   	default:
>   		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
>   		return -ENODEV;
> @@ -1995,6 +2003,7 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_DEVICE_ID),
>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_2G_DEVICE_ID),
>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID),
> +	BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID),
>   	{ /* end: all zeroes */ }
>   };
>
> diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> index d823734..aa06ea2 100644
> --- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> @@ -50,6 +50,7 @@
>   #define BRCM_CC_43602_CHIP_ID		43602
>   #define BRCM_CC_4365_CHIP_ID		0x4365
>   #define BRCM_CC_4366_CHIP_ID		0x4366
> +#define BRCM_CC_4371_CHIP_ID		0x4371
>
>   /* USB Device IDs */
>   #define BRCM_USB_43143_DEVICE_ID	0xbd1e
> @@ -75,6 +76,7 @@
>   #define BRCM_PCIE_4366_DEVICE_ID	0x43c3
>   #define BRCM_PCIE_4366_2G_DEVICE_ID	0x43c4
>   #define BRCM_PCIE_4366_5G_DEVICE_ID	0x43c5
> +#define BRCM_PCIE_4371_DEVICE_ID	0x440d
>
>
>   /* brcmsmac IDs */
>

