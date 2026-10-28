Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793162493;
	b=gdyIytHueMumkHzjSBmITF9z/E5NvysA5tvbNVxvXMyCpBwNR92obqv2w9Ip6/Yu0T1h
	 FdCWfFZmp300S8hpJOmWwD4oeu6v+WReNvNseCJuwYJ3zOWGkLQYnze3ntptcrWL/XfKw
	 H8IW83x30jy+lj1f+HO0QqwP4m48yGmi6cqTe45XPgvMx3VlPxQf9S3pFQV/Gii3CdTK5
	 E/FE7z+DCzq43HGOS+Lt/cExzR/yIy+wqVtlZchrUxSyF05fNfb+fi2VHATM1NLfVxQqO
	 uasCUwjjSobGyd/o8SROTKWP/MnFlhfXIHSlwIi4CmJjtNsbQaehDxzyElhhxyqdFZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793162493;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=CK6bAj4fyaubv/sz1v4G+a/N14rm2U0txFX5ajSiJT8=;
	b=JSI+AMPFEMtHHEi20vcHwst7RIrT/S6XINpTuCRV1LQtSCTTUuMe/nMguc/8dJnWcDst
	 LrwRwLtriZlLXBB0Tsqb6mYcnl2E4B6VtTsbsOeZ+Cx1KQgBsPuDbenyDageaRiqDA7bs
	 zNYgDPg0LhDbccYJLycxuB5ytVY5PWOVBcH+p3d9JyDiJwzmz84yO076T8Ae2NtfwcPXx
	 jac0xzDq9iWT2zoyY++SN44g4H/aBTPVR+FVw70p70L5jX+dtjEY3VnJ+9VfVkMqBo0g3
	 TIS55tqzk7okEDaqtQgMj1lbsxt649Xkq7F90GoCPrel2oCpvKl5FNlZwHOo2+wYUWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=morsemicro.com;
	spf=pass smtp.mailfrom=morsemicro.com;
	dkim=pass header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lvaJCICb;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263A606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 04:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8263A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=morsemicro-com.20260707.gappssmtp.com header.i=@morsemicro-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lvaJCICb
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a05b210703so267731b3a.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 21:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20260707.gappssmtp.com; s=20260707; t=1793162492; x=1793767292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CK6bAj4fyaubv/sz1v4G+a/N14rm2U0txFX5ajSiJT8=;
        b=lvaJCICbdjUWgnp3WZLnVorrc6ct+z3WGAniweA7RMM7OkfUk/pI7bmnILGY204mE2
         N+sStFN20CP2ZBe4KmX1DeXIeDweoxGQCEXbaDeRzd7TIdG84vo3IzW8IdhU7xdt8vsf
         weypZ0tVYZlNuw9m1ODe+Nbg5JVBQpfjbSBSD4lKgUX6s9Xq90rL8NEYOSbOFOS/CWmC
         Jv9CkEdWzB2Y3I2atk1h0TrlDWLDYEv7WmRKTTZNxmnaasFbtBGDRh6vRxCUHd3sViS1
         ItViezPzuPX9hA+kSrenMgqpB0v5AWF+q5oO/Cb8gKr+hUthUrnWtaVq0gqcf+V3I8cP
         ZiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793162492; x=1793767292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CK6bAj4fyaubv/sz1v4G+a/N14rm2U0txFX5ajSiJT8=;
        b=xALbMYKhI7J5g1hCogKh7lVxfWEQdCDvYQuOov87chzVj2Q/VPOW36jeKYqLgPesiC
         hO1jRkuwVGbAYl+OAVJ4+bH+8TboDZLPgHCCQKrBv6eG77d+d8fqQPyGea4mpebZMLjh
         IpW6NJlsKJ/LP/3xhpP7V8Ldj/EYfJS5YW1U2zqlus1IvPVIix1G3do5N+vudsGtAWed
         3pmsCIV42x7J1ePG48ApSPBZ2myYDZoYSpBXhGjiB0kBa69mvixNFbhqZZ2qmWbNPecZ
         QoAVdgcsGCmowQWrtDE/4uRXEI/NX2k53JpdblB8EzAziKVVrIs0B/r47CRlyjIPtZnf
         C8GQ==
