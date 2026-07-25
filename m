Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32C72D0C62
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785005915; cv=none; b=XyXiNJpBseJWyT7Zl/+vv57VnLLlJxINF66qASN7XPntutF8AkhNY34wc8gs4HzlVMV0MxnP2Y/n8OxsuXVAy60hW+lTuf1wNJjeN6CDLbM24zKrgfxPkmWEJ9aZ8qY0tbiU0ANtf2QmU8iuKwEvJKFM6juTet/Q5Q1ZdgXC/po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785005915; c=relaxed/simple;
	bh=q3IrKVgX0wGRpPkKZoViOtoKdnS6RCjtfM7uhmltb0o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=urRT9XFR+y5IsYfzUV3U9pic9BAQp19Wh9MZkEb2SbMyJQvVDFZ09jzMGYK7CBYwiB/QH0UweX//HtaOik+SfELTB4xuGVaauY2li9SW8re4Bg9k7uXDyMGbw4PJkgsVFjaTxm1X5MnHoAl/CJjzzvVZY2e7Rt3F8aKMA2oQLaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pcGjdC9Q; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pcGjdC9Q"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-381b831d535so1789736a91.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 11:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785005913; x=1785610713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uj24S/lDnrC1Dd+wDSbJnV+1NrjW8KO7QWnzgbuwANY=;
        b=pcGjdC9QU+G/lEdfzBmo9l5j6xcMd2AgTsQp867CCAzMMOfmFl4n1FHtoibXTnDc6q
         9N50f5SLSrRPv36hKRMqQEDvaexCwNN5sDRfrZQJyg8lst4QQT3FXw2ygTCIc++V8nGo
         pMM+j2YtsByOTVRt7fd+cGyfWkZHno2ga5QlWXR6QFqEbaSteiVlwgBEpzKlhNpg3fW+
         nYB4OnknFUjiXJpRmB9XRdTjzN2ZpzLbQwyDfU3Re6LJUkXPOJu7iZNUNd3PAQH3VN54
         whKAmpT5T4Y51fAo203lisNAXQH4kkpxEhTuku2yeiSkXG4pTtSANU4kanT5W6pdSP+0
         evDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785005913; x=1785610713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uj24S/lDnrC1Dd+wDSbJnV+1NrjW8KO7QWnzgbuwANY=;
        b=aD0nBvbL5Rb+GX/QJi7fNG3i+/Yle/yoaDqYCtinwXD6OF+Lrw+CiofNJJ3pYt/zwI
         j0SKF39c8vzgGsKdA8fNu7tR9ivwwOnb/Y5muZS7+eShelHtQ833lVDb8qpgXm61fNFP
         FsetL/ZRbR3i4XZb0zjUV5pko9CZDaqUCAckcgaYFk9uzYIqnlwHTT8wJ+d2QqRbGuMu
         XrhiBeX4CCN1F7YTIWHkftYV2rXJ0AD2PAC6jqAEBVylQw6ULB4IQ6DjoHXVDQR1lJgp
         aei1tE4h/PPJYBoUd4WMXPEbJUNOBQJxZ5uFHMEyV/BFiZVw/7eM1XnyPR2ltnvd3KUz
         9nTA==
X-Forwarded-Encrypted: i=1; AHgh+Rqi+GRHrkXotq+/9rgY86yt8U2+nosZcay+JlZiCdzt/D0zCJRYbemuyf/zKDYlk0oauOt1Bs0bXX69Z/3n+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoW4k7wyD/HArsw5OaNgqUj3GdKwqcmuB4mX5sbFF920wP4xnB
	XcEaDmwQWxyZvXn2OD6V/apeTtoH/uTvecAPWeYviD+TemnY5FJ1Ymla
X-Gm-Gg: AR+sD10kyhAkuOHUBHZlJ5KantUyle70KryCbPLo/YbCim+o4PJ96qrCqvpDdRbLYRA
	9f8xDwcIInrPMtFD9Ls6JSEJT1+koVEkiocoU27PEsucy4nTvlLhxM1PyJfIOwyEQ7xZp99TpqU
	FUAiDZc+EE/izisby8ri54zePwPY7p+EV1xpRL3hg9RBfWm+YVMBfetmPmYDCRHthgVIuCJea+s
	MVjoQNXaWz/AQBvYqR5jebwtD1MDos81S4/i0KvmwUDuE7I5UM/Lilc2X2Febwamayj6c1D57RA
	czGf3J8bFSIIteKLDb1HqH7BgkBOtX0gpap4ehbWrMzMYttv0LtlLjPkm4vSHOSmhi/WR6NOyIa
	/f/TG5p0HWw9nVSCRQCNrmFzyr5WBOfKRbDuyA4sggFnfiJ1glQ791rewHxylXZxiCvvMyLkBvN
	QetnYFBI9cw//jIzerjRyMixku9WnJuQWMFlBeAN09
X-Received: by 2002:a17:90a:da83:b0:38d:dbc7:5178 with SMTP id 98e67ed59e1d1-38f296554d6mr3125715a91.22.1785005913226;
        Sat, 25 Jul 2026 11:58:33 -0700 (PDT)
Received: from localhost.localdomain ([115.110.225.242])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d13003f12sm65054718c88.2.2026.07.25.11.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 11:58:32 -0700 (PDT)
From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>
X-Google-Original-From: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
To: loic.poulain@oss.qualcomm.com
Cc: jjohnson@kernel.org,
	wcn36xx@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Subject: [PATCH ath-next] wifi: wcn36xx: fix OOB read from short firmware HAL message
Date: Sun, 26 Jul 2026 00:27:40 +0530
Message-Id: <20260725185740.56658-1-shitalkumar.gandhi@cambiumnetworks.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wcn36xx_smd_rsp_process() is the rpmsg callback for the WLAN_CTRL
channel. It dereferences msg_header->msg_type to dispatch the incoming
message before validating that the payload is actually large enough to
contain a struct wcn36xx_hal_msg_header.

The payload length is fully controlled by the remote processor: the SMD
transport takes it from the packet header written by WCNSS
(qcom_smd_channel_intr() stores le32_to_cpu(pktlen) into pkt_size) and
hands it to the callback unchecked. A message shorter than the 8-byte
header therefore causes an out-of-bounds read. For the indication
message types the header is read a second time in wcn36xx_ind_smd_work(),
there from a kmalloc_flex() allocation sized to the short length, which
is a slab out-of-bounds read that also violates the
__counted_by(msg_len) annotation on struct wcn36xx_hal_ind_msg.

The individual response and indication handlers do validate their own
lengths, but they only run after this dispatch has already happened.

Add the missing header length check. Drop the message and return 0 so
the SMD transport still advances its receive FIFO tail; returning an
error would leave the malformed packet unconsumed and stall the channel,
which is why the oversized-response case in the same function also
consumes the message.

Fixes: 8e84c2582169 ("wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware")
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index c0b477345832..32dec45dbb50 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -3254,6 +3254,11 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
 	struct wcn36xx_hal_ind_msg *msg_ind;
 	wcn36xx_dbg_dump(WCN36XX_DBG_SMD_DUMP, "SMD <<< ", buf, len);
 
+	if (len < sizeof(*msg_header)) {
+		wcn36xx_warn("Corrupted HAL message: length %d\n", len);
+		return 0;
+	}
+
 	switch (msg_header->msg_type) {
 	case WCN36XX_HAL_START_RSP:
 	case WCN36XX_HAL_CONFIG_STA_RSP:

base-commit: 90883c513ca01e77c56b8d94be7de11420c1dacf
-- 
2.25.1

