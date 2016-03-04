Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37893 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbcCDOtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 09:49:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 18/21] brcmfmac: switch to new platform data
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
	<1455704830-10088-19-git-send-email-arend@broadcom.com>
Date: Fri, 04 Mar 2016 16:49:32 +0200
In-Reply-To: <1455704830-10088-19-git-send-email-arend@broadcom.com> (Arend
	van Spriel's message of "Wed, 17 Feb 2016 11:27:07 +0100")
Message-ID: <87a8mexpqb.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_154942_900505_2822D5C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> Platform data is only available for sdio. With this patch a new
> platform data structure is being used which allows for platform
> data for any device and configurable per device. This patch only
> switches to the new structure and adds support for SDIO devices.
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

It's more work to review patches which rename a file and adds new
features at the same time. Splitting this to two patches, first a simple
rename and then adding support for SDIO, would have been much nicer.

>  static void brcmf_mp_attach(void)
>  {
> +	/* If module param firmware path is set then this will always be used,
> +	 * if not set then if available use the platform data version. To make
> +	 * sure it gets initialized at all, always copy the module param version
> +	 */
>  	strlcpy(brcmf_mp_global.firmware_path, brcmf_firmware_path,
>  		BRCMF_FW_ALTPATH_LEN);
> +	if ((brcmfmac_pdata) && (brcmfmac_pdata->fw_alternative_path) &&
> +	    (brcmf_mp_global.firmware_path[0] == '\0')) {
> +		strlcpy(brcmf_mp_global.firmware_path,
> +			brcmfmac_pdata->fw_alternative_path,
> +			BRCMF_FW_ALTPATH_LEN);
> +	}

[...]

> +/**
> + * struct brcmfmac_platform_data - BRCMFMAC specific platform data.
> + *
> + * @power_on:	This function is called by the brcmfmac driver when the module
> + *		gets loaded. This can be particularly useful for low power
> + *		devices. The platform spcific routine may for example decide to
> + *		power up the complete device. If there is no use-case for this
> + *		function then provide NULL.
> + * @power_off:	This function is called by the brcmfmac when the module gets
> + *		unloaded. At this point the devices can be powered down or
> + *		otherwise be reset. So if an actual power_off is not supported
> + *		but reset is supported by the devices then reset the devices
> + *		when this function gets called. This can be particularly useful
> + *		for low power devices. If there is no use-case for this
> + *		function then provide NULL.
> + */
> +struct brcmfmac_platform_data {
> +	void	(*power_on)(void);
> +	void	(*power_off)(void);
> +	char	*fw_alternative_path;
> +	int	device_count;
> +	struct brcmfmac_pd_device devices[0];
> +};

If I understood correctly this undocumented, and not mentioned in the
commit log, fw_alternative_path is a new feature in platform data. I
guess it provides a different firmware image name for the device so that
devices can have different firmware images on the same system?

It's not pretty but I guess okayish. Opinions?

-- 
Kalle Valo
