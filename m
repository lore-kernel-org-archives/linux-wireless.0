Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:54194 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdHQTDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 15:03:03 -0400
Date: Thu, 17 Aug 2017 21:02:54 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: franky.lin@broadcom.com, chi-hsien.lin@cypress.com,
        Wright Feng <wright.feng@cypress.com>, kvalo@codeaurora.org,
        arend.vanspriel@broadcom.com, hante.meuleman@broadcom.com
Cc: Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
Message-ID: <2047157622.557304.1502996574659@email.1und1.de> (sfid-20170817_210307_090715_32847E51)
In-Reply-To: <1502965327-29630-1-git-send-email-wright.feng@cypress.com>
References: <1502965327-29630-1-git-send-email-wright.feng@cypress.com>
Subject: Re: [PATCH v2] brcmfmac: add CLM download support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Wright Feng <wright.feng@cypress.com> hat am 17. August 2017 um 12:22 geschrieben:
> 
> 
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
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> ---
> v2: Revise commit message to describe in more detail
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  10 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 156 +++++++++++++++++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   2 +
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  31 ++++
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  19 +++
>  .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  19 +++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  18 +++
>  8 files changed, 257 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> index b55c329..df42e09 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
> @@ -71,6 +71,7 @@ struct brcmf_bus_dcmd {
>   * @wowl_config: specify if dongle is configured for wowl when going to suspend
>   * @get_ramsize: obtain size of device memory.
>   * @get_memdump: obtain device memory dump in provided buffer.
> + * @get_fwname: obtain firmware name.
>   *
>   * This structure provides an abstract interface towards the
>   * bus specific driver. For control messages to common driver
> @@ -87,6 +88,8 @@ struct brcmf_bus_ops {
>  	void (*wowl_config)(struct device *dev, bool enabled);
>  	size_t (*get_ramsize)(struct device *dev);
>  	int (*get_memdump)(struct device *dev, void *data, size_t len);
> +	int (*get_fwname)(struct device *dev, uint chip, uint chiprev,
> +			  unsigned char *fw_name);
>  };
>  
>  
> @@ -214,6 +217,13 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
>  	return bus->ops->get_memdump(bus->dev, data, len);
>  }
>  
> +static inline
> +int brcmf_bus_get_fwname(struct brcmf_bus *bus, uint chip, uint chiprev,
> +			 unsigned char *fw_name)
> +{
> +	return bus->ops->get_fwname(bus->dev, chip, chiprev, fw_name);
> +}
> +
>  /*
>   * interface functions from common layer
>   */
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 7a2b495..6d30421 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -18,6 +18,7 @@
>  #include <linux/string.h>
>  #include <linux/netdevice.h>
>  #include <linux/module.h>
> +#include <linux/firmware.h>
>  #include <brcmu_wifi.h>
>  #include <brcmu_utils.h>
>  #include "core.h"
> @@ -28,6 +29,7 @@
>  #include "tracepoint.h"
>  #include "common.h"
>  #include "of.h"
> +#include "firmware.h"
>  
>  MODULE_AUTHOR("Broadcom Corporation");
>  MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
> @@ -104,12 +106,134 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
>  		brcmf_err("Set join_pref error (%d)\n", err);
>  }
>  
> +static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
> +			    struct brcmf_dload_data_le *dload_buf,
> +			    u32 len)
> +{
> +	u16 flags;
> +	s32 err;
> +
> +	flags = flag | (DLOAD_HANDLER_VER << DLOAD_FLAG_VER_SHIFT);
> +	dload_buf->flag = cpu_to_le16(flags);
> +	dload_buf->dload_type = cpu_to_le16(DL_TYPE_CLM);
> +	dload_buf->len = cpu_to_le32(len);
> +	dload_buf->crc = cpu_to_le32(0);
> +	len = len + 8 - (len % 8);
> +
> +	err = brcmf_fil_iovar_data_set(ifp, "clmload", (void *)dload_buf, len);
> +
> +	return err;
> +}
> +
> +static int brcmf_c_get_clm_name(struct brcmf_if *ifp, u8 *clm_name)
> +{
> +	struct brcmf_bus *bus = ifp->drvr->bus_if;
> +	struct brcmf_rev_info *ri = &ifp->drvr->revinfo;
> +	u8 fw_name[BRCMF_FW_NAME_LEN];
> +	u8 *ptr;
> +	size_t len;
> +	s32 err;
> +
> +	memset(fw_name, 0, BRCMF_FW_NAME_LEN);
> +	err = brcmf_bus_get_fwname(bus, ri->chipnum, ri->chiprev, fw_name);
> +	if (err) {
> +		brcmf_err("get firmware name failed (%d)\n", err);
> +		goto done;
> +	}
> +
> +	/* generate CLM blob file name */
> +	ptr = strrchr(fw_name, '.');

maybe it's very unlikely that the firmware name doesn't contain a dot, but i think we should care about the error case.

> +	len = ptr - fw_name + 1;
> +	if (len + strlen(".clm_blob") > BRCMF_FW_NAME_LEN) {
> +		err = -E2BIG;
> +	} else {
> +		strlcpy(clm_name, fw_name, len);
> +		strlcat(clm_name, ".clm_blob", BRCMF_FW_NAME_LEN);
> +	}
> +done:
> +	return err;
> +}
> +
