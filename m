Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103D5330307
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 07:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789025197; cv=pass; b=c0vGJPB+55rFbSkSbqoq/sre91L/Nq+7utwuS7ba/tnEeWcOe22of2B27DDsFnsITZynRXfWG0kCQceSH7pmZSJRHvkIGgcN4ndY/vsXbVqtx8B6YYJ9t6hImu8HNIzsjuVAOD3zjGGmIBTUkSRX+G5b7XHZT0N/vKB12W8HKd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789025197; c=relaxed/simple;
	bh=dVjw4ljiCFw+ESWsURmLdu8hWv/DpVWzvl8Lc62Ew7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QVFg/bIqKLTZjc++RfrNEgX9Ibqzq8fZKHA26G2RVSh9korx7+PcwIQPG1GF7PPJTO9n4cXOG5r/ANWp0ZaI4IXNq+l5acTrtxWTD01cFPMP+vMs2/peuqG6nHPYqew7LNSo/OkTBnY78nKntGRZjaclUM574usNpv+LmalXj8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=suHkh6UL; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="suHkh6UL"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-857ff9fef54so66253577b3.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 00:26:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789025192; cv=none;
        d=google.com; s=arc-20260327;
        b=M+ZGoD5Sj5d+lccHX2eEV/idezTr7f3dcH9we3Kh69eKsp1HXJAIbIcga405hsVc9O
         zxnFLMkUqIsBNV97WC8UvT/43uoV9nTirRpwklMSYUECB3zyGPOUW3U2wHpTpAM7uEqw
         +gC0dzzTvk/U6UBziJ8ivGHRNoQIxlvoXk43fX9AlrdwKEGXtz4Vxn39a13KhLusL5Nl
         gqyW9g/S+j6tUq/2dUkAaDhz1YHmXe13tTWEsT2uxYxqhgKO/YiYVqEyjaUdLeplwaot
         Zz0aQDA7XJTWKvmtf9lUe0+qqV6EhSEzguOzVBjPluhd2ybWmmmap0wDMFG51MpOgB2j
         Yoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/vXglpmyQqtm2vQGfMHWvnjy2MGvK+hpILt4Bijo3TU=;
        fh=/6MfcJwdDrIJQwNZ2olwHjTdGtRQmR479/qnz1ghsxo=;
        b=IeFQmxvDNZcd4ML+QggUiFbOHHKcV586igtmu/f8U9MY5aN1CIXpzO9M+yDcCT8xJh
         aj4lkGHnV/k0MEm6N1ROUtmFFMQSPi+sUfovQUQnFCoM50QBUJn7FftvaNwCzFrBVRR2
         s45KJ/v/ZIJx1zvHe3u89fkjxiJe/LLdqHBhaykc+q3L3ikNds80zM9kSd9XRLu/objP
         emEqN2Yum893nVvwSvm+CcDbALhCX0QU8M9d9XG5dng/DrzscPo3ITV4Ah+AQ2ZKfJN7
         noE8bPgIWVjC+HDMQpZpf5ypqIPp1e2cI2y3wmB6oEj8eLk5fCIYIzmgkgDazO/beOlj
         QuaQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789025192; x=1789629992; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXglpmyQqtm2vQGfMHWvnjy2MGvK+hpILt4Bijo3TU=;
        b=suHkh6ULwnDEWuDq436Z0xkKK71gJkFK5kmNpji9DlmfxQ5sg6C3wx1SaMmP/hGw9r
         nMzsMW3AJhSurvDdseK61b388tLYVv/KE1m8IVKsI+cCEe0LjMhWqdlNjE7heQ1CvMPX
         2iDyssSW8uJoF1oYtyIjgzL64c7gwbna6Is3NmFQVRnTogqO6vIme6ZQvBxqRhsgne11
         T3RBsGh6Rc3859z5Cqk64eMxHkhCATZn/B2eu4/zZBIYgzkhQbNXI/vHhW0WXJcFhA0u
         KdxakDtzeD2BwwLbkXKsjpeoTbZkpD/G6+ATxRurL6Tlb8mFv+j3Q1GkoXNk+8dl3o+L
         BV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789025192; x=1789629992;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXglpmyQqtm2vQGfMHWvnjy2MGvK+hpILt4Bijo3TU=;
        b=IDKOAptdeBTtzWvhhFY/ESj445PBLjFzCAzv+URFkHt6APlClFHBWyaztoWxGXIz41
         de5NgiCCFPrnhvq6hz/DS7LSqpT/trJ8DPPqeGxDWcFvbTMyUJUB0W2hKvusQU0LZD9W
         xXyRA0V73FsbDfY4ABZjazZ/Fbe46ZtEk+lzbeMTT5yYZ7PxkuhkAG3Wv4pws2YK1EY3
         tz1kxiSc7+0NNDfhYQCentwWiwLCsNr13focuKWy9qpIhmMoU8nkVVMt/b4nCi8Z99eu
         TcX2cCtxQyywbHpwoLn7P64WUQ8yNXZv6+kdyFzw7nkC1scq9CO5cQ8aTQ+mU59tA7rf
         Myiw==
