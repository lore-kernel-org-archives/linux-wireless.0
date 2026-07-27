Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818C241D133
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164691; cv=none; b=q136PixywjebpTqtI+NdrKxFSPbyovJcuTvJvywZpjaC0uytWp3hiiS3+UGlXroq3mMk+p4w6UKyVgtu++8jKPu/raNHZ+58J7lXTvUpiGMQfw2Eb9x2WcQ7faNEVMQz7/VCKWCBlzO1K/pspg5ykwl1JMC6lub8xfg/0dOSqGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164691; c=relaxed/simple;
	bh=Xiqt9E7jP/D54qDm948Bfq2EzYyRFTCUfW/ftmhU+PE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ooVSwbayks10AC5zfLTueQ9/6YttmefSXuwxRnJ5OyCawhGD841y6bAW3MYkdtQoH/Q2ieZmQ892fX166S6+xWnpn1taaOkavUE97Yca9yqrk2vogpoe5tS3ur86nJXabR+LPgLixGbWnxb+fjvFZswvgbkmz6hQuWIwEuPL4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=EiX6XdGP; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="EiX6XdGP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uJYn6j+7byC0unnBxQuJgtHI+dk4AyaHQ2ZgDGYOw5s=; b=EiX6XdGPCcNJMzKl7HA0qX75Cv
	nd3pegfLdf8hr7bMfPSOqI1yPd1qTZ42uM2v+dE6QTKG/LK0Ovb9AgE7DXjkvIQHKW6RXdHa+F/vP
	RqxCV4nfwWu/gbQB1egRlGpRLnuG6d9eT3sd9J8Y8GQ5lkZiyiWZhmUxCUdX35TrTR7w=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsj-008KN0-1T
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:41 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 01/15] wifi: mt76: mt7996: fix MIB TX aggregation counter registers for mt7990
Date: Mon, 27 Jul 2026 15:04:20 +0000
Message-ID: <20260727150434.1778520-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MIB_TSCR0-7 counters read by mt7996_mac_update_stats() are
hardcoded at the mt7996/mt7992 offsets 0x6b0-0x6d0, but mt7990 moved
them to 0x750-0x770, so TX AMPDU statistics were read from unrelated
registers on that chip. Move the offsets into the per-chip register
tables.

