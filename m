Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EEB479895;
	Tue,  4 Aug 2026 16:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785861374; cv=none; b=BDURYSHr2N11G75Vq1cYmPsKuEnnh4Xjmt38Ql84PeRL6PXThuMuZ3VlkcsvGmxdeOFlDW7i7nQ+ErLbnGS5frEfv1Jnav/WEztlTyvouy0So2DGT48FVO/oUgY9y4OJm+qGoY2XLMfQE2a8m3dIVg6Ong1xru+1pXQNSV0xZlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785861374; c=relaxed/simple;
	bh=1OehUdJ53tVLxlPsRLeAgB9SH2XB7mrQ0auW96D5it8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts/KeSdY/iMCnaV6BxjeqJonEux9zIeDzuxyXsdPWsaL/WhjbnGRR1j3j9ThanpcZsZ+C2BxjuFstb5NNQBe2XvG/Dbd1DhXtfLptFvH8563lMtDARqMBD02PFmJ2ehpwI/9TTecFJ/g+8l9PqKNAKiGkYJPMH+jFwLzhEbU/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ku8aZn8d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ku8aZn8d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+phEtP839OmAXTAezANS2diupL0Drcp1+juhMBWBlYs=; b=ku8aZn8dwi2K8skwzigc5WZi+F
	sGbkZQW9yPiF+Kdu3Yoz5X6M2D7aQZZd+Jpd/rZZjFGCN8At0x2aWiGAoj48JVD+ScNKu4nPi1M2f
	BcwiziDIYhuAMSRGqJWL+W4WWLYMc86R7t2i4gYkpo8uaSszVtJmDGRTzoCM8TpGqz3rBT8kzz0jU
	/nZyhx9clYVpEAKCzPLeeDhk6fPubdVM5pQfO3uZjMYurcf74js1uVqUizFWNvXjk21BlIBM8/Kro
	SmpF9fydW3/wZr5b3xHPGM0rXAVgb+XvpViaXHFoTMjL+fnQgb+V31w0aniIm4wyKVEEPtbrtMCwl
	jpr+p/Vw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrI7Q-00000002LWG-0afw;
	Tue, 04 Aug 2026 16:35:56 +0000
Date: Tue, 4 Aug 2026 09:35:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
	Rocky Liao <quic_rjliao@quicinc.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Saravana Kannan <saravanak@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>, linux-mmc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-block@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	daniel@makrotopia.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v9 06/10] block: implement NVMEM provider
Message-ID: <anIU7FSBT6VMzsf3@infradead.org>
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
 <20260730-block-as-nvmem-v9-6-f72935817dbf@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-block-as-nvmem-v9-6-f72935817dbf@oss.qualcomm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 06:00:36PM +0200, Loic Poulain wrote:
