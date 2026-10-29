Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793253151;
	b=0mcPxS5ezDNOaH+6oVHIYgw0yc3lipH2puGBrrJUGp5DxJV23k4OLDH/aWqkPL1DXcBb
	 GvMzHbDx834x9TgdYL3L7kvXs8N7Zmu5lM8cIAIfx1fqymoRVD1bQxMlZAhPDrlPVbMPv
	 +mcj2psUIc9g8RR5dH+VCgS+9I7aWkdS+ZXrFkWhSvNZ/3yKPdj6vbplFtEIiY1W47ARm
	 Kjg5rHzjIuMk7tLRupKZzTEeAFdVUe5021k/ApDrv+FRyeDuYWufk1KHouEZhspJBMUic
	 uaKfHG7i01nSZ6EO2ZFgHdX/S/6s+N238l9qPNeNQpl9CfgU9QmkPe7zf7hSbPGCDWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793253151;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=WqggUXWKGj67wxLykAgTEJFP8RRDv099Z247PGa1WfE=;
	b=V6W/QNMAQ04CboLM/nGU0gtuuBqA3xInmpQl1uCpfcZMpYIBgdPFBH34s9Un1TUOaPYN
	 /+5SrvBxaiIKOUGcEQ4DWRAQuSb4KQpS1aGEaFL656MP7am5TpXrjIc8SH0ltIFBcntiG
	 0OpPX7STJ0BUFg4C3AmWiGq9E5jolVBSfS9MNFgn7gj+R2NCvrwfFnppjCGPHYIPFPYkx
	 4DpaQ3XVHMUSEPAeQDdkDixolH0aLIfC/iLVDU0bOka51xeQnE4HJ87Irvg9lTP3BySYH
	 3ohSmofDAT98f9b/jUEd+BERQErhQvFZ4NzDBl/5SWmAh/PNqprNGywtBQDKBy+Lp6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PfZmAWG+;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA15B606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 05:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA15B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PfZmAWG+
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-881269371acso175694b3a.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 22:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793253150; x=1793857950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WqggUXWKGj67wxLykAgTEJFP8RRDv099Z247PGa1WfE=;
        b=PfZmAWG+5ALiWwip8dAh1peEUdRsIuF67ht6GN5eLlmgJt60Kq7HoeW73aMhPxTqKV
         MNn2fLwRlnFvkHUP9vwizBHQWorccL1kdaop5GV02ilZs0YKTLNmV8TG0PpqhGkAoQNl
         KWe2pbUIOktNK7KgM1fMxUpKzkLVa3hayuVjsA3Xk+jTWy+HWKXHJZ9F7I0KdtA22Sqa
         6+8Res+tuC2QD4697KgJcvz03l/7KdQykpYEdNvEf07kBNDRtuSiXkskZDXi9YbWYJGu
         ZYvmile3xr+dfijCecqgyx2gmvfyUSotKVskZq7zHioAcDkSzoQiS+MqPZclq8nkG2XS
         mBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793253150; x=1793857950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WqggUXWKGj67wxLykAgTEJFP8RRDv099Z247PGa1WfE=;
        b=gQbrWniPJv7fMmPukEcJtosCEdyGtoxBWWPFrx3TT3Ps+XVWvsFAGrhgwwz5f/NcUW
         fGyW5vA9vrDuu0hX0ZtLDJYNbGpH3+1j7Qu0swq+E8j2HskENxBECHif1k8nwy5tUKkI
         vzXRBJcRotwnoYxMsFjAolhF6Z4HdsZqCLyclcoxra1dYvJBxxhEoqAyTfrdXCVii/af
         IAfBuexK4o4YtfBfFnv0X4pktvi0TMRfJKEBNV+43oGMgGWaEDPhngvQzH+3CzgeknP6
         aH4T+oyqM7pxp1iZDT/faUa1JeWlKFOOPNvNYrmEFedXDeqiTn5pyS0gfJyrPmoyz3H8
         9JZw==
