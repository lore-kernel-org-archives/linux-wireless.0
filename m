Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E743A05C2
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411378; cv=none; b=EVWUt+7Hgj5yAGGKBGmEsxNlchBlsHn0fmfhXsOr7maR/MHpYsiNOZi7txfGYXaAXLSY56HF0xizRf4Xn8ZP7v6Z+dKx9y1vPgaApkmBCGod206BrP+xVcKSrLuVTnWxeZpQ5tJEib7mWTolNOoLynh12Zk6PPGZRNJtaquz6+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411378; c=relaxed/simple;
	bh=Ndw6hik3x/AoZoF1Io5lferB93Yj0K1/+VbsvX2dnC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Olaoj4M2vJqGbSQbLGKcGe1Rq3iYw2tvVDU+1j0gsMOQhq2+hBUUxQVbZQOpmh6I3tASJZU1upK1xWt8zwivBy5SSQX/XapGiznUWRDUbGmy9rLUCIiLbYMoYfxlXVpkGG62ot2AjFSLSgxocBnzHFzxGvYrCzeoYEnKa4wHeYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ifq3A8aq; arc=none smtp.client-ip=209.85.210.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ifq3A8aq"
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-86cf1b397edso406012b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411375; x=1790016175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3geujkzCqEAatEWbaDVNzshK13FVbc1sKj1PBNVHXWU=;
        b=BIsyIFVp4R/ZsgjjvMDKz8Ct8loY4G8UJCFzl+s7AS4pPY5MdVjlrSFYsZs4Ph+6KI
         i6a3BCCcbNji5qHU5WUM3l/0TYb59krXZjc7Rrz+8bOai5CYf8MjrzQugOLVZMvKP4FA
         suHSVs159ua2Kuv31j2wlfbCSu6QYq4w6cj8cTJZAqMCbuDUNuUaQKXhd0ginbb66FfA
         W4hFXP1PuV5/LbuSWjFuH2/8A9qUxAc7nkiTDagg7EfSBHVa/CCwk6D6lAhT0Vccrjkv
         B1uf9/9PiPh4jx7Et1qHUB7L5uV0XDuK9SSFHGsZWA1RpbU5A+rthHIuC7iDV6LgR/az
         EUjw==
X-Gm-Message-State: AFuF++mwmXuAL1wKnIr0k0eBUj4x8d0zGtzDTJXQMFCfOtjXe4nbz+bN
	i23aTgpouDFuK4hVYRb5ZlSVO2G/q6lg1nxj/X4LYAiI0cpQfK/DDc3TsH9NpBu7mpq/YLZz83B
	1OGQZX+2+Fwiy/CxsGQkHJNJTloLCJSN5fN5/xMY8mHH52v6YUUG09AQ1KeRTvrtjiVU/MnZt1y
	VpvxB9KzGbdi6w9n1iyq5Lb1AnfsVd+GHEyqynhWKtiyocNC0qKszicNOhMMmWrwzuXnYvIjIC5
	PlU5Ffq0Y8qQQOYb/3qcrpU1che5ik=
X-Gm-Gg: AYBFou1R10Xfr/ATbaYPm8GOM+61byJmjX9E4xPxF5Z6HeHB92l3JmXI2/hFkCp9Flt
	MMcpA52gUttl72Xf13+wCOiJwA2onMTgCREdbIBGs4CAbqwV77RmFAadsFC1TPShOz6eSI/LrWP
	jEjetn/EkUp+qJmfUyg3+RChARtNEu5U1EZginLG2gPZcSYhxTJ3ROMh1CHbFE3/xsFI9tkNtYb
	S+lSV3iqh2rIhO+KyIY6kHUZdPtyFa9alfwvyW63tlorjwqRtx0n0oAzpbtsfy1KvHQV5EHfmTV
	oSLHkMWXawgqYolW6X/Y0d4riWbZl7BIibreI52ks5BZsssIEcCfB5ZAsQRx81IuP24hsC2Bwks
	shcSW8TlTwquaBmautPsLnkzmvw7Db/sNJdcn2NlJq5blROLkfkVMrYH08ZB4silQ6quaeKHjt/
	fF4QQAty4NJ4n+Ys6yPqRTWEcsSEv+S8cNTQa6Jr0=
