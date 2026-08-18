Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3E395ADB
	for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2026 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787018111; cv=none; b=hHIA/Wh0I5UK3ccdh9F2ozYsdxGyv7TmSmeIEZTNNDrcR47BoVJDZ+6Y5oOJuYMU+yAYe8znbeEOf/Qj5EX0S0KOUv6njfLeJ75E4eKGxM+Y4XAs1B3frkv9l1PnXXcV9XDj484cVAOwkS4S5XL5w+ULM62F6YtwotdQ7b2wPQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787018111; c=relaxed/simple;
	bh=hYMqB4lujGsT9M4jEdLrS3NEuiDIXKqTwxIYK6gfydQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HJaQO1e7wLwquXcHEesuLkXgclRhcw5aTfu0bM1NtV1OFTzrhO73dkyAVWnRmnOPG4L8i55Y0HSxCIvnHdI9IEdjiLJI2JBx0UnyAno9HlA7gg+prZThvpg3yOyZdABNPuK9D/cDTzzQL78DOrM7sfclqq5wmCDHcqu/tiSsLQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pmL1iNmr; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pmL1iNmr"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66bee28e978so3777026d50.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 18:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787018107; x=1787622907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qgbYfTaLJzZ/mWrE8M0JIJXKh7owvbsDYdf4//0WP8A=;
        b=pmL1iNmrdJTNm+fpXkaL9WvDVXdKWoNBbNkuc90rhrQGknF4fQ8YD5dv+29M3l6ymW
         XruTz3zZ0szsJKu4w4HTSwR4TPnG7z2j0NHHfwCIbbuwQzjc86MFNHJlTZ6VIcC/WPQU
         BCcYfe/zJqmreq6zPA0eF3aVwQaqaelLMYpe31EemCYaVLbHrqfaypS516oDgKQHtIIE
         J5jgjYeZvgWVLz0V88Gs4q4SPQ6ANKMqsEvUsSHpZ+XMNpqIOKTFRpVtxHw10aZpJki8
         Sl4dclzmy0BwhvopUnVLsS9Nc6HeMUJtC3EEPs5jNwlkDIZnKXu2OsUqEDTpmKQfEZ/a
         xXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787018107; x=1787622907;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qgbYfTaLJzZ/mWrE8M0JIJXKh7owvbsDYdf4//0WP8A=;
        b=b5yihN+VjYwfGTMoivz1+SAMoMn1yUsTY2ckT8/kTetg3AIPgd7HBEB13CCOTbb7le
         oQ2KVYhdF7LYI9h9/k8Wtmk80f5xDhI9KPIcYRPtPSAgkUqEec6fwxHOAlRcpqDkEM1z
         fF4LVLCgq/4aRnblPTAtaTtjQmRdmxskqKAvU/VV/WCGQitbNWNU5BljXtME8BdwmgW8
         FCJxQwRbQBii5aFOlAq8+4f7/LYa/gvXNslsLmN5brm7bJH9j3sgGDOH2hKBSpNPqrKL
         CdlgEJafjaYQ5TsVrMf0KYUueHSXSBYVIpKs71RzguykmqUTl1i/JY4n/axOcjTry/oz
         xeew==
X-Gm-Message-State: AOJu0YxZHXxszf7kAjmVPgfaMSBlQ4Qt/J+KQLQFy7AXwnHSwm16fpPt
	TywD1C213Tw3oSEfSSWS3GBkWQLhYPKKTdnyY9GWF5C4b2YfZTlVT+7K
X-Gm-Gg: AR+sD112HGXY8yzaXrbAYnrkE80/PT2P05btLZ6B+Hovz/kxuEa6HMYJB/aYO5PMQmN
	/fXhjZBb1WxZ+PaOxKoAPzlnvSSzmFfGDAu5j4a61/K5EZg1Kez0KCkXRN0Cc/IC8YoISCI8YZU
	/9XjMPREqLbJ/THjv3QIS9Hiu5boDOnA7Om4lchJl/JhQhRJhY2Oi71e8ENQFzMfWc24r6FFxMX
	Lhi7jWNn7ksLmxmFQebHW7+OCUGY1LMTAms29wHn1mVx09AotRV+HXpCWcQeEybPV/O+/ildNS8
	/eVv17YGGS6G8zHhft1+gOxhHBWCeWRyEfBlTqqIhwu+k4HBJrwVJln76jQv0PTBGrEtnY3AaBT
	3mIssljErSLO930lyovRgx3N4Pkl4hCAMOTHH8e66V2axMkN6xpGoUMCiCciGEIna+B7D5i2bhO
	ZieniBHLNd7steLYI966/S3sV7k1vJzp6YGG/Lvgn8mv2BsXeJV2kjWvPECOCwcYGjUbsW6wurW
	y57zVmm7WwOAwnfdhfuWV3vBXFXdFQ4463gJjLv/2oHQRQY1itnh359ffzQmg==
X-Received: by 2002:a05:690e:1189:b0:667:a95b:59f0 with SMTP id 956f58d0204a3-66c72c826ccmr9003965d50.34.1787018107417;
        Mon, 17 Aug 2026 18:55:07 -0700 (PDT)
Received: from tux ([2601:7c0:c37e:2360::6219])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cb47a6f8dsm1598940d50.16.2026.08.17.18.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:55:07 -0700 (PDT)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jeremy Yu <chengwei.yu@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] wifi: mt76: mt7925: Remove useless condition
Date: Mon, 17 Aug 2026 20:54:40 -0500
Message-ID: <20260818015440.875703-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The condition (master_pref > NAN_MAX_MASTER_PREFERENCE) will always be
false because the variable 'master_pref' is of type u8 and the macro
'NAN_MAX_MASTER_PREFERENCE' is equal to 255.

Fixes: a5487a6824068 ("wifi: mt76: mt7925: add NAN MCU helpers")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index d260e803d056..8d13a42b72a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -255,9 +255,6 @@ mt7925_nan_mp_tlv(struct sk_buff *skb, u8 master_pref)
 
 	mp_tlv = (struct mt7925_nan_master_preference_tlv *)tlv;
 
-	if (master_pref > NAN_MAX_MASTER_PREFERENCE)
-		return 0;
-
 	mp_tlv->master_preference = master_pref;
 
 	return 0;
-- 
Thanks,
ET
https://github.com/sponsors/ethantidmore

