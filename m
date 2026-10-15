Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8172E737B
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070538; cv=none; b=KrE75InavaPTyLoKWPZ8+817qar3NAKZtGSZWdOkAhEADYse3yD1rnIUg2i8xoAnUKap1RqEztnB8lrnwWpSKF34iHSN+lLQUFlSEkNvQLDFYE+WQPvL3Ogy3vXBW+T45LaJq+CzkoPRTLXJU7pYPhg9TOBd+MNLZdDY4h4DRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070538; c=relaxed/simple;
	bh=Bvd3KlAPV/LoSwyVaQKOlcSewMN0hb53j3YhEQur7lI=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OS9kGBqQA1isuFaboiB7rHkx76pCSwICV/+i6GX/hBEGtW+Jdgrqm4e+i1Tf2W3FXXLZqZn66fRNxwHDdczw4SLmYa09cg6fW+mnknZoDaAGRbAa9tHt+Krb8FeqXso2NycIW1pNoGHVukk21GIf5G2PXVUwY5dLu7xB78gwfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvGKIciE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvGKIciE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3A51F000CB
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 13:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792070535;
	bh=PtakM2rq+ivjR0e7DosmM9joh8D3XX6lnOGvhtqu8Yc=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=jvGKIciEueQGGCVpxvxDNWq25lUom4brJTJxQKGaWt2s0mCC0H2VC8KvrJ6CHU05Y
	 Y3i0DSCcNUIZpSmWx+dA9MiIg2dzpM+h81xrqYLNkdALJqiEI59r55mnBGCUDOn1Fc
	 SAFzZFw+g2kaH/4ZS1MuhVhcW+hcX5aArcf3ojFAIQwGMkw+13A3IBJmzTXL2PYBOz
	 I5a8f+AMrdlQERHcbAn5hQDZ12SX4+76MvLwPCQJoa+XHefU0m0QF4ebwvWVerb+B8
	 Wi0i8LRRd+4fGEo3oWIk2R7d44rbs8J+V71pNNtxGT627RD02Apb80dF/VPlSAej28
	 mYbBq2bCoT4eg==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3a75f960be3so23567341fa.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:22:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByV33B40gNcDWNLWL1pSHRB1OQhhy6/bLqWdylklBXfbyh+12U2QG88YsLLGKTJrSK+/wl9U4SqR4eO1tBcmA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJJ+mTwtRcAg9mJGOK4hlNzooSUuwoJ+IE587A0RSHYy8MVsviQ
	i+RRxp+FxsF2rm7QNhwJ2e0MIUF8LsYDiQvoQXEjAq7/ZN84U00FkMcoTlNYMY310+c0k01MhZl
	4VbhK+nfrcXX3dpTxnRWla/oos4gVHG9pdPW5mVr6VA==
