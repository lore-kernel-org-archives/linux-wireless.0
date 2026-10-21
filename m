Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599626;
	b=J4eJ4bRvSuyJ/t2IEN+5Yt7+R5DHRY2Y58bTr1AERfg1RwMw8/sVR2zZnu0B5oDelgST
	 pspqwZnsE/KvKOYFEe2WPEqVw5MMTIKiVoQvfzwK6+a/6lZGldFAIMHqWEhqpLF+T4v+5
	 Cx3mJImNzdQf6jvaQsGPYXqV7xz3sc+elJjyuipXuvDhk99D2C5PJldj/nJRzt08C8hG4
	 wse3xbA4F6XMISRr8v95tGTdX7xJC4gIWtysGgBknf3eCPTkw/ZYlZU1MC+fuzq/IHRMM
	 EL4/hl0tRHNm3NAlyVVPwAXJkvswrUwtJpNfTsrghpUIpTuyTxwsAiSIxxy5tkobWVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599626;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
	b=i32DkN9q0TwudnBwfnr3K78qwcj2c7eUvPRqIcHuIarEfrqUcmdA5PmZpwCcJUR2dUoe
	 iJXaxomLrjD2DEktUlQosYiT2jBA/mrNBae9t99z5PjcwJOb+06xZp1fDLihjqQwViNyD
	 VhcAz/lq5HoEvnWgTDHttPySPHZZn/hloiUeOXjCVeQ0EfNiJ0pM2npPEc9Eeo7FnU0q5
	 9/bSxMZCPMBSI2uS5dhxc3u5b1DbGP3rXXB6B1izVmMBev+Wfqa5fBLmSGAgtXDvK+7NZ
	 IDwEYtdG+N75G4fEt6SvsID8iZuGpvNDi3fsfl/hO00plc1wEHYcXtSko3mgGW1rXiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=oOaGmDJa;
	arc=none smtp.remote-ip=209.85.208.44
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6363E606AD06
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:20:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6363E606AD06
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=oOaGmDJa
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b1f31c63ebso122262a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792599625; x=1793204425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
        b=oOaGmDJaCariJirE1p4UYpcKw1+r13eouk3htRv7ZUTg1b6QVzB9mWfAkREwpa01jA
         tNp/WtCgElbxAwHC+RDwUpcorxIGw85VKAHl2go1a0K5BMdjA2fdZK4pkgcPZLCow6ul
         bK/QXs2Nigz6aS6frzmLu7xQA2oxQgyYJ8yPpEyq/bdQoQUdwlHgceXEN70KNidWea8b
         yNnjSbq4yLzvvJ8rAkrF+FpWyQiBjOtZzA4iU/s33/CNtQ5E4bhuZAKkJ89Hytjk6cR1
         L0fQCVKD9gGzRxicWuSAVUsZAo3k/N3++Zg+jDjotFxCyrQaEL07kcAEnTB8JvIuPvlM
         gpaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599625; x=1793204425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
        b=Mq7VNjZ7+YO/ZCufnoOaI8kf7PZhqS6LuoTrv/qu8G+6B2Stx13hHQRLyjXhVJhWtH
         Mokf3uXqjltPkQNSKpwixdk4r/Q1rKOF6TgVGvPWUHeYae9y9Q/OUf2hxQ+75GpPMVTW
         RJrrokGHNiufRiz9llafrKWR7CJLjqmG7dXHC6waI+3E+TFfD3ELozVE9CscTIzPShRu
         9EocGN3+x+QMd6O8n05ZU/6uYCWwGC4Yfg+eRaAO1GvxjKNtpvn76p7Oac6LZnZPObfD
         2oMdWiC6ImmFySG1AnGFbGtvCuGLwFGfw5lwZuMT4nFvlJLul9t6zhYrfUX8o0QXUKOq
         cWFw==
X-Forwarded-Encrypted: i=1; AKwUvByAEwmGS8GonSX4mn48cNzeRZxhZJGn0uQ3KZldN7N0t82+8BqmZEF/yGM+w5coucALUbImcAjeZ3N28Ur7Mw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKO6PX7WCUp6LXM7S2zovkkn0cXfYGjMI+MMzrpvuWOrdlwLwUD
	eSbTDhpHlxTXGLIWgrqSpDavhubb5TceM1DHhBw6N/WCOfJvyHe/wZo+BFb7v6dI0g==
