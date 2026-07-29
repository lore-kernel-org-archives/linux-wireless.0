Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016037F8C9
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 17:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785346608; cv=none; b=TVKWvppCK1kjAeWMwSvi4TLcK0V17qs+CmjlcSrHUCKI6gDRHFqEQuKEkL66ouRrF7CxD8uFB4aMhdqFdCgcshfqkjwysq8QKPZdq/+aJHNWSNnyKzn6rk79M9Ntw33I0hitnRAMbH93kZc25Mh2ip+o9mdP2dfHNcmtlvgY35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785346608; c=relaxed/simple;
	bh=bLigRDlF77Q8rMCVJRJEG9Iw4ESVLt7RgamZeM/qbdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBshXiWTxNaSBbUcwfz78ntZiDri1FLNxYZGUvxuE0radAeryDoAcoh5DH4VfPlcajR+iCiJeP1fKnqZLUM1oVb08X7mbI9/s+eb3Sx/fmr2CMCjA3VpmPi16u4ycLgy+I2BsdQF7bAvBD4Y0W8wZzMyBNIpk7Mx0MWH5WY+Jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n3NzY01O; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n3NzY01O"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ce7d2adef4so18679615ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 10:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785346607; x=1785951407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gg6ArNtx1AiAv6yPr+prFaZ5QUtx/jRFL3cP/oq9oL4=;
        b=n3NzY01OnnfSW9mbHuQ9pZZkdkPs1ymiGLtBi7kc40Z7F8Id1dP2IgBfvPi8huyxmg
         5AQk1bY1q4UjE781Oe1FnSRpRjHBQgwkDwXNk7s05+nRZRVNHIY5eUSZFHuslopz8mAB
         ZBnH84oxy0GUM+oG0EUYGGF7G0zYyGyqViA/DCjskzAD9QVh1/wkQtfZmawnxOy68xBl
         wEn6xydJiJN2Z5MVBMmRTNVl5chK2q5jnD1YVXwNxCXcfJfrbIVT8LL9Mf6Kq40zcSvI
         4g0NNKj9IquWZwaXD9Fxy4Sc4MZpWeCowj/Kw8UXQclI+jbP+xlmp768D/yoiZkrTddk
         eiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785346607; x=1785951407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gg6ArNtx1AiAv6yPr+prFaZ5QUtx/jRFL3cP/oq9oL4=;
        b=qkd81Lz02NYq0/wco3utCqb6n2zbY+uP/VhEV0QjP7g4XtnlDn2qipIF3bH9dvMZwV
         fBn8ZuUaqukXnFfOO+zbL89PRHB9rYPAJ1dMv2/xlpVhK/PqBf1LbxWAYINAGlsM74b8
         VWdtqaN3OynByhI80EFL8mn3wgctE8ZpPRGj4Sc2OJisq7k9NpDXoEqbtor4EptbiTYB
         WOAftmc3VzDHDfrcgFbgWGSWAq5SdSuXL/zR7GC3a11MLSjJPn98Dza3bECm1l9zoOt8
         fDrj3xZzRhQmPLLRf6+G7N7FZZkbAnhOkwGyA5Ea7bcg4T9hKuy7OGUtJbHZ7d9k9kpZ
         D0zA==
X-Forwarded-Encrypted: i=1; AHgh+Rp2XoyfWN8XwLYqnLZTbiiIxD1wHFchF3NOkvuJPdVlF9QLhsndB11LutKMzZZOUB3pPJg28Nkd/piVoTo6qA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZokY8pqE4nsCowftfPSnRV1JTL5hGk/t6hi3j//kAc+ocNEER
	grVTyGsHQdUJhdMQAXrND3XXtK6AG6ol+IJtGdOgPgPEp2PRn4NuweAJ
X-Gm-Gg: AR+sD13b9PwxKSrIMKZRgcm+h5GkDQRx8OQAqH+p/Ovwpqoa3PIvyKwsa3sVt3xoWx2
	O3pKGggdyjRAYuivOiAaLV63XAhL/21ItP8IFkrM2M3egKuWTeKUyr6kPjX6oVw2q96gHNdCqk0
	GrPdPMoTEmJ+w51QbZ34KbbhyIJCW9/MYvqhChqOO5FELsp9hvCCK3sUwvj6SVv3s0pb+cUNJ/7
	+Te/M4z9QgScHdxhvAtwRlcsFwCrLTavKRm1u03sIQewT+DG76PTXbmM2y1GKO8hTJkSNZF6Z2r
	DGiTp+QQS9b0WDqa4iVcpHzPfLGHqOzfvmQA2d51ZZP6yTy3hXu4zq2h1pv37LYycGUT+Z8sQ/Q
	Ss5RmdMZ+nhDifVJo6lyeu0lSR8nndkz9EjRRhwO2Uz/wReFmlLroE9mbZTTG4oMLItl1xrfHhL
	5HA8xAbx1F6C0DHs/t6U4EisyupPac3RiVJkIBEfL3imU9IrpZnUf9Gmyp6Ktsvgnsd/rxUIUHf
	FhNcBBjQ8FP53yIeFWn7boD7hg=
X-Received: by 2002:a17:903:11ce:b0:2ca:b8fd:1a8f with SMTP id d9443c01a7336-2d016050393mr86243135ad.39.1785346606916;
        Wed, 29 Jul 2026 10:36:46 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([120.234.91.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf39cdsm14806045ad.55.2026.07.29.10.36.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jul 2026 10:36:46 -0700 (PDT)
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
Subject: [PATCH 1/2] wifi: mt76: mt7915: unlink TWT flow on MCU add failure
Date: Thu, 30 Jul 2026 01:36:31 +0800
Message-ID: <20260729173632.14387-2-enderaoelyther@gmail.com>
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

mt7915_mac_add_twt_setup() links a new flow into dev->twt_list before
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

Fixes: 3782b69d03e7 ("mt76: mt7915: introduce mt7915_mac_add_twt_setup routine")
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 334c19ab2b22..1ad54a5bb374 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -2345,8 +2345,10 @@ void mt7915_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
-	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD))
+	if (mt7915_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD)) {
+		list_del_init(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.50.1 (Apple Git-155)

