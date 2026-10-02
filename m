Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BA244AB60
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 23:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982652; cv=none; b=XpzNwG7NVlV+WDD3HZ/TxHLoKvlPCMdZDGml7ALTNdzLUSOpmQt+pW8OwztatR9gnEar3lJucgH0Xb9No5EfFq3VjgOWF13G5mBI8/xSpSKDErUrwOa5MBZpnikLXKNzhuWiefupNDb8rXLg0sUyZHwii6mqUr3aefOQzuok3T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982652; c=relaxed/simple;
	bh=NpmzQmIY13xWYtyfBz/1J0Ez76d7G6HcJmDQiz1+ri4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXqpry+aBb4J3omT5bwYwMcC2sqpKhk5MgjD+nGN1TFXiFN4cd0SMY2wsdJKq6Ui+WcG4afK12iFf9n/aCLfPRStiRlEPJf8SbgZ0WSu3X3Rzvx1YttezwL537SwZ+QRk5Q7UL0zH5uqtkj5BpAtnE6Bfn4zAzFaSRXLKGWcu/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNuDzr4A; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNuDzr4A"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so181989f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 16:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790982649; x=1791587449; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ws6bJPQmVcNrG3rQzGbCXRbhstrZhw8G1K1q80pps2I=;
        b=QNuDzr4AkHE50nYWW7Y+NGbFVAx4L8LspGP8w1XI976bPm0vt92r1ZG3Ne+DLa18ul
         KdCAKEUjV8eOy3DPHZjxCnfHO9JoIhTCrs+Xa0wbWB5O4sifAQ+BstZnNVBG5vZn7eTU
         6+f/mK99lCpN9d/Jj7BP3PqWu5ZeXZxQB61qQZzmQTBByhm2VTKQh2IJc01M8zeH3mG+
         hdSk/lqqcaORxwky3F7sk3m5AP0Su5+ZSiNfnaJ6cd9QpdTVXn+q7S0XyQQNgoKnwbIu
         KeDAwf6T1/eiDYjNV7dQrXvHe4oyS/nzGlcplP3i+9ds8GVpDSTgUl87HrxNdTGZQZxc
         lqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790982649; x=1791587449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ws6bJPQmVcNrG3rQzGbCXRbhstrZhw8G1K1q80pps2I=;
        b=wBiMkWVUZo7NmRZj4Q2Nb7JuRzmlg/wgNWVIfoki+6oa2koPC3xYdqrtcnTgUcDJ8G
         xCLRMP4X2+g+wNWWwzt+ODnEv+Z46hmYPYRXMo4B8DTCk84jZ35n9/vGwlMa+oZqMFPV
         s7iY75pKUOrbUt+DVyueuD0dhH6zQJdhJUVLf9dRUgUP3iD1wetOtUkbIFp73EPsYjfA
         uN2lphs9AGB1J6hHzZ8KI+kDx+0NTvB4Pxb6C9ndgTXe1U4UEmaUiYzuExiLSPRfRnK2
         EsaMKCMF+56i3nJHwLREo8qL0y6s2lh6DX9pukWRCyoPJETzagSwTVl7EBJ9Ug28Ur0b
         fJbw==
X-Gm-Message-State: AFq9FYKWrM8pCG2Oc5ur+gPh4bd35Ms601gxxQcDhooIMVXpXjqhOWik
	msi4o/bPRwaFicw2PXh8VUf8zlYPRqMhKvtfz6MvIRW7ywHkUCOboDAD
X-Gm-Gg: AYBFou3uDzm77zfRoo5KxmR90FJHUc8vrasyvDroXTx8/13v8h3OlYjUSHtugpttISK
	3wtaT1NMPXuWztHytktS9AiU6ivcQ9bgYctaJxxOV3efZV2b0KfC8qkJReKvodnZGcUrvLRSgzE
	owyRtKu3o8cpJrrERnBpphS/EGWfBzH6q6gscbTp5pn3sejuxDjHHX2Q2Y/60JKgUOpBZI4oa3e
	nIDoCdRzmpbH9+dTs37x64OT6fBFBjODftzBbseBbIpMHMQgBbFRFGaeJLJKFCOkRx0xCzsNA+C
	lQdmTTvzQkn6lW/HQMgwcToFVfmuUlHyXEC5LmEOtZ4zU9/op44k9xC+9oiRFkvAa0HOk0Tmc1C
	jL43EE5Pa/wUx5+AC3zkL0u195Y8qavVDc8/uF9Pg0CG3NZAVfbMl7G5GzoGkYZvBxtfhzbvRm3
	gFiaJlaAPxt7WoEM+5Nd0O77+l5vKRLzAAxmGhG1//zljU7wdHE1i+ocR5z5yqKz91g+srRQ1lJ
	0kEQgPKX2MPOLAPqpCjodyAfB2EBJQ/kTxJpQfGAbiHcuhKWBT43X6iFR/zItf2G1tq2ZxX0718
	w6v+v9sfRtW0mze/L5I0Ng==