X-Gm-Message-State: AFq9FYIyiWkKj4jVsPEN3/131oF6pqEPLsW03DuZUGtUW+2Z9Vc0lLaG
	+gb7QELF1tIWwisNexmPwspBSCxukGea7HV4VPWsKJMdO50X6kh5tD1C2qmiyjR5FuM=
X-Gm-Gg: AYBFou0FJjFHLDqFgicQUaZjQlIt2KmVVhl5wt15ZzMfCd54BlseHFvLRh7ldKZB1NU
	3S5bQZVxAADkWmiZKfD5FVtJVSM3st87w+sTUiJ9/87zrICPKeEEcjt1MUSxwtxbJEWd82kyvKZ
	OU0cn0O+xxVVPnD4XzShHRDG89AZitdKbF9f8pXvtg/AlCiRmOo3BnIzr0K7E7U6NCmHWImZfBu
	KmjFzLI2Tj9R8x36GHPVnQJIP8TD4aOFDEFzPufFvn4rPd1bHb1HgT5gOpwDZOpc+xgdPHq+bA3
	BBileoSnajpI1x8Z3LMNeHFVfNwRnBiWnm/1gYvMWb3FlzAbw1htwQmn9vVYpAa4t09uJ8pNjL7
	t56qY2s82CNcD8K1zpufAYIhzV8hwghAEFWHs9Mkx7XR9ZRajRGihJKFkJEqowYU/sshkYJ9sfk
	hCcsNrHYWGUAIeNUnoUlczRUhFBa9/W6weTEBKqcZgbgvHxYWHDZjaor9/EE7FtAkcFEEAwGBtc
	M4YFDH6nLK1DxpK3IF4brQd56E+ideFQnCUZzsniP/XhXJtybBUJV4Hdq5GTaaoy6P8s7XDsW7Z
	L0pwa2AOu5PiRbdceOLyvZTKUYiEc27hzq0lA6AIpmLOOu/zIEtekV9aqtxXj52ehz59vxoybX1
	gws0Y6IgcYHRuVD767VDCLPEfkFhZMMRKbQ==
X-Received: by 2002:a05:6a20:4323:b0:3e2:97ce:b571 with SMTP id adf61e73a8af0-3e9023d6619mr1191666637.62.1793162491777;
        Tue, 27 Oct 2026 21:41:31 -0700 (PDT)
Received: from mma-H9MHD44.lan (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a6cfc5ccsm630826b3a.40.2026.10.27.21.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 21:41:31 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	arien.judge@morsemicro.com,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>
Subject: [PATCH wireless-next 0/2] wifi: S1G rx frequency fixups
Date: Wed, 28 Oct 2026 15:41:16 +1100
Message-ID: <20261028044118.1422069-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following [1] the approach I think works best is reporting the 1MHz
control frequency while also including a 2MHz bit if it was transmitted
on the 2MHz primary (this allows us to compute the 2MHz center freq
easily). Right now though it's not needed and will be added eventually
for any off channel work like DPP etc. A future firmware version
already actually provides the 1MHz primary index in the rx status so
this works out well anyway and in the future once we add support for
the firmware version will make it easier.

Johannes, I am targetting wireless-next here because even though it's
patch #1 is technically a bug fix, not accounting for the freq offset
doesn't actually make a difference since the base freq is the same.
Though I guess it can't hurt going into wireless for 7.4 ill leave
that up to you. The driver fix will go in to 7.4 on my current tree
which will actually fix 2MHz primaries and make them work again.

lachlan

[1] https://lore.kernel.org/linux-wireless/20261002072954.1168872-1-lachlan.hodges@morsemicro.com/

Lachlan Hodges (2):
  wifi: mac80211: include freq offset when comparing frequencies
  wifi: mac80211: remove ieee80211_rx_beacon_freq_valid

 net/mac80211/mlme.c | 36 ++----------------------------------
 net/mac80211/rx.c   | 17 ++++++++++-------
 2 files changed, 12 insertions(+), 41 deletions(-)

-- 
2.43.0

