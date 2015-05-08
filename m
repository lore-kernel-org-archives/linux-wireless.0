Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:34660 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbbEHK3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 06:29:16 -0400
Message-ID: <554C8FF9.60501@broadcom.com> (sfid-20150508_122919_994247_0D535C57)
Date: Fri, 8 May 2015 12:29:13 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 2/2] brcmfmac: fix debugging info for received hw messages
 with errors
References: <1431025661-8879-1-git-send-email-zajec5@gmail.com> <1431025661-8879-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1431025661-8879-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/15 21:07, Rafał Miłecki wrote:
> Code in function setting/querying device was treating every error as
> Broadcom protocol specific one. It wasn't right thing to do as most of
> subcalls return "normal" errors (errno-base.h). This resulted in e.g.:
> brcmf_usb_rx_ctlpkt: rxctl wait timed out
> brcmfmac: brcmf_fil_cmd_data Failed: BCME_NOTDOWN (-5)
> which was misleading because of interpreting -EIO as BCME_NOTDOWN.

So this is the reason for putting the error map in debug.c, but you are 
only addressing devices using bcdc protocol, ie. SDIO and USB. Also need 
to address PCIE. I would prefer to extend the query and set callbacks in 
struct brcmf_proto (proto.h) to pass firmware error code up so fwil can 
keep doing the mapping to string representation and have the callbacks 
return -EPROTO if firmware error code is not BCME_OK. Need to assure it 
can not get -EPROTO for other reasons.

Regards,
Arend

> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcdc.c | 5 ++++-
>   drivers/net/wireless/brcm80211/brcmfmac/fwil.c | 3 +--
>   2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
> index 8e0e91c..47941ab 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
> @@ -203,8 +203,11 @@ retry:
>   	}
>
>   	/* Check the ERROR flag */
> -	if (flags&  BCDC_DCMD_ERROR)
> +	if (flags&  BCDC_DCMD_ERROR) {
>   		ret = le32_to_cpu(msg->status);
> +		brcmf_dbg(BCDC, "received message with error %s (%d)\n",
> +			  brcmf_get_errstr((u32)(-ret)), ret);
> +	}
>
>   done:
>   	return ret;
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
> index bdbdc9e..c86a522 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
> @@ -53,8 +53,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
>   	if (err>= 0)
>   		return 0;
>
> -	brcmf_dbg(FIL, "Failed: %s (%d)\n",
> -		  brcmf_get_errstr((u32)(-err)), err);
> +	brcmf_dbg(FIL, "Failed: %d\n", err);
>   	return -EBADE;
>   }
>