X-Received: by 2002:a05:6000:2287:b0:48a:f5ab:4ad6 with SMTP id ffacd0b85a97d-48b12754112mr7380951f8f.15.1790982648666;
        Fri, 02 Oct 2026 16:10:48 -0700 (PDT)
Received: from omarchy ([2a02:ff0:1e10:93f:ce47:40ff:fef1:ce77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fab11sm8372266f8f.16.2026.10.02.16.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 16:10:48 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rtl8821cerfe2@gmail.com,
	Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
Subject: [PATCH rtw-next 2/2] wifi: rtw88: pci: warn when a TX ring stops advancing
Date: Sat,  3 Oct 2026 02:10:13 +0300
Message-ID: <20261002231013.11792-3-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
References: <20261002231013.11792-1-abdurrahmankaradag19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On RTL8821CE the hardware read index of a TX ring can stop moving while
the driver keeps submitting descriptors. The link stays associated and
RX keeps working, so from userspace this is a dead network with no
explanation: ping and curl report 100% loss and nothing appears in the
log.

A watchdog dumping the TXBD registers caught five of these across three
boots, all with station power save off and REG_TXPAUSE at 0x00. Two
examples:

    2026-08-28 22:05  BEQ 0x3a8: 0x003c003a, unchanged over four
                      samples; read index 0x3c, write index 0x3a, one
                      descriptor free, so avail_desc() < 2 had already
                      stopped the BE queue
    2026-09-14 17:48  BEQ 0x3a8: 0x00c9004c -> 0x00c90068; read index
                      0xc9 frozen while the write index ran from 0x4c
                      to 0x68, 124 descriptors free falling to 96

The second is the more common shape: the ring is still mostly empty and
no limit has been reached, yet traffic is already gone. Rewriting the
host write index does not restart it, so simply reissuing the doorbell
is not sufficient to recover the condition.

This patch does not recover from it either; I do not have data showing
which recovery works. It only makes the condition visible: once per
watchdog round, compare each AC ring's hardware read index with the
driver's write index, and warn if it has not moved for three rounds
while descriptors are in flight.

Only the four AC rings are checked. BCN has no index register, and
MGMT, HI0 and H2C are drained on events of their own - HI0 in
particular is the after-DTIM group queue in AP mode and may
legitimately sit still for a whole DTIM interval. The hardware read
index and a snapshot of the host write index are taken together under
irq_lock, so a submission cannot change the write index between the
two. The check is not run while scanning, because rtw_watch_dog_work()
returns before reaching it. A ring with nothing in flight has read
index equal to write index and is skipped, so an idle device is never
reported. The recorded history is discarded whenever the ring is empty,
whenever REG_TXPAUSE is set and when the rings are reset, since samples
from before say nothing about the ones after. The warning is emitted
once per episode and rearms as soon as the index moves.

This is the detection half of a patch I sent and withdrew in September;
the doorbell rewrite it used as recovery turned out not to work, and is
gone.

Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/hci.h  |  7 ++
 drivers/net/wireless/realtek/rtw88/main.c |  2 +
 drivers/net/wireless/realtek/rtw88/pci.c  | 83 +++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/pci.h  |  3 +
 4 files changed, 95 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index d4bee9c..432333e 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -12,6 +12,7 @@ struct rtw_hci_ops {
 			struct sk_buff *skb);
 	void (*tx_kick_off)(struct rtw_dev *rtwdev);
 	void (*flush_queues)(struct rtw_dev *rtwdev, u32 queues, bool drop);
+	void (*tx_stall_check)(struct rtw_dev *rtwdev);
 	int (*setup)(struct rtw_dev *rtwdev);
 	int (*start)(struct rtw_dev *rtwdev);
 	void (*stop)(struct rtw_dev *rtwdev);
@@ -271,6 +272,12 @@ static inline enum rtw_hci_type rtw_hci_type(struct rtw_dev *rtwdev)
 	return rtwdev->hci.type;
 }
 
+static inline void rtw_hci_tx_stall_check(struct rtw_dev *rtwdev)
+{
+	if (rtwdev->hci.ops->tx_stall_check)
+		rtwdev->hci.ops->tx_stall_check(rtwdev);
+}
+
 static inline void rtw_hci_flush_queues(struct rtw_dev *rtwdev, u32 queues,
 					bool drop)
 {
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498..a6adbda 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -273,6 +273,8 @@ static void rtw_watch_dog_work(struct work_struct *work)
 
 	/* make sure BB/RF is working for dynamic mech */
 	rtw_leave_lps(rtwdev);
+
+	rtw_hci_tx_stall_check(rtwdev);
 	rtw_coex_wl_status_check(rtwdev);
 	rtw_coex_query_bt_hid_list(rtwdev);
 	rtw_coex_active_query_bt_info(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index ff751bf..50c9fae 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -473,6 +473,13 @@ static void rtw_pci_reset_buf_desc(struct rtw_dev *rtwdev)
 				BIT_CLR_H2CQ_HOST_IDX | BIT_CLR_H2CQ_HW_IDX);
 }
 
+static void rtw_pci_tx_stall_reset(struct rtw_pci_tx_ring *ring)
+{
+	ring->last_rp = U32_MAX;
+	ring->stall_rounds = 0;
+	ring->stall_warned = false;
+}
+
 static void rtw_pci_wake_stopped_queues(struct rtw_dev *rtwdev,
 					struct rtw_pci_tx_ring *ring)
 {
@@ -503,6 +510,8 @@ static void rtw_pci_reset_trx_ring(struct rtw_dev *rtwdev)
 	for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
 		ring = &rtwpci->tx_rings[queue];
 
+		rtw_pci_tx_stall_reset(ring);
+
 		if (!ring->queue_stopped)
 			continue;
 
@@ -819,6 +828,79 @@ static void rtw_pci_tx_kick_off_queue(struct rtw_dev *rtwdev,
 	spin_unlock_bh(&rtwpci->irq_lock);
 }
 
+/*
+ * A TX ring with descriptors in flight advances its read index within
+ * milliseconds. When the hardware stops consuming them the ring just goes
+ * quiet: the link stays associated, RX keeps working, and nothing says that
+ * TX has died until the ring fills and the queue is stopped. Report it once
+ * per episode, where an episode ends as soon as the read index moves again.
+ *
+ * Only the four AC rings are checked. BCN has no index register, and MGMT,
+ * HI0 and H2C are drained on events of their own - HI0 in particular is the
+ * after-DTIM group queue in AP mode and may legitimately sit still for a
+ * whole DTIM interval.
+ */
+#define RTW_PCI_TX_STALL_ROUNDS		3
+
+static void rtw_pci_tx_stall_check(struct rtw_dev *rtwdev)
+{
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	struct rtw_pci_tx_ring *ring;
+	u32 bd_idx, cur_rp, wp;
+	bool paused;
+	u8 queue;
+
+	paused = rtw_read8(rtwdev, REG_TXPAUSE);
+
+	for (queue = RTW_TX_QUEUE_BK; queue <= RTW_TX_QUEUE_VO; queue++) {
+		ring = &rtwpci->tx_rings[queue];
+
+		/* a paused ring is not advancing on purpose, and samples
+		 * taken before the pause say nothing about the ones after
+		 */
+		if (paused) {
+			rtw_pci_tx_stall_reset(ring);
+			continue;
+		}
+
+		spin_lock_bh(&rtwpci->irq_lock);
+		bd_idx = rtw_read32(rtwdev, rtw_pci_tx_queue_idx_addr[queue]);
+		cur_rp = (bd_idx >> 16) & TRX_BD_IDX_MASK;
+		wp = ring->r.wp;
+		spin_unlock_bh(&rtwpci->irq_lock);
+
+		/* nothing in flight, so there is no observation to carry
+		 * into the next round
+		 */
+		if (cur_rp == wp) {
+			rtw_pci_tx_stall_reset(ring);
+			continue;
+		}
+
+		/* the ring is draining. last_rp is U32_MAX until the first
+		 * sample with descriptors in flight, and no index can equal
+		 * that, so that sample lands here and only records.
+		 */
+		if (cur_rp != ring->last_rp) {
+			ring->last_rp = cur_rp;
+			ring->stall_rounds = 0;
+			ring->stall_warned = false;
+			continue;
+		}
+
+		if (ring->stall_warned)
+			continue;
+
+		if (++ring->stall_rounds >= RTW_PCI_TX_STALL_ROUNDS) {
+			ring->stall_warned = true;
+			rtw_warn(rtwdev,
+				 "tx ring %u: read index unchanged at 0x%03x for %u watchdog rounds, write index 0x%03x, %d descriptors free\n",
+				 queue, cur_rp, ring->stall_rounds, wp,
+				 avail_desc(wp, cur_rp, ring->r.len));
+		}
+	}
+}
+
 static void rtw_pci_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
@@ -1637,6 +1719,7 @@ static const struct rtw_hci_ops rtw_pci_ops = {
 	.tx_write = rtw_pci_tx_write,
 	.tx_kick_off = rtw_pci_tx_kick_off,
 	.flush_queues = rtw_pci_flush_queues,
+	.tx_stall_check = rtw_pci_tx_stall_check,
 	.setup = rtw_pci_setup,
 	.start = rtw_pci_start,
 	.stop = rtw_pci_stop,
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 04630d1..c6c9a63 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -189,6 +189,9 @@ struct rtw_pci_tx_ring {
 	struct sk_buff_head queue;
 	bool queue_stopped;
 	unsigned long stopped_queues;
+	u32 last_rp;
+	u8 stall_rounds;
+	bool stall_warned;
 };
 
 struct rtw_pci_rx_buffer_desc {
-- 
2.55.0

