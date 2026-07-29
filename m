Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB5C380FEA
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346614; cv=none; b=AYCMCejH4V2UNlXMM5NlDfXdJNSIQFZwnjxDBF+daxRWabUBeyaABl0Ad9oS7UmvWlarvAYEQ3DKKhSc/WAIf9J54gk19lqT3SJ8m8kfEYJCCJmF+u+R82LIf3xV26XLdV2BECnZ7Z1PZPc5NVPrPphRzyKp/VAebziBEytEGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346614; c=relaxed/simple;
	bh=uf/XwxYZfY9BgYrEGqyb31ycLivbYD9kLuKe/0q9hTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnVKl6X/xGKi344/qf2G+WVL1Gqw8bXNmOrxMwe9GRm93rvMXyk38tJdWH3NxAkRB0QDd2jiCHDpnv4MgI3tFyCpaZEHptpew896DwP1cWM4lZu7cQrUL70kTWLFQ6rLqILU+uArGOr4I7Ovj1vRgIoffYa3chHfAq4hxdaprKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EkDxQocP; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EkDxQocP"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cca0c5799eso13112515ad.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 10:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346612; x=1785951412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4KRrR5InAG6qbH+2o0ICn/FfbIaKM6RpEitfK9J2zk=;
        b=EkDxQocPAjLEGGXLBylwYw7OYPw4QE/p4DU5o9UHe+Lg/XTre4EsAvgRkcd4zrZmhU
         f3CMkPrftkTAhlGZEZ8TBRgyeKhJMP8w9XXllXwXsMU690EcoEYjLyT7ZT+7JLxi7zVI
         77jpMn3JPq7l9XhF2c0KUtW67qjfyhBkAd/wcR9CAeBekC8BCZtPeriJpoR04ETCaA7y
         Uo/Mks6Xpv9ymBrAAjAZ3jufFv6yzgRgz+Giq6R/DHWQzO/9/PW5XV0umk6qzdPF7gCw
         FPbS0w/WX9YHhq4mtlZUETFLTqkrndCrVsIw0ZvgtQTe7a8HjmxBd4OYW0yqBR2Ndts8
         eBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346612; x=1785951412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4KRrR5InAG6qbH+2o0ICn/FfbIaKM6RpEitfK9J2zk=;
        b=QcwV65pMT66JAMmaq8PGL3GaD5FBUbdALuhu4MJRUk157kcLSZn8Yk1SzksT7+/v0D
         Bcgd9XocYv09TUt9cGsQZu6VBkJ4CxYkgnuq1TTbgOqa3I+2oFTe1dILmfN3eaqG5S2R
         V9jHfuFqnDeMNQ5IB1HG7NNqVa1WqeE5MZ/sn2G5VQOQEsql/2Pomm/cYY8HVE6R7eIg
         2k8K7k7s7YmMi91o6MSKeBMx/u+gRS6GJCK1q6xkb8WBr2RR8qLeBYfLEqUwsrSEATFo
         wYjxc3m2LHj+Rj3oZxtlSoHIqz/QmnlmCM0iKtExk2H5tjCxM0HJTOyexMFvlOJPHOZW
         VSSg==
X-Forwarded-Encrypted: i=1; AHgh+RphoZ0x0mDeO6RLhAjV7eA4CiMiOyft+F/9aOGmApmqZ36zfoTnACZjlTslrfXU0nJo/q8OHY65C10LG38cqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp1A3OGDBi7sJChE+3Qacgp1DyIO1S9aDwPfyJAHEgCMx7WfFF
	JF7vvl1HN6yg5M/s0jS3VbtdkXirIn6hTYMfQosquPacGa5LhamCM4aO
X-Gm-Gg: AR+sD11L3aMBLGDNG0htcc3Xr7vxip2ALgLu4PulFuach9dPvxoimVCIrH4oW9e8hsD
	o79JhDCGi4y+WHu//WZSeF4KJeWKMR1cwmx8YpcNjlVlE637fvGDJQZdo3TemC/AI76MsUBOcnY
	ajrC6vj0BfcbtYHWjrA547+sJtgUBWascWgvYPqAO/WBDVbMNCHeX9QCjSGxnz0mwaNKsjlu6SK
	eNz29IGoxctPlAb3KQHBFIEgepaD7kUNqiw3XN7ikeE4SsLMuFT3W5KdEn0Wkh/VzbTzKOOtDcr
	43J9KD6lcSw15PGk4+s2cUqPBTVtAOwXPQfmheGP3FJ8JgC9+lP/3UeZf1PKlVRUDHLq+GTKBpF
	TpRmbrEsZTgMzPKyzy8TnnZSSRzxavYOHZSqi/6BRN7wQ5maPm+hvkNC1Zm8wZdy7r5vIZd+Xnl
	7zHX4XY5WG8PYe3vBSe8CKZDZ3QzKFqXsKeQ043zsSjun5iZuy/TjKtvMrSrPlfeo3Lk9yVCyKk
	0BLRs+OIYelsKBhOIUBTM6PjZbC4WNqH1UrLA==
X-Received: by 2002:a17:902:d2c9:b0:2ca:cde5:29c4 with SMTP id d9443c01a7336-2d015db90afmr81414495ad.47.1785346612435;
        Wed, 29 Jul 2026 10:36:52 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([120.234.91.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf39cdsm14806045ad.55.2026.07.29.10.36.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 10:36:52 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Rex Lu <rex.lu@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Chad Monroe <chad@monroe.io>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] wifi: mt76: mt7996: unlink TWT flow on MCU add failure
Date: Thu, 30 Jul 2026 01:36:32 +0800
Message-ID: <20260729173632.14387-3-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260729173632.14387-1-enderaoelyther@gmail.com>
References: <20260729173632.14387-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mac_add_twt_setup() links a new flow into dev->twt_list before
asking the MCU to add the agreement, but exits without unlinking the flow
if the request fails. The flow-ID and table masks are only committed
after MCU success, so the still-linked flow is invisible to the
mask-gated teardown paths.

If the station retries the setup, the same slot is cleared and its
embedded list node reinitialized while it is still linked, corrupting
dev->twt_list and potentially preventing a scheduling walk from
terminating. If the station disassociates instead, teardown skips the
flow and station storage can be freed while the node remains linked. A
later scheduling or debugfs twt_stats walk can then dereference the
freed flow, resulting in a use-after-free.

Unlink the flow with list_del_init() on the MCU ADD failure path. This
restores the list to its pre-request state and leaves the node safe for a
retry. Mask and agreement accounting remain untouched because none of
it was committed before the failure.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0eebc8182ca9..445bd7d63cc8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -3207,8 +3207,10 @@ void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
 	if (mt7996_mcu_twt_agrt_update(dev, &msta->vif->deflink, flow,
-				       MCU_TWT_AGRT_ADD))
+				       MCU_TWT_AGRT_ADD)) {
+		list_del_init(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.50.1 (Apple Git-155)

