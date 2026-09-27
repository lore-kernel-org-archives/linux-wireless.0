Received: from mail-yx2-f41.google.com (mail-yx2-f41.google.com [74.125.224.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AA2231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543003; cv=none; b=c1bHiPeTtWJGyfTT+n62s0o4mn1BMkS00/HFpfxENRJknsdQpODwipDSvbUJKjI6E5nlxeRXFVg7YR/W0V06oNuKDOfyLg5Twd2xMkWY9mjJtD9pdm8fzZU4IdWSvfMcP4blg6MDgIwjGLaxlImhmGDaKn3VsChYmzcR4QftvgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543003; c=relaxed/simple;
	bh=ymg97HhM4uQNO4bW+3XTy8rdmLuv1qcJCnAOe+wk5RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJBGIbwgZtaTV7HXlvJHjbFfiUFOkqBFVge0QxAP7gXjzc7WVRjxdY6hsQzIBVlOPE3/dLsuEZ6pdSPkEdlylwk9obo2KmoggDUz2H6Gj3YX3FBy2AOB4wGbK+lGVXP5oUsuvTcmjv9yx0EgNChtDFuC38PJp5dV0nKx0DKKxuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f41.google.com with SMTP id 00721157ae682-8a7c33dbfeeso22085237b3.2
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543001; x=1791147801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yHU4nEGW7+kHgbtl043kdQcpDp7Ms+JDgnl3vA2EDIo=;
        b=uTL839KnMD1s8vBFpaJBtpOlamy2Ab7xDUIVYWbrBz6LY93hBJAxJx+JVMbP9HYyh5
         5gpFVzxkKJlmmreviDASaQYytG0f3oHM3FjENWrkND3KZAYpftrd7e8eTrDq7yiXwCyL
         XXMSozYpNGDzxtqQNBn35eydoYAndlwZC6kx3kjtmqCqoFOIG0FA43q70t4SpF10dtSO
         oYYYexQg+hw018e7tUW3FjQXVl/43WsLKqX8JjcBdrB/AdNp8rP5t/I2rSqt5lrA1sXe
         9bCiXKJB7ohchoOcNdC4wsaM8ek62SIligw6a9Gcqsl55pjcBO2LmIH2dahCTbOYLGCR
         GQSg==
X-Gm-Message-State: AFq9FYIZmDRIsOon09WB15buaOm2plCldZDgZAOMMmQioxC0PPFl5xQW
	5avn38KDR79jJ+jSbKbxGI5rKMMifTu8B/lKGmpGjDomxmCmXOF+DRa7
X-Gm-Gg: AYBFou0umjFEjHKb5Pqj/pzOT+Ym1FGogTNq+jRQjuagHjgRkrApWy9HTMOX7DfrWoc
	IqECOa4Qjegtw7buuhcBRgNYri+tKZAUOG95/ZPZkRjT9lcrCzfOLGGomkWXZJMAXtRJB5Ju33M
	4lyGFUVS+lksA76QoFrJvJPxlFdB9pUWmL74aH5OqEe+M//M6qTjSNDVooe3bFvN9EvSsaRXPWI
	lsvXuhmS8wj5Pu7VfME3k37Y7sPKOo6e2hCbueY01IUx/KvHMDpDuamHl13UzzOAR0/JeMwkRCs
	qWjjb+CAXtp2yIyrXaHOQsYNYUtgfDoXGonAuRtcuTpCY5+P/Gwr17kYbydaeLlueA/ZVrHaiyP
	vV3uyGI9zLPQPGcDktqcZsNV/ob2uD7occ0bi7IyQoVMwXeE5EM2makmJx9d83U3k6CfiBw82/y
	Ky5RKvNYJm/ybqE4ZaiuF4LaPJqCIBJ28IgUvbycD5LpZkPUNLrsk8ijZAUgDbYwxyHHFpFSRrS
	RK3s3opLPvdOfKZhJG4ZHgDDkgYALnm1e/nxESIgOFoP/CidP+c/hcfID2Hob2MMzB3iQ==
X-Received: by 2002:a05:690c:a79c:b0:8a8:8456:a970 with SMTP id 00721157ae682-8a88456bccfmr20134317b3.68.1790543001580;
        Sun, 27 Sep 2026 14:03:21 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:21 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 01/23] wifi: mt76: mt7925: make NMI address TLV tail padding explicit
Date: Sun, 27 Sep 2026 16:02:43 -0500
Message-ID: <20260927210306.737669-2-sean.wang@kernel.org>
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

From: Chengwei Yu <chengwei.yu@mediatek.com>

struct mt7925_nan_nmi_addr_tlv is __packed __aligned(4). tag+len+
nmi_addr is 10 bytes, so the aligned attribute already inserts 2
bytes of implicit tail padding to round the struct up to 12 bytes;
sizeof() is unchanged by this patch.

Every sibling NAN TLV struct in this file (cluster_id, sync_rssi,
peer_rec, map_sta_rec, ...) declares its tail padding as an explicit
reserved[] member instead of relying on implicit compiler padding.
Make mt7925_nan_nmi_addr_tlv consistent with that convention, and
give the field a name so it shows up (zeroed) in TLV dumps instead
of appearing as anonymous struct padding.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index d81d84a222d9..297c2856578e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -346,6 +346,7 @@ struct mt7925_nan_nmi_addr_tlv {
 	__le16 tag;
 	__le16 len;
 	u8 nmi_addr[ETH_ALEN];
+	u8 reserved[2];
 } __packed __aligned(4);
 
 struct mt7925_nan_avail_ctrl_tlv {
-- 
2.43.0

