Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DEB1A6817
	for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 20:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786913492; cv=none; b=Vcki+cAWUD11PLBjhmyRa3AUbCV2qrQaQf4TvYlVB/Yw0QLs19yOUOZLMjAH0hAOPdFGtAxq6coPCKYIGF4mMd9wXL0qJN/ndsFW1RnMlWizdMyXN5Iv8Nn/z/9tKeS9F035/zLoDvGAeSN4JdsZJNXKWm94UFPxyLlXnlfR34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786913492; c=relaxed/simple;
	bh=Vv5wzzgdbVHD4/D1Tdz8KIHUz0hiBF1y0K25Sl1rVHM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BLnjWGQVmEkz7RsceksYJ97/fFWwBRzuMmPuFAW8HH9swJP/DDhcWr4xbzy/4gFmT87JEPn3uewcgB7nYyetsZNMrz6eOj6Q+r0YiAd1o1LzFKQ+UqG/Ktn+A7q3i4D9z7dd+K9qkQM4YHW/va3la+3M8e4I+29wrr2Nzk+6n78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+epE9IC; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+epE9IC"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso3335920a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2026 13:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786913490; x=1787518290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ovHSvSxxVB2ycJhuBd+B9EB5pMmf5qs2DOJiMsLHkw=;
        b=J+epE9ICwIjr7IrrHNEiOe6Tk7g4AuwryLdsDG0nApxU2QMB1I6C+CZVlm6Z8iad+H
         ykms5J9d5sGm2/NwZxClgbuVIQoY8NOfRe+PyDUTMkzLTufLhTzI7YsDAjZLRPdLa5WW
         hKnpHE0CFJHG5DSegNRgRtwCDEM3SVB60X7AJcyzwK808Ow8LZzj2D/pzg3xA6n0xkVW
         lF4g5HG5YddMRUn6+kCW6A9KAxFygzZ4hAH97hiUVkmKyBQ9S8gu2UpzmdnIYT8x0k4r
         oFKTjJf3P4adrosyBaflQN3k71iwBktIpNMOa5F9MVt1ZuyU9/yfkYxW943iUTeyx3nw
         9Rxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786913490; x=1787518290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ovHSvSxxVB2ycJhuBd+B9EB5pMmf5qs2DOJiMsLHkw=;
        b=iU8AprDB+Hi5V7uF+VF15p+fPr/I7ovORxYWtuFWWw+F4DYkhm6Ud2Cqzn13UozUt1
         k/LuxyPolm6M/oumX4TfNkLSiVk86FDmWuZV4hqlaOo/Kr+8CscOP9VcNkiL1jAKW3bx
         wSwp7IeUybYqWbNmg8DX9LAe2X4sYFbQ5LkI0z7itvvKuOIujy8B78EkTydAJG+/fRN7
         cLoXsSmBjqq2F64f9qxA3NT/0YsC3/sEVxc0OppBPT/W1s+tSp1ZlP/VuviGW/H+fPJd
         OvjsCUyFLdYVPeiLiA0JlYYYvsSCWWpyVMNNdQRNrxinQeUWB2mp1+Ezu1g/+/ZM3RsO
         j+eg==
X-Gm-Message-State: AOJu0YwE7Y9NP/g3G9rgMcvV8ckhq+1JOQVXjot3mrKQIfDYs+wyDUx1
	ZRhFSLfK3/WHco9kHP/cGx4UhKrGAhJsiZ7TMWQDv8wmR6qGYo8QGwj3bcrTww==
X-Gm-Gg: AR+sD10CbFdjGUwaWgLPO7nhaQXpM5eRMKv49kCwhMO/+Bxgk/mi2+GJXoe+gLDVOTr
	icefgWSvneIbNXqEEdGNcJruNH/6UHnMnPmGe1hjsWnaYWFz1q7DS1jgOZPLOMi3nwaJhprLAfF
	73IJoTnBcuGfrwpxMTqLSWlGFDpF31oVZpg6fiq2bvhwVgTcDF7wyEjePHqqT3v+Pyay4aALewT
	qKXMBzyfbCPeOsh2PVyI7QbgLvk85WL3LVMZ2aN+NtRvyNaX0YF4z2QpnJSEs7PPLzo85eAVc35
	4BW7nFOHCGv+5XYkyz8xFXdzZjgVdYuKv4rvkCvAoEqqySBpA5Jz4p96NjhAwN4i4Nb5iO3V6FS
	Pc201fuswYV0mBm+pvXWLx2+cm81sIP4vsd+hy9+nTkxrUSYFG46yzr/Dwk7/INTnK38HkWQuPG
	7+pLayfVEGetN7Kx6VCokEOby7gfHW3OeZFyon4jyjdW/n0Zghnz1UrZS8k1UQOPR9wgdtL3Dqy
	B0P1CbPd/BbtafqSmBFFQlyAkc0N3Czwr8=
X-Received: by 2002:a17:90b:5805:b0:380:105f:8ffd with SMTP id 98e67ed59e1d1-3933b90d562mr21509902a91.16.1786913490318;
        Sun, 16 Aug 2026 13:51:30 -0700 (PDT)
Received: from abs.sf.dndws.com ([50.35.86.68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531e84118sm2519804a91.5.2026.08.16.13.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 13:51:29 -0700 (PDT)
From: Tao <gongtao0607@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	openwrt-devel@lists.openwrt.org,
	Tao Gong <gongtao0607@gmail.com>
Subject: [PATCH mt76] wifi: mt76: mt7996: skip HW_RRO for sub-64 window BlockAck sessions
Date: Sun, 16 Aug 2026 20:51:19 +0000
Message-ID: <20260816205119.1793197-1-gongtao0607@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Gong <gongtao0607@gmail.com>

MT7996 HW_RRO (Hardware Receive Reordering Offload) seems to be
architected around 64-frame minimum BlockAck bitmap windows. Enabling
HW_RRO on sub-64 window sessions causes it to lock up internally,
stalling hardware RX offload on subsequent associations reusing that
WCID. This was observed on the W1700k with Apple Wi-Fi clients, which
negotiate buf_size = 8 (TID 6) and buf_size = 16 (TID 1).

Bypass HW_RRO for RX BlockAck sessions with buf_size < 64 and delegate
them to mac80211 software reordering to work around this issue.

Signed-off-by: Tao Gong <gongtao0607@gmail.com>
---
 mt7996/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mt7996/mcu.c b/mt7996/mcu.c
index 176d71e8..f021c4b3 100644
--- a/mt7996/mcu.c
+++ b/mt7996/mcu.c
@@ -1500,7 +1500,8 @@ mt7996_mcu_sta_ba(struct mt7996_dev *dev, struct mt76_vif_link *mvif,
 	ba->ba_en = enable << params->tid;
 	ba->amsdu = params->amsdu;
 	ba->tid = params->tid;
-	ba->ba_rdd_rro = !tx && enable && mt7996_has_hwrro(dev);
+	ba->ba_rdd_rro = !tx && enable && mt7996_has_hwrro(dev) &&
+			 params->buf_size >= 64;
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);

base-commit: b2704cf5a4068b672bf47ad5bf6b4802b6770a90
-- 
2.54.0

