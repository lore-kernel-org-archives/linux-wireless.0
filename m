Received: from mail-yx2-f39.google.com (mail-yx2-f39.google.com [74.125.224.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D82B231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543046; cv=none; b=m4n8mozvJMijd8iiEh2+U2FSK4dTbW3iJ4erUMNQEukj+XMaNyR0AJgVnY/UFXRuOl/SrHQxE1izxvRrbwOnONJUU6bToR4FByx6x982gL2v9//xKrFWOiJdhWgdTM63wOT1SC4xuhOhXv78jVfzLq0Wr0IYqg1Mg2xlpLofJ/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543046; c=relaxed/simple;
	bh=KS1Rxyxcu3686DN5FMEXBTWZ66Lhip5HDsmSwzdhkn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZ3Po6hBm6auiWtxNk0+fNqQbeVlf6vcVGO3eSeF30QSkNzreRlL2Nf8yXUUmkREG9WY4bWZqUzG1f4U0j6PIs60UoYydmV/aLZL1OrvDdIeabPim8az3IkztiGA1tsTOwSCrXObpi/QtmeN7o94W5A/j2Z5wBvMkpDbRbWWE+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f39.google.com with SMTP id 00721157ae682-8a9bfc2e341so6073387b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543043; x=1791147843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rS3YQYx0uEiGdEuZPQRIfKhfJr0nb88p5R+xsGmGVqE=;
        b=ILEPGma5sIFqLpJI87I4fSp54GFE7nYqM8Qgj9HmpEIfKRzVgD5GiozEee3Xjkqi4j
         CFj521pBVrKyQZCvYMESzIkAOO3oPjWhsA/HkLzCoAyPO2fWEmoLaNQmpBJ+aRjOetYu
         lh5LjQPHuD/LJfs9cOIp3q/JsDLWUno/KdR5ecmElgofaiWx5I8JaLtu9SbPgIEK+aIW
         k+ZnihY2HqqqrCml8ppsrK4CI5AXxkwLrJ9r829FMaN8AJFj+oKuUF7OtOt64NRrrA8j
         18Av1CiOs7gmTwa9ZGJBOD9ee6WHf4EEXYfiXCMuSOQoyljgv9hUQFndItZABIaW4web
         MoPg==
X-Gm-Message-State: AFq9FYJd2CBk1nRv+ERARZ9wfFZdLsKX6XiPoJGDOFg5AXA52ab1jNXx
	zQJ++X105cL2AlRUyuT7xDmUBSF/gbWEpBg8a2jHwqFGPJn0w1V+OR0h
X-Gm-Gg: AYBFou2sXp5whYpNdhhXc2RJLebn3JbF9Pjis56bNLWZYoA9/DeDANteD69klGMXK7p
	EZmgEnVOFNmcD7K49J/cBYyWNUNnVMlObnQIPVINZzu42jrDZsJ614RR8I+J4wym0NnKmnxFNEt
	h01KoJc6KLAvMLPWYa2sJx7MhgxiGdOnWTtcsKHqokEmjd92nFocWggNx+JTlleSAuorfVcMHJt
	NNZsiiAUg/Ua52wkAdAbAwKwpZ6iA9gkm16Bv8Dd/n6ke26cKEIVVbZXALjvbt/unXJtzFlhSxy
	zeb0Pmcd4uGSgYdLsEcVZ14k14z9QA3NcNyEp4O1zGEMoKlWnwoXJyzBREHnTc+9BdA8e9g5Yg5
	0tXu0blD7JDs9Hs303eGFaW71qCgmm8JIIHYGuOQyn5RUCYj1ROlMTHGt/WWgzzzgoA/lDAV6cT
	zDu4U6evWPkiWm5LXGwtt8Uat4RaV/HnR6g3ICydaA/i4vi/k5OYMGwPMOdre71iHwu+vOcAlv9
	2eIlHvcsLZf3u2jl4Ei7CefJ1eIFfOM6xU1En7a7tt/hUYtwoe8JjK9M+VvXR+eh8fZfg==
X-Received: by 2002:a05:690c:6d82:b0:8a4:c2ca:181 with SMTP id 00721157ae682-8a64e5bf298mr46142927b3.39.1790543043374;
        Sun, 27 Sep 2026 14:04:03 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:04:02 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 12/23] wifi: mt76: mt7925: assign the interface WTBL to the NAN management TXQ
Date: Sun, 27 Sep 2026 16:02:54 -0500
Message-ID: <20260927210306.737669-13-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jacobs Wu <jacobs.wu@mediatek.com>

mac80211 does not allocate vif->txq for a NAN device, so every SDF the
host sends - multicast discovery and unicast follow-up alike - is queued
on the dedicated management TXQ (vif->txq_mgmt) with txq->sta == NULL.

mt7925_mac_link_bss_add() only programs the wcid of vif->txq, so the
management TXQ keeps its initial wcid of 0. The mt76 TXQ scheduler then
resolves dev->wcid[0], i.e. the global WTBL, and every host-originated
SDF is transmitted on it. That WTBL only carries the parameters used for
beacons and has no usable unicast rate, so a unicast follow-up sent on it
is frequently not heard by the peer and the send is reported as failed.
Multicast SDFs are unaffected because they need no acknowledgment.

Program the management TXQ with the same interface WTBL that the beacon
and interface paths already use, which is fully initialised here.

Instrumenting the TX descriptor write shows every follow-up leaving on
WTBL 0 before the fix and on the interface WTBL after it; a 100-frame
unicast follow-up burst goes from 92-96 frames received to 100.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 6c603d57e89f..64853fc7f60e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -447,6 +447,17 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 		mtxq->wcid = idx;
 	}
 
+	/* A NAN vif has no vif->txq; its SDFs are queued on vif->txq_mgmt,
+	 * whose wcid was never set and defaults to 0 (WTBL 0 has no unicast
+	 * rate), so unicast follow-ups go unacknowledged. Point txq_mgmt at
+	 * the same interface WTBL as the beacon path so SDFs continue to use
+	 * txq_mgmt but with a properly initialised wcid.
+	 */
+	if (vif->txq_mgmt) {
+		mtxq = (struct mt76_txq *)vif->txq_mgmt->drv_priv;
+		mtxq->wcid = idx;
+	}
+
 out:
 	return ret;
 }
-- 
2.43.0

