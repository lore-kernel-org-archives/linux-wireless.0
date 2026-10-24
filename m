Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792847916;
	b=Xpxxz158OIfOGrcNKkc+DF45aS3Ntztw6ChIlKLzexA6V/wnTN5za/iglTXCp1BbWKVh
	 tNLcJF46ivpK6lvmfz+28xcsD9hwgbAIxWRkJO+NFwk2YEYIHJZqUVnwICGMyjt2+ZTgL
	 CEAkQwz5/V5T6qh+Irx2fcTGUhLaIqsBxHklhXPkUrd06xYpjTAJVRkmPhojwn2z5F2qu
	 Zc4rgpqaPaK1EqsF3ee/00jPt15vm7eyG0R0jTqwcJfRbVTics7UkhhjxoP4UEGd2XCWr
	 8gRDYOnwM2dBK1IEFq3OYXbR21AYezyGNdBiGJyGiSR+yFUVtcpvrgDqS5OSmk0Me6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792847916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=r53zQBd90L9qdkyWqx4Yp32RyLUSfl8WDtc6jDamlsM=;
	b=Z9jTgVCyvZMpbcZfcNQyV0qrlbqjcqZ52UKhbz6WG0Ru371qNzAfxk8aBATCJ+Q/l5Xj
	 IhL/ZAtPdR+z4oLXuTZamd4Fhwmk3gUs07faPQdWXyc4/5fEXSsU774rjrqFop2XrnHlT
	 zUerh+FzO5MOHTLL5kbFHshKRn2QfWz8qjiPT8A708smDQr2PixExspCZsEwG0veaFQ+d
	 yl78p+6MJl0SGABMlp9ELlG8VEK9RhSgBSxV3WEFT/LE5VAjCtbYGp4cqKCJg4i2moWqq
	 MfGmxdC/Cpz33xb+SEVIsi/b4dyJJZ29kHPjkK5FS56k+bz3L1bM05BjPEQnguvgTSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VSvFNyqh;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FDD606A31B
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 13:18:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15FDD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VSvFNyqh
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so2768695a12.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 06:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792847914; x=1793452714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r53zQBd90L9qdkyWqx4Yp32RyLUSfl8WDtc6jDamlsM=;
        b=VSvFNyqhMUeeID/TDzuFbF9AoZ+sHEGSyXve2GFhLKesyMr5IA5cVkmgRSLKKaaR0e
         agkgQf/p/unG7iiN8jrnfTc/hxW4VheXSO6Peulizc6v+ZxKLt+D52hwA3f7/kEzEFSL
         PbX7kOh0xjFYPR/cfRYX/nTYXs7K3UrucU5SD+BDfHKXs9o6z2lZgHLD4mpc0AwLxme1
         BywKhG1NQ6Ce/PMfM3T5hBLr7OCv1DV87fbpnTtSoHu6oXrkCUu0uoamWo/xkcueiiGn
         +q3WdnbQx9TjBf8UjcfWQEx1UTAQ+TwO5a743f+DB+1b6FEmLulHety77WvNW2rvQZUq
         r3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792847914; x=1793452714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r53zQBd90L9qdkyWqx4Yp32RyLUSfl8WDtc6jDamlsM=;
        b=RKPJ4HM6aczhxLgSs2V9Z+J5EGG0K/pbDmdrfwxjc6Nq4nIWrMCxng70CkfBuQgOzM
         A/o/p9C56kYNn4dZtlOwy+kEgvF9XUnWsyFNRynF5G3qCdiX8B5aUUY5jD3AModUoN53
         ug4N+b8PxLpfBG/cCtS+/aJGwGtxOlvp7BkQHEg06IEi0W6A3xrzr/IW2U6npdAW5WAH
         wW0V8z8hUlZsAXKT9UtrcocYmnjiZjlULYLoJXEOpyrFcX4nHN4TZcKzR8MlCiQzt8kk
         A9GGhG/ZfhYSkUuatV6HMCXz7Lk/wSEVmJgrrsEzFdtDhiurgwq0VcdMuonn+d89mU0n
         KIAA==
