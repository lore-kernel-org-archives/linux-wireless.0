Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACA847ECF0
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045762; cv=none; b=Pzg+nCgELxrHiWakAhtidxOSetBh4KAKG86F0jvkR9DsJFItvcAIdTlR1DyQhNSWnViLYQElzeMWy7MhLUjzTgyKz934bzWexwXqp2UUISvSu8l1zjW3pN6U7rYvnAq+lpCAMj7gXbQEsT0YSJGV7/brUQGYyxu8VjhraC1KDfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045762; c=relaxed/simple;
	bh=ngMMr7wv1g49NtcMDPtMet1+NYvAn6ISxIYsQhJogC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoBR0sVdfthZPScLleLa435JbG/pVLKXdh2mFouXIgdXSvsQDrfR1CeVqCCgF1G0RSKZHa2KVtdBq4k/YQddOcNOWjFdsZpuJfFotGNyde6hJXww+hJgGA3WTjiS8UUP+VJGEBEmL8/BMbYUttrusE7vl2mmo7UbGLhzX3KGEsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=Cl+1VbGv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="Cl+1VbGv"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a172eb31f0so41782705e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 23:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1792045758; x=1792650558; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CrzILkoyvowEBCBs4W94J+1nI3BRb4DDhSmm0sp3WxM=;
        b=Cl+1VbGve9R8Ka6N1rGjxz2HnPX569Tm1n1DR6sF7EG+5DD+4YZz0WJxP5T6R4vYaF
         tDrLs2VjC9vMoL5cNEwunvTnwgg+9O02W1Fa2vJK+40FuXfScaUx3ORpY8y2B1gynUHV
         xGSUEl9i3QVOAWrg0bwidzD6W+jodHwp9n1eg74O3erLKRyCEI9gLWcb0V1l3OtQe1Mv
         XAikl0A315kw862GfFaNfU5I52c3XPrqeIMHroEPfvDuuNNcB+ywmUKLesH0oirLBeY7
         fVz9YjYC429S58c3ummgT8DX+Lxe/VKle/d0woSMr3McQjfga56QYq6GJ0BMc35j7mrW
         Eidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792045758; x=1792650558;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CrzILkoyvowEBCBs4W94J+1nI3BRb4DDhSmm0sp3WxM=;
        b=EYdn315NyrccumHxrFwQY5h10jaSHoFS6Z50FfgZLwLI+5QCrdRZz195npbZM21bdc
         RqKWzJ/5kSB18fHlcYviFZz6n31dlR0dzzA66sBV1Nm00JNIxdLP8VxKANDlvH9nE3+2
         RUMBEeXrSIujK5aivjHwbCOOROZPYM3hxzw4zU6FNMGZYaNkw70W6trj6MAA+Nxpfvm+
         yB3Ktwmt1a7Ux7RyKPoG7BTC8DOKKoY37A6As2mphj4FpJaVNHgBg4vax/TxgDgxDkwo
         gW3oQ255r2A1sz1jyArNQZMFU+nfLhy9JztWvd3JAnnu4HhRQJkuRVjPlRi3LVfnufdd
         n3uw==
X-Forwarded-Encrypted: i=1; AKwUvBxRqlqy/VMRW4keCra1/gSSUjppZp3o86Pw9uNT73L4LIsgh0DcNQRO5AJto8mgZiRzo7FkdgMglR2TH1lXLA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLfL2qpyybpus1z/idMggP+7yPktIRVD3Wf1Pbj6M/u8D2Zf7rk
	Al9oQeDhG71YcH8ywY8i99xNKnczkHtCK4kyX6KpFkVpW8vTPRCdPHKpjMFdvdcMsLw=