X-Received: by 2002:a2e:b888:0:b0:3a9:82c2:ec1e with SMTP id
 38308e7fff4ca-3a9c537ed07mr41696771fa.15.1792070533876; Thu, 15 Oct 2026
 06:22:13 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 13:22:12 +0000
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 13:22:12 +0000
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-2-187c85f65018@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com> <20261014-b4-nvmem-efivar-v1-2-187c85f65018@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 13:22:12 +0000
X-Gmail-Original-Message-ID: <CAMRc=McDsv0k0bD2LoaXfOh7uyFo=HRyO098H=N=QeMFDXsLKQ@mail.gmail.com>
X-Gm-Features: AclHuK_mQfEq7d5o6k5CJtNKj-nIhBiWJK67TxDvSr-imzKrws_f6xRwLeLZhi8
Message-ID: <CAMRc=McDsv0k0bD2LoaXfOh7uyFo=HRyO098H=N=QeMFDXsLKQ@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] nvmem: Add UEFI variable NVMEM provider
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, Srinivas Kandagatla <srini@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Jeff Johnson <jjohnson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026 15:02:40 +0200, Abel Vesa <abel.vesa@oss.qualcomm.com> said:
> Add a provider that reads a UEFI variable via the EFI runtime
> GetVariable service and publishes its bytes as a read-only NVMEM device.
> NVMEM cells are described as device-tree child nodes and can be
> referenced by consumers through nvmem-cells / nvmem-cell-names.
>
> The vendor GUID is optional: when it is not provided, the variable is
> located by name by enumerating the variable store. This keeps working
> on platforms where GetVariable is emulated by firmware (e.g. the
> Qualcomm uefisecapp backend) and where direct flash access is
> unavailable to the non-secure world, in particular when Linux boots at
> EL2.
>
> If the variable has not been provisioned yet, the device is still
> registered, sized to cover the described cells and filled with zeroes,
> the same way an erased EEPROM would read. This keeps consumers probing
> and falling back to their default addresses.
>
> Assisted-by: LLM
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>  drivers/nvmem/Kconfig  |  12 +++
>  drivers/nvmem/Makefile |   2 +
>  drivers/nvmem/efivar.c | 273 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 287 insertions(+)
>
> diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
> index 083a5e528960..3f619dfa1cf7 100644
> --- a/drivers/nvmem/Kconfig
> +++ b/drivers/nvmem/Kconfig
> @@ -185,6 +185,18 @@ config NVMEM_BRCM_NVRAM
>  	  This driver provides support for Broadcom's NVRAM that can be accessed
>  	  using I/O mapping.
>
> +config NVMEM_EFIVAR
> +	tristate "UEFI variable NVMEM provider"
> +	depends on EFI || COMPILE_TEST
> +	help
> +	  Say y here to expose the contents of a UEFI variable as an NVMEM
> +	  device. This allows the kernel to consume data provisioned in a UEFI
> +	  variable, referenced from consumers via the standard nvmem-cells
> +	  bindings.
> +
> +	  This driver can also be built as a module. If so, the module will
> +	  be called nvmem-efivar.
> +
>  config NVMEM_IMX_IIM
>  	tristate "i.MX IC Identification Module support"
>  	depends on ARCH_MXC || COMPILE_TEST
> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
> index 5e70bad9f0f9..038d3d9ee95c 100644
> --- a/drivers/nvmem/Makefile
> +++ b/drivers/nvmem/Makefile
> @@ -27,6 +27,8 @@ obj-$(CONFIG_NVMEM_BCM_OCOTP)		+= nvmem-bcm-ocotp.o
>  nvmem-bcm-ocotp-y			:= bcm-ocotp.o
>  obj-$(CONFIG_NVMEM_BRCM_NVRAM)		+= nvmem_brcm_nvram.o
>  nvmem_brcm_nvram-y			:= brcm_nvram.o
> +obj-$(CONFIG_NVMEM_EFIVAR)		+= nvmem-efivar.o
> +nvmem-efivar-y			:= efivar.o
>  obj-$(CONFIG_NVMEM_IMX_IIM)		+= nvmem-imx-iim.o
>  nvmem-imx-iim-y				:= imx-iim.o
>  obj-$(CONFIG_NVMEM_IMX_OCOTP)		+= nvmem-imx-ocotp.o
> diff --git a/drivers/nvmem/efivar.c b/drivers/nvmem/efivar.c
> new file mode 100644
> index 000000000000..699b1d67aea4
> --- /dev/null
> +++ b/drivers/nvmem/efivar.c
> @@ -0,0 +1,273 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * nvmem-efivar - expose the contents of a UEFI variable as an NVMEM device
> + *
> + * Lets the kernel consume data provisioned in a UEFI variable through the
> + * standard NVMEM cell bindings.  The variable is read at probe time through
> + * the EFI runtime GetVariable service, which also works on platforms where
> + * the variable store is emulated by firmware (for example the Qualcomm
> + * uefisecapp backend) and where direct flash access is not available to the
> + * non-secure world.  The variable contents are published as a read-only
> + * NVMEM device, with cells described as child nodes in the device tree and
> + * referenced by consumers through the standard "nvmem-cells" /
> + * "nvmem-cell-names" properties.
> + *
> + * If the variable has not been provisioned yet, the device is still
> + * registered, sized to cover the described cells and filled with zeroes,
> + * the same way an erased EEPROM would read.  Consumers are expected to
> + * validate the data they read so such systems keep working with their
> + * defaults.
> + *
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.

This should immediately follow the SPFX header I think.

> + */
> +
> +#include <linux/efi.h>
> +#include <linux/module.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/nvmem-provider.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/property.h>
> +#include <linux/slab.h>
> +#include <linux/ucs2_string.h>
> +#include <linux/uuid.h>
> +
> +struct efivar_nvmem {
> +	void	*data;
> +	size_t	size;
> +};

I would have preferred it without tabs but whatever.