Fixes: f6c87411d15f ("wifi: mt76: mt7996: rework register mapping for mt7990")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 24 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/regs.h  | 24 ++++++++++++-------
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index d9780bb425a7..de68e60a1e86 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -54,6 +54,14 @@ static const u32 mt7996_offs[] = {
 	[MIB_BSCR7]		= 0x9e8,
 	[MIB_BSCR17]		= 0xa10,
 	[MIB_TRDR1]		= 0xa28,
+	[MIB_TSCR0]		= 0x6b0,
+	[MIB_TSCR1]		= 0x6b4,
+	[MIB_TSCR2]		= 0x6b8,
+	[MIB_TSCR3]		= 0x6bc,
+	[MIB_TSCR4]		= 0x6c0,
+	[MIB_TSCR5]		= 0x6c4,
+	[MIB_TSCR6]		= 0x6c8,
+	[MIB_TSCR7]		= 0x6d0,
 	[HIF_REMAP_L1]		= 0x24,
 	[HIF_REMAP_BASE_L1]	= 0x130000,
 	[HIF_REMAP_L2]		= 0x1b4,
@@ -91,6 +99,14 @@ static const u32 mt7992_offs[] = {
 	[MIB_BSCR7]		= 0xae4,
 	[MIB_BSCR17]		= 0xb0c,
 	[MIB_TRDR1]		= 0xb24,
+	[MIB_TSCR0]		= 0x6b0,
+	[MIB_TSCR1]		= 0x6b4,
+	[MIB_TSCR2]		= 0x6b8,
+	[MIB_TSCR3]		= 0x6bc,
+	[MIB_TSCR4]		= 0x6c0,
+	[MIB_TSCR5]		= 0x6c4,
+	[MIB_TSCR6]		= 0x6c8,
+	[MIB_TSCR7]		= 0x6d0,
 	[HIF_REMAP_L1]		= 0x8,
 	[HIF_REMAP_BASE_L1]	= 0x40000,
 	[HIF_REMAP_L2]		= 0x1b4,
@@ -128,6 +144,14 @@ static const u32 mt7990_offs[] = {
 	[MIB_BSCR7]		= 0xbd4,
 	[MIB_BSCR17]		= 0xbfc,
 	[MIB_TRDR1]		= 0xc14,
+	[MIB_TSCR0]		= 0x750,
+	[MIB_TSCR1]		= 0x754,
+	[MIB_TSCR2]		= 0x758,
+	[MIB_TSCR3]		= 0x75c,
+	[MIB_TSCR4]		= 0x760,
+	[MIB_TSCR5]		= 0x764,
+	[MIB_TSCR6]		= 0x768,
+	[MIB_TSCR7]		= 0x770,
 	[HIF_REMAP_L1]		= 0x8,
 	[HIF_REMAP_BASE_L1]	= 0x40000,
 	[HIF_REMAP_L2]		= 0x1b8,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index c6379933b6c3..8ff78cf6eb04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -64,6 +64,14 @@ enum offs_rev {
 	MIB_BSCR7,
 	MIB_BSCR17,
 	MIB_TRDR1,
+	MIB_TSCR0,
+	MIB_TSCR1,
+	MIB_TSCR2,
+	MIB_TSCR3,
+	MIB_TSCR4,
+	MIB_TSCR5,
+	MIB_TSCR6,
+	MIB_TSCR7,
 	HIF_REMAP_L1,
 	HIF_REMAP_BASE_L1,
 	HIF_REMAP_L2,
@@ -250,9 +258,9 @@ enum offs_rev {
 #define MT_MIB_BSCR7(_band)			MT_WF_MIB(_band, __OFFS(MIB_BSCR7))
 #define MT_MIB_BSCR17(_band)			MT_WF_MIB(_band, __OFFS(MIB_BSCR17))
 
-#define MT_MIB_TSCR5(_band)			MT_WF_MIB(_band, 0x6c4)
-#define MT_MIB_TSCR6(_band)			MT_WF_MIB(_band, 0x6c8)
-#define MT_MIB_TSCR7(_band)			MT_WF_MIB(_band, 0x6d0)
+#define MT_MIB_TSCR5(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR5))
+#define MT_MIB_TSCR6(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR6))
+#define MT_MIB_TSCR7(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR7))
 
 #define MT_MIB_RSCR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR1))
 /* rx mpdu counter, full 32 bits */
@@ -268,14 +276,14 @@ enum offs_rev {
 #define MT_MIB_RSCR36(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR36))
 
 /* tx ampdu cnt, full 32 bits */
-#define MT_MIB_TSCR0(_band)			MT_WF_MIB(_band, 0x6b0)
-#define MT_MIB_TSCR2(_band)			MT_WF_MIB(_band, 0x6b8)
+#define MT_MIB_TSCR0(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR0))
+#define MT_MIB_TSCR2(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR2))
 
 /* counts all mpdus in ampdu, regardless of success */
-#define MT_MIB_TSCR3(_band)			MT_WF_MIB(_band, 0x6bc)
+#define MT_MIB_TSCR3(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR3))
 
 /* counts all successfully tx'd mpdus in ampdu */
-#define MT_MIB_TSCR4(_band)			MT_WF_MIB(_band, 0x6c0)
+#define MT_MIB_TSCR4(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR4))
 
 /* rx ampdu count, 32-bit */
 #define MT_MIB_RSCR27(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR27))
@@ -299,7 +307,7 @@ enum offs_rev {
 #define MT_MIB_RVSR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_RVSR1))
 
 /* rx blockack count, 32 bits */
-#define MT_MIB_TSCR1(_band)			MT_WF_MIB(_band, 0x6b4)
+#define MT_MIB_TSCR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR1))
 
 #define MT_MIB_BTSCR0(_band)			MT_WF_MIB(_band, 0x5e0)
 #define MT_MIB_BTSCR5(_band)			MT_WF_MIB(_band, __OFFS(MIB_BTSCR5))
-- 
2.53.0

