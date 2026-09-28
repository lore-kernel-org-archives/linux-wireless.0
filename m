Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2D93546C1
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 07:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582106; cv=none; b=dakrynWm5W822w8Xra1Tw8vevrlCWMKcTSK3B5j/Io6SqGXs3S91TBRc8gWUiqYFBnlnTS0s2mtp2jivzCCMyTPizSVnxrUSwNkTvMVnnFHckC020gBbPKbgrIHzUykROtDteJ/AnTUwLy0VxsSrsUYmDu1wT6YGdjDvNTEfrqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582106; c=relaxed/simple;
	bh=b8alYS8//PbcHqgx8jRmmDZzchvUgilx76oq+rn8QMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MxTZYMkrpGIhsUuyD7HYlHVz2607hSE5wYRfkQOu4yX+Tnb3uFX/l4VuBdKBZRNzJtd95uqOWol0gl+N61l5XTR524yZXyyH8lBSnWU+0auBTHQsOhtrkvH7582WHinneJQGfsFY6r8jvPFHQ4kAxFNeAj04BrV6XrIVAW3P2D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a3DrdT6Z; arc=none smtp.client-ip=74.125.225.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a3DrdT6Z"
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-4a0054e5976so1535835e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 00:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790582102; x=1791186902; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=31XUkSRJuqJIxbyoM09CJAfu/QARGMWZ93NvtWQGmao=;
        b=a3DrdT6ZD4ThIMfFpURBub57KClHU3uQAjzWuaMsUo/PnyMxV0LN82P1aOvaSIeNVU
         cOVcVgXSY2SBad0Cxeu8hOfL85eIeUQ3faRNAxqqxgx1RBj+p/OZk/7eunMTh4x9rwWu
         /oK6rb0k4Oi2DZ4PgX5gKaVaUIpt85VG2/PzIUO7ETSdQlqKYILWqncuweeO2umthmiL
         /ov28wI+O+16GiZVCXAgjY5NWFOzy+lSWYoguoQh6wfUEv1QKqOdhmbkOG/4DStTYmqd
         7lo5F+MmQ/lep9PKBPjmzNJsG3uyIEyYXh0gfJ4IF9hktscqUaTe7jh9TN9IM8Jdc6py
         yOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790582102; x=1791186902;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=31XUkSRJuqJIxbyoM09CJAfu/QARGMWZ93NvtWQGmao=;
        b=uBjQHxqJr+MvkGNH7CXNJJlGGRfMzdibsV8EqpmWsdoYPFz/Tz9qJ9UGnRKSLUc9UA
         +RDlR5LBAD7NWJLLpXVBNIdtV5tcd8e5fyeOBuEcKwKJp7XVGSo3rrDcYlK1UapynGzF
         WoRKBr8oyYkJzpi2nsKlr1WPkIbs1PZGxLJYvvPj+JgRRegx1oncZMRcw9trPiosVwZq
         4CH7eRuIgbU+BuJBcIe/Ju9jaFEUN+solcPHs98an1skV56fGSj5NZwykkG2XLwe8jnP
         gP7t3VvrX57VkzCcnv3nPll2+hzyPyij6CyHYKIse9LaIC41N/TOIkKXNRV2Fw8NpjUq
         4lWg==
X-Gm-Message-State: AFuF++lWncKdtulpkwNxiAeGL3thcLC0z4BrKp2SMyLYKmxfY4aNLBk4
	0BW1CJtobUBwZ4wOcDwBF3LAZ9FbqYWetPSAhsRuxI8NbViVu2QI0o0uSA69rQKNMHI=
X-Gm-Gg: AYBFou0KzV5s3Sz6AEXYLAPq5vMAF1ZutPIZG75gAN9DLiX66/Mwte0WEGH3jgIZrwg
	Gso4dpoQU3clxNAGdKGAscI7l862UJKLpLJGjI6ACcQ22W2NYk5yUpHvwvIghlSbarMBAJq6RGk
	msTsJhDG9X1gRKSo0YysdWOxvpU4BrG3uZTJNxB5RagsRTY/fJINp95RC9NAQvU/J0vo446R6va
	jhwwmd2nzyQ+2FsV0bG21TSa3Vp9Q7HgSDGmjARGqS19qTasp+TJn/rkgoc2l1RBlzHTTZUUnSQ
	el8nlkWG40ZDsXybZ6RX3cj1rROit8jbFrSPsnSgWFo5uhOBSTn4zoXfwPD3QI7+SojeXRVhMsc
	ezNeGFDCUFni9oNIdHT9qfOlElMED/s9RrcuxyVP6MvHZ8jMaT4bTdrxxNwRx649kulp2vrMrTG
	WDWSG769ATb9bBUPFVMdZzpGx+1A4Uga7h87qdcFmyxTN0PGbeoNa7KQP+0qi/1pai0CTTQVlNA
	dpkaaQmETIhr+fwVKTl+IrmA6henT/GWc1cGQSRXxw=
X-Received: by 2002:a05:600c:8719:b0:49e:6c11:c4fc with SMTP id 5b1f17b1804b1-49fe66c8a5amr224841855e9.7.1790582102485;
        Mon, 28 Sep 2026 00:55:02 -0700 (PDT)
Received: from [192.168.0.38] (static-246-51-231-77.ipcom.comunitel.net. [77.231.51.246])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00178bebasm128950675e9.11.2026.09.28.00.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 00:55:02 -0700 (PDT)
Message-ID: <c2f3dd05-97a8-43c8-9825-46f62cb5d41e@suse.com>
Date: Mon, 28 Sep 2026 09:55:00 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] wifi: brcmfmac: Add per-board clm_blob firmware
 binaries
To: Benjamin Drung <benjamin.drung@canonical.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260923203739.2560527-1-benjamin.drung@canonical.com>
 <20260923203739.2560527-2-benjamin.drung@canonical.com>
Content-Language: en-US, ca-ES, es-ES
From: Matthias Brugger <mbrugger@suse.com>
Autocrypt: addr=mbrugger@suse.com; keydata=
 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
 PVrr2NoUqi/bxI8fFQJD1jVj8K0=
In-Reply-To: <20260923203739.2560527-2-benjamin.drung@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 23/09/2026 22:37, Benjamin Drung wrote:
> On Ubuntu 26.10 these firmware file are missing inside the initrd when
> including the brcmfmac kernel module:
> 
> ```
> /usr/lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43436-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-a-plus.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,500.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,4-compute-module.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,400.clm_blob.zst
> ```
> 
> Commit 885f256f61f9 ("brcmfmac: Add clm_blob firmware files to modinfo")
> added clm_blob firmware binaries, but did not add them for per-board
> firmware binaries. So add a similar glob for the per-board firmware
> binaries.
> 
> Bug-Ubuntu: https://launchpad.net/bugs/2168109
> Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>

Reviewed-by: Matthias Brugger <mbrugger@suse.com>

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 381801af3ac9..3cff0f1fe25f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -631,6 +631,7 @@ MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.txt");
>   
>   /* per-board firmware binaries */
>   MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.bin");
> +MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-sdio.*.clm_blob");
>   
>   static const struct brcmf_firmware_mapping brcmf_sdio_fwnames[] = {
>   	BRCMF_FW_ENTRY(BRCM_CC_43143_CHIP_ID, 0xFFFFFFFF, 43143),

