Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353DC28C5B1
	for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783784027; cv=none; b=efS56qHtNiy04PDj1kGpEl5QstkhgbHQY7TG1Rv9n6+QHNldStpjVa8tAyExOFRr03BYiaIF+gH7tn7PwbdnLKoxNhsw8/d8x5o87aO4f/lTriVaPa9OOkq1Mwcsn8qwJl+EOofsRQxmjSnNMzbiCFz8nex1TvK6Qm/s8X3+zUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783784027; c=relaxed/simple;
	bh=klSAWJ+LyVat8IJ5fTR83Bg1CYUQhCsmSF+iDHUXRZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKy4C3Hf/VGlqP4vo1ETK6HhZYahp0W9Fb69i44SFsU3tO6ZTkVbmi2ZZEKdV8U8ySD6h8kJJksWuSQQhfFYFJ+tA9+yaKuUbYRZa/55ZZVF2N2JlSo4DlLug6+/QEWhqS+2dZKP615niJs26ujOeZTLApeTWYXT4cqiz4sw2f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jd1JKdll; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jd1JKdll"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caed617615so18711975ad.3
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2026 08:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783784024; x=1784388824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=klSAWJ+LyVat8IJ5fTR83Bg1CYUQhCsmSF+iDHUXRZU=;
        b=jd1JKdlloGUMn8vHrxVB5LQSyZAcJ1UXRkqvOtoxUePYEhLIIaNy63IDzqiNH14tGo
         f7wGPEb9hrR8+mBlB8OCdJ/2arSPjbUyqyWRabe92hGZli1bBjJkj040mmf+8jufJlHi
         /dBzpZK+RWt6rgk2puwocmbTjmn2bxAYVRhcMrbdPuk9On0tUoHShR2ZwcO9S06jno3F
         2U+wUxhnbr8CGO3BggI+Nl3bjR9eYkHjMMNiwCFQsEGut0z1jNb9VPq7f+tq49KcDVpu
         QXz19kmVr06Tpj1Eecf/9CMEkr3LgpshcBXSf/y7M08iuRpVcfP+4b8tAO7exCf0TL3a
         5vfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783784024; x=1784388824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=klSAWJ+LyVat8IJ5fTR83Bg1CYUQhCsmSF+iDHUXRZU=;
        b=Yt/Ovcpr2XDh0ztM0jvmEGYxcHUA6pZINkuOUxa56Gxi29iSqqzoUTD9NBnDvpoMOG
         ZnlTmiShi7v6y1nWcvb6yHZ3/LZM5FFYAhlfeYGPxH2GClehJCGfZUJyY46JSGOLbjjd
         nPx0UG1s8SM0rLOMTlo8hXi1dcLhFCeNo80yAfx5B0y7LFOHNri97yhx5rvwaCBt8KC6
         3Y47mi+CxAiqfSTVH1KTlDaS2wtKtXOraekr0xmmNkIxFz/SVZrWICQalkBKp3OJyy/P
         V8MdwZzreRbbIP7Au9mUwhrU15AINHd8d92Y8gnkJlauH7uCC8TojZDVeu8JGUJ62lve
         GnPA==
X-Forwarded-Encrypted: i=1; AHgh+RqSbETngAl29/Q0KmDHDi9jpnGE7Mq1xWOQ/FxKcv7loLJB5DrqunfmGcF2PdfDaVkxVpoFazKUe0jSK3g6vA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOBRdY7EBjp+mIzsTOuiPfBtGJzyxkJSWDkl/M4OGbHiaO3mFD
	PK87GQ0w7Q2lR4v1Gw6ctnpAsD/K9vNM3etIeLy4BZ2eYLrNAVugjE8bsWgoiPJX
X-Gm-Gg: AfdE7cmp0GhqjeE9mwfGRjnLr8j+KwySS1XtFG5CEW6107R+uaAAcG1d2+kMZfdfw7v
	hEozWyABsgI9HoLPY7TOevprd9PyQQyODjREDRTeTcLzE2Nv2af9UXD2se3WwPrNUP0ka2z5w8U
	q7Rt9ysvDVgWEqHwC3WYMdMjgfejmPqU6Xak/6a0gpTA+eJNdgNVeMF9rlL3Q5/7UItcyqNTsmi
	+oe/M/5FIXVo17rPocPjfkgF6pbB3CUV+y9hUEepk4250XxDde6A48hfA8Ldxft7PerfScyzurA
	9OO1qKP6QhIzGxCyOGXWiuRPSawgIhtEl8TCoyLZNr+qXogrLPCHamHpi/RJmiCAEF4+neW4ngK
	/vom4YuYfMDE9jD5ZfQ219QwVoa1b4g96MVe/GkPXbHdCOqVpt/ws1WL36l9/2iTX+RSVolekkH
	iWOdjakhqrvzhnfbP+fPG2FglPVy2GS07zIz/3Rm9iT57jjYVY8FR8M6nKXfUJlqvk
X-Received: by 2002:a17:903:b08:b0:2c6:a172:55a6 with SMTP id d9443c01a7336-2ce9e7a5d20mr32200805ad.9.1783784024060;
        Sat, 11 Jul 2026 08:33:44 -0700 (PDT)
Received: from DESKTOP-VNSSJ2S.lan (59-127-145-64.hinet-ip.hinet.net. [59.127.145.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ce95e001b1sm18256645ad.66.2026.07.11.08.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 08:33:43 -0700 (PDT)
From: Zhi-Jun You <hujy652@gmail.com>
To: jtornosm@redhat.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	hujy652@gmail.com
Subject: [PATCH 1/2] wifi: ath11k: implement custom wake_tx_queue with flow control
Date: Sat, 11 Jul 2026 23:33:36 +0800
Message-ID: <20260711153336.542-1-hujy652@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710155443.1761760-2-jtornosm@redhat.com>
References: <20260710155443.1761760-2-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jose,

In wake_tx_queue:
ring_id = txq->ac % ar->ab->hw_params.hal_params->num_tx_rings;

In ath11k_dp_tx which is called by ath11k_mac_op_tx:
ring_selector = ab->hw_params.hw_ops->get_ring_selector(skb);
ti.ring_id = ring_selector % num_tx_rings;

Are you sure ring_id will be the same?
Also mgmt frames use a different path.

Best regards,
Zhi-Jun
