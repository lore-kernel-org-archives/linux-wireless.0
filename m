Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106C23876C7
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601196; cv=none; b=SsVkYSwo+QTJ+WM1W0DkJ2rE1kOBN4RuRgCvGWlu41TpuHwN8KTzziku0arBB+PfCkBqim0Uz1pwb4gwxstrGLvRd6vE9X11iTBlxsa3tfAmlqD0JvbxVfnh8Cz3yA67fKanWYf/yMFkBLRoY3jGtPpUpqxY9mRvJCdHG8dJ8jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601196; c=relaxed/simple;
	bh=yiXha/gk8SdONcZqZTxBqFxcrFRizUBpfVADcOlXNXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8MuDjPo9DVxqCtBkkwWujXeT+sfYBKxZd304L5IpjHwW+nJv8wN89KgIxzOBLUJ5pFhEM431J1G0zWIf48coUIuwh65i1rhcXfoVHcH57b2nO5k7CqP9BeRsfJyVwfqooO6n4iFfFgec3eUXFbvjkHY0FHlV+yKFWByYiTdKbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-45eddb6fdccso2168049fac.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601194; x=1788205994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=50u75fL6ptaG9Rq88Gv3OLx35FZRL72ZpUeu9/HT7x4=;
        b=bADdwToYWGRi012MO8ElzRHDKY5PIU2ED82Ooxjj5+MBuWi1JAgawqiUdm3zvdDrq+
         AsrvrPCt2Gl/w+d+pPtoz5pOHT2b+0Mf8+lD2OdoQg9HCVJwSiObzMLBPRVsZEYCfrlM
         90P1KQQlLSLHgXzslepko95Ui9DzNvsTlKNPGLG+V9b+SedOGgPiL4r++RUUkwvrtteC
         yxyChDfLw3p4pwCnX7GDcRdLS+bdPtksy+m/3epHCtRiKHkdzu+rvX/WfeWPXwQspPxX
         NqWg+Im4jkwvLl9lii7SCkus0CO8muYV2jgf/+VDoLtHVf8aqWUU9umzqPqPVewP2PUR
         sH+Q==
X-Gm-Message-State: AFuF++mM4BOiKuom5rLnkYPlx6PpYbmNcCtYQeUdW1cnTCTvJajc2kYK
	ZXks90s25aQEXg2SLCWEoRiT2HC9LUTvI++ZkeWoFjs9nA2HW38oRf1P
X-Gm-Gg: AR+sD134t1nor2rIhSTLSk1etXF1YzXoFDvXjp6SiCP9RZoD+itjTordwwB882ApdE8
	e+giK8xDuFVy9aNKKCUSzlQMue/MJNF3VFnmtW/u1YO9x7dK5lm7bWvEkVhfPg/YopdQ/cywF6N
	7f0RvTs2b/wuJCqc3Iohp46d5lG17nFRcZsZ3VMXr0lULHV2KftBsq7a3fuP3hnM/35m/zjvpNe
	AgLVNZ296eKDsJNCA8lxq8vMD9OInuxYA/2avAoGm63KSeFcamQYY4S3LfOw420uiR2/IAeWM/M
	cJbyYlSBa6SivIuQvidjcDTolz4llQONayh/f0WIauSo4VqMooADSnxiBXEDMzwwTQadWrz1170
	EspwQy+h3e1xHbBkTt2li1gsmwnJyfjAXwR1O1x4B5id3zgV09TZGriV0VsYYJA/Re7MgVdfARM
	zg+4TBPtTSMCYo3vC93XCgXKZjPgm7Af+7jMInoD3W0jbk2esbm2I6/2g2Db1J+4GAqadxBoSrA
	ajkUBeClikUtJHKJXg/bt6G0Pnp6oN4Y9XkyGfWRLZW
X-Received: by 2002:a05:6820:f030:b0:6ae:774d:45ab with SMTP id 006d021491bc7-6b19048e8f4mr886552eaf.27.1787601193943;
        Mon, 24 Aug 2026 12:53:13 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:13 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 06/15] wifi: mt76: mt7925: drop deferred NAN local schedule update handling
Date: Mon, 24 Aug 2026 14:52:18 -0500
Message-ID: <20260824195227.12589-7-sean.wang@kernel.org>
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

The deferred NAN local schedule update path in
mt7925_nan_local_sched_changed() is removed for now; it will be
implemented separately. Drop the now set-but-unused ret variable
along with it.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 5c6598a0f3b6..e6d6af4fc681 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -602,15 +602,12 @@ void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 {
 	struct mt7925_nan_common_hdr *hdr;
 	struct mt76_dev *mdev;
-	bool deferred;
 	struct sk_buff *skb;
-	int ret = -ENOMEM;
 
 	if (!dev || !vif)
 		return;
 
 	mdev = &dev->mt76;
-	deferred = vif->cfg.nan_sched.deferred;
 
 	mt792x_mutex_acquire(dev);
 
@@ -627,19 +624,9 @@ void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 		goto out;
 	}
 
-	ret = mt76_mcu_skb_send_msg(mdev, skb,
-				    MCU_UNI_CMD(NAN), true);
+	mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
 out:
 	mt792x_mutex_release(dev);
-
-	if (deferred) {
-		if (ret)
-			dev_err(mdev->dev,
-				"NAN: local schedule update failed: %d\n",
-				ret);
-
-		ieee80211_nan_sched_update_done(vif);
-	}
 }
 
 static int mt7925_nan_peer_rec_tlv(struct sk_buff *skb,
-- 
2.43.0