> +
> +static int efivar_nvmem_reg_read(void *priv, unsigned int offset,
> +				 void *val, size_t bytes)
> +{
> +	struct efivar_nvmem *p = priv;
> +
> +	if (offset >= p->size || offset + bytes > p->size)
> +		return -EINVAL;
> +
> +	memcpy(val, p->data + offset, bytes);
> +	return 0;
> +}
> +
> +/* Size needed to cover all cells described as child nodes. */
> +static size_t efivar_nvmem_cells_extent(struct device *dev)
> +{
> +	struct device_node *child;
> +	size_t extent = 0;
> +	u32 reg[2];
> +
> +	for_each_child_of_node(dev->of_node, child) {

You're leaking the reference to the child node. You also probably don't need
the OF variant, use device_for_each_child_node_scoped() instead.

> +		if (of_property_read_u32_array(child, "reg", reg, 2))
> +			continue;
> +		extent = max_t(size_t, extent, (size_t)reg[0] + reg[1]);
> +	}
> +
> +	return extent;
> +}
> +
> +/*
> + * Find the vendor GUID of a variable given only its (UCS-2) name, by
> + * enumerating the variable store.  Used when no 'efivar-guid' is provided.
> + */
> +static int efivar_nvmem_find_guid(const efi_char16_t *want, efi_guid_t *out)
> +{
> +	unsigned long max = 512; /* in UCS-2 chars; variable names are short */
> +	efi_char16_t *name;
> +	efi_guid_t vendor = {};
> +	efi_status_t status;
> +	int ret = -ENODEV;
> +
> +	name = kcalloc(max, sizeof(*name), GFP_KERNEL);

efi_char_16t *name __free(kfree) = kcalloc(...);

> +	if (!name)
> +		return -ENOMEM;
> +	name[0] = 0;

Doesn't kcalloc() imply it?

> +
> +	for (;;) {
> +		unsigned long name_size = max * sizeof(*name);
> +
> +		status = efivar_get_next_variable(&name_size, name, &vendor);
> +		if (status == EFI_BUFFER_TOO_SMALL) {
> +			efi_char16_t *tmp;
> +
> +			max = name_size / sizeof(*name) + 1;
> +			tmp = krealloc_array(name, max, sizeof(*name), GFP_KERNEL);
> +			if (!tmp) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +			name = tmp;
> +			continue;
> +		}
> +		if (status != EFI_SUCCESS) /* EFI_NOT_FOUND ends the walk */
> +			break;
> +
> +		if (!ucs2_strncmp(name, want, ucs2_strlen(want) + 1)) {
> +			*out = vendor;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	kfree(name);
> +	return ret;
> +}
> +
> +static int efivar_nvmem_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	const char *name, *guid_str;
> +	struct nvmem_config cfg = {};
> +	struct efivar_nvmem *priv;
> +	struct nvmem_device *nvmem;
> +	efi_char16_t *name16;
> +	efi_guid_t guid;
> +	guid_t g;
> +	unsigned long size;
> +	efi_status_t status;
> +	u32 attr;
> +	int i, len, ret;
> +	void *buf;
> +
> +	/*
> +	 * The EFI variable service may not be a native EFI runtime service;
> +	 * backends such as the Qualcomm uefisecapp driver register the
> +	 * efivars operations asynchronously.  Wait for them.
> +	 */
> +	if (!efivar_is_available())
> +		return -EPROBE_DEFER;
> +
> +	ret = device_property_read_string(dev, "efivar-name", &name);
> +	if (ret)
> +		return dev_err_probe(dev, ret, "missing 'efivar-name'\n");
> +
> +	/* ASCII variable name -> UCS-2 as expected by the EFI service */
> +	len = strlen(name);
> +	name16 = kcalloc(len + 1, sizeof(*name16), GFP_KERNEL);

efi_char_16t name16 __free(kfree) = kcalloc(...);

> +	if (!name16)
> +		return -ENOMEM;
> +	for (i = 0; i < len; i++)
> +		name16[i] = name[i];
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		kfree(name16);
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * The vendor GUID is optional: if it is not provided, look the
> +	 * variable up by name across the whole store.  A variable that has
> +	 * not been provisioned yet is reported as not found and handled
> +	 * below like an erased EEPROM.
> +	 */
> +	if (!device_property_read_string(dev, "efivar-guid", &guid_str)) {
> +		ret = guid_parse(guid_str, &g);
> +		if (ret) {
> +			kfree(name16);
> +			return dev_err_probe(dev, ret, "invalid 'efivar-guid'\n");
> +		}
> +		memcpy(&guid, &g, sizeof(guid));
> +		status = EFI_SUCCESS;
> +	} else {
> +		ret = efivar_nvmem_find_guid(name16, &guid);
> +		if (ret && ret != -ENODEV) {
> +			kfree(name16);
> +			return dev_err_probe(dev, ret,
> +					     "failed to look up variable '%s'\n",
> +					     name);
> +		}
> +		status = ret ? EFI_NOT_FOUND : EFI_SUCCESS;
> +	}
> +
> +	/* First attempt with a modest buffer; grow if the firmware asks. */
> +	size = 512;
> +	buf = kzalloc(size, GFP_KERNEL);

void *buf __free(kfree) = kzalloc(size, GFP_KERNEL);	

> +	if (!buf) {
> +		kfree(name16);
> +		return -ENOMEM;
> +	}
> +
> +	if (status == EFI_SUCCESS) {
> +		status = efivar_get_variable(name16, &guid, &attr, &size, buf);
> +		if (status == EFI_BUFFER_TOO_SMALL) {
> +			kfree(buf);
> +			buf = kzalloc(size, GFP_KERNEL);

krealloc()?

> +			if (!buf) {
> +				kfree(name16);
> +				return -ENOMEM;
> +			}
> +			status = efivar_get_variable(name16, &guid, &attr,
> +						     &size, buf);
> +		}
> +	}
> +	kfree(name16);
> +
> +	if (status == EFI_NOT_FOUND) {
> +		/*
> +		 * Variable not provisioned yet: behave like an erased
> +		 * EEPROM so that consumers still probe and fall back to
> +		 * their defaults.
> +		 */
> +		kfree(buf);
> +		size = efivar_nvmem_cells_extent(dev);
> +		if (!size)
> +			return dev_err_probe(dev, -ENODEV,
> +					     "variable '%s' not found and no cells described\n",
> +					     name);
> +		buf = kzalloc(size, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;

Sprinkle in some newlines after return for better readability here and
elsewhere.

> +		dev_info(dev, "variable '%s' not provisioned, reading as zeroes\n",
> +			 name);
> +	} else if (status != EFI_SUCCESS) {
> +		kfree(buf);
> +		return dev_err_probe(dev, -ENODEV,
> +				     "GetVariable('%s') failed: 0x%lx\n",
> +				     name, status);
> +	} else {
> +		dev_dbg(dev, "variable '%s' attr=0x%x size=%lu\n",
> +			name, attr, size);
> +	}
> +
> +	priv->data = devm_kmemdup(dev, buf, size, GFP_KERNEL);
> +	kfree(buf);
> +	if (!priv->data)
> +		return -ENOMEM;
> +	priv->size = size;
> +
> +	cfg.dev			= dev;
> +	cfg.name		= "efivar";
> +	cfg.id			= NVMEM_DEVID_AUTO;
> +	cfg.owner		= THIS_MODULE;
> +	cfg.type		= NVMEM_TYPE_OTP;
> +	cfg.read_only		= true;
> +	cfg.word_size		= 1;
> +	cfg.stride		= 1;
> +	cfg.size		= priv->size;
> +	cfg.reg_read		= efivar_nvmem_reg_read;
> +	cfg.priv		= priv;
> +	cfg.of_node		= dev->of_node;
> +	cfg.add_legacy_fixed_of_cells = true;

I think it looks better without tabs. Better yet, use compound literal:

	cfg = (struct nvmem_config){
		.dev = dev,
		...
	};

> +
> +	nvmem = devm_nvmem_register(dev, &cfg);
> +	return PTR_ERR_OR_ZERO(nvmem);

return PTR_ERR_OR_ZERO(devm_nvmem_register(dev, &cfg)); ?

> +}
> +
> +static const struct of_device_id efivar_nvmem_of_match[] = {
> +	{ .compatible = "nvmem-efivar" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, efivar_nvmem_of_match);
> +
> +static struct platform_driver efivar_nvmem_driver = {
> +	.probe = efivar_nvmem_probe,
> +	.driver = {
> +		.name = "nvmem-efivar",
> +		.of_match_table = efivar_nvmem_of_match,
> +	},
> +};
> +module_platform_driver(efivar_nvmem_driver);
> +
> +MODULE_DESCRIPTION("NVMEM provider backed by a UEFI variable");
> +MODULE_IMPORT_NS("EFIVAR");
> +MODULE_LICENSE("GPL");
>
> --
> 2.54.0
>
>

Bart