X-Gm-Message-State: AFq9FYL51Zrs8Ki7yK0yTaS4hH2ajjrWv1sAgtqcFsgye3FJ0rkjRgP7
	PoKwmJQ/1dA3iYBb71wC1iqF+p13B3PIistHw8fsuiIMvoYsSCO2zmJd
X-Gm-Gg: AYBFou1w0mOm6VGL7lqs6/2wTKCkWLqLSHsgT6OUp9BMzgEThA+5bz+LBRHuQcCypS8
	hxIPnIx6fIksCJB/z0ru9NPoHkKW2XWIG2qQ3NXFKbM4lCvyeAIHOpaonRoXcu3gUMvh6qfBQPt
	4xd4Vf9geX1TFcxGX60ah/WPsHkzZckpAsUMsVe+BwsdwNOzyqR5+NBNB+fZIVe6zCBinqq1SOB
	xckO7OnyyBsUUlnT6knw8H11xNfthw3PkCLQKNrBOayALCyEz33cJB2bYjOj1GNSfsmaH7dTJpb
	P4rbeYg6FQLtwcZiAoTN4Gn7a2pdxB8YJ90TbLz1B4SpLxQO7LcXMULCNTp9nWPLGqFWGdMm1Az
	9BkCFGPjLEgKdbCJ2Cc5lGSmZcsFFg/4MbaKk3oDhs9pkF2UdQPnoOpSDtXIycqBxbIeK9dWTW9
	gpm6JcPtd5+tMPHZxTpyUYFntp7fjB+42j7/lmvL/CClEa8vCO3QZycVdSzo4HpE0yVIrHEO2Tp
	+fq1Sn7xTnISH2Ygb3z11TWtgra1HihkQZ9+4314FN2P18TN61F1JLIxN/iSmVEfq3dqZIdoy1B
	imCFMxpG6XN7Ni7rRCypuwlXcqQlI52N9YrWHiBMn8zHDz80tv6jcuwhncyDnZfZH+0i0g6wcAa
	vhKsQ
X-Received: by 2002:a17:90b:1d0a:b0:3a4:7195:ecba with SMTP id 98e67ed59e1d1-3ae6ed2b1dcmr775956a91.20.1793253150072;
        Wed, 28 Oct 2026 22:52:30 -0700 (PDT)
Received: from hostname.tail4fb79.ts.net ([2401:7400:c804:b668:65cc:625f:9c43:1e88])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2523531a91.0.2026.10.28.22.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 22:52:29 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH 0/6] wifi: rtw88: extend 88xxA support
Date: Thu, 29 Oct 2026 13:52:02 +0800
Message-ID: <20261029055212.84711-1-hjf3108@gmail.com>
X-Mailer: git-send-email 2.55.0
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

This series enables HT STBC transmission, VHT SU beamformed reception,
carrier-frequency-offset correction and adaptivity on supported
88xxA devices.

Tested on RTL8812AU together with the driver-frame series.
TX went from 136.0 to 144.2.
RX went from 215.5 to 249.2.

Ho Jie Feng (6):
  wifi: rtw88: 8812a, 8814a: enable STBC for HT transmissions
  wifi: rtw88: 88xxa: receive VHT SU beamformed transmissions
  wifi: rtw88: prepare frequency-offset correction for more chips
  wifi: rtw88: 88xxa: correct carrier-frequency offset
  wifi: rtw88: 88xxa: adapt channel sensing to receiver gain
  wifi: rtw88: 8812a, 8821a: respect peer A-MPDU size limits

 drivers/net/wireless/realtek/rtw88/bf.h       |   2 +
 drivers/net/wireless/realtek/rtw88/main.c     |  14 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   1 +
 drivers/net/wireless/realtek/rtw88/phy.c      | 109 +++++++-
 drivers/net/wireless/realtek/rtw88/phy.h      |   2 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |  25 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c |  68 ++++-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |  24 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 100 +-------
 drivers/net/wireless/realtek/rtw88/rtw8822c.h |   3 -
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 232 +++++++++++++++++-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h |   8 +
 13 files changed, 465 insertions(+), 124 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