X-Received: by 2002:a05:6a00:992:b0:866:abd8:f112 with SMTP id d2e1a72fcca58-86f83a3f608mr7764552b3a.8.1789411375240;
        Mon, 14 Sep 2026 11:42:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-86b22009f92sm3298455b3a.0.2026.09.14.11.42.54
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:42:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b1a3f01d2aso5326648eaf.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789411374; x=1790016174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3geujkzCqEAatEWbaDVNzshK13FVbc1sKj1PBNVHXWU=;
        b=Ifq3A8aq8xNNmvZ8GhhrxeZrOhZLNw1MH2+tndHVK/EdYOmSi1vXu9q+pqzYqDmNzs
         DEvKkZ8zpKMMSgfCOASkHEkgBVUcGJ8PZYO2zDSCWbLr4M5J0w1a2AX4oZwKLvd8UNa0
         fek/B8pGnsaDtDqW973MXYsDRiGEcBsT4idfc=
X-Received: by 2002:a05:6820:f09:b0:6b7:46fc:1cd with SMTP id 006d021491bc7-6c542041664mr2261099eaf.44.1789411373635;
        Mon, 14 Sep 2026 11:42:53 -0700 (PDT)
X-Received: by 2002:a05:6820:f09:b0:6b7:46fc:1cd with SMTP id 006d021491bc7-6c542041664mr2261069eaf.44.1789411373137;
        Mon, 14 Sep 2026 11:42:53 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f55735sm29037930eec.24.2026.09.14.11.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:42:52 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Max Engel <dev@maxengel.com>
Cc: linux-wireless@vger.kernel.org,
	arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] wifi: brcmfmac: schedule bus reset when the device is unresponsive after wake
Date: Mon, 14 Sep 2026 20:42:48 +0200
Message-ID: <20260914184249.1464637-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <178686152030.336421.12015467912819395181@maxengel.com>
References: <178686152030.336421.12015467912819395181@maxengel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sun, 16 Aug 2026 06:25:20 +0000, Max Engel wrote:
> That worker's only SDIO trigger today is the firmware-halt mailbox
> interrupt (HMB_DATA_FWHALT) - which a chip that is off the bus can never
> deliver. Schedule the same worker from the KSO wake path when the
> failure is conclusive: wake direction, retries exhausted, and the CSR
> reading back all-ones.

[...]

> @@ -770,6 +770,28 @@
>  	if (try_cnt > MAX_KSO_ATTEMPTS)
>  		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
>  
> +	/* A wake attempt that gives up (whether by exhausting the KSO
> +	 * retries or by bailing out on consecutive access errors) with the
> +	 * sleep CSR reading back all-ones means the device has dropped off
> +	 * the bus entirely, e.g. it lost state across a system suspend
> +	 * despite keep-power-in-suspend (observed on CYW43455/BCM4345C0 on
> +	 * rk3566). No in-band recovery is possible: the interface is gone
> +	 * and a module reload fails to re-probe (-ETIMEDOUT on every
> +	 * function). The bus reset worker already performs the only known
> +	 * remedy (mmc_hw_reset -> pwrseq WL_REG_ON power cycle), but its
> +	 * sole SDIO trigger is the firmware-halt mailbox interrupt, which
> +	 * a chip that is off the bus can never deliver. Schedule it from
> +	 * here instead.
> +	 */
> +	if (on && err && rd_val == 0xff) {
> +		struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
> +
> +		if (drvr && drvr->bus_reset.func) {
> +			brcmf_err("device unresponsive after wake, scheduling bus reset\n");
> +			schedule_work(&drvr->bus_reset);
> +		}
> +	}
> +
>  	if (on)
>  		sdio_retune_release(bus->sdiodev->func1);

The hardware recovery reasoning makes sense. However, reaching into
bus->sdiodev->bus_if->drvr directly from sdio.c to schedule drvr->bus_reset
breaks the driver layering.

The common entry point for scheduling bus_reset is brcmf_fw_crashed(), but the
device coredump done in there is guaranteed to fail because of the unresponsive
bus. So I suggest to add a bool parameter 'coredump' to brcmf_fw_crashed() to
indicate whether to perform a coredump so we can opt out passing false for it.

Regards,
Arend
