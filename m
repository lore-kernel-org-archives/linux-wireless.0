Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2E2D3EEB
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 21:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498309; cv=none; b=P+dC6lU/ZvFc4wG200IVHcZTxk76cECW3qNRPAj13xGQgCxv0J0llKTVspMzf+oKR1jUEFIjJkb4/Tsb5bLIdOEkoafCTIjLMUDu6DCXW9E9adjqkoErEXNPgbA5RhYOuRjwpkFJcC5fXw1RGKf5T6gl991M2I5TV7Rq7+K3RW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498309; c=relaxed/simple;
	bh=96jUqkmWGmgTL/yMXlrwuUWoNFfxwQXaD+x3qCH+sN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKmuejdNOnR8pCaWZGtkoTCh2BxyhoFnnXXxu8gHBRnbeGxqK8KwpSGV0HivwzMbsMsmM5Bub74b9t89ONxzLEqDBdUli+F+4aYfAXgDMnQEe9SAhHEiSGR7StHwR5k8J9CWHgFW1o+n21OEKGb6hWvrFhkJqML8vCWBj199BZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V3H9FO+x; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3H9FO+x"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69c20ba892eso4135198a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 14:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784498306; x=1785103106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d76k8owGu9adTwGj/IM8Q9U7V5diOFFO3Oby67bvuxI=;
        b=V3H9FO+xDCNCaKpbu5tZ18hDD7gfWs2eombTOs2ZvymyK3juW4020xb6uMzzyGKVEw
         9ybBKSpu/mJb0V18aDtsg8Yg7VKzASdHEBmTM76ZyTU7+qi8im/9Hp7iyZx70NjuKLeF
         SZdlBzUOjGHRLu62gLIpM3+SCU1ghkejtElNyGjfoQn7qUYAUZcwupmU3zt0SBgTsSi4
         CDHnov85yxOB3+QjdHnGeITkh0DTX6MUNY/lSZJezidYDhJbkQ4FEvWnNaVBDKsV8NrD
         9t1soet8ltjzKMaB1ZvK3n+ULNExAjXVzSkOYzn79r9xLjLd4z5B0UWEM7g4fYk66CTx
         XmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498306; x=1785103106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d76k8owGu9adTwGj/IM8Q9U7V5diOFFO3Oby67bvuxI=;
        b=IzttMRd+z4el7xzA1CnZa+6rqFKFjkRW33gq4WeMP07ErmDAQSCyUEd+mYsHhV1NLI
         CxAQ7sGQGTidr7aToNqWQpQUQVL0dkQ/Zgotu6Rso8NkUVHPd81dvB3R0S/L22H7T1wc
         x4XwUntMFYuigdEjD+8EW4ZPiw+XD44px+LfrmUAoUya+W9X7E53gmpi5kuGPCnLYflo
         XZfjSJCHo8xg1mcCvgzmUpcwsxtWyIt5euUT58lNzZplvdhZwgZo+S71jHTabqFzdr3D
         QBR1oLAo6D2F9I/D7ab6mexgpWgcV3Mh1a5nRPblnOjzJM4+aUC1cTDHNIl9l1uvTAXs
         gcoA==
X-Gm-Message-State: AOJu0YxaLagO+7+yHKZn5vS08td0QyTf8MTjVGKHtl4hGYzYdOvE62EY
	yqZcgL8Tnz/vWjUrTRbCm803edsUAXFV0LOonYQC6yfLDMoLRKNdl6yFrEss0aD0
X-Gm-Gg: AfdE7cm/ikD/QvTJaq8W5lrbTrMPmD5jtqQLRnN9U+nBxMMFyVeSztK+KA4C48sc3Px
	LiFd+NPQVavvTtSYl/3MP8lJQBd5yAGW2483WM+51TuP/4vOvDmun2/87I+78rHsp9Gfmygw71v
	/S+SLT2WQ+uxdSviA1NdGdNliW6WqbCr1w6l9TJIDGmnuAl61Ob7CZdJ/miRB7a1w3RhfeM1KoO
	GrO7+U4k3IIPvQwDIRmuZsqheU1DAit7Bd5s6TO5vWiJKq95wmsR/91vpIDqH15fHan0kDj1WU0
	7FFhUzTIGrZ3grz28tuMSTqSNy6RZbicZxQb/tTxIV4+iNy+IC6xh02joRijOT1l153hklwl2hv
	7t50ptObnasq8T0ap48Fq99+apMUwNN73r2yVaKQNvedH+DBiVtPUJ1LbRFxe6ExJSze5XiEZtF
	EWGwjb92xvVBOAPg==
X-Received: by 2002:a17:907:3d11:b0:c12:c5d2:bf37 with SMTP id a640c23a62f3a-c1692104a7cmr618368166b.12.1784498305865;
        Sun, 19 Jul 2026 14:58:25 -0700 (PDT)
Received: from nv-msd-x1c.mtdk.labs.mlnx ([212.60.125.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c16eb80bbf8sm379116766b.0.2026.07.19.14.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:58:25 -0700 (PDT)
From: Mark Ruvald Pedersen <wabsie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org
Subject: [RFC PATCH 1/3] wifi: ath11k: reserve headroom when aligning RX buffers
Date: Sun, 19 Jul 2026 23:58:15 +0200
Message-ID: <20260719215817.2468580-2-wabsie@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260719215817.2468580-1-wabsie@gmail.com>
References: <20260719215817.2468580-1-wabsie@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RXDMA buffers are allocated with extra space for 128-byte alignment, but
the driver tries to move skb->data with skb_pull(). The skb is empty at
that point, so skb_pull() rejects every positive delta and leaves the
data pointer unchanged.

Use skb_reserve() while the skb is empty. The existing extra allocation
space leaves at least DP_RX_BUFFER_SIZE bytes of DMA tailroom after the
reservation.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Signed-off-by: Mark Ruvald Pedersen <wabsie@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 33425707c..e4ea0c216 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -378,7 +378,7 @@ int ath11k_dp_rxbufs_replenish(struct ath11k_base *ab, int mac_id,
 
 		if (!IS_ALIGNED((unsigned long)skb->data,
 				DP_RX_BUFFER_ALIGN_SIZE)) {
-			skb_pull(skb,
-				 PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
-				 skb->data);
+			skb_reserve(skb,
+				    PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
+				    skb->data);
 		}
@@ -2875,7 +2875,7 @@ static struct sk_buff *ath11k_dp_rx_alloc_mon_status_buf(struct ath11k_base *ab,
 
 	if (!IS_ALIGNED((unsigned long)skb->data,
 			DP_RX_BUFFER_ALIGN_SIZE)) {
-		skb_pull(skb, PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
+		skb_reserve(skb, PTR_ALIGN(skb->data, DP_RX_BUFFER_ALIGN_SIZE) -
 			 skb->data);
 	}
 