X-Gm-Message-State: AFuF++lhjXFZx4bYlGmTKEzZWSi1AVBqc+X9SNnQvPTJZeG315cHXacZ
	TmDLd75S2ySO0vxigJDBklVRQxiJzSK5LkbxIQJpWsXzievhl0MuH3KMJMrj5wSC3gJyX0avZHX
	oO8LXBH9VVMwDUjS5AeiU4ilgtaA45XtNS1NhQZp3
X-Gm-Gg: AYBFou2FxxA0svyenmW/wEx0tt780lHjsE+/SFpB0JZofqbMw3rQT1OspVc6R6Sn1/b
	7rkOOYT80kurodP0Jt1ZUXhg8QMhKnnPrwR+ercNPDTaXLQGksJYyUWGcajwD4GpAmFnaMiqIOF
	TOdtusszr1+NRuafNtStqzy9QKdKFj0ZMGfzelNkWVERYhBYrNafLDwNz+oTZGCC2IoJEqv3dBz
	cNfYB1C1Up2mpFHSPLMsVESYEf/9G1WHEUryZVQuqJS/9qt4W97/Ft9M8wdPNkmZhDjRroVGhFX
	FJ2XkKII2VQ1KQlWWMNzYAuSOP1Iu0Bu5sGRVkh+N1JIoCx55TuLRPnTa+XG6VYrBpuykBstnIS
	wxJfibD35ILDSO1ItAcoCdUCWxtNjpIqZ23jCs4xgOdrgNq53OnBwXcwTQzrjT47hQb66oGdw65
	3oLQxHsMmAwX16MRRhqrL4cfSrCDUh8Ocw58yYzLhTUxbw8fdQ7aocGGnSOTRRtNF+zF47h0DIy
	C2RR3+ReGkgwOXrYE77ih2rnaHr7d2hnM2TkNSd1SVyQkJHIxFbHJCyFcJHmV0im/fXEH1Y6Z1b
	rk0LWXewt8FKWm9WMtK+e5PV
X-Received: by 2002:a05:690c:e28a:10b0:873:5bb2:6c0a with SMTP id
 00721157ae682-8735bb26e53mr93150277b3.52.1789025191861; Thu, 10 Sep 2026
 00:26:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910071838.1983652-1-julius@bairaktaris.de>
In-Reply-To: <20260910071838.1983652-1-julius@bairaktaris.de>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Thu, 10 Sep 2026 07:25:56 +0000
X-Gm-Features: AcwNN1WlZOuuaCW-CiTDQ_naRpa8Ngn8cqeQa6DliN7h_89pveR3c7oHeLWNBjo
Message-ID: <CAC1t37+f7+CJ+kBSe25g31fMWE65hme1m1gvB7ZZ_Ydvmce4vQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: ath11k: request firmware-2.bin directly
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

This doesn't change functionality, but log lines like

    Could not find firmware /lib/firmware/ath11k/IPQ8074/hw2.0/firmware-2.bin

confuse the average user.

linux-firmware does not ship firmware-2.bin for IPQ5424. I don't have the
hardware, so the fix would be unverified there. Would you like the same
change for ath12k?

Julius

Am Do., 10. Sept. 2026 um 07:18 Uhr schrieb Julius Bairaktaris
<julius@bairaktaris.de>:
>
> ath11k treats firmware-2.bin as optional and falls back to API 1 when
> the file is not present. Request it with request_firmware_direct(),
> which does not fall back to the userspace firmware helper.
>
> Closes: https://github.com/openwrt/openwrt/issues/24743
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
> ---
>  drivers/net/wireless/ath/ath11k/fw.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/fw.c b/drivers/net/wireless/ath/ath11k/fw.c
> index ef1b4c81843a..88ec2ffd9f00 100644
> --- a/drivers/net/wireless/ath/ath11k/fw.c
> +++ b/drivers/net/wireless/ath/ath11k/fw.c
> @@ -16,10 +16,12 @@ static int ath11k_fw_request_firmware_api_n(struct ath11k_base *ab,
>         struct ath11k_fw_ie *hdr;
>         const u8 *data;
>         __le32 *timestamp;
> +       char path[100];
>
> -       ab->fw.fw = ath11k_core_firmware_request(ab, name);
> -       if (IS_ERR(ab->fw.fw)) {
> -               ret = PTR_ERR(ab->fw.fw);
> +       ath11k_core_create_firmware_path(ab, name, path, sizeof(path));
> +
> +       ret = request_firmware_direct(&ab->fw.fw, path, ab->dev);
> +       if (ret) {
>                 ath11k_dbg(ab, ATH11K_DBG_BOOT, "failed to load %s: %d\n", name, ret);
>                 ab->fw.fw = NULL;
>                 return ret;
> --
> 2.53.0
>
