Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD301F3BA2
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 08:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787991542; cv=none; b=YPTv35NOPCbowVNEekOxWJ5Zs+1E8ZX4bURyYZaZWIQhtUkLcutNVMID9RqObzrOOJWC/B8TbLks/Rv4T+xS/apCVO4X7ANNUWasfGgDWoyp2sYUccB9e8y9ZrEML5Xmw1FaAaKrxwCRaqH373BGAB+hlXF5vaCGbFKl/IJ9YYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787991542; c=relaxed/simple;
	bh=v+aWFiqZUP2AW8f+kRIKMwUZ2Rh6EogLxpcx+G8AQBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxEVVsIgywMMkNkRluoqLwHgWp0sAdFi/DWQgEIgTze7VrRE8um429CSHu97vrFUJ+ZBGNm9Z2pBhjdAT8kMCB+qnJvG8XRLzTj2gG2ZycKBg8ptJ0Hom8HHAvEta9QACLAtzfYRG23ohxiB5km/qytV26E/QHrpPwgBnZoiKhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Og3Eiqbm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Og3Eiqbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07AC1F000E9;
	Sat, 29 Aug 2026 08:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787991538;
	bh=6zA5WS2zaQbUnSdIGVGh77V3TtsB5L9w2bGdVkoSJi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Og3EiqbmovTeNEyE84oWM/qVKdpsREUMQNs8gP6jfmpWq2kplUAU+LUExB0sRPui5
	 l5vMEqL59d+Lnbcu0DFcOTrIVxJqOVP8PZabymsYfklBXM0QUJOmLQw8XCO/UO8wWp
	 bKFhMnBYy1zm5v+iO1n+JwFdxGMwCcsaJtrwjHytF52W+juVsSkif1sW+QkK7NII+V
	 ZP7Yvnod0hJEUAwoYM7xx5DUOTuo9fQgJQcVRJx02bY+5gLiYq1kivnwpombIJ94xr
	 wYRPx1fNawTCBZZ4pKyFVyJSBw7I/djTs1OchL/JLffS0jiO4tmlmqPy6v1LSAfRle
	 oGq2WdOYc0XWg==
Message-ID: <c33a1ea9-5608-4770-992e-a3dbe1226a65@kernel.org>
Date: Sat, 29 Aug 2026 10:18:53 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH wireless-next v3 1/4] wifi: aic: add SDIO BSP and
 build configuration
To: Yanli Yang <yanli.yang@bedmex.com>,
 Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Zhirun Liu <zhirunliu@aicsemi.com>,
 Dijia Xu <dijiaxu@aicsemi.com>, Chunqiu Liu <chunqiuliu@aicsemi.com>,
 Liheng Wei <liheng.wei@bedmex.com>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
 <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
 <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
 <cover.1787903339.git.yanli.yang@bedmex.com>
 <395cd2d678c7b53c927daec2860a7d3f3d5c2025.1787903339.git.yanli.yang@bedmex.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <395cd2d678c7b53c927daec2860a7d3f3d5c2025.1787903339.git.yanli.yang@bedmex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/08/2026 14:11, Yanli Yang wrote:
> From: Zhirun Liu <zhirunliu@aicsemi.com>
> 
> Add the build configuration and SDIO board-support layer for the initial
> AIC8800D80 U02 upstream target.  The BSP handles platform power sequencing,
> SDIO transport setup, firmware loading and chip initialization.
> 
> Limit the selectable configuration to the D80 U02 SDIO station baseline and
> use the kernel crypto library for firmware MD5 diagnostics.
> 
> Signed-off-by: Zhirun Liu <zhirunliu@aicsemi.com>
> Signed-off-by: Yanli Yang <yanli.yang@bedmex.com>

You still did not run checkpatch and has obvious issues pointed out by
it, but more importantly - you still did not document bindings for your
device.



...

> +
> +static DEVICE_ATTR_RW(hwinfo);
> +
> +static DEVICE_ATTR_RW(fwdebug);
> +
> +static DEVICE_ATTR_RW(adapt);

Where did you document the sysfs ABI?

