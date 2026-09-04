Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11E7DF59
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 01:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788484035; cv=none; b=BI7LdJGuPQzKTtHNb+xJTAP7E4rckULJfP95nqDvz1Qdxx5gZQ0KZIsr79XTFL+/hfSFSFtxhmHp1tTV/sLqyfnMAYEqES6leTKiXGu/W6HzZflpM6kw8MPQMbBSy70StMXCIsKSXmZcJI5js3mGkusgqUhOXrcURcSebrT9EBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788484035; c=relaxed/simple;
	bh=V+whmUX8XzuC2LAuqdzy68aZedQol/qYxrciaKqgL4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EvPuYaZQsq2LDUQViWTqjcf5AcfmJVFSwK7UD0s6f3e7eVAUd+zX1Bj8u6i7ByD9QuvMzUxLzAf2gGtfb63yT7xl6+evKhDD19S02++rM8RoqDaM+r5y2kZ7GEDA3efjhboIwg7CxEvyFx+cl/ItlX1SPn6It2wEyJIh/uCTuuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WV8H7nyT; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WV8H7nyT"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5c79c9f7b54so259897e0c.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 18:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788484032; x=1789088832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ytj1LLsnzT4CFuo0gdf7aqlLxBYXmvU+PDPXyHag5ak=;
        b=WV8H7nyT9lxnqZf6yfJCLb/28geuyivEa2rBlZOh7jwgLCyeVjzMunc0S7vqR5Ug4m
         A+h0INQvnW6ObKxNDCkZ3ra+bKMLfZ+FqHrQGNTISmlKNjraq7Mzqc0bk/w0FxxKNbBL
         AQiu/0iUxFK5C5kb9ZvduQBZy6tUxsgy6G5yaz8WexfQrd6Pw3HE+ekqTCGgZpp/Wv3U
         Ow9dpuK4b0qwUYkahg6bemv7PYqIZvBug8gVlW+e2cC1scQmq/tTGvHahEUtnV2VsL3H
         SAgLXyCRI0fXqIIv0OduTmKEeH19jii/Wwp7Ut3uFSyVV+doHdZ7XeYYd+Ise7k2b3ob
         V/ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788484032; x=1789088832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ytj1LLsnzT4CFuo0gdf7aqlLxBYXmvU+PDPXyHag5ak=;
        b=grzCTx7UvvDJiWKPeChZb/aMNjeZQBIi6gUXYAwFWpPkaP9yTeEeqiBWx7uXCSPzyA
         HUuW8RfobRZz/4CY3t4BXZowJ3TN9FRGsypV6mZPlm/FFaBopuAwUgbiU2B8ZbbYHSJB
         JJuT1p+mO/Mc/s7NdhUoxEudeF9eHsN+ZkIQHNm1/TYXWzB6mgt/HkWKZOQWoL/QeS1W
         Rn+donls0rjwlB2Juy33aJirZ3Hj63/ncBy4TU30S+virEaWSaScFQfgd+1iLCUntDoi
         3z87FtelUWmxPRcsHBTpK9nEbIDlp/9N+DIEh90F3VcfbEpsoVVkQ5zGox+iBUa16n/D
         2ezQ==
X-Gm-Message-State: AFuF++lkQ4SG99U0gbtW59ID7W7ylPgBVQlPD0Pmj6SI+Fzt6XhwKirr
	G/wMZmGSgVbcvniqpGuV+P9KnIsyQuhiBs2oWsBj7e1LyGH2nmFyQTciBO4pmDai
X-Gm-Gg: AYBFou1rYuB5Xe3JrFZmLPjDImcUbz+BcrFYtUT9pqoDEXkLmBnt6ACGApSg0PoygCr
	cOr6Dak0jx2kHNQ0IxPB2nxhv15okiZ3DoczclyCyw1IYLS5PNBfAD6+orewfCaHu8qKoAapCcj
	HLOP0K049RZZB009rM9STJ5ogHa/GXbyloqOF+L6INME37bV4inzU04CkaGSzj1ym5k8iibDAcW
	D1epNgldUeBtQ3FovEyfvfOoBS82xL4wp44zAt/IPUvD6NQphTyWRu0Ob79N4Df4ukssrS+GB9y
	68UUe6EjdatV2SsYl+Evr8VZT9p312RwJc9zi/y5e3n90GfElTTjJ6+2Mnk8kAS1ZAxN0Y1HB5r
	Bcz3hKvdoD1rd3VpryuQkDZiTRcKpcmNxrmEfOLMB5WNtBFhYx0vbWU8FyoNUAViC0kgGQbpIG7
	JXeCZ0St/I4z6Cw1Ink3HEMnAPsd8M85rkXZqIJoHUkKKF2elyko0YRboXDhgm6IOYGTNci5cbp
	dX05AHvENKvoZ86L4VVqlmSiQ+C4aGWj4M=
X-Received: by 2002:a05:6122:4698:b0:5bf:4522:fca7 with SMTP id 71dfb90a1353d-5c7ed3b2275mr884693e0c.4.1788484032511;
        Thu, 03 Sep 2026 18:07:12 -0700 (PDT)
Received: from localhost.localdomain ([190.177.170.24])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c7ec1ef798sm1117875e0c.4.2026.09.03.18.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 18:07:11 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7603: initialize global station WCID
Date: Thu,  3 Sep 2026 22:07:02 -0300
Message-ID: <20260904010702.16306-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7603 uses a driver-private global station WCID for frames that have
neither a station nor a vif, including frames injected through a monitor
interface. Unlike the core global WCID initialized by
mt76_register_device(), this WCID is published without ever being passed
to mt76_wcid_init().

Since commit 0335c034e726 ("wifi: mt76: fix race condition related to
checking tx queue fill status"), mt76_tx() queues every such frame on the
WCID's tx_pending or tx_offchannel queue and links its tx_list. The first
injected frame therefore reaches __skb_queue_tail() with an uninitialized
sk_buff_head and dereferences a NULL prev pointer.

Initialize the WCID before publishing it.

The fix was tested on an MT7603 PCIe device. Three wildcard probe requests
were injected through a monitor interface. The hardware queue head and tail
advanced from 0 to 3 and a second radio captured the third request over the
air. No oops or reset occurred. After restoring AP mode, a 150 MB transfer
also completed without a reset.

Fixes: 0335c034e726 ("wifi: mt76: fix race condition related to checking tx queue fill status")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index 10f2ec70c792..218ec406d2a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -230,6 +230,7 @@ mt7603_mac_init(struct mt7603_dev *dev)
 
 	eth_broadcast_addr(bc_addr);
 	mt7603_wtbl_init(dev, MT7603_WTBL_RESERVED, -1, bc_addr);
+	mt76_wcid_init(&dev->global_sta.wcid, 0);
 	dev->global_sta.wcid.idx = MT7603_WTBL_RESERVED;
 	rcu_assign_pointer(dev->mt76.wcid[MT7603_WTBL_RESERVED],
 			   &dev->global_sta.wcid);
-- 
2.51.0
