Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E1F431A49
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317389; cv=none; b=W0N+ghgLwWTbogJ5nySxVIjBNKdAJaZD1kkzV9+eKAnFHAgq6nAJwWChiTS1ATPBYaVXwGv0sTn+INNKAAJteT58WNN2hit73B8KEgqqNrMZConHVW/xvAcqH9iQ/BHFvirkA2s9/7/3hQUk9qGsKYMmSnkWYhQSVLxXbsUjqGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317389; c=relaxed/simple;
	bh=5WnxcIEaVC0j3CtWI+yiPRs8vygJw8ntQCvpp65dOv4=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=tZkFkCNG8HRrEfWC8+bxEFm+EBg0O4YO9JBJk8tFPX0C8LcWTf2gtF8oJB1C/f0HUhs7Saa/c2V8u8No/y/wYSMNkzz8wif3deNJIwYg9CoVE3fb4HjDUtaJw/oYpz9CTMZBtrGcCTiKyLn1hrpDGSSkB61Ukfz3jqdi04nJX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mboFNZRl; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mboFNZRl"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495635a85d2so5583605e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785317386; x=1785922186; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5WnxcIEaVC0j3CtWI+yiPRs8vygJw8ntQCvpp65dOv4=;
        b=mboFNZRlykl2k+JtSRL2uNwQAaVLQ3XOr1RWQ1WvEHYdlvIP+9qbc8TxbYA+mEMmOq
         2imXHnk+VH8BVMn3dkFhXEexjUi9Dzo7J+3tQryAkwAGoBcvQVjI02p12wbKNBUp6elf
         3R5IHNJG3Hd1Z7rD+p/vuH7voWqzSJ4eq3DIOpQfGvo35RAU+DkfiZVa/AJXQNPkj59Y
         z0TfyceGxkWkfCikzfQgp+sneMeciFw/E1RWFaAlXZjpimWTgJjaRONtFKy8iGy8iTYo
         ApmXkuskEJnEZxMigxMaEcDHODzWfEkLfQ/l9TOd3iyMgbh3u5JbDnWWI31n1Yc5lLnQ
         o2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785317386; x=1785922186;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5WnxcIEaVC0j3CtWI+yiPRs8vygJw8ntQCvpp65dOv4=;
        b=VUONXfhqfWMpQ4Ta9l15xc7c8jQNWOU7X1YOrF5rz5mKuKque2kg/iYi10QiRvocK4
         +47uooK/zfhOLS47M/+yOBVvd45WINMn+y63pmzLjXPShavn6+WpU8ZJsBBUZac91GXQ
         NK+8GCNoPLDhjyab76JHsDnpphjaTZswOC2aV24glqzUkJtGvjYaw3pRr1d1w9irl6qn
         vAQIDkBEkgqRh1xyq3nJpDCWTmTvjrsYMwu2AjcaNgMcE4N863A97b7WKzrYUcHLg9MS
         N/8UAIvqN3zHSgQPX+wIkaikcA8pUAfvyvGCWugPfdnWw0t+7qmF7nPyNdsRVblwtbxS
         Sqgg==
X-Forwarded-Encrypted: i=1; AHgh+RoaQ/GCeFHp4oFEwWmxFXxJvYzLKWyJdWc/C/obG3LYOKul/Az4XQwGNeDidAgh2a8T2sEkzZFM3J2NVDJAIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhT2VwfFdHtErhGqEG1rZnTBbIQCUN31v9oMiSv+OqbjKFGUeL
	0y92P57JXiI86pg8rcFFyLezE+9vGr413pGDSraEdMbJ4lfwvWWAHx6scptADzGq
X-Gm-Gg: AR+sD12gYjy/yWdv/8M1o+IrYW5KTnEUTupbSCwoHy6fSDKtc3JeBWX/uewMf8kvuXD
	kD6X9eHCpjpUmswkPxDob4aGsVuJ2LqC22cUipQ1+QZhbYpSgdcR0vtcgj8BrD9qBC0I8CC+IES
	RXIGEY0SIrnOUljOe2oYvlGrp0rLs16Fnd49xQqL+w1wV5AXbreHktvx+XGWG4Ky2nNHCLOgg0U
	Ss+U5fiS6IDa871TQI2VvfHlKwWyApNq6zqoLQvck+pB+XDR02so0fX8K8SxXgANBACj+bOyeBJ
	BOIF5wWss1flkM6pbDfHdQrXc9ADeXwdj2ERbPxRFc/iJD3DMpSQhIDSfoPws1TdzTN26pWZAEQ
	US6/22S7M2Ddp5TF/T+1NsREqhoDM42+Woqy7a39myPhF/lUe956PBSAraMDi3Px4VAvpwQQpaq
	3UTVLckvVEQdgj8svNXnM3Bw5Zhsa4xkGecqQCZ5nP0reHS7g5ZKIBy1xs9qVO4RZoXyi2obNBx
	gATNxw6HUnxE+nFJ412nsJp95FF
X-Received: by 2002:a05:600c:3b26:b0:495:4fd4:619b with SMTP id 5b1f17b1804b1-496c64151d0mr69763385e9.1.1785317385761;
        Wed, 29 Jul 2026 02:29:45 -0700 (PDT)
Received: from ?IPv6:2001:8a0:c4c6:f00:6d7d:cc54:8605:a888? ([2001:8a0:c4c6:f00:6d7d:cc54:8605:a888])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49764d848edsm43293315e9.4.2026.07.29.02.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:29:45 -0700 (PDT)
Message-ID: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
Subject: ath12k: recommended regulatory country source for embedded AP
 products?
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, Wen Gong <quic_wgong@quicinc.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, Kalle Valo
	 <kvalo@kernel.org>
Date: Wed, 29 Jul 2026 10:29:43 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello,

I'm integrationg the=C2=A0Silex SX-PCEBE module (Qualcomm WCN7850, ath12k) =
on the
ARM-based Toradex Aquila SoM family, using a recent mainline kernel (7.2-rc=
).

Hardware/firmware: wcn7850 hw2.0 (PCI),
WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
(fw_version 0x1103006c).

I'm trying to understand the intended way to set the regulatory country for
ath12k on embedded products where the country is configured by the integrat=
or of
our SoM or at deployment time by the end user.

My current understanding is that ath12k registers the wiphy as self-managed=
, but
userspace regulatory hints, e.g. "iw reg", are ignored in ath12k_reg_notifi=
er()
unless CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS=3Dy, which in turn depends on
CONFIG_CFG80211_CERTIFICATION_ONUS.

The SMBIOS coounty-code path, looks intended for fixed regional SKUs, Howev=
er,
it is not available on our ARM platform.

So, I have 2 related questions:

1 - Is the expected ath12k model for this type of product to enable=20
ATH_REG_DYNAMIC_USER_REG_HINTS and use userspace regulatory hints before
starting hostapd, with the regulatory responsibility on the product/integra=
tor?


Or is there another mechanism you would recomment for this use case?

2 - Since ath12k is a self-managed regulatory device and the firmware owns =
and
enforces the regulatory database, is the CFG80211_CERTIFICATION_ONUS gate
intended to apply to this case as well?

In other words, should a userspace-selected country for a self-managed ath1=
2k
device be treated the same as dynamic user regulatory hints for non-self-ma=
naged
devices, or is this dependency inherited from the common ath regulatory mod=
el?

Without a country, the ath12k falls back to world "00", where 5 GHz AP oper=
ation
is blocked by NO_IR.

Thanks,
Vitor Soares