> On embedded devices using an eMMC it is common that one or more partitions
> on the eMMC are used to store MAC addresses and Wi-Fi calibration EEPROM
> data. Allow referencing the partition in device tree for the kernel and
> Wi-Fi drivers accessing it via the NVMEM layer.
> 
> NVMEM is registered for a block device whose OF node describes an NVMEM
> layout, either via an "nvmem-layout" child or by being a "fixed-layout"
> node itself (e.g. an eMMC boot partition associated through its mmc-card
> node).
> 
> The NVMEM device is a read-only side channel: the block device stays
> fully usable, reads are performed with a non-exclusive BLK_OPEN_READ
> open, and no synchronization is done against concurrent writes to the
> same region. This is acceptable for the intended use case of write-once,
> factory-provisioned data.
> 
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
>  block/Kconfig             |  11 +++++
>  block/Makefile            |   1 +
>  block/blk-nvmem.c         | 104 ++++++++++++++++++++++++++++++++++++++++++++++
>  block/blk.h               |   8 ++++
>  block/genhd.c             |   4 ++
>  block/partitions/core.c   |   5 +++
>  include/linux/blk_types.h |   4 ++
>  7 files changed, 137 insertions(+)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index 70e4a66d941ff66ecb0ec34f4f7eff7fd1e4be40..4899ad572c71ffdbb62460d57623216254893ddc 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -209,6 +209,17 @@ config BLK_INLINE_ENCRYPTION_FALLBACK
>  	  by falling back to the kernel crypto API when inline
>  	  encryption hardware is not present.
>  
> +config BLK_NVMEM
> +	bool "Block device NVMEM provider"
> +	depends on OF
> +	depends on NVMEM
> +	help
> +	  Allow block devices (or partitions) to act as NVMEM providers,
> +	  exposing factory-provisioned data such as MAC addresses or Wi-Fi
> +	  calibration blobs to the drivers that consume them. This is
> +	  typically used on embedded devices where such data is stored in a
> +	  dedicated area of an eMMC, instead of a separate EEPROM or OTP.
> +
>  source "block/partitions/Kconfig"
>  
>  config BLK_PM
> diff --git a/block/Makefile b/block/Makefile
> index e7bd320e3d6971a8abf584f5de42776bb54e8216..8200297fbcbab304beb4239d0c33da07011c3ed9 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -39,3 +39,4 @@ obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= blk-crypto.o blk-crypto-profile.o \
>  					   blk-crypto-sysfs.o
>  obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
>  obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
> +obj-$(CONFIG_BLK_NVMEM)                += blk-nvmem.o
> diff --git a/block/blk-nvmem.c b/block/blk-nvmem.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..05bc35b9b8f373ccb606bdca35d211c41d2764fe
> --- /dev/null
> +++ b/block/blk-nvmem.c
> @@ -0,0 +1,104 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * block device NVMEM provider
> + *
> + * Copyright (c) 2024 Daniel Golle <daniel@makrotopia.org>
> + * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
> + *
> + * Useful on devices using a whole disk or a partition (e.g. an eMMC boot
> + * partition) to store MAC addresses, Bluetooth addresses or Wi-Fi
> + * calibration EEPROM data.
> + *
> + * The NVMEM device is a side channel onto a block device that stays fully
> + * usable. This is somewhat mitigated by opening the device exclusively.
> + */
> +
> +#include <linux/cleanup.h>
> +#include <linux/device.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/nvmem-provider.h>
> +#include <linux/nvmem-consumer.h>
> +#include <linux/of.h>
> +#include <linux/property.h>
> +
> +#include "blk.h"
> +
> +static int blk_nvmem_reg_read(void *priv, unsigned int from,
> +			      void *val, size_t bytes)
> +{
> +	struct block_device *bdev = priv;
> +	struct file *bdev_file;
> +	loff_t pos = from;
> +	ssize_t ret;
> +
> +	/* open and prevent other exclusive openers */
> +	bdev_file = bdev_file_open_by_dev(bdev->bd_dev,
> +					  BLK_OPEN_READ | BLK_OPEN_EXCL,
> +					  blk_nvmem_reg_read, NULL);
> +	if (IS_ERR(bdev_file))
> +		return PTR_ERR(bdev_file);
> +
> +	ret = kernel_read(bdev_file, val, bytes, &pos);
> +	if (ret >= 0 && ret != bytes)
> +		ret = -EIO;
> +
> +	fput(bdev_file);
> +
> +	return ret < 0 ? ret : 0;

The error handling here is a bit weird as you seem to handle the
positive/negative values twice.  What about something like this instead?

	bdev_file = bdev_file_open_by_dev(bdev->bd_dev,
					  BLK_OPEN_READ | BLK_OPEN_EXCL,
					  blk_nvmem_reg_read, NULL);
	if (IS_ERR(bdev_file))
		return PTR_ERR(bdev_file);
	ret = kernel_read(bdev_file, val, bytes, &pos);
	fput(bdev_file);

	if (ret < 0)
		return ret;
	if (ret != bytes)
		return -EIO;
	return 0;

?

> +	struct device_node *child __free(device_node) =
> +			of_get_child_by_name(np, "nvmem-layout");

Please avoid the __cleanups stuff as it doesn't interact well with
the goto basd cleanups usually used in block drivers.

> +	config.id = NVMEM_DEVID_NONE;
> +	config.dev = dev;
> +	config.name = dev_name(dev);
> +	config.owner = THIS_MODULE;
> +	config.priv = bdev;
> +	config.reg_read = blk_nvmem_reg_read;
> +	config.size = bdev_nr_bytes(bdev);
> +	config.word_size = 1;
> +	config.stride = 1;
> +	config.read_only = true;
> +	config.root_only = true;
> +	config.ignore_wp = true;
> +	config.of_node = np;

Maybe initialize all the static information at declaration time
here?

> +	bdev->bd_nvmem = nvmem;

What guards access to this pointer?

