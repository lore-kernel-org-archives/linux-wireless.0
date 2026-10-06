Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E54A5C41
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320388; cv=none; b=aI9r/CllMPjnjPdUbOcQfOpK69egWC3lkSqcQC8SbtKqc24ueHpYkO3p03bqFc5jdPI+fgnXlXkf9kntZUxeBkJBLDzTjacHm3sE1r+GbFbuV1LlomrZMjwKZZ4cwhEbzq6UmkZpSoswC41aIqyR09P6K+CQwxzoYQjOKha8jsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320388; c=relaxed/simple;
	bh=Q1br/mN6tGiY55CAG4dUpcGqHAR3azLBtzjQ2HxkHmE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdOU4TbgdYPhnxzUG2xzkrICxGH3g1phly7tlYPFgo1LnXlSHLZpl+pSscW+AF7Czb+SkObrzHs1bO4zHWJxNiETSZRX1PATQjXCkWHFk6pLaWdT5aWcTOKmiYUpbnGeTRIq3mJSyezv6New74njSkBGk43Yu/weDsX5gj9VU3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Y8OxKk3w; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y8OxKk3w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NrnPx0ixI925HgUMOK9gu8MDpZBxM2NNESIkD9ESS7w=; b=Y8OxKk3wK8F4ATKp9Z63pwkkRG
	fXuCuRBOPbD8t4bNMrW0qD8le/8Q2pBZV3yNgU9ZZT2uXh6t2Tx1kKcIAxdVKopAO7uX48YyFY6R4
	Y4wQKkpVZpL16ctn49kp+kTTN11laHj0xWZcHm7n1B34lzrSchss2QhPaXcrVoBgfhDs=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xECGF-00HAg3-2B
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 22:59:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76-next 25/27] wifi: mt76: mt7996: fix PLE free page and AC queue register offsets
Date: Tue,  6 Oct 2026 22:59:34 +0200
Message-ID: <20261006205936.669125-25-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006205936.669125-1-nbd@nbd.name>
References: <20261006205936.669125-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PLE register map in the MediaTek vendor driver places the free
page counter, the free page head and tail, and the HIF group page status
at 0x3a0, 0x3a4 and 0x3a8. The driver reads them at 0x380, 0x384 and
0x388, and the vendor map has the band 1 TXCMD queue empty status at
0x388. The same map has 0x100 bytes per AC for the station queue empty
bitmaps, with the MT7992 extension register at offset 0x80. The driver
uses 0x80, which cannot hold the 34 registers per AC of MT7996, so the
hw-queues file reads AC1 to AC3 of a station from the wrong register.

Use the offsets of the vendor register map.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index 8ff78cf6eb04..30bec7a0a987 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -155,12 +155,12 @@ enum offs_rev {
 #define MT_FL_Q2_CTRL				MT_PLE(0x3e8)
 #define MT_FL_Q3_CTRL				MT_PLE(0x3ec)
 
-#define MT_PLE_FREEPG_CNT			MT_PLE(0x380)
-#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x384)
+#define MT_PLE_FREEPG_CNT			MT_PLE(0x3a0)
+#define MT_PLE_FREEPG_HEAD_TAIL			MT_PLE(0x3a4)
 #define MT_PLE_PG_HIF_GROUP			MT_PLE(0x00c)
-#define MT_PLE_HIF_PG_INFO			MT_PLE(0x388)
+#define MT_PLE_HIF_PG_INFO			MT_PLE(0x3a8)
 
-#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 +	0x80 * (ac) + ((n) << 2))
+#define MT_PLE_AC_QEMPTY(ac, n)			MT_PLE(0x600 + 0x100 * (ac) + ((n) << 2))
 #define MT_PLE_AMSDU_PACK_MSDU_CNT(n)		MT_PLE(0x10e0 + ((n) << 2))
 
 /* WF MDP TOP */
-- 
2.47.3

