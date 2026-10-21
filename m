Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601500;
	b=QWMbnLtYx/kb6Oe2c6kwhm8Ys3nkBGGCaTvv6HWgaVS0qx5YtOZlYVggqYY2/hEOrFHw
	 nFANDPmXAm7jrNkUxe6QtBJLxVryU1N733dgXlFN098yJg/SfPHHSVY/pcLm6u14DDGWu
	 DPpiXkGpWcFSEmSA8j1gBDe7M1gsPh3hAv3ZwkX4bpo771RP3kfl2wziS8/NgUIOVISRm
	 MRjFoL2OBW3vQbSi8ZTDx5dh4yay4HURagKKVhyuSPHEsiky5dhdxcP26ztZ42rHdTXjo
	 JuYgVmbsQ+4YVz0DxZZWpR+ueGP+IAu9hMZYM96fqW0nwQsqas1HGiCvbBgxCtlaCaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601500;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
	b=qbiDI2lwm5/2cI5txbEgQf6K/wChOdD+5KEBrrnsMsEirh1IENTrC+gjZ2wVn7xiNww+
	 0v4suZOQCsnNcIbfqUEwp/yo8+U6BAhWLvGPJVVzm3gDaqH35u54NTCS1Bf725WREZEw8
	 rwNjAUxI9//bcytmP2HcBKNIjBWycn3lhC6xdQLYpcy7Fsthh79JQRv3AepEQYY4lTeUm
	 GO2ObtDzeJ7neASkAVnifaSHx/lreLTH/iOkhDk7lc9uQbqjUFFVN1Sjf0Pyxx/2GUt3p
	 SZkinFIl5d07x2w0mQqWg6/mIPiKKMG2t5MeEx7IDQ7DRo4QcmBYBMKBr/XDbKxEBFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=WagjL0Om;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5A3606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:51:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C5A3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=WagjL0Om
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so1307252a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792601499; x=1793206299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
        b=WagjL0OmsY5okLV7EcpILW+/Rq+PC1du8VgIryG5T+Ec0Y3iTImJW868SwpGxrs2Rb
         5p8/lUKnOpl16ZJxVxcE7s0wxXZZW0Ps6VU4vMQOJ90+o64k9DnXoHAf3BWtzhd8rLW2
         0rc0OAjQFYEUye2n1InFhBB1s9PUex9ZZtGCRNezrU8oApQiJi2QrrZ2IHIvNYTGOP73
         9FNYGZS9osOKrKjU11kYEVwDQ2EYsx3hmaFPNSTyfAmLRPE04U+jwI4V6JQTel413cNt
         qjpcRZWoaQ7iDVcYWu1SklYgAgpwYjmUKT49Lls8av7q29Zx8N51ExT+lUSzWIyl/424
         KmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601499; x=1793206299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dacLjl7RN0IeeDiK9b8hPkWa1OXHnnZ0y7fVu/qkLNs=;
        b=zap2xEsXtc2WylfGYt5v0io0FSVLsfYZY28BjXFBOQa0u4Wq2G9kQd9vZNuZOdCcKG
         uXCpo6Afm4SC8eGOweYzA+/jpSyq17eZPE7mstJbXOh5l1/wKbD2EoXU49ShZa/9V0fi
         iTLQL4iM7sf5U/gg6TEofZLYusEUj3A4aL1Ak2suV2Vsx2aF3fODi1oK6TEGaihkppDv
         Iua6jHJx1d9bspikk8eIw2gC2c0/YCAI8pBSIUetcwN4fDXoYAcqhu3eX3kCx6Zm3LN1
         AT6diNJ8t6laK7nWLy+4pqP4ZXwxjQV87JgfCVVUVLR7VEij5Opps9AqBtYVJuQckR8s
         yDgg==
X-Forwarded-Encrypted: i=1; AKwUvBzpyBjX4h15N8vQQcwWsNwJzoi2KVyWP7faLHJPTIJRqCUgbKqirHncP48dP/yZAhfxH3C4L9rrHz/JLNS+aA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+zQer6aGtSur0OW3r0v2UrZYLvOo4OOyTG9txZIXRqru3TavO
	IYk5RnwSpRqh2pvbzs0xmcn+KjY/1zVoEnvpE45FOgHx0p5ufFRC5NDc6CD+6q+NPA==
X-Gm-Gg: AYBFou1EH3tv+AOvCJGjjA3rcym0CmMwdKWRBobgamguQfGS8o6YY1lBy/QZreFvPyg
	4YtPJBioif221pkdMc7L0JKl7UAZz8Mm4iDJXom2SOJ0tNRWZFmycd2aVUlVas2cBcyr1C7EhYZ
	OTLHLQSFU+Kir8jqDW8e/5KhoNL0OzmOkFjQrTJ+YR/BYi2qiCauSccImSc7o19IWs5YALTduph
	qqtN5wsSykj7+YyFBJsTOcA0UBwuUAWk7IhUbwa82YOshGVzfjn/rpnK/p0ec8FuY2nNQUwL9Hs
	uvrVd551CaDLtzlEfZ9q5wgBWISbjzCN64yW54xpCRoGfl97dTgHNSevsoAGBMudWkGm7widm4K
	2tDMtzDkEwjtXD2WGczDdIX20WO6wvHB9lwkEOrBJlzuzVf6ar++sMGf4SxRs9PnFaafGeiPpt2
	HBIatli8W4MASVFK5pSDXsyWBwjYbQcMhln9eEfBVWtYJX0Wfox0wOqeMdNeEJCw6tK7B8WxxkH
	jUEHJtJooTRUgoAQ5uoOC5F6Omtlg6tu94GgJHPc+fUxH74PvrkDUNCa+f+oE5pWixkzJS69O+5
	I6Nhfkv6wdAf/PrARDZzQKigwGHtnLHY0KJ2x6ygorM67Xg1XPT3swmuQI0aJ85XCQLH5VCA/gL
	538Ch6XVIEvXdE0vdHehNrRlndySnFjia+qX37f/hFgUV3b6g43oJTmyEu+XDPue7a0aubVSdRW
	1jV/upsg5xL+/hClKNiKqIr4tyDo/e607qJSb5rnxVGL7HN+vdCTzm569Bt58po04s
X-Received: by 2002:a17:907:e0c9:20b0:c46:8b87:c1f4 with SMTP id a640c23a62f3a-c468b87de82mr18142066b.20.1792601498828;
        Wed, 21 Oct 2026 09:51:38 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.223.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5de48esm20782466b.66.2026.10.21.09.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:51:38 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: rameshkumar.sundaram@oss.qualcomm.com,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/2] wifi: ath11k/ath12k: apply the 160 MHz NSS ratio to the radio
Date: Wed, 21 Oct 2026 18:51:36 +0200
Message-ID: <20261021165138.388593-1-julius@bairaktaris.de>
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

