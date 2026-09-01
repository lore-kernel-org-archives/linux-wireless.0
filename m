Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389413CA49C
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 19:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788291869; cv=none; b=rUx7FsWX3XjB2f5Ca9LA/HAd43R5olhivsyD8xrps12/f6Gk+SzxeEibGY3P8LaPnQWHtfd/jBhDbbVAO0A1zfl2ps1UA9sR9UiVKo1Q8t2AGdd/9N9xB266GnTtDOrhU/FiXtaENvgFTE7/02c01K1cWpDnHmxYo9LlG2oFQZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788291869; c=relaxed/simple;
	bh=jzhY2DH69snmR3VNygKSckBjSkjbfJpBuIDf4hM4GUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKl88J6dCnJ31SJYAfDhcbgk7RPpM2wFXwhhFDgmJGjKXpPgLaxsPdyKsdCUpY1sTLaIQQqQRe6B2rbldWi0O567sjsLWD7qqEKectne07dSuNdTZf6LglDpHjg10U171VtzL/rbWyWD1UUfY2tDYvKXh8ZA4/JTi7dt8n7ANY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dro0c+pG; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dro0c+pG"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so332762a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 12:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788291867; x=1788896667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjRjrMv7qS/HayGfbZIGn5bUAwBVTC8Av1nVxt4MqRA=;
        b=Dro0c+pGqusY1zuLrlOHW1aoWRDFh1WNPJEXqnaTgYbqdWNe/UvpNIiCVqfWsDXn91
         x4Pkvy0XoOmY3FDIoV2nhR+VSHVItxtTAR5iK1ZZ0WcxY/yjVeTo1kQjssuFUVGSs42I
         xukkWQYXI8erHk8caK7Ut2b8LPFFlA+aBNlkFPjJvxMulV2TEzFoO3PACULfeEKdeFDV
         x3CpYOLUVJUt08YH6OyhBxCp8F4dPs4nGH8WM133lVM2Cnr7tcRqEYN+388FFZL82lbI
         2Rj+gfC26mL1OaotGHD2S2Gv2+1O9L7/qhgUHs+LSxxVU6vo7qo4tkpdDt/99TblO8pH
         X62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291867; x=1788896667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xjRjrMv7qS/HayGfbZIGn5bUAwBVTC8Av1nVxt4MqRA=;
        b=gj9B0aM6YI7E0hDbevJdEmECwQspnnGH/pgKSZs1xMwleQB3QBJk/nZbbEdSzEFWxw
         xweUyI5iWKG3jYXoFfotYHWW8zGfhK9R3A5+hJ4QoRTmRfd6FSmODr3E2fqrGXsORxqH
         1IFNWfh+VSvAEkkn6OmFEpF8y4yMIDdSd4zkk1tanaacah5qxhRUnfV+/0LexBf8l0z2
         JkaitobOkp8bWel6GmDi/U5hlL0xn/lBV63RfeUAlG8N5DAO6vvwA1VO9Rx5RfJTg3Rc
         6hmsbh5S3O3WN94/d59v+NQUcqnmVdECjYBrp/Iii4qQyVExEJghLVN02oQaO2sA73Zc
         ZFWQ==
X-Gm-Message-State: AFuF++mBTrIs7ww+55HJorV7VY41348tFN9VlTD1joV5Pkx7871qY98e
	6knHWw6SllyYhEp4TxZhwB5RHnbPxlqQCqHzcAy3ElHSvsIkx+p584D0Skq2lmZZ5Gw=
X-Gm-Gg: AYBFou18DRsRzmI14HlBclmNVeQevFfDAUN2RwuiNiJrHhoT9/oCjAa9SpASHicUjfb
	SFBAWl9uTZV3E7xilhnPITkXvCwxfcAb7eBjgAQkQC0u+ygOG0+B9PAibpkk0izMi2tp2v4yscz
	cJe/z/ls6C1QJ/K4zbxqC7533v8jBWCveuP9nnHP4JPbW0Jsj6+MpCNU4FMRyToDiyB6ygAonpx
	9PTyVanoDI9RG8rfFxKLfc0OjTZyNfL5ivII/ahimZPtD96TK75l8KXU3zulHaZSzyhC7XA3DsB
	ZsRQOi8ZzXcjYqyvTZpIdVvWx78zdp24S4dFw3pnRbeK7MBAU+K4BwPVjDDjZ17zyprnLae/GS0
	oQ5IBs6mXDZnrrMHi/bGSHxK+zWqFiWwv+oV+R7//wLupzA+Ns+yT5BG3/jGeKK5sh66NCsSi/s
	hCzzgpuXFkKfQJf+Z+BFSgbKrYnhrREj3CfiMje/Ll1LcRsMS0x/ZBHaNGsJCrarlaKp2x/22+q
	bd6p90B6GvaUlDOBzCxVhZOTdCMGKDSMjs=
X-Received: by 2002:a17:90b:2b4c:b0:393:19a3:4f1 with SMTP id 98e67ed59e1d1-39907b651d4mr17790882a91.6.1788291867400;
        Tue, 01 Sep 2026 12:44:27 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07b79cf9sm309019eec.18.2026.09.01.12.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:44:26 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	Valera Kozlov <valera.kozlov19@gmail.com>
Subject: [PATCH v2 2/2] wifi: mt76: mt7996: route disassoc frames to ALTXQ
Date: Tue,  1 Sep 2026 22:43:38 +0300
Message-ID: <20260901194338.110-2-valera.kozlov19@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901194338.110-1-valera.kozlov19@gmail.com>
References: <20260901194338.110-1-valera.kozlov19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If AP sends deauth or disassoc to a peer station while the station is
in power-save mode, the frame may queue in the normal ACQ and lead to
PLE hang, since the station won't wake up to receive it.

Deauth frames are already routed to MT_TXQ_PSD / ALTX0. Extend the
same handling to disassoc frames, and additionally route any frame to
a station that hasn't completed authorization (tx_info without
MT_WCID_TX_INFO_SET) to ALTX0 in mt7996_mac_write_txwi(), clearing the
flag again on MT76_STA_EVENT_DISASSOC so it gets re-armed on the next
association.

MediaTek's vendor tree has an equivalent fix, though written against
a newer MLO-aware version of this code that doesn't apply directly to
this tree:
https://github.com/mediatek/mtk-openwrt-feeds/commit/ed6924828479aaeadbb7c402ec390df26dcbd8bc

Signed-off-by: Valera Kozlov <valera.kozlov19@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a9558381ad91..decf6ea15777 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -932,7 +932,7 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	} else if (beacon) {
 		p_fmt = MT_TX_TYPE_FW;
 		q_idx = MT_LMAC_BCN0;
-	} else if (qid >= MT_TXQ_PSD) {
+	} else if (qid >= MT_TXQ_PSD || (!(wcid->tx_info & MT_WCID_TX_INFO_SET))) {
 		p_fmt = MT_TX_TYPE_CT;
 		q_idx = MT_LMAC_ALTX0;
 	} else {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index dd7a01c02a7c..32ba5cbe5062 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1422,6 +1422,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				goto unlock;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
+			msta_link->wcid.tx_info &= ~MT_WCID_TX_INFO_SET;
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
 				mt7996_mac_twt_teardown_flow(dev, link,
 							     msta_link, i);
-- 
2.53.0

