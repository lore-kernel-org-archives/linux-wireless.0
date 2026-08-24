Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDB2387348
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601178; cv=none; b=aCKzVaenkjUcZf6YBvQBIczTLnad/vw3VfgLdWcgJZiW0j28XVTYX/YOyd/pc00LDhxgh6lHD2VgS0NVLJqJ8+gH97CkzV2tVkf+E/FfKCuoqPCxF/+GQhSpeH2XdC9foTCFaN6km+qH8FIgguqPPmfHrLKwOigkuRUxmmISUyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601178; c=relaxed/simple;
	bh=S7b2U5gXh0RSCayCF1Fbv/gc+vDtgUCxKipzgzdYam8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9gLJTXOhowVp0pQc08MBkvvWIU1hJi9xTvF9H80G+oF5B75/9tVRW587zGsAP54fZAxAN+Izn/8cu05LE2/eNhhC1dijllmWZWjfJ64behbe6rDS4C8U/P6aTggrzZwtBUaeSgcFQdhV95WxSr4Z5NwdmJfoefh/c6fbUCsZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-44cf70de986so2708399fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601176; x=1788205976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vJux4Od4WclGRzmE6aM1d/Z4wHjU5GgSWPM1pDjMQUM=;
        b=ahwtXYapIuRCbLFpJabvwe+cX154udLZSjNrOf2TVKaKAQqC/Xl9qADOjzXpUmyRo1
         SPnXCgzh79fzddQ6EqavlSga8OCeb8H8bI87Yae9W/p7s0ku0PSICsbBs96ULldv2Csn
         xOrGEd63qd8lxuCj8jqXTMSoBYVtJHvQ7/aeOl87aUv4Er+VAqUXz6AmuG44cO7ronyt
         AtjW7UDKHaoTIh0ebfPkbUliIpmSA20/NEGhVy+4uH6h67JUILL7Co/jGZjlrlPu6+et
         lrRYxXjhXGPHhdlVcHHXvvvug9GfKxXvZoRcJkqjEgtyegbNAX/ffVbno6YyGGU1iYJ0
         7Bow==
X-Gm-Message-State: AFuF++n6jsFyPeLUcu/+FEgtkq64rGdzI9KX53QY2MVSwcvyCdgk2COc
	K6ELs7xqlJ6R6foDJsEdKtyT4RBWNsqcWqn8VcUwvDfeeEEJTJCaXCWL
X-Gm-Gg: AR+sD12nnGu1cci/GWzFVtNXn6Tr4FH/Y8+4U8aLT8rSAIRrujkwdLWvelprXDXPe8L
	x1QouMQjoBZ03gkZzcwlWziFxG6G27heMd/j1qVHbLVr1hE+Ogo8AlncFNTGUZ+RQmm9Eke1xWx
	JLFCmsfAo0zyRWIj/43PC+gTxuX74xuDHCaW0ksiXdQqAPVA/OLpbvpWxDBQigQb+n0CuDDB3Rb
	vGQ7fH8CG9tqOsmmhUJQbK87wSzEeBZH7gthQpB70t3urVFeAV5XhZsRhQLG/IO3we4EwZdVVr5
	XrmbUyknRLJ18YtsBqz1pj5aRJj29ktWC1dxS8hrlRvweKDvD7ZPUV0AIY4EuhaW/xKEBmjxAmC
	uyEW5ZnZUeJFlfpF7PhQOlxayRqXJ1IVQX0fvF/9+/rMRRF44oh9FoMWFh3t1tdLT2iv3XnbxqN
	4vCWDXelo8wdKSI1RsRJIihh8r7uDFpB/MLDJ1jtGI4KD59BPD8kaS1smAeKXphJlAb3pEn7UGl
	4DpakXo0wUuyLd3iXh5WcjNJVHgqylxmwzqmupCfv1Y
X-Received: by 2002:a05:6870:b3e9:b0:451:9455:d733 with SMTP id 586e51a60fabf-463802da087mr21787483fac.21.1787601176165;
        Mon, 24 Aug 2026 12:52:56 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:52:55 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 02/15] wifi: mt76: mt7925: fix NAN start failure
Date: Mon, 24 Aug 2026 14:52:14 -0500
Message-ID: <20260824195227.12589-3-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

mt7925_start_nan() called mt7925_nan_set_nmi_addr(), which makes NAN
start fail. The NMI address is not managed here, so drop the call.

Also track dev->nan_vif only in add/remove_interface and fold the
single BSS rollback into an inline error check.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 17 +---------
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 32 -------------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  2 --
 3 files changed, 1 insertion(+), 50 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 84b55f008b3d..77420bb6f977 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2592,21 +2592,9 @@ static int mt7925_start_nan(struct ieee80211_hw *hw,
 	if (err < 0)
 		goto out;
 
-	dev->nan_vif = vif;
-
-	err = mt7925_nan_set_nmi_addr(dev, vif->addr);
-	if (err)
-		goto rollback_bss;
-
 	err = mt7925_nan_enable(vif, dev, conf);
 	if (err)
-		goto rollback_bss;
-
-	goto out;
-
-rollback_bss:
-	dev->nan_vif = NULL;
-	mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
+		mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf, NULL, false);
 
 out:
 	mt792x_mutex_release(dev);
@@ -2630,9 +2618,6 @@ static int mt7925_stop_nan(struct ieee80211_hw *hw,
 	if (!err)
 		err = ret;
 
-	if (dev->nan_vif == vif)
-		dev->nan_vif = NULL;
-
 	mt792x_mutex_release(dev);
 
 	return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 70cb2c44869c..ba7374fb7c03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -144,38 +144,6 @@ mt7925_nan_update_conf(struct mt792x_vif *mvif,
 	memcpy(mvif->nan.conf.cluster_id, conf->cluster_id, ETH_ALEN);
 }
 
-int mt7925_nan_set_nmi_addr(struct mt792x_dev *dev, const u8 *addr)
-{
-	struct mt76_dev *mdev;
-	struct {
-		u8 rsv[4];
-		struct mt7925_nan_nmi_addr_tlv nmi_addr_tlv;
-	} nmi_cmd = {
-		.rsv = { 0 },
-		.nmi_addr_tlv = {
-			.tag = cpu_to_le16(NAN_UNI_CMD_CHANGE_NMI_ADDRESS),
-			.len = cpu_to_le16(sizeof(struct mt7925_nan_nmi_addr_tlv)),
-		},
-	};
-	int ret;
-
-	if (!dev || !addr)
-		return -EINVAL;
-
-	if (is_zero_ether_addr(addr) || is_multicast_ether_addr(addr)) {
-		dev_err(dev->mt76.dev, "NAN: invalid NMI address %pM\n", addr);
-		return -EINVAL;
-	}
-
-	mdev = &dev->mt76;
-	memcpy(nmi_cmd.nmi_addr_tlv.nmi_addr, addr, ETH_ALEN);
-
-	ret = mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nmi_cmd,
-				sizeof(nmi_cmd), true);
-
-	return ret;
-}
-
 int mt7925_nan_enable(struct ieee80211_vif *vif,
 		      struct mt792x_dev *dev,
 		      struct cfg80211_nan_conf *conf)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 1dcc888d98f9..91f4e999711e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -405,8 +405,6 @@ int mt7925_nan_change_configure(struct ieee80211_vif *vif,
 
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb);
 
-int mt7925_nan_set_nmi_addr(struct mt792x_dev *dev, const u8 *addr);
-
 void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 				    struct ieee80211_vif *vif);
 
-- 
2.43.0

