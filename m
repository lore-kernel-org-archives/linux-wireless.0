Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:42866 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbeFEXZE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 19:25:04 -0400
Received: by mail-pg0-f68.google.com with SMTP id p9-v6so1988977pgc.9
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2018 16:25:03 -0700 (PDT)
Date: Tue, 5 Jun 2018 16:25:00 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990
 client
Message-ID: <20180605232459.GA200893@rodete-desktop-imager.corp.google.com> (sfid-20180606_012509_812787_3DEC620C)
References: <20180605123732.1993-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123732.1993-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jun 05, 2018 at 06:07:32PM +0530, Govind Singh wrote:
> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
> 
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between application processor and remote
> processors with underlying transport layer based on integrated
> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
> 
> With this patch-set basic functionality(STA/SAP) can be tested
> with WCN3990 chipset. The changes are verified with the firmware
> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig  |   13 +-
>  drivers/net/wireless/ath/ath10k/Makefile |    4 +-
>  drivers/net/wireless/ath/ath10k/core.c   |    6 +-
>  drivers/net/wireless/ath/ath10k/core.h   |    2 +
>  drivers/net/wireless/ath/ath10k/qmi.c    | 1030 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/qmi.h    |  136 +++
>  drivers/net/wireless/ath/ath10k/snoc.c   |  209 ++++-
>  drivers/net/wireless/ath/ath10k/snoc.h   |    3 +
>  8 files changed, 1387 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
> 

...

> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> new file mode 100644
> index 000000000000..6cbc04c849b5
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -0,0 +1,1030 @@

...

> +static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi)
> +{
> +	struct ath10k *ar = qmi->ar;
> +	struct device *dev = ar->dev;
> +	struct device_node *np;
> +	const __be32 *addrp;
> +	u64 prop_size = 0;
> +	int ret;
> +
> +	np = of_parse_phandle(dev->of_node, "msa-fixed-region", 0);
> +	if (np) {
> +		addrp = of_get_address(np, 0, &prop_size, NULL);
> +		if (!addrp) {
> +			ath10k_err(ar, "failed to get msa fixed addresses\n");
> +			return -EINVAL;
> +		}
> +
> +		qmi->msa_pa = of_translate_address(np, addrp);
> +		if (qmi->msa_pa == OF_BAD_ADDR) {
> +			ath10k_err(ar, "failed to translate fixed msa pa\n");
> +			return -EINVAL;
> +		}
> +
> +		qmi->msa_va = memremap(qmi->msa_pa, (unsigned long)prop_size,
> +				       MEMREMAP_WT);

You're leaking this mapping? Either call memunmap() in the release
function, or else use the devm_* version.

> +		if (!qmi->msa_va) {
> +			ath10k_err(ar, "fixed msa ioremap failed: phy addr: %pa\n",
> +				   &qmi->msa_pa);
> +			return -EINVAL;
> +		}
> +		qmi->msa_mem_size = prop_size;
> +	} else {
> +		ret = of_property_read_u32(dev->of_node, "msa-size",
> +					   &qmi->msa_mem_size);

If you're not going to use a reserved MSA region (the other branch of
the if/else), do you really need a fixed size in the device tree? Is it
safe to just assume some given size, e.g., by virtue of the HW revision?

> +
> +		if (ret || qmi->msa_mem_size == 0) {
> +			ath10k_err(ar, "failed to get msa memory size node\n");
> +			return -ENOMEM;
> +		}
> +
> +		qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
> +						  &qmi->msa_pa, GFP_KERNEL);
> +		if (!qmi->msa_va) {
> +			ath10k_err(ar, "dma alloc failed for msa region\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa pa: %pad , msa va: 0x%p\n",
> +		   &qmi->msa_pa,
> +		   qmi->msa_va);
> +
> +	return 0;
> +}

Brian
