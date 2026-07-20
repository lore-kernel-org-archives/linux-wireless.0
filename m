Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D138D014;
	Mon, 20 Jul 2026 22:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587619; cv=none; b=hzrH52hORFsQt/DrN2IkUy6J1woLoBqiu6GDVrDwBBzTicn5PBqina8T7YGbDumhxm823n7J4kT9wmx/DlnnOKy6wCN5R1qRbfqS42x+2YyHSl2VSNwTH1bKLvLhU5LHXbueEN2wQDgnhhaq80Ox7Vd09volLmnJU6AlaGW6P38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587619; c=relaxed/simple;
	bh=G28jyeTFq6CtIFaSECPw6bRj9dZ5++FHmZLh1y+5jRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6Nr6UVebPE98PniMqKMro6MmjJE2tMv/Af+SAhCOthPFj4kacyLHSkFw+gCcEJjWsLH0mAUTOr3PU6//48eZ0txWPnk6gCWKoVJjGCPPbQTY1gnJUF3PcVssYyTyfy0OeDmg7MrREsjcnQIU6Sv7H5Psa1plfq7TAXs76JP13M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Ij/94th7; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Ij/94th7"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4h3wcW55sszKn65;
	Tue, 21 Jul 2026 00:46:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784587611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eo+9+4t/XF8wxVM2KHRZKUCNyv2OchmaEckT5QN/S/I=;
	b=Ij/94th7YYbgHBRyVHOahYsl8rkSBNtGUZwdiCvBSAC1Q8j1Z7JESgPz44piNJrAmlOP0k
	1uiC4uBmBbK+g5wTmdczuO5T/y8tho/+4Wd53XqBH6rCK9bXzQhCaOFYhEkXhAKR7C+0um
	WUB2T+xyXtR3djxwMo70wDFbgQKdIJwJzKNBEv7x1pTd78NtWEapTtCw4VgzqDULShcg+z
	Wm8Y2olnj/fLTbARpbolvxoMlppymj1b/J5BNEvlc+/Mi6gI0Q6pSKJw5WpK8RU0BycR2n
	o7cd0VZcczumDE7JwVWkhIs4zQleQTiKrEZ40YwdHwUp7M6yAN0LOzl9JNXj8w==
Message-ID: <d1ae2d8c-43af-4a59-ad8e-fe5ab1f0a2d2@mailbox.org>
Date: Tue, 21 Jul 2026 00:46:49 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH do not merge 0/4] wifi: mwifiex: add iw61x support
To: Sascha Hauer <s.hauer@pengutronix.de>,
 Brian Norris <briannorris@chromium.org>,
 Francesco Dolcini <francesco@dolcini.it>,
 Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mmc@vger.kernel.org
References: <20250326-mwifiex-iw61x-v1-0-ff875ed35efc@pengutronix.de>
Content-Language: en-US
From: Marek Vasut <marek.vasut@mailbox.org>
In-Reply-To: <20250326-mwifiex-iw61x-v1-0-ff875ed35efc@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: jtkc5g1yefost6y1o99j5kbqexk3ogz6
X-MBO-RS-ID: 9b924e6a7eed59363d5

Hello Sascha,

On 3/26/25 1:18 PM, Sascha Hauer wrote:
> This series adds iw61x support to the mwifiex driver. It works for me,
> but is not yet ready to be merged. Some people showed interest in it, so
> I am sending it here.
> 
> All testing and review feedback appreciated.
> 
> During startup I get these messages:
> 
> [   12.078010] mwifiex_sdio mmc1:0001:1: Unknown GET_HW_SPEC TLV type: 0xff
> [   12.078018] mwifiex_sdio mmc1:0001:1: Unknown GET_HW_SPEC TLV type: 0xff
> [   12.078024] mwifiex_sdio mmc1:0001:1: Unknown GET_HW_SPEC TLV type: 0x23e
> [   12.078029] mwifiex_sdio mmc1:0001:1: Unknown GET_HW_SPEC TLV type: 0x25c
> 
> Not sure what these are about, I can't see these handled in the
> downstream mwifiex driver as well. Could also be there is some parsing
> error. Nevertheless the driver seems to work.
> 
> The series applies to v6.14, but should apply to my mwifiex cleanup
> series as well.

I was able to test these patches with IW610G based muRata 2LL SDIO 
device. I used firmware from [1] and I had to add SDIO ID for that 
IW610G device (trivial patch is below). Besides that, I am adding my:

Tested-by: Marek Vasut <marek.vasut@mailbox.org> # muRata 2LL

Do you plan to finish upstreaming these patches ?

"
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c 
b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 84e3946cc4e4e..54fc82a6e3458 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1049,6 +1049,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
                 .driver_data = (unsigned long)&mwifiex_sdio_sd8987},
         {SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 
SDIO_DEVICE_ID_MARVELL_8997_WLAN),
                 .driver_data = (unsigned long)&mwifiex_sdio_sd8997},
+       {SDIO_DEVICE(SDIO_VENDOR_ID_NXP, 0x0215),
+               .driver_data = (unsigned long)&mwifiex_sdio_iw612},
         {SDIO_DEVICE(SDIO_VENDOR_ID_NXP, SDIO_DEVICE_ID_NXP_IW612_WLAN),
                 .driver_data = (unsigned long)&mwifiex_sdio_iw612},
         {},
"

[1] 
https://github.com/nxp-imx/imx-firmware/tree/lf-6.18.20_2.0.0/FwImage_IW610_SD

Thank you for your help !
