Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575DF4D9F74
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357327; cv=none; b=Q3OMLrt10XWNbw56/O+yu7/5RftZBo8PDgnjpIvGfP/4Yjv5sgr39olFS8VscuAR6hctdXPW76t7iBTNkyqLn/lEwWoiNxIlO2YUwHvKtxNTkAZ+6QWpgm8IfGH1X0mr6FTw7MF+r5AYlpV4daSoSvuPwrhqabmJAW7W5xOUwZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357327; c=relaxed/simple;
	bh=j/1zUQRbqig05cvA0Htabmv3HK7YvRbrDkDYd0qo2AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXhot/fH7OB/61wwC69BXepBvX73e6a7nV8nT2tga8GW0gH3wZWm9eFVCKqgUhphIwtWWU0c/7nPQ0j6YCb1yQ17MYji5QNFiA92umXBchAaz+98/I0u8ynDMPX6UZMzPmhgpTdpytEpCjvvY9fYg4Y49/9YpR/kFVqsq4Bga30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=PF8GPzdi; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="PF8GPzdi"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c423b145922so100841866b.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357324; x=1792962124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=14A6w5xPMpUCV8gRRYD7ibxrUfMizPY/0c4dLS53tf4=;
        b=PF8GPzdihEqQJrpfmWYPrU56/jXKvhq+qkYiOudH6qnnQgycarI+ku0YCo699fOw42
         lWYnBP2han5ho19fgY5Uik5kB7ja5OD91OfmpFMcVfZAQXTPENk8bF0CFHYsjgDwL/AA
         gYRLq7o5f3HszapXbGgQJDreYdeZ+6ELUIl3ZudxMIjewOe+a1JTIdea+HutN+ComxNW
         uN4F/HTVtSOaG0HjKKm8TS29HeHZccovM1gfKtJdnRKCo93dA7HTDLReHpDSENxCAzRv
         +Mq8VAKbvLj/V/nxozp5MCyY41cP249mWSCBJmzqYZw4J2Hc1puPhcui1x99C5QsRPQ+
         w5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357324; x=1792962124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=14A6w5xPMpUCV8gRRYD7ibxrUfMizPY/0c4dLS53tf4=;
        b=Un43H/frkGHrjwHZwrNvsStDBa+lwgoDUyIifTolu3RoQJD+djIwQfpiSNNW27K/1j
         HX8WJNzl8vHZ4doC1YCnetE2xvFiRrbZ5dHjFZKpCS7FkAz+ZB1z/ttG1cCFx/TIMgK0
         RTvTluU3SoNSURQUmcLASigaW90OHPGzv3xHP5HHuqZlh1T3ai3uvgtxevAgbDphTXE6
         H+yX3nv+nZh6+yRPf7yftkab63UE+N4FXhKCKyLY0f5f/Suk4tER1eSImjcVYI1CSZqO
         sZN+mT4Ldh1CGGsd5CZWj3pedsENE7RvaGEH0nDYLQL3zex9iKdpbVpbdYsWAZENyMsj
         kKag==
X-Forwarded-Encrypted: i=1; AKwUvBxqIIZzQJ5t3dxK1IBSGBd8nHpBj3bacf7QojQ3bxtNltx1iEVWafQkIlOtMMr5hUoTADYs+CJ+SGDs5ehzGg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJQFdp9xKNc8+DJtera8C1tbW86EA5QyUDDd8Rfc42uIrOtauLw
	IfLyJyr40fFnFd8/kMvwgNl/5S8mVVCaaHuQMU9u7yfnT449fXBUP3KJvddfmbuaNQ==
X-Gm-Gg: AYBFou14BjvR681V/ww20cNFBWypND5vlOus7nLuauNdso+MhlIwqPkJv55d08g6NsL
	j+/h0s/gF1xXpXTMi0Yw31ZFBnF15M+RVlUgVWRlq6bQ5zSUj1+DqnJ6G7FkivVPILvJJVpRoRA
	ABwskAF7FFoqxYKtLUnREuoaz5pxF+5/VbW6S1Y6SdvCxcUaJ8JXH3qvt+6yJeLg512PYKskWDc
	ETwSxc9FybwbPA/WwW/NDcPyMZ4ofbbuXtGMAcg11ap0wem0BFy2tbP09seRv/0CphsalS0yYaZ
	UmVQv69ygVwfx9Utv7Pdu+ItNjtbcjke/ZJB3O8l/FSHXOcAN5gCbhmXn3QWokQ4h5WQQoJ0LeQ
	tZByRduLGWQLwNYUnIwjLeEL1TEAs6SOwUc89enI21m8yTFTAu//eqcIqEO0BjaAy8D6DUgV/oc
	i18QZ2cDXJ7uBXi9GBLqUxd88+a8w6QwjsGE2P+6uCg0z8NVct+VRt7muO+OsYeizayEZkXcwD6
	NfsXBMGkuytrtw2AotbVMqSZHKpcz9pLpG9TWDWjNXhcO3Vc/9R1wv58BBZKvN7UksS7uLGFD2B
	V6YrtECpHTWr1hiTVEreOcL1fKAGedbYLKXJbB9hZqvAhvROo4Le/taACFjNHJxLQ6+3Dr8m4+A
	zb+zBJ5OX/KulTEZRv6+Gil4EGTj/JGM898gvj3yLcLHG+YHKgwY+PPvCXfz8JUCTT0Fy3yKg4Q
	OveNFHyIh9
X-Received: by 2002:a17:907:a2cd:b0:c29:8a0e:4458 with SMTP id a640c23a62f3a-c419996fef0mr351005766b.7.1792357324577;
        Sun, 18 Oct 2026 14:02:04 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912cefd4sm291618666b.35.2026.10.18.14.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:02:03 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: [PATCH ath-next v2 4/5] wifi: ath11k: clear CRASH_FLUSH only after recovery rebuilds the rings
Date: Sun, 18 Oct 2026 23:01:52 +0200
Message-ID: <20261018210153.1925962-5-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018210153.1925962-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_core_reconfigure_on_crash() clears ATH11K_FLAG_CRASH_FLUSH right
after ath11k_hal_srng_clear() zeroes the rings, but
ath11k_ce_init_pipes() and ath11k_dp_alloc() rebuild them only later. A
WMI command sent in between passes the CRASH_FLUSH check in
ath11k_ce_send() and dereferences the NULL tail pointer of the cleared
ring:

  Unable to handle kernel read from unreadable memory at virtual address 0
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  lr : ath11k_ce_send+0x114/0x350 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
   ath11k_htc_send+0x188/0x3c8 [ath11k]
   ath11k_wmi_cmd_send+0xc8/0x2f4 [ath11k]
   ath11k_wmi_send_peer_create_cmd+0x78/0xe0 [ath11k]
   ath11k_peer_create+0x138/0x500 [ath11k]

Clear the flag once the rings are rebuilt, before ath11k_core_start()
sends the first HTC message.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index daa3751d75233..4666245aee36d 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2294,6 +2294,8 @@ int ath11k_core_qmi_firmware_ready(struct ath11k_base *ab)
 		goto err_firmware_stop;
 	}
 
+	clear_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags);
+
 	if (ath11k_frame_mode == ATH11K_HW_TXRX_RAW)
 		set_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags);
 
@@ -2348,8 +2350,6 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
 	ab->free_vdev_map = (1LL << (ab->num_radios * TARGET_NUM_VDEVS(ab))) - 1;
 
-	clear_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags);
-
 	ret = ath11k_core_qmi_firmware_ready(ab);
 	if (ret)
 		return ret;
-- 
2.53.0