X-Gm-Gg: AYBFou0SxpaI8iBFebIzYhGKeyAG5V7y0l2EEmCumhIwxs2gUjrINs/MxAM2DQE9Hrp
	YuU7HbqonGRl7O9iEN20DkIZT7au4teCrA+OGtSttl1qkXpbBV5gLEyezRkS24Po/Z2amKB0/Nb
	lT79fTW/TWdcJn0NTMwKWWFbqVJ/4hP31BzdTBzAAAill/L4aEX+PCs/auooRwjAPQ4MNNQZjuK
	UzpPCsiZglQNuxMFWefbLgOyrUCBzqyedZVbCeltnxh0o/ebVQArP1c/y5zFZrjJhPHAo2pkYhc
	yFnnCaj0m1X1lvaJRTmT50+wAE/pEmaA88GnwqZhdVS0F/56hxqiaDdocxIpZMQTZE4PhidQQbS
	RQU37IIYJ1J3ggr9edL2VeUU7lvTpCd8pOJgJglRCJoL8Gfy/4c39mFda74HEzpgYrWU2aeM7kr
	qvGZLEehvojDh2LZnZZo8aYZKGTSENsdxDGn5VMajSAduLTFqvTkPqoZlEewUTPmN39OiQOp07m
	T4E
X-Received: by 2002:a05:600c:8518:b0:49f:cbf3:551c with SMTP id 5b1f17b1804b1-4a18e4a8ca6mr326220155e9.12.1792045757868;
        Wed, 14 Oct 2026 23:29:17 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4a1bd9a8a15sm46085045e9.4.2026.10.14.23.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 23:29:17 -0700 (PDT)
Date: Thu, 15 Oct 2026 08:29:15 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Jeff Johnson <jjohnson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org
Subject: Re: [PATCH RFC 2/5] nvmem: Add UEFI variable NVMEM provider
Message-ID: <atBwaKE20dJF1jXP@monoceros>
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
 <20261014-b4-nvmem-efivar-v1-2-187c85f65018@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zmiuyjupclul4syh"
Content-Disposition: inline
In-Reply-To: <20261014-b4-nvmem-efivar-v1-2-187c85f65018@oss.qualcomm.com>


--zmiuyjupclul4syh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH RFC 2/5] nvmem: Add UEFI variable NVMEM provider
MIME-Version: 1.0

On Wed, Oct 14, 2026 at 04:02:40PM +0300, Abel Vesa wrote:
> +#include <linux/mod_devicetable.h>
> [...]
> +#include <linux/platform_device.h>

<linux/mod_devicetable.h> pulls in a lot of unneeded dependencies and
<linux/platform_device.h> already provides of_device_id. So please drop
the former.

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

having only nearly all of these aligned is really strange. If you ask
me, don't try to align =, just use a single space before it.

You can write this as:

	cfg = (typeof(cfg)) {
		.dev = dev,
		.name = "efivar",
		...
	};

which is a bit less repetitive and easier for the compiler to optimize.

> +	nvmem = devm_nvmem_register(dev, &cfg);

Does nvmem_register only return success or -ENOMEM? If not, a
dev_err_probe() would be nice here.

> +	return PTR_ERR_OR_ZERO(nvmem);
> +}
> +
> +static const struct of_device_id efivar_nvmem_of_match[] = {
> +	{ .compatible = "nvmem-efivar" },
> +	{}

s/{}/{ }/

> +};
> +MODULE_DEVICE_TABLE(of, efivar_nvmem_of_match);

Best regards
Uwe

--zmiuyjupclul4syh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmrQcrgACgkQj4D7WH0S
/k7Hggf/V5sRv/MeY3XE+UjeelKqRfTHz0evXvOJWyrUMTHIBxrDkz8QKuEN9Suk
jeahg8flS8j/DDI1JqZdIFpsddA/zp4pQtQL5VgFe35gJoG3wYXsrVLdWozBylIP
n/evHMBXhRXiCUnQPMB4l3th14mTR5TE1Hb94GtlMKTueC1PPc4L0jzfLBPzEsdT
vnz/amCvOXWaguwBCYf2gy/PYMK/JZtJf0peAj404US7HDDFWiwqI+UdFRK4sTTy
xUgWhdZ+Bj5PLXYavMI1VcPx6G1YPlfflK1GjkMA5/puxk28nPCguUFz9G9zoKwR
7QQYsNrlVCJ9O8W14hihe8LrM7cotQ==
=Qsq8
-----END PGP SIGNATURE-----

--zmiuyjupclul4syh--
