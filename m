Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67E44AB60
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517500; cv=none; b=WpYuQIMMaZXzGYvXhEM+ELwH3yVOMNVWINp2y6p5YnkXgEGc4T0nuVA4qM5TddX1nDYN9G48hbuKl+LxFLUnS8WJLgX2pe2sD99gyB5Jh6GSI6mHQ0jD75ASRATYUNDXnlEEJZkZtZ/MXC5ueAktsJg9hxsLMtTJ7GUP4Z/iY/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517500; c=relaxed/simple;
	bh=8G22stH9+mabi49WnBtjC7Xjo+sg3VNSjxd7j6C5NtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uvlhXa/TSqVsIqVHenlqxFL02UwOEcXAoZtBXZ0ZUFVM0PQNhSUfa58PZIrY7tq5dFT45GxXEkM8i1scJXxtsxCa9eYSxK3fFJal6lVFiutEm9dSPgHkW8TgnoHH4h+w9TGknZ56NW8FLXzF95gHc/vvCXtAvb6HX+upGujPmgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUljHUD/; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUljHUD/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69ea0595598so1531226a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 10:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785517497; x=1786122297; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K/G26UF84bxEx5MK97aH+lyUa5pLQNuqoVNWR4lJkkc=;
        b=aUljHUD/wEe/QAPDbdYyeq09TxlO4Gf/dNKcK/bzxWxsqzNkPYN0ZXNXx6zhEb1nYE
         t6dBforRIM7rw+/sOnUzb8Ps3dGvczK6DNrrmQxtBrZlDrJaB5lfoIia81Wv+xFR9MIb
         9JuslFFoKTzikAJGmBPR8t8q7RRxEqy2NCY6cqaMKd/pZQ8IQWe/B4DVeqmM+AcmyemY
         kn8f5eFTTo/YZJw0IMSmAU96gUWUxB9WYXQQR6Zldg8lgs0JF/p6KrLI7+birnTa2rcI
         BCRCaDpjDyz1ZMWUrR7UeXMTSYOosKmQOv4MlcsQuKiDYILZ/Am7FniOOFY3E2kFke/Y
         QUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785517497; x=1786122297;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K/G26UF84bxEx5MK97aH+lyUa5pLQNuqoVNWR4lJkkc=;
        b=EjlULSBxTcDnOyd+prVkJx6/Ti8iPUPWGAOIZhVzofzT826ZqqdMwIKZ8N5ebgwK/A
         xe6OQpblT/ZO91CBPW7RWohBdg0CzBznCh69Xxo7uzYA6BdhqvhfhfNoz/Z8eE5WTSR6
         lKXdtRnduLcweXo5PoiBFv02hHg1m+mxz89nepu2zmcm/ZSPC8yvmbgMUDlFxAuaeipP
         p2kW9g6+FnLMggm76QISg1IESAc1jX64o5oOmA2qGsm2z9jEGzHgl+xacAyLbIUIbDXH
         GiegFKKZXlb1FpbqJKcfaeY4cbqncvAWNpB+pOMvrcqMLYvf6yLIQ0S3wO1SII7O/of3
         XlTA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9rYDETeqFT1yNcUVWSrtuS9/6aAnWkVWP8ePxOJhn8aNEbNJibkohS9fufDT6AOZJYthzwL3ax4ilAqSjMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe2X5WbzH5xH0gZAR5a+SPHxT0Z15KwqqnI++vYTsOdOKzfXeL
	EEuqikumA56UJ4ZZ6R2RTibKK+E1C1/1RxFdtlRqNrN6ZA+f2Dv0m/8x
X-Gm-Gg: AR+sD12ZklEhSPxmfQSYXmEe4LPAThx7wP5XvYEKr0z91yqVG6JCjGeJ/G5SeKbw3RD
	WuTO9NGO2+jaAvsRBH9iWWx2uh6fuep4QTaQyMC4U3z+BtIxZVQWtqjV1B9hXB4QvRbTSY9TMRo
	5IvvZMQWQdx0TMkz+i8jzcz4xpfFvz7l+FstQZWRs9V4wng/j0KXRYbSIGibpvqH+t8gKPmCUzw
	ynoXFUITS6kfbh+hZ3DHjzmaKtznDvpVmeL8d/fc2nGPdfRJq/DJuTaLhqu0d8abpsN9QZ1TO39
	umin5QoazDVKM5YBI+5ussD7dFlz9aJlmP39cQjT0MrnCpsTt70nLRxu7lKWqARsZjRaox8bOR+
	RT78fVtcni5NfWVZyXhmS/CbrTmsodriFbC04QtfD3xXJ6TER5IeLWdwRQSeC24PuzclQpFzov/
	WufUUg2e8Gt6nYVQ/edhvI6/rAEnGaYutwLlq8gyScN0GPMHSSBKr7ICCLe6GQWzXac4UD1YelG
	i6qYO76
X-Received: by 2002:a05:6402:44da:b0:69a:b38d:403c with SMTP id 4fb4d7f45d1cf-6a0a7c6b782mr264208a12.7.1785517496865;
        Fri, 31 Jul 2026 10:04:56 -0700 (PDT)
Received: from debian.local ([2a0a:ef40:e13:1601:a8d:2d:6c37:dbbd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd456a6besm6602316f8f.22.2026.07.31.10.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 10:04:56 -0700 (PDT)
Date: Fri, 31 Jul 2026 18:04:54 +0100
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: emmanuel.grumbach@intel.com
Cc: johannes.berg@intel.com, miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org, regressions@lists.linux.dev
Subject: [REGRESSION] iwlwifi IO_PAGE_FAULT and Master Disable Timed Out
Message-ID: <amzVtgQb2p-_nShU@debian.local>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

0eaa1f245ac0 ("wifi: iwlwifi: mvm: don't support the reset handshake for
old firmwares") introduced an intermittent boot regression on my laptop:

[   15.974991] iwlwifi 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000a address=0xbe9f5000 flags=0x0000]
[   15.976184] iwlwifi 0000:01:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x000a address=0xbe9f5400 flags=0x0000]
[   15.978501] iwlwifi 0000:01:00.0: Master Disable Timed Out, 100 usec

The commit only contains:

+       /* Those firmware versions claim to support the fw_reset_handshake
+        * but they are buggy.
+        */
+       if (IWL_UCODE_MAJOR(mvm->fw->ucode_ver) <= 77)
+               trans->conf.fw_reset_handshake = false;

The if condition is evaluating true on my laptop despite using firmware
ty-a0-gf-a0-89.ucode. So I suspect this is not the correct way to check
the firmware version?

Also comment #21 on bugzilla.kernel.org bug #220600 (which this commit
was supposed to fix) reports the same "Master Disable Timed Out" error
(although no IO_PAGE_FAULTS, probably the bad memory access is not
caught without iommu=strict).

#regzbot introduced: 0eaa1f245ac03ed0c6394159360532726f666811
