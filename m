Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C63361941
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 19:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791660419; cv=none; b=N1/JSK4AcLRwq8wuNMadkkRzvAbqVh3xXBlFCggyeGvQKDAX1BDeae17b46X7cxKceiTdmkv4Eqa1Uy2HdU8hfTXBJf58/Df7Wc8HQkP4cE7Bc5IbdG/tctypn96X3Of/GEPiR+KyfOv6OlySA4kYQKFmwNKsKNP50vRXLT+2a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791660419; c=relaxed/simple;
	bh=FC3pc+NH9tG2+CT7Jona8XVuYvpdkSJ7+CUK5Df7gX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QlDpBQdx+dxUJRDajSV+8LpRHnz1tEO9ESmrnW9owri1EsQPMd5ad8xpVj3XPg48KaRA8nY7ETUMKqyZDWDiSbM4zGToPEJQKclHk1/on2jbOc5F87XP3YoqUotUj6z6Dp91bhf8SMPeHf54L4rZ1n8km9+GmL4sEPQ9Nn2FV70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fdfq37gC; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fdfq37gC"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5e521deaa2fso322060e0c.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791660417; x=1792265217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=75/9wntxrYg7KAVI+BsS7cL60VeD2bNUigkOoVopl5Q=;
        b=Fdfq37gCJ7RUqn4A1bApWpdBhfY+bOOGokGKdZ+UsPiBTBdamLJFXmlGeDQiq+NGgi
         o7+/8UqJlvzNrE7SnBxBsgCvixbwjUEGtScv5/xn1xaCOu1BwiLdoERTlZucY3i22vwM
         cSHzMy+8TntKXLpfw/4YQqRT2xDwCd71ZY7KQymqNPtaJoVzN8KJw9l/umZQPoF5Ldzy
         0HhiFCszJJa5nyuU1Q+hT8N9nerwiP6xl64bw0G6jSDnubgEdX753h6HHL0+L6xm0MM2
         tDzUEvbZmUtRpzRxlvsegGpkTCougfzLyvAyVyCmCZcDMcLUUjttvOAAp1TucJtAB51Q
         e4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791660417; x=1792265217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=75/9wntxrYg7KAVI+BsS7cL60VeD2bNUigkOoVopl5Q=;
        b=bW5weHAGBvvXoZkx2ZXvxLwQMHo/S66bRNHNryTj46YI9AIS9iI82dB6t3+uZqD+9Z
         wIfkAlz7tciVQ0ZxZbUP0EH8EvVNfzpopnWTjGMEs+Ubg1bf19ZtIlYxjctxU2e7xOvO
         ZUiykBrCFEaDKxSH2prd4MLJ39WRAHUztTFcJYOkmPHSvOZodqlP2umtwOU4kIa6Ilgs
         e0Z7FjmPhfJqQ9wUAqVRn/gO4MmtW/CaBncyn4pWrxbocajOufG9xS2gmehTk3v6wD/j
         3GsjLPCUWel7OFo+svCxy0GrDTppeI2rLV1BNZSpYPrxbv1//x5/nAnsYQL+f01YoXs4
         JsBA==
X-Gm-Message-State: AFq9FYKA2b+Mfl87Orqvzvh3fNxabmyzG1wgmW4Nae6odAjQVWD6RsGE
	UXhng6/3kbruhKzc2eGHLErOPFWWOaMzG0Iyoru4AHXoUWgjwi0R6B3B1ct1sjJg
X-Gm-Gg: AYBFou09xMb5d0DduFIyqAjLttPZfZY3ykfYL//jAMhaUboDC6p3Fnisvuf3T+wAZVS
	2lKBVRzrlxNq+mzJilGQEH36y2IWsj4g811HCgITzH2O3HPBgCT1s5F7H5Qc3IXl2eMKYk6ZqqR
	XYFcraF3rpUmtkLS/0YiaJCbBB332iv2HwttzDm2sHayV27Qjr6B+O3q1i6ClcE/Fi2OAz4gJ2R
	4asdWL8JkV78xhjFCuhXuYF1v7PxWOfLnwxVLLCXtEyn8cuzt7PCYcIRobU3hEGdOsAwA32qKW7
	egYVyvBCpD5emqG7STuUkULIRurVELFPwVbBBLTo1WPCrMob0YI8y5OJtkE8rPpUiJDSYr0frvV
	Jwq56muDn6r6yQ8I+6RPAZDqol85EcvYJdJFh+KI/X+v1B+0UxqO136PKaFVHQQK4oiOGhjH6UB
	exvWoFhNSWbGSyyENApVkeLK/N+DzGNtV4uT/u2D/JDjaKWYHCHfZ8ZGIjs0V2bYSONPIoEWuPz
	rruT7mMobMKKFRAuYgYf9XL6zQiWPcYDnVlTWWIptsrJ1o=
