Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35044 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdIEUDs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 16:03:48 -0400
Received: by mail-wm0-f45.google.com with SMTP id f199so3128944wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Sep 2017 13:03:47 -0700 (PDT)
Subject: Re: [PATCH v5] brcmfmac: add CLM download support
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org,
        chi-hsien.lin@cypress.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
References: <1503987821-6132-1-git-send-email-wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <32126aa8-359f-a333-bcc0-ecc464c5c20a@broadcom.com> (sfid-20170905_220439_722631_6EA3F98D)
Date: Tue, 5 Sep 2017 22:03:45 +0200
MIME-Version: 1.0
In-Reply-To: <1503987821-6132-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-08-17 08:23, Wright Feng wrote:
> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> The firmware for brcmfmac devices includes information regarding
> regulatory constraints. For certain devices this information is kept
> separately in a binary form that needs to be downloaded to the device.
> This patch adds support to download this so-called CLM blob file. It
> uses the same naming scheme as the other firmware files with extension
> of .clm_blob.
> 
> The CLM blob file is optional. If the file does not exist, the download
> process will be bypassed. It will not affect the driver loading.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> ---
> v2: Revise commit message to describe in more detail
> v3: Add error handling in brcmf_c_get_clm_name function
> v4: Correct the length of dload_buf in brcmf_c_download function
> v5: Remove unnecessary cast and alignment
> ---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>   .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 160 +++++++++++++++++++++
>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>   .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>   .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>   .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>   .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>   .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>   8 files changed, 261 insertions(+)

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 7a2b495..f6268e0 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -18,6 +18,7 @@
>   #include <linux/string.h>
>   #include <linux/netdevice.h>
>   #include <linux/module.h>
> +#include <linux/firmware.h>
>   #include <brcmu_wifi.h>
>   #include <brcmu_utils.h>
>   #include "core.h"
> @@ -28,6 +29,7 @@
>   #include "tracepoint.h"
>   #include "common.h"
>   #include "of.h"
> +#include "firmware.h"

You are not calling anything in firmware.c from this source file so I do 
not think you need to include firmware.h here. Or did I miss something?

>   MODULE_AUTHOR("Broadcom Corporation");
>   MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
> @@ -104,12 +106,138 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
>   		brcmf_err("Set join_pref error (%d)\n", err);
>   }

[...]

> +static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
> +{
> +	struct device *dev = ifp->drvr->bus_if->dev;
> +	struct brcmf_dload_data_le *chunk_buf;
> +	const struct firmware *clm = NULL;
> +	u8 clm_name[BRCMF_FW_NAME_LEN];
> +	u32 chunk_len;
> +	u32 datalen;
> +	u32 cumulative_len = 0;
> +	u16 dl_flag = DL_BEGIN;
> +	u32 status;
> +	s32 err;
> +
> +	brcmf_dbg(INFO, "Enter\n");

Please use TRACE level for function entry logging.

> +	memset(clm_name, 0, BRCMF_FW_NAME_LEN);
> +	err = brcmf_c_get_clm_name(ifp, clm_name);
> +	if (err) {
> +		brcmf_err("get CLM blob file name failed (%d)\n", err);
> +		return err;
> +	}
> +
> +	err = request_firmware(&clm, clm_name, dev);
> +	if (err) {
> +		if (err == -ENOENT)
> +			return 0;

This exit point is worth a comment or even a brcmf_dbg(INFO, ...) to 
clarify what is happening here, ie. continue with CLM data currently 
present in firmware.

> +		brcmf_err("request CLM blob file failed (%d)\n", err);
> +		return err;
> +	}
> +
> +	datalen = clm->size;

move this initialization just before the do-while loop.

> +	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, GFP_KERNEL);
> +	if (!chunk_buf) {
> +		err = -ENOMEM;
> +		goto done;
> +	}

initialize datalen and cumulative_len here.

> +	do {
> +		if (datalen > MAX_CHUNK_LEN) {
> +			chunk_len = MAX_CHUNK_LEN;
> +		} else {
> +			chunk_len = datalen;
> +			dl_flag |= DL_END;
> +		}
> +		memcpy(chunk_buf->data, clm->data + cumulative_len, chunk_len);
> +
> +		err = brcmf_c_download(ifp, dl_flag, chunk_buf, chunk_len);
> +
> +		dl_flag &= ~DL_BEGIN;
> +
> +		cumulative_len += chunk_len;
> +		datalen -= chunk_len;
> +	} while ((datalen > 0) && (err == 0));
> +
> +	if (err) {
> +		brcmf_err("clmload (%d byte file) failed (%d); ",
> +			  (u32)clm->size, err);

Instead of casting clm->size it seems better to use the proper format 
specifier, ie. %zu (see format_decode() [1]).

> +		/* Retrieve clmload_status and print */
> +		err = brcmf_fil_iovar_int_get(ifp, "clmload_status", &status);
> +		if (err)
> +			brcmf_err("get clmload_status failed (%d)\n", err);
> +		else
> +			brcmf_dbg(INFO, "clmload_status=%d\n", status);
> +		err = -EIO;
> +	}
> +
> +	kfree(chunk_buf);
> +done:
> +	release_firmware(clm);
> +	return err;
> +}
> +
