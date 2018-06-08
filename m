Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbeFHMJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 08:09:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 08 Jun 2018 17:39:05 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990
 client
In-Reply-To: <20180605232459.GA200893@rodete-desktop-imager.corp.google.com>
References: <20180605123732.1993-1-govinds@codeaurora.org>
 <20180605232459.GA200893@rodete-desktop-imager.corp.google.com>
Message-ID: <5e14916b2711b5d2c7fec81b344ca94b@codeaurora.org> (sfid-20180608_140911_045695_F386FED9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-06 04:55, Brian Norris wrote:
> Hi,
> 
> On Tue, Jun 05, 2018 at 06:07:32PM +0530, Govind Singh wrote:
>> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
>> subsystem. This layer is responsible for communicating qmi control
>> messages to wifi fw QMI service using QMI messaging protocol.
>> 
>> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
>> between components running between application processor and remote
>> processors with underlying transport layer based on integrated
>> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>> 
>> With this patch-set basic functionality(STA/SAP) can be tested
>> with WCN3990 chipset. The changes are verified with the firmware
>> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/Kconfig  |   13 +-
>>  drivers/net/wireless/ath/ath10k/Makefile |    4 +-
>>  drivers/net/wireless/ath/ath10k/core.c   |    6 +-
>>  drivers/net/wireless/ath/ath10k/core.h   |    2 +
>>  drivers/net/wireless/ath/ath10k/qmi.c    | 1030 
>> ++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/qmi.h    |  136 +++
>>  drivers/net/wireless/ath/ath10k/snoc.c   |  209 ++++-
>>  drivers/net/wireless/ath/ath10k/snoc.h   |    3 +
>>  8 files changed, 1387 insertions(+), 16 deletions(-)
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
>> 
> 
> ...
> 
>> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c 
>> b/drivers/net/wireless/ath/ath10k/qmi.c
>> new file mode 100644
>> index 000000000000..6cbc04c849b5
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
>> @@ -0,0 +1,1030 @@
> 
> ...
> 
>> +static int ath10k_qmi_setup_msa_resources(struct ath10k_qmi *qmi)
>> +{
>> +	struct ath10k *ar = qmi->ar;
>> +	struct device *dev = ar->dev;
>> +	struct device_node *np;
>> +	const __be32 *addrp;
>> +	u64 prop_size = 0;
>> +	int ret;
>> +
>> +	np = of_parse_phandle(dev->of_node, "msa-fixed-region", 0);
>> +	if (np) {
>> +		addrp = of_get_address(np, 0, &prop_size, NULL);
>> +		if (!addrp) {
>> +			ath10k_err(ar, "failed to get msa fixed addresses\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		qmi->msa_pa = of_translate_address(np, addrp);
>> +		if (qmi->msa_pa == OF_BAD_ADDR) {
>> +			ath10k_err(ar, "failed to translate fixed msa pa\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		qmi->msa_va = memremap(qmi->msa_pa, (unsigned long)prop_size,
>> +				       MEMREMAP_WT);
> 
> You're leaking this mapping? Either call memunmap() in the release
> function, or else use the devm_* version.
> 

Thanks, i will fix this in next patchset.

>> +		if (!qmi->msa_va) {
>> +			ath10k_err(ar, "fixed msa ioremap failed: phy addr: %pa\n",
>> +				   &qmi->msa_pa);
>> +			return -EINVAL;
>> +		}
>> +		qmi->msa_mem_size = prop_size;
>> +	} else {
>> +		ret = of_property_read_u32(dev->of_node, "msa-size",
>> +					   &qmi->msa_mem_size);
> 
> If you're not going to use a reserved MSA region (the other branch of
> the if/else), do you really need a fixed size in the device tree? Is it
> safe to just assume some given size, e.g., by virtue of the HW 
> revision?
> 

Yes msa size can be kept in drv pvt data.

static const struct ath10k_snoc_drv_priv drv_priv = {
.hw_rev = ATH10K_HW_WCN3990,
.dma_mask = DMA_BIT_MASK(37),

};

I will fix this in next patch set.

>> +
>> +		if (ret || qmi->msa_mem_size == 0) {
>> +			ath10k_err(ar, "failed to get msa memory size node\n");
>> +			return -ENOMEM;
>> +		}
>> +
>> +		qmi->msa_va = dmam_alloc_coherent(dev, qmi->msa_mem_size,
>> +						  &qmi->msa_pa, GFP_KERNEL);
>> +		if (!qmi->msa_va) {
>> +			ath10k_err(ar, "dma alloc failed for msa region\n");
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	ath10k_dbg(ar, ATH10K_DBG_QMI, "msa pa: %pad , msa va: 0x%p\n",
>> +		   &qmi->msa_pa,
>> +		   qmi->msa_va);
>> +
>> +	return 0;
>> +}
> 
> Brian

BR,
Govind
