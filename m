Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2886B351C0B
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 05:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787463465; cv=none; b=hZRs1XHX+W3EKEFcip3XquhWxwj1k4kiC0MA3/RQg9lQ3nJoftQaOeSM5GbzMJHkzfFCIcHKIRsyoUgEUwFxlL0+FSSuD8Q786IjdRg7YnJznX2kFB1uFwHb1uE/iU9B9WnTzP8wFFLADCi/QLUCp+LP3gl0nSnSgY6REgtXFbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787463465; c=relaxed/simple;
	bh=dysMJuJcvCi8JjYa1juREuHTUe3tKNXanZFbtV29vTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a0YoN8jDRaEu3GoRzmZQEfUL/gYD/mnwchOgtkhSvwaQvvKJ/jihv2cluLGChYAJEQIGTfhQ0JjutXJVks5Jjn99QVM3CBz9wBqr+C4KxufABBwomMzIriWt97/IDlYsQL/v/RYBTmVfYkAN2+IJdgXCKE6a/HKAC1HT9epoNpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mF0VGtLX; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mF0VGtLX"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e58034d05so1932107a91.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 22:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787463463; x=1788068263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VI+wC2ZwURtRw83o8Q0TT7vjqPfR+zB6SD6dpsg4Vi0=;
        b=mF0VGtLXe1rjVuARq9oUUysl6Dv0nGB5alKngl5TIOEVD5IQfxoT1WHhYzS36ieuQS
         /4WxkjFEqma8xlOrMFsNQHejSQmeniSK8enEb86YIEVijrraykkg+Fckv4x9ngXJeOed
         VDvn1klqk+JnJaHxbx5yZXVo5BHvr/L1fcz0gFo2aOE5990JfrpfmFOin4cFlW5vxRG9
         Ng2lGnImvt+vv1VqxAAZzUxUUh1EajQxSJ6hN5WSxHQASFWBUS4VSAVEkcoYFeAJc+62
         Z5AUnHMP/fFzkYafgIHVh55BVduiFPOdvwPRnEKbDP3K8y1itFt9mKwDF1eHbp4Nn1VK
         asjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787463463; x=1788068263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VI+wC2ZwURtRw83o8Q0TT7vjqPfR+zB6SD6dpsg4Vi0=;
        b=Ym/ufUyMi+1kOFPCF+SZmSrpCtvPfJywPDNT5hhwpHLWYMqOCmdoKVD21S8L3Ykjo4
         aJ+u5pCnFZfeiNFpHE/IIw74scaTEQc3t3L2hX5p4Tig6ZCVnIQvc+bwbnMv3vArrJ9B
         D6QaVvbUEAeQ0wDft7gMKN41V2y5vXiSvt8/QhltGbjtLRB2rVA3iJ1spZDQu+rCVrmp
         CAqVwVjkctZcnuqfk3EGGstcjTdm/ZFlcUx+tWBZOq0EOv+HK55nzB0aYGN5glWi5Yc3
         wsAqPtEYoZk3sEdASbXACznWbB0VC1KxBOY8sGimaIX4qneXTY0hEIeG/LtAFtlCuGxs
         YqKw==
X-Gm-Message-State: AFuF++mmmy7WlH7pAfKUtFuyfaAa9DCAoNxAhk0H6lMhmmD7LlIcfkJl
	HsqQGVS/nhRWYTIlFcnZT1SOfPKZZovV7vKHcxNJGFgptmrXbPQtL9FZ
X-Gm-Gg: AR+sD10y4c4NSby7tSFN1mc7cBU8ZaBZJ57eOZI3Ft4Ynz9Zo0KxDDIZUTEepAjeCUb
	uHV8KpTZ0zUZixwxQEtitUbCuKG/lZ/OdlARyrb6Bmqi3bPWezIpaXnep7CpsdthM7qXKEweoKL
	GtX8NJ4dBlX3aWbRsKKf7wn+oqLsiOMcn1VKUQsmvt3AfLSvT81H5m8r0M1ZoEoyHZzJKFwK8yO
	Y0ZHUZ425f2/wN1SkupByYS/qA6I/1ENsW3bXwi85i67xWZZXDX/3UmG3L8FSDqPMl1uKNa0eMR
	sLSsYmvEETtdu+LehVTqfEHLhR7hzKCI7q4UfxRQL71B82D82YimPk6tPJPO8MKH5aiE3HmHIf6
	IXhEImHEHH7c73w24naUCx0z35jd4qXfCdCLhH2TTdHMRT3zE8nbEfVyQ2KI0/pu81GQVMlDiKx
	eL/WZGjW9M3Pski+qRdt2KB//JQJKY8/d0PcruhlhWHN9Wz3h366iL8bElE/hiYWenS+ksjB0sd
	O5ocnnTJXGwG+yqT4t+1wPa
X-Received: by 2002:a17:90a:f945:b0:38f:aab1:5148 with SMTP id 98e67ed59e1d1-395c35b75efmr31305716a91.13.1787463463365;
        Sat, 22 Aug 2026 22:37:43 -0700 (PDT)
Received: from abs.sf.dndws.com ([50.35.86.68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395e4969fb1sm4884832a91.1.2026.08.22.22.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 22:37:42 -0700 (PDT)
From: Tao <gongtao0607@gmail.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Tao Gong <gongtao0607@gmail.com>
Subject: [PATCH] wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout
Date: Sun, 23 Aug 2026 05:37:39 +0000
Message-ID: <20260823053739.186748-1-gongtao0607@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Gong <gongtao0607@gmail.com>

Correct the definition of struct mt7996_mcu_wed_rro_ba_delete_event to
match the 12-byte event record layout observed from firmware.

The event TLV sent by firmware is 12 bytes in length rather than 8 bytes.
It contains an additional 4 bytes that appear to be wlan_id and tid.
For example, a captured batch deletion of sessions 8, 9, and 10 (TIDs 6,
0, and 1) shows:

  00000000: 02 00 0c 00 08 00 01 00 06 00 00 00 02 00 0c 00
  00000010: 09 00 01 00 00 00 00 00 02 00 0c 00 0a 00 01 00
  00000020: 01 00 00 00

The previous 8-byte structure corrupts the parsing of subsequent TLVs,
leading to unhandled delete events and erroneous session deletions.
Consequently, clients that create and tear down BA sessions in batches
(such as Apple Wi-Fi clients) fail to properly clean up stale sessions,
causing HW_RRO to be lost upon subsequent reassociations.

Fixes: 0f89bf58efda ("wifi: mt76: mt7996: add wed rro delete session garbage collector")
Signed-off-by: Tao Gong <gongtao0607@gmail.com>
---
 mt7996/mcu.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mt7996/mcu.h b/mt7996/mcu.h
index 71f87da0..922fec17 100644
--- a/mt7996/mcu.h
+++ b/mt7996/mcu.h
@@ -284,6 +284,9 @@ struct mt7996_mcu_wed_rro_ba_delete_event {
 	__le16 len;
 
 	__le16 session_id;
+	__le16 wlan_id;
+	u8 tid;
+	u8 __rsv1;
 	u8 __rsv2[2];
 } __packed;
 

base-commit: b2704cf5a4068b672bf47ad5bf6b4802b6770a90
-- 
2.54.0

