Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B814A619
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 19:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576954; cv=none; b=FEowiA6jrLl+hUhQXo3bU1jBQV+loAxDPOy7RoZ71F9xyCeDtpkrvqXwnlCUFz/I9xH23ZO7IqxRZ6OxNpvEnNlZS1qblevFXZrJ1yPFF7o55dnGyKTaE8a/6hy8v534i+2A+CSQfiywRI3J5H87meqRcpgpq/YIISLQNIuGlF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576954; c=relaxed/simple;
	bh=Q92lWuMn3xKdUx7myg0r7cLEvOzGhk924wJFAIzX4Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrSK+/iR29+yo4PZZFPd37k8GXkCex8AiK7JvsSxwZbpA6k4SupoJNFpljZILP19vOm93McAOO3MfCvpUI+19NtgT7S1h8QYfZQNezGDKe0OaDohgHk9ZFbeqhDm3bKyApRWC0e/7xPjEwa0vN1g3CP+2K2P8GuKf7fcjA2BuvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hZ9LpQNM; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hZ9LpQNM"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-6685483aad2so1711796d50.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576951; x=1785181751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FKqBGdGQQX6H/zEdNMKQSXypwrRgUjHCTJhDmIBT1A8=;
        b=cnKXthnh0ZLMiAXLWl1jR3jVW67Mv+gGdw151J2QKc7B2+kEzOY+Li10thhS9R5iIt
         yTr9xK3t98oCw2PzyCwVYNqcRsB+Z/oKDETZu/ugaQutuBGFXFyqbniMJ8llQUiUCiTG
         /iweZe3CIgAZhpGs+MSp1pQO5b5548vLnaiHGkIn9DGOHZc8GvaLi1ON8FNE9Hbz9ncS
         3quh8LX4dds2OPKGpwWvMhMWLQw0RwErXDVGrr2JVTAwIJPyRd9090TGbgpKA7n4LmiL
         Fm6ozFZgAlFXJYrQcJCaSc3U4Y0MYTQkFDvfcWILfT9Hbe65U1gYl6m/tT/guEtUbP6C
         RhPg==
X-Forwarded-Encrypted: i=1; AHgh+Rpxza7e0HSAZE1mmzBDkH3RWxYuM7UWVX1KPJU4gyVHQHplyN/8sT4qEXa3OrgdYsEHlR+At+oYCYonxPouAA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9ccwV9T7/8S7BIPUoTpY0UPsI7KgCFQvQ0/zlRaF+OhQEytIB
	zoRuPEPWbIEjgNf3pFJdKd/Bf40VRrUVOUNxcK1zVILu3jwBabcss/Wwv+K97Zu5DENi5qt6Oua
	98fpEUjTowPckGQWV7DKhyWPIBu6kL0WuTXBnaK9DB0l+Y1T2oSXdaSNEi0eFR5mtWNfjHsty5a
	ih7/bCzIPNlnJHG1MeLrQt2dPv7anMyiPaFyMW/Utu4f0VBXaCcS12wMb0i85FxZd5qvOgIT1B2
	MJ7xzI0OBWK0eI1BAXLeZXAivnv
X-Gm-Gg: AR+sD10EhAZYIc1/29+aoDH/25k14jFFrtASvKLulQhga64YIutCJwMEs1SSDgzLBOT
	nvkBHi/Mg/NfE4bnAsV/jkvVjAJu95LzQ3yam39KXy3Hgmq9yR5sxrIGxfyWif1nvNBbhybmsSQ
	LNI+xEY4NvRJmrq9B0Yn3tcP2NPeI2nZDljDQe8/z+yUkfOE+IaXAChP9TbeLyeKd82rYdH1npq
	q/e0kasOA3fkWfhbgrwq0/AbGaC7fnqOD9gbRjIXVzMlg6OSm2u8/BXOIFb8janLvSR7+E5kHQM
	3OPx0fXst1Vz9vqZQ4aikjf3FLRIWZ19ADYR7+6qBDp3dHe6vBde44bGZEQDXpzlJW1WWRluElo
	QpAikEnnF1DD7YGitEBZQ94dBECQr0f7aVMzA2lOkJTMH37+QO07ghRYktUOEjBnVQdT9FCUZh2
	KVGMra17Jo1AOPcwSifyba4xDcK2wO47Hwqiz5fRYBlA==
X-Received: by 2002:a05:690e:484e:b0:668:2343:f9a9 with SMTP id 956f58d0204a3-6683bda79f9mr2927120d50.93.1784576951065;
        Mon, 20 Jul 2026 12:49:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6683b55f018sm801364d50.12.2026.07.20.12.49.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 12:49:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15d84e3572so8825866b.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784576949; x=1785181749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FKqBGdGQQX6H/zEdNMKQSXypwrRgUjHCTJhDmIBT1A8=;
        b=hZ9LpQNMVh+HsINRWBVvrIwc3Lpdk2zSKfR0IwFGO7QZEawy2je+Nbsw647unAx/VX
         yA/BeyAnXTotX6QFY1fyxMhlTO/79B2ljv7ds565QoLajQo0LEA0EBNFLZnO/O5x4dI2
         tPx/+3GTbzbMlarVGbesm93Ek8xMJjYq3JOWo=
X-Forwarded-Encrypted: i=1; AHgh+RrETToTeN/XcbNZ2f7ek6GG+r5qsOSqGpPuLrfBxE5X1ZOKIH9G2wMPg39hIfkoTl8aeay5IlZEzk5dXlXzHA==@vger.kernel.org
X-Received: by 2002:a17:907:c896:b0:c12:6ad6:6398 with SMTP id a640c23a62f3a-c16b4854d08mr545723266b.34.1784576949507;
        Mon, 20 Jul 2026 12:49:09 -0700 (PDT)
X-Received: by 2002:a17:907:c896:b0:c12:6ad6:6398 with SMTP id a640c23a62f3a-c16b4854d08mr545721766b.34.1784576949094;
        Mon, 20 Jul 2026 12:49:09 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705912972sm506543066b.14.2026.07.20.12.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:49:07 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: LiangCheng Wang <zaq14760@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Kalle Valo <kvalo@kernel.org>,
	Angus Ainslie <angus@akkea.ca>,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Wig Cheng <onlywig@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: set F2 blocksize to 256 for BCM43752
Date: Mon, 20 Jul 2026 21:49:00 +0200
Message-ID: <20260720194900.2356442-5-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260715-b43752-f2-blksz-v2-1-f9be49856050@gmail.com>
References: <20260715-b43752-f2-blksz-v2-1-f9be49856050@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 15 Jul 2026, LiangCheng Wang wrote:

> [PATCH v2] wifi: brcmfmac: set F2 blocksize to 256 for BCM43752
>
> The BCM43752 is not reliable with the default 512-byte SDIO function 2
> block size ...
>
>  1 file changed, 1 insertion(+)

The stable backport explanation is clear and the "needs adjustments" tag
format is correct. The one-line fix is trivially correct.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> The BCM43751 shares the 43752 firmware handling and F2 watermark case
> and may need the same fix, but I have no 43751 hardware to verify.

I have a number of devices but no BCM43751. If anyone has please try
this change and let us know.

Regards,
Arend