X-Forwarded-Encrypted: i=1; AKwUvBz/dk9NxqIe/ZncpGTOsyTMU6xLtGP/q9gLlfZtCxKMn3+qFBDXEUFuOEotxPjLIGOuh8BF0Ejx8gGWcr64qg==@vger.kernel.org
X-Gm-Message-State: AFq9FYICHMtoPF5r2H/aL8plpyu6O4GIl5yps6xxs5RYieJw3TTfd6Hj
	k6XumEhF4xvVGUx3sU5xAN96JIBwwHuv1pRWE39CNs3yOMsrjZX8a/XF
X-Gm-Gg: AYBFou3MNgMGzGBnuheqF71WDfA/Xx/XpxCMH78NDtLDN9dGOCcmyITPZFhbKPukH7R
	KU0oyV96LCeD26bH67cXpxyTj9an6iHVcoEcclDh511qlv0bXaqguH4xCpJ0Z4jzIq73rpu3MxA
	d2flLy0X9ZWvLCAXgInfFfTqukVWNpP9UF3LDeqaJbTQhXXY2biR8cErnK4yJ+jMlqVtjbXxfKr
	t3jExM+fwLU+6q01kTmPWhJRaS0VEB5aib9ccYJEL9qV9QuwKCE+y9oJzVspPbs9ejt4O7FcaAE
	/CIJa4ugO+PLPZJHRgnsALUkhME6/L7MCzTkGGEazU+lm34ZjI5CzRynD/oj/fI1/aCQxX7nm7t
	ssiIDSwoALtgzfEqQUV/kiQIIg7veTMos6VdYsHNglpyRf0qp0CzVcnGzfDxkyQZUZDNJtHdNHA
	WSc9trEQii7STpq1MTXw3OISFnTjl0FEolxm8YqCWpQs3quDbplu8SZYlPPBytC+Cg+O+T2ZIV0
	/r5rv03JvWAUAp9W8lKc0eOMqAorW2RCtoKeBvystOKyeGX6KBONUBbRIxwjeMP6eE0RNxuVg==
X-Received: by 2002:a17:907:6e90:b0:c46:8909:963b with SMTP id a640c23a62f3a-c46bddb52camr227292866b.9.1792847914396;
        Sat, 24 Oct 2026 06:18:34 -0700 (PDT)
Received: from localhost.localdomain ([185.65.135.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd6276d8sm87306666b.41.2026.10.24.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 06:18:33 -0700 (PDT)
From: Hedi Ben Hamida <hedihamida096@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org,
	Hedi Ben Hamida <hedihamida096@gmail.com>
Subject: [PATCH v2 0/2] wifi: mt76: mt7921: fix hibernate and suspend resume
Date: Sat, 24 Oct 2026 09:16:51 -0400
Message-ID: <20261024131715.64435-1-hedihamida096@gmail.com>
X-Mailer: git-send-email 2.47.3
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

This series fixes two MT7921/MT7922 power-management resume paths.

Patch 1 adds a dedicated .restore callback for hibernate. Without it the
S4 restore path runs the normal resume sequence and times out waiting for
the HIF suspend MCU handshake.

Patch 2 recovers from the same HIF resume timeout on S3: the firmware does
not return the HIF_CTRL response after D3, so reset the device and report
success instead of failing the resume.

Both were tested on MEDIATEK MT7922 (14c3:7922) on kernel 6.12.113.

v2: add the suspend resume fix; patch 1 is unchanged.


Hedi Ben Hamida (2):
  wifi: mt76: mt7921: add pci restore for hibernate
  wifi: mt76: mt7921: reset on HIF resume timeout

 .../net/wireless/mediatek/mt76/mt7921/pci.c   | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

-- 
2.47.3