X-Received: by 2002:a05:6122:1d4e:b0:5c6:81c2:5496 with SMTP id 71dfb90a1353d-5e91f43e0fdmr1833621e0c.4.1791660416965;
        Sat, 10 Oct 2026 12:26:56 -0700 (PDT)
Received: from localhost.localdomain ([190.177.186.207])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cb292a5sm4457640e0c.7.2026.10.10.12.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 12:26:56 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] wifi: mt76: mt76x02: keep A-MSDU subframe buffers at even addresses
Date: Sat, 10 Oct 2026 16:26:49 -0300
Message-ID: <20261010192649.15608-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On mt76x2e and mt76x0e, mac80211 builds A-MSDUs in software: it chains
each new subframe to the frag_list of the first frame, and
mt76_dma_tx_queue_skb() maps every skb of that list as a DMA buffer of
its own, two per TX descriptor. Since commit 166ac9d55b0a ("mac80211:
avoid kernel panic when building AMSDU from non-linear SKB"), mac80211
pads each subframe to a multiple of 4 bytes by pushing the padding in
front of the next subframe, so the buffer that follows a subframe of
odd length starts at an odd address.

On an MT7612E in a TP-Link Archer XR500v (EcoNet EN751221 SoC), the BE
TX queue occasionally stalls under load: its DMA index no longer
advances while descriptors are queued, the MAC is not transmitting,
and after a second the watchdog restarts the hardware:

  Hardware restart was requested

A debug patch that dumps the TX ring captured three of these hangs.
Each time, the DMA index was stuck on the last descriptor of an A-MSDU,
and the buffer in its second slot (LAST_SEC1) started at an odd
address. Such buffers are rare: in 20 runs of 95 seconds with four TCP
streams and without the check below, the driver queued 227 of them
among about 10 million multi-buffer frames, while frames with more
buffers and descriptors, all at even addresses, went out by the
hundreds of thousands without a hang. An odd buffer does not always
hang the DMA, though: the layout of the stuck descriptors was queued
63 times in those runs and hung once.

Only append a subframe if the frame built so far has an even length
and both frames start at even addresses. The 802.11 header, the IV and
the subframe headers have even lengths, so head->len has the parity of
the last subframe, and thus of the padding that would follow it; every
buffer but the last then has an even length as well. A frame that is
refused starts a new A-MSDU, so nothing is copied or dropped.

The cost depends on the packet sizes: full-size TCP segments and pure
ACKs have even lengths, while with uniformly random sizes a host model
of the aggregation refuses about half of the attempts. In 10 runs with
the same check as a run-time switch, interleaved with 10 runs without
it in the same boot, it refused 143 of 7.5 million aggregation attempts
(0.002%), no odd buffer reached the ring, and A-MSDUs of six or more
buffers were as frequent as before. TCP throughput was
307.9/401.8 Mbit/s (up/down) with the check and 308.6/399.1 Mbit/s
without it.

With that traffic the hang is too rare to compare the two cases, so a
UDP flow to the client with packets of 1500, 275 and 217 bytes was
added next to the TCP streams: mac80211 then builds the layout of the
stuck descriptors whenever that flow backs up. In eight interleaved
rounds of three 25-second phases in one boot, the driver queued 64,000
to 91,000 descriptors with an odd buffer in the second slot per round
without the check, and 5 of those 12 phases ended in a restart (11
restarts in all). With the check, it refused every aggregation attempt
that would have produced an odd buffer (139,000 to 160,000 per round),
none reached the ring, and none of the 12 phases restarted (one-sided
Fisher exact test, p = 0.019). A shorter calibration run before it gave
2 of 3 phases with a restart against 0 of 3.

Turning software A-MSDU off, as commit c2fcc83b41a6 ("wifi: mt76:
mt7603: disable A-MSDU tx support on MT7628") did for mt7603, avoids
these buffers as well, but on this device it lowered the download
throughput from about 440 to 360 Mbit/s.

mt76x0e uses the same DMA code and descriptor format, and it has no TX
watchdog that would recover from such a hang, so it gets the same
check; it was not tested on MT7610E. The USB drivers do not use this
DMA path and are left alone.

Fixes: 166ac9d55b0a ("mac80211: avoid kernel panic when building AMSDU from non-linear SKB")
Assisted-by: LLM
Signed-off-by: Cristian Papa <pcristian292@gmail.com>
---
Testing: OpenWrt on the XR500v, kernel 6.18.44 with the mac80211
backport 7.2 and openwrt/mt76 at be5ce79105 plus the board's local
patches. There the check ran as a run-time switch of a debug build
that also counted the buffer layouts handed to the DMA (neither is part
of this patch), so both cases could be interleaved in one boot. This
patch itself was build-tested with W=1 on top of openwrt/mt76 master
for that kernel (MIPS) and on top of the mt76 branch of nbd168/wireless
(x86_64). I only have this one board, so I cannot rule out that its
PCIe host plays a part.

The throughput of the runs with the UDP flow is not comparable between
the two cases: after some of the restarts without the check, the client
stayed associated but passed no traffic until it reconnected, and the
upload rate of the later rounds dropped in both cases. That looks like
a separate problem in the restart path and is not addressed here.

mt76x2e and mt76x0e already set MT_DRV_TX_ALIGNED4_SKBS, so
mt76_dma_tx_queue_skb() pads the 802.11 header of the first buffer to a
multiple of 4 bytes, but nothing keeps the buffers of the subframes
that mac80211 chains to it aligned. Is there a known alignment
requirement for the TX buffer pointers of the MT76x2 DMA (buf0/buf1 in
struct mt76_desc)? If odd addresses are not supported, that would
settle it.

The hook documentation asks for a symmetric and transitive relation,
while this check depends on the length of the frame built so far.
mac80211 only calls it to append to the last frame of a flow, so I
think that is fine, but I can rework it if it is a problem.

Tools: AI coding assistants. OpenAI Codex wrote the first ring dump;
Claude Opus 5.5 (in Claude Code) decoded the dumps, wrote the later
debug, test and host model code, and drafted this change and
changelog. The tests ran on my device.

 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h    |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c   | 17 +++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_main.c    |  1 +
 4 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f8d206a07..3c4948522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -90,6 +90,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.get_antenna = mt76_get_antenna,
 	.reconfig_complete = mt76x02_reconfig_complete,
 	.set_sar_specs = mt76x0_set_sar_specs,
+	.can_aggregate_in_amsdu = mt76x02_can_aggregate_in_amsdu,
 };
 
 static int mt76x0e_init_hardware(struct mt76x02_dev *dev, bool resume)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3c98808cc..f5a25608f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -193,6 +193,8 @@ void mt76x02_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
 irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance);
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
+bool mt76x02_can_aggregate_in_amsdu(struct ieee80211_hw *hw,
+				    struct sk_buff *head, struct sk_buff *skb);
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   enum mt76_txq_id qid, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 301b43180..3ca530f1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -32,6 +32,23 @@ void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx);
 