X-Gm-Gg: AYBFou2j/Vu5Zq5Gt3Zdh8Miap5r/HqZyU3HEiRwETuA/L1fKGJ7NgDMOd/xPgLWueb
	S2QzCksKzHMYHe4XIrVDO04UaTT0lZLhrg1OXzlfKr9CjDPzp9roPNz18D07Xw5OHeAjhCAQrBW
	6lMerDkx1sG2BnGRI+xVuX19ZZsbrnUZP8cZ3lDpiw8MRFnYFr2x4E6YxA+/ksqtK708RPSSkz2
	YCGkC97uH6t+YIhoDuVJ+V6aPO3HUPxoDB+lsZbI7yq+LguntZfSx5U1dp48AUC3npeznaHfxEn
	QoHKghD5ZF1EaBtJ4zx0OGMRiV9U2I/nbnKZjF3NQz4s6KmTQQDQmWrfLVTq8G0Kxek8W/5FL05
	b1sHBS3w60St/Uypy41ujeUb9ds4w4c09mraAIgX2HDVFMVfHxoBg41sqvgBpn2kDMxLHibpHVH
	VjEkPt82swwjlgeksYntIuXJCcr9V3wDUsvCq8mhpKlVcm1mGv0AdnUr8s8L2vR89r33gRKBNSy
	VANrLBej6zbvEJiv7tceecZw7j+vkZYrx1lbOAP3nzPKGIr0G+x06HLUx2AzRWSLfjMb/FMmD1d
	g4qz/1c7kk8fxdM9zjNkV0Gf0quVNTJThdzEZCrg+BgNcg+hURIHhWwY1sPQfpYVBLAWfTtEYvD
	81rBoqWJFHLbL+T2TVwkwkbJFpSugt9sb9QnKFlVMh5zJ8zbj+Gg8Q63mAb2oq3CW4jev52x9I7
	bcPz/UhBIqAJ0mUXmGhz27r/YTakdPA5v052fLGhrMjm3H82d75kSI2Jw4jDZxfeXSKwDalY3Se
	WxPSVY=
X-Received: by 2002:a17:906:9f86:b0:c36:777f:824c with SMTP id a640c23a62f3a-c4600c81c46mr477496066b.4.1792599624671;
        Wed, 21 Oct 2026 09:20:24 -0700 (PDT)
Received: from Desktop (pd9513e2d.dip0.t-ipconnect.de. [217.81.62.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5625cesm17445766b.39.2026.10.21.09.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:20:23 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: rameshkumar.sundaram@oss.qualcomm.com,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] wifi: ath11k/ath12k: apply the 160 MHz NSS ratio to the radio
Date: Wed, 21 Oct 2026 18:20:21 +0200
Message-ID: <20261021162023.280823-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
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

The firmware reports the 160 MHz NSS as a ratio of the radio's 80 MHz
NSS, but ath11k applies it to the peer's NSS and advertises every chain
in the HE 160 and 80+80 MCS maps. ath12k fixed this for HE and still
has the peer-based calculation in its VHT path.

On a Xiaomi AX3600 (IPQ8071A, 4-chain 5 GHz radio, firmware reports
WMI_NSS_RATIO_1BY2_NSS), `iw phy` lists 4 streams in the HE 160 MHz
MCS sets without patch 1 and 2 with it. Patch 2 is compile tested only;
I have no ath12k hardware.

Changes in v2:
- Add Fixes tags.
- Use the plain Assisted-by form from coding-assistants.rst.
- Add patch 2 for the same bug in the ath12k VHT path (Rameshkumar).

v1: https://patch.msgid.link/20261011123631.1664734-1-julius@bairaktaris.de

Julius Bairaktaris (2):
  wifi: ath11k: apply the 160 MHz NSS ratio to the radio
  wifi: ath12k: apply the 160 MHz NSS ratio to the radio for VHT

 drivers/net/wireless/ath/ath11k/mac.c | 24 +++++++++++++++++-------
 drivers/net/wireless/ath/ath12k/mac.c |  2 +-
 2 files changed, 18 insertions(+), 8 deletions(-)

-- 
2.53.0

