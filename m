Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465521;
	b=wE1tf8KYOC1v6zcgUomtuYy36ctRI0jmLDgM6pI0rsnGXqCphTkuXlKzF3b8w9OqvAI1
	 YD1xFR8L89jEvCQs/7PhHhxu/PiPjM4aeb+QyxVwMwz/huhWb925rMUM2lqqlJxl55JZy
	 Zc+QBUQBAnHl8BKY+1MlOmWKbZmlKEJCsiPZVLjHkVDMUWrCxhVLR/5OovYL5h9AXTBxG
	 /wMf2stq/ycrCAx1H2OeZjxZwWhb+I3z3L0feYjVWxau/oCR3aKrRoNk3cye1N6oXv3CA
	 5mgcLcGsT8ClGWH99q2EtBpzznlBzBdKUMIxaiFSbNEtW8x0DRjrKeI0iwQxuKXoVBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465521;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=E+21lEgufVUNREtB+EaLC1ZgvxJvGOOcCZeFt8RdM30=;
	b=SW7eDPnjHRJ6gXTThBazlYeLlX5VSvUW5eHj6T1MfzPQQ+4SuM1YtEg4TYhpRDdcbZ2T
	 CPspc87q/t6u4jwBTvSN34qojVRojAsEEQeDH7DQHvVMSkCXQlpyo3cVt7tIXrwdekRaF
	 tElRjQJyMFpkJPYIxy2Hr0ihlbneobJSg8tfBjfHGuQ57EhdJaC1ATU/BH6iUAmiDfESG
	 Jv09E98Wq75xiU+S+T0VtTTp0mtK4BSOi4QbjnUD7kCIbwbUIe7tXvyBf/c2H7x3hvfWf
	 QWECZxkqLMg8au9cqp7uiFK2vpOqro2cW1VX0pY8QrJDI2lPvkbJ/tPPG2eJbjPul2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v4FvYtPT;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5CB606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:52:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5CB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v4FvYtPT
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-36a0f27c9f4so3003496eec.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465520; x=1794070320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E+21lEgufVUNREtB+EaLC1ZgvxJvGOOcCZeFt8RdM30=;
        b=v4FvYtPT87orSU2M/N6cpEGYdhhW1LKpcYhnritDMFQOtLEta/9bBRWw2LRibrLE51
         wyLm8WK5XzXjwPtPufBDPovzgOBRVKbAwqhyocXE348RsO7X4cBfxVcv3PI+pMS7Ik/3
         CVmJE7/ItDCRANAfeBp2SCj5p8M3mJ0WNbqclJKHXbn2a9deXWXWRgefar6CNw0ugwYy
         mlAz/Shpv0nC/CpGfV1w+sD/vCQb7LexumsgDB1v2CN7dSg5dYktS2nB0YBqXyQHFapu
         AvN92po/pidS/0NjgtXFc3+eJ4Gy2WmThU9lfhbwntA6gUINDUcnY8Ep5A6Khs92uGzr
         REWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465520; x=1794070320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E+21lEgufVUNREtB+EaLC1ZgvxJvGOOcCZeFt8RdM30=;
        b=qfHj9PgPltWBc2/77eSvPCBEjr833S81QDhq4BdLHg2TTu5mSGXzoQ7YVg2Tv4n8fj
         Dg479nTlkTMzMo3L2eKM81k8Mz4mwgbk8QYFX4rCV4emum6Z7P8UXsafrLYKnudD361t
         tRCmXcmi/PskJY7PWJIxSF29ldKGJpDfsE8iYYII5/Ub5mxdiZHcAg7yT1pR82/2qX1Z
         kVgDNtJb19cwa50bj9yAM8nSjZ2n1z7N14XTWCuDZS4BswwjqH1DBOEiWxihhmsWTJ07
         LRQcVxodj0QPqjkJPaQ2bdYooP95WQLFXgNYr5K6llwgNZOsr2Qv9swEQ0OQ1P6s7uNX
         o9Ow==
X-Gm-Message-State: AFq9FYLYMUrsG2hqOnQCDPfOrvDkU58GoCDrzEXzQC1UDKIjKGbX/wFR
	Jsk7wbgE7f+6wT3ztjcUxFWJfcpyZkV4vUvf+Gp5wMOqPc4oezUTOiuSXZeKOi2X
X-Gm-Gg: AYBFou0Q5RbR/Kv+Yzgugz+iV8TXz1ZjE9fWpQwChdnQ0DCjUBeLlu4uwXxzdyE9+xg
	DO04q2e89N2HFOht8QwUq0g31uytuxP8xtvr7DtxroNctIB2jf9WjqqNG4pBd8Ej98QZSIHcXup
	zv7/m3+00u90fdrxsbGS9F06v3+0C5gTysjpRr3qG0dG0526e2jk70BTkVmaBoj9C6N+W4KT0IC
	W2ej3jnYVZ2siojKpi+YUkio/IjnR1IHQYK/i7fLeSofc+3JmHLfUucvv6ylTtTgVwAYGEEerNF
	UL8KIXe64FD2P0L9dMx81wDWbl/VQ5Nx8lL7i11a8uZof9F6PQeFi4rjAmJpM80zJFWfDOISqqb
	LoS5nrWfZ+NWVpxK3KOBgVtnCBD0xLVAVrxTXkFL/VNmtKCoJzFEXmp3B2Qc46R6lZoWHdfSyOd
	YMPaOASKd5J2m3BX0SC6ltndlF1p+l5IVhu+cjyLPL3gNBXY4TSVNjBmKhRJTEF+KaHC6068FFs
	4TLZUZsRxRi4fgKyxPlKZRfaw8/j/LJ/9sZFfNQRV2NKh3f71U8NwZ6FLoYJ3sC6Hd2xEnWMCUL
	ABHkLwunXOeUTs5eM+XaCvyLufRav7Ne0Jetj4NzEtEB6xTPZIH2fyqpabvDgbhjYNClr74aacX
	vlrFBCPw=
X-Received: by 2002:a05:7022:f908:b0:144:c123:4036 with SMTP id a92af1059eb24-1ac5d2c5c0amr7212209c88.35.1793465520303;
        Sat, 31 Oct 2026 09:52:00 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:52:00 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 5/7] wifi: rt2800: support A-MSDU in A-MPDU
Date: Sun,  1 Nov 2026 00:51:12 +0800
Message-ID: <20261031165117.2868671-6-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
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

Set SUPPORTS_AMSDU_IN_AMPDU, which can increase throughput.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 1301bc24d9413..83d349a238428 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -11861,6 +11861,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
 	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
 	ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
+	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
-- 
2.53.0