+/*
+ * mac80211 pads each A-MSDU subframe to a multiple of 4 bytes by pushing the
+ * padding in front of the next subframe, and every skb of the frag_list gets
+ * a DMA buffer of its own. After a subframe of odd length, the next buffer
+ * would start at an odd address, and the TX DMA has been seen to hang on such
+ * frames. The 802.11 header, the IV and the subframe headers have even
+ * lengths, so head->len has the parity of the last subframe. Only append to
+ * a frame of even length, and only if both frames start at even addresses.
+ */
+bool mt76x02_can_aggregate_in_amsdu(struct ieee80211_hw *hw,
+				    struct sk_buff *head, struct sk_buff *skb)
+{
+	return !((head->len | (unsigned long)head->data |
+		  (unsigned long)skb->data) & 1);
+}
+EXPORT_SYMBOL_GPL(mt76x02_can_aggregate_in_amsdu);
+
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb, u32 *info)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 550644676..cd8130790 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -153,5 +153,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.set_rts_threshold = mt76x02_set_rts_threshold,
 	.reconfig_complete = mt76x02_reconfig_complete,
 	.set_sar_specs = mt76x2_set_sar_specs,
+	.can_aggregate_in_amsdu = mt76x02_can_aggregate_in_amsdu,
 };
 

base-commit: 2e6968e9286f3573016b9f804d4945373a21c489
-- 
2.47.3

