Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A87E3264C2;
	Fri, 24 Jul 2026 04:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784869083; cv=none; b=rIUgdE4hctFmKeANe6LF+sQ7mfiqD4vYKNEyTrO8iUX6NW5s2l+N8Sjq2YK3sobyG6FB5buuYFSFcPCkN+UFjiOA7gUeR5JBnSASPmtTLTtHYBfw9L5/vMvstkarKpqewjVB0GUXf+Y5qfy87PYocKJlBk//4jAUBUvmfz6kFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784869083; c=relaxed/simple;
	bh=muNGbVSE63ZwLx6JTwUqy7Oq+2WVsxviAG63JXRC72A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7JZDOMZCMUn/07GDAp4Gf+rx8XYrFq+zZXLXu+eG7PjACNkI6luzqeA4pmTjmZnILpG+AXXBt2W4H3WeOZoumrANhhbF9yF01LEZdw5V6qwQFF/EtMqokhpQYbvx+KuFpci6bUpXRto2GRm/uP0xHDRsT5k4g25g2th590ndqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dCJEMHRn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dCJEMHRn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0pO6hUB0iIxD4TyXUYlqc7LrnsyhEtYUcjdZrQrosCo=; b=dCJEMHRn3xYqVAfuYYkzbIPIp3
	Inq2NxvS38Srj9Jj4S6ZY+acCFPe1cObOEJRiTmc+Ezv/JVCiqJtb50wgxpJaBky5Nu/S0t47ipvB
	GO715i4MWZCMen5TGlZJM+oZYzf5tt+pLPElmDgc+RediL8nEVrUwocrewR2SlAwypnL/5SzFO3c7
	hbasNQagNIq0oEqoKbmWsN8LzbUg4tQAcYUct//pUr5JQCGXI0GhKjzCVct4bqY6ZFn/o2fpDIOyn
	WM1czYp32/cejCQe5997e7Om4NX3n1Iz1mj01qp/3S6PZafVrfY6vZWI0M0Di/xGIL4vifq4/n0q2
	RPRVg4gQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wn7yp-0000000FTwy-42lv;
	Fri, 24 Jul 2026 04:57:51 +0000
Date: Thu, 23 Jul 2026 21:57:51 -0700
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
Subject: Re: [PATCH v8 5/9] block: implement NVMEM provider
Message-ID: <amLwz6WuHYUwKKJo@infradead.org>
References: <20260703-block-as-nvmem-v8-0-98ae32bfc49a@oss.qualcomm.com>
 <20260703-block-as-nvmem-v8-5-98ae32bfc49a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-block-as-nvmem-v8-5-98ae32bfc49a@oss.qualcomm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 03, 2026 at 03:45:18PM +0200, Loic Poulain wrote:
> +	  Allow block devices (or partitions) to act as NVMEM providers,

Based on the code below I don't think you actually support partitions.

> +static int blk_nvmem_reg_read(void *priv, unsigned int from, void *val, size_t bytes)

Overly long line.

> +{
> +	dev_t devt = (dev_t)(uintptr_t)priv;
> +	size_t bytes_left = bytes;
> +	loff_t pos = from;
> +	int ret = 0;
> +
> +	struct file *bdev_file __free(fput) =
> +		bdev_file_open_by_dev(devt, BLK_OPEN_READ, NULL, NULL);

Please try to avoid all that magic autfree stuff that makes the code
impossible to read about.

> +	if (IS_ERR(bdev_file))
> +		return PTR_ERR(bdev_file);
> +
> +	while (bytes_left) {

.. and just use __kernel_read instead of badly reimplementing it.

> +	config.name = dev_name(dev);
> +	config.owner = THIS_MODULE;
> +	config.priv = (void *)(uintptr_t)dev->devt;

Why is this storing the dev_t and not the block device itself?

> +
> +		blk_nvmem_add(disk->part0);

Hmm, and you're always doing it for the whole device.  So the intefaces
really should be based on a gendisk, not a block_device.

Also once you register the whole devices as nvmem provider, we really
should keep it from being used a block device, shouldn't we?