> +
> +static struct attribute *aicbsp_attributes[] = {
> +	&dev_attr_hwinfo.attr,
> +	&dev_attr_fwdebug.attr,
> +	&dev_attr_adapt.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group aicbsp_attribute_group = {
> +	.name = "aicbsp_info",
> +	.attrs = aicbsp_attributes,
> +};
> +
> +int testmode = AICBSP_CPMODE_DEFAULT;
> +int adap_test;

Drop, not suitable for module params.

> +module_param(adap_test, int, 0660);
> +
> +#if defined CONFIG_PLATFORM_EXTERNAL && defined CONFIG_CUSTOM_PWF
> +int gpio_pwr;
> +bool gpio_pwr_assert;

You should not have globals. You need properly organize Linux device
driver structures.

> +
> +void nxp_pwr_ctrl(int value)
> +{
> +	pr_info("aic_bsp: %s: %d\n", __func__, value);
> +	gpio_set_value(gpio_pwr, value);
> +}
> +
> +static int aicbsp_pwr_node(void)
> +{
> +	struct device_node *np;
> +	int err;
> +
> +	np = of_find_compatible_node(NULL, NULL, "aic,wifi-power");


Undocumented compatible. But also unlikely to be accepted. Please read
writing bindings, DTS101 slides or some other guidelines for beginners,
how to properly describe hardware in DTS.



> +	if (!np) {
> +		pr_err("aic_bsp: %s np not found\n", __func__);
> +		return -ENODEV;
> +	}
> +
> +	gpio_pwr = of_get_named_gpio(np, "wifi-power", 0);

Do not use legacy API. Please open recent Linux drivers and look how
they manage GPIOs.


> +	if (!gpio_is_valid(gpio_pwr)) {
> +		pr_err("aic_bsp: %s is invalid\n", __func__);
> +		return -ENODEV;
> +	}
> +


...


> +
> +	(void)testmode;

Heh?

> +	aicbsp_firmware_list = fw_8800d80_u02;
> +	aicbsp_info.cpmode = AICBSP_CPMODE_WORK;
> +	if (!fw_path)
> +		return -ENOENT;
> +
> +	pr_info("aicbsp 8800d80 u02 wifi firmware: %s\n", fw_path);

Why your driver does not use dev_* calls? And why does it print so much?

Drivers should be silent on success:
https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/coding-style.rst#L913
https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/debugging/driver_development_debugging_guide.rst#L79

...

> +
> +aic8800_fdrv-y := \
> +	rwnx_msg_tx.o \
> +	rwnx_msg_rx.o \
> +	rwnx_utils.o \
> +	rwnx_cmds.o \
> +	rwnx_irqs.o \
> +	rwnx_cfgfile.o \
> +	rwnx_strs.o \
> +	rwnx_rx.o \
> +	rwnx_tx.o \
> +	rwnx_txq.o \
> +	rwnx_main.o \
> +	rwnx_mod_params.o \
> +	rwnx_platform.o \
> +	aicwf_chip_8800d80.o \
> +	aicwf_chip_ops.o \
> +	rwnx_v7.o \
> +	ipc_host.o \
> +	aicwf_compat_8800d80.o \
> +	regdb.o \
> +	aic_priv_cmd.o \
> +	sdio_host.o \
> +	aicwf_txrxif.o \
> +	aicwf_sdio.o \
> +	aicwf_rx_prealloc.o
> +
> +aic8800_fdrv-$(CONFIG_AIC8800_NONSTA_SUPPORT) += rwnx_mesh.o rwnx_tdls.o
> +
> +aic8800_fdrv-$(CONFIG_AIC8800_GENL) += aicwf_genl.o
> +
> +ccflags-y += -I$(srctree)
> +ccflags-y += -I$(src)
> +ccflags-y += -I$(src)/../aic8800_bsp
> +ccflags-y += -DAIC_TRACE_INCLUDE_PATH=$(src)
> +ccflags-y += -DAICWF_SDIO_SUPPORT
> +ccflags-y += -DCONFIG_SDIO_PWRCTRL
> +ccflags-y += -DCONFIG_RWNX_FULLMAC
> +ccflags-y += -DUSE_5G
> +ccflags-y += -DAICWF_RX_REORDER
> +ccflags-y += -DAICWF_ARP_OFFLOAD
> +ccflags-y += -DCONFIG_RX_NETIF_RECV_SKB
> +ccflags-y += -DCONFIG_AIC8800_RX_NETIF_RECV_SKB

I do not understand what is a ll this. Looks like out of tree module
build. We do not define defines via Makefile. Integrate the driver into
Linux.


Best regards,
Krzysztof
