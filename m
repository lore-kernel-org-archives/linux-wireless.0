Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EF847045E
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 21:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964201; cv=none; b=j1UkbT6O3dHvVtu0q0QqY/mdghm6+zJk6DKC7lkbEbQ6ZcCzAE9f8y4981pCyeeUuhQACMOjiIeseapBvR2rQc7tnryl+rwzm5/gRbqO9EQsuGQEctBCHNd1gg2npLdaqdErXusluvXntZtoDP8XGOq38PRXXhpxudOuWOI7dOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964201; c=relaxed/simple;
	bh=j6D8ImoteM7kDuq1VRILlohiwkKfmrlM2XD9L0SLgL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FbjwC43O6KmvOCYX3+qNKgSl+645jBSyzkDWDY0AJfCJ8j4Z8BDN2IXcUXP+jgnMOfqwewfJvtDAYpz3qgRev8coq3efR0hzVBme7RoTxbZBvDQtQcjJw+zigGLN731t6pFM6kjPll32/I7DCO/Wa2PhnWnNGeWB/EE+RSf3GdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bepM/hld; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bepM/hld"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca80d708489so220492a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 14:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785964187; x=1786568987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NCfLIwLQXd+ehjGtddX19Kp+kZQI1+gPoAz7ZcG61eM=;
        b=bepM/hld3cwSizRaDp11fhZZCy5k3JTr3yOzBhHPrq7AEV6mpPwdfvAlWgs/2mdOqY
         r8QVZCDUcGJ6BcFQoVhcdzaNG1WaAR5gXxMBmJYn2ikm36d4EBy8+hDStxksz1hzCstG
         eCUp8pKO8ZvOJNza78+yn9Li9AG7dpn8WuyriuWKdicFSVExEyhymGZPap1nbQ0l8qVB
         XtQtoKXh/veoQA9WNoBLDCkO18qRSxxQLIWfcBOM/TzUIm2T3phhmD9XTDHdQdNaU3fJ
         KaP2R7ofz2OkPiLUvMrGsM0/l80GPoW/7u2rkAZHepFGeCF5zB8FjY9Ucjy1LTWU+ES+
         QwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785964187; x=1786568987;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NCfLIwLQXd+ehjGtddX19Kp+kZQI1+gPoAz7ZcG61eM=;
        b=FZ/QHklj14P9bPVYpgFzIXTSa2iMbHZMJCX0ea522TGAqU+E4nE8zJrJlEBCdCx+Uv
         yJ1KFdL+d82Cz8E4zGGrfwFu6MXS3wg2LU4CBRFX4ccxoxP4xrwbnvav4p2MyoFO6llV
         rFUs7Fp08wUCd6MFOE/1FyHbOidTIit7ERKZDzWN0fYsOpsTNvtrRMGFxym3g0msU6ie
         CIyLG8Acxy7jUg5h5cC8Fet8xA5ks3F9N5HA8QJXkwJ4swCxvSWB2PM5LFBEtotCXlqK
         TtIgS7FAgsY0bKBntx6yIo6Cl7HE/+jOE0os0bB33AN3zdH+Um4hsCLhhVs/z5UZzUz4
         qQvA==
X-Forwarded-Encrypted: i=1; AHgh+Rq10TZIdAHSsa5AgF6KcN/qBykMPvft2I7ZrQkmOS1kQV0OtJw4E1busEfJWMbXc3/KXWzcwGQSoTNECbRymA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcvYfNRmsqBmIMQ8dXWy1a6OeKy+Sw2t5nB1O8k2puRiU4+eeA
	53GcvvaL4kRFt4WaTEqMy21SWEUKdgEkWfQ5P18LXCi9X3i8Dx9eijeo
X-Gm-Gg: AR+sD13BX4m5rUEYdiX8ylNZqFnFQ7m/6c96QDxx89UXNFxCOXGSHki3eMYpsxaPOyl
	ClIEbeQXg38+EWZOWsjZo9p4G6+xHcpys/ZScpwygDrLYxDUDKv1uzxmIpNCtomhQrjih/mWSaO
	nKVkoYjSEcjNE0QiqcQbnoTheoQKpUImyj/47m6TY8E7h85o141fKVO7ZPoBx00eutKv6rhQLgi
	iq2prKFtiq8cq9KyS/HFAxfjGPhejs6jZH65f/2x19kuWFYFQvRB5gwOqx2V58D9C4siB/McatT
	GFqvtei3L+cYO8F/TEF/X3t5/oqWcufbIYWbpAiSOWI5Mj1CwIDMkoHX450SaDJyrDfS3ZxZp0O
	wfQ5++/tQIGBR4zxljwa9a2XKPCCBNinRL6khAUWHYaVq2c9AV01mvZqkguC9MIlPsaM9BTE3QW
	GWv8b2l2bztixPnqonZ3m4Fw5zKApapvY/M8GyfnxGLBHzjqBzLafxIm8JIg==
X-Received: by 2002:a05:6a20:7f91:b0:3ba:d7b0:fcac with SMTP id adf61e73a8af0-3cb9c0a2040mr2070221637.5.1785964186427;
        Wed, 05 Aug 2026 14:09:46 -0700 (PDT)
Received: from eos ([103.89.26.200])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fca2e8ae2sm16914896c88.0.2026.08.05.14.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 14:09:45 -0700 (PDT)
From: =?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?=E3=82=A4=E3=83=A0=E3=83=86=E3=82=A3=E3=83=A4=E3=82=BA?= <reza1234khan1234@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] wifi: rtw88: fix out-of-bounds CAM write when key table is full
Date: Thu,  6 Aug 2026 03:09:41 +0600
Message-ID: <20260805210941.75136-1-reza1234khan1234@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In rtw_ops_set_key(), when the CAM table is full,
rtw_sec_get_free_cam() returns RTW_MAX_SEC_CAM_NUM (32) because
find_next_zero_bit()/find_first_zero_bit() return the bitmap size
when no free slot exists. The bounds check compares the returned
index with ">" against total_cam_num (32), so the invalid index 32
passes the check.

rtw_sec_write_cam() then indexes cam_table[32], an array declared
with RTW_MAX_SEC_CAM_NUM (32) entries, causing an out-of-bounds
write that corrupts the cam_map allocation bitmap. The write also
sets bit 32 of cam_map, which overruns the bitmap as well.

Fix the off-by-one by rejecting indices >= total_cam_num.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Cc: stable@vger.kernel.org

Tested on: RTL8821CE (PCIe) on kernel
7.2.0-rc6-rtw88test-00059-g0d8395707651. The patched module loaded
and associated to a WPA2 network; ping traffic passed with 0% packet
loss. Reassociation and disconnect/reconnect cycles completed
without errors, and the CAM table (debugfs dump_cam) showed valid
key entries. The CAM-full boundary (28+ pairwise keys) requires an
access point with 28+ clients and is not reachable in a
single-client setup, so that path was verified by code inspection.

Tested-by: イムティヤズ <reza1234khan1234@gmail.com>
Signed-off-by: イムティヤズ <reza1234khan1234@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 766f22d31079..3b6302f14de0 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -597,7 +597,7 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		hw_key_idx = key->keyidx;
 	}
 
-	if (hw_key_idx > sec->total_cam_num) {
+	if (hw_key_idx >= sec->total_cam_num) {
 		ret = -ENOSPC;
 		goto out;
 	}
-- 
2.55.0

