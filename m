Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:47107 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753680AbbJNSzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 14:55:08 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 02384B19B2
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 18:47:16 +0000 (UTC)
Message-ID: <1444848433.2718.27.camel@perches.com> (sfid-20151014_205513_003335_378B4E1A)
Subject: Re: [PATCH v2] brcm80211: Add support for brcm4371
From: Joe Perches <joe@perches.com>
To: Eric Caruso <ejcaruso@google.com>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, leizh@broadcom.com
Date: Wed, 14 Oct 2015 11:47:13 -0700
In-Reply-To: <1444844949-8765-1-git-send-email-ejcaruso@google.com>
References: <1444844949-8765-1-git-send-email-ejcaruso@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-10-14 at 10:49 -0700, Eric Caruso wrote:
> This is a new Broadcom chip and we should be able to recognize it.
[]
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
[]
> @@ -1456,6 +1460,9 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
>  		fw_name = BRCMF_PCIE_4366_FW_NAME;
>  		nvram_name = BRCMF_PCIE_4366_NVRAM_NAME;
>  		break;
> +	case BRCM_CC_4371_CHIP_ID:
> +		fw_name = BRCMF_PCIE_4371_FW_NAME;
> +		nvram_name = BRCMF_PCIE_4371_NVRAM_NAME;

missing break;

>  	default:
>  		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
>  		return -ENODEV;


