Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792520919;
	b=LvTID0QUgRMMU1/9iZx7EsIRURD6pgwedz1bCEfeDrPYDD2ukhaT+ccV4jqfLOOxD4JE
	 KI34/412hkMbxHkJickzf9+iIEIHlplMybPCDa8R0SsDN7tKmgP1gNCPr0jm8KqPwb3mT
	 zSufK4Ug7BDqiq822JBKW3yP0uhwviHe6/oSkOOdn6lvcg9q9VCtlfwM9JTUOAZ0YrsI0
	 zu2bChhbZZk7WuPHr8KfEFu6UT6eyQGD3HmN4B1MaXBU5zQ6Kxh341CToYH32A1m0pU6R
	 P04ewjzNxCXt/q5ek/6MUK23aN1da2AOVN5dW4eqLaz4El591t97e8Kskj+fssHV/dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792520919;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Z5zSggzBne2c+TcNuspBgPLfuRtz5PeeaW0VSn/S1BU=;
	b=QIVt4vQAz2vMxRc3TKwF7059IOXQeOMg0VRi0X/JJz+8wu5Fm5ZfmDUntef90nV3aHcl
	 paMulJkpQpxqIW0c5MIukArvVBCLABzGPID2+dgTZyHMScgtrB1kxLtSH4UjJ56cWxo3L
	 O9xP11z6aC7U6z5zz2RD/RVP9g2sI/9umnPFxBPsiQSy/fUepZOxAg3JdzrXN+BsYJHJH
	 4FWsNMl1a/eCA1ti/1VEKdIIoUAzmeRgeri/b3VV5IrbbwOsPamg6BkDSjNwk0AzxTNDM
	 Lu97vuWoY9BJw1TQQqV7ITRoBpJyTGDzbRRGRsB47z0/4bUxlXfL8b2MP2fpEuEvwxw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbopTNcg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365BC606A319;
	Tue, 20 Oct 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FbopTNcg
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792520918;
	b=bHBmN7+8naJrEZSTkCeMZ99WuA6LiVfI2/jXXPPgbCp3RJXq1SBB1en7VHU3Qv7o8WYX
	 /RFwvd9KNcFmIW3Q/ytubzkUux12PmHwcDGQ/qFDnOtE/pjZ8eIqURKDg9u1/C2DLAGkH
	 tceFInBm4k3lyS/YqqXSbAmbRDeKqluxOEbgMUV91BosuGVn+MLS8xP4j8UELVx5glNAa
	 SUGhXKlWlWZ9PhTGETnd0Nz3r0HlJQHhD8LzxHlpqCfxSG1vVA3KxcrkvI+f2gT3aW2Rr
	 k5ebBK5oZvzV08ZQpEQRjqvmOR28hKFtPXmos5ihOmXBhlEMiBHsKSj0Nz982wFL8Kw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792520918;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Z5zSggzBne2c+TcNuspBgPLfuRtz5PeeaW0VSn/S1BU=;
	b=pLCx7e2Krtjus3+4OxVZMOu9k50TC4y1Z2Xw0LWfSUDRwLv23Jc6+3BbV5k/WgF1bRyj
	 Blb6nwnBB+ohy//UhTO6hCvN1qQ6fbpmLnzdRFSaFabUGwfd+z8bUBgCNPdv3a2Z3A+pR
	 +OVKc8qI3RV52E3gYhG8bnOi/pCD8faw5/Fr0LGEVb1akp1G5B0lsKpTMNGW9QulpLkiv
	 HMar1YB+zB9sHTZrbZRWPlsjKhVy6F7NpINzQkP0JuHtWm6c3EHAywjfK19zO3+ZWC6y9
	 1+tR/FWML+UZDF7VEUQEDvNKbre3CoSc5R6aS1P9MQohO7zcb/ZqxMddbWDT6RepEHQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 577C11F000C9;
	Tue, 20 Oct 2026 18:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792520918;
	bh=Z5zSggzBne2c+TcNuspBgPLfuRtz5PeeaW0VSn/S1BU=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=FbopTNcgrGFHEydP43sUD6i3obdVCrJp/i9aYVvUIk6oe1+vaz7PuS2Zad8XqPDHi
	 hxw63hLUEecwwVIlR+1yPSmwRqghhhX3wEbfVX2mMRDJefifM7xcq9OJkwlX85eCKC
	 ehUiT5RjMCeUAk9w3xTJfjEiJTFLztmKeVXL8l45u1T4SRJZBDHMjHtRSE1slfpg2e
	 XQ96+0Un6YSxePyROISMK6qhYpwMhy28Ev2MN5YW/bAPKsBl81NMnWptg3aX2Pm93I
	 NukpOrK5rlNVc7a2CY1Xiwot26lCKi/kx9H/SufEkH8vGJDDnR/k7AzzIU4B8XeYzg
	 D0ujboI2A9GcA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AEFBD4320B;
	Tue, 20 Oct 2026 18:28:37 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Date: Tue, 20 Oct 2026 21:28:37 +0300
Subject: [PATCH] wifi: mt76: dma: run threaded NAPI kthreads with
 SCHED_FIFO low priority
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261020-b4-mt76-napi-fifo-v1-1-ac8a24e2062a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqEMAxA0atI1gZqqQpeRVzYmsxEsEqrIhTvP
 h1dvsX/CSIFoQhdkSDQKVFWn1GVBbjv6D+EMmWDVrqplFZoDS5726AfN0EWXnFyNbFhp401kLs
 tEMv1PPvhdTzsTG7/j+C+f+QaXPF1AAAA
X-Change-ID: 20261020-b4-mt76-napi-fifo-dc5ef4fc24b4
To: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com
Cc: shayne.chen@mediatek.com, sean.wang@mediatek.com, 
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 Fil Dunsky <filipp.dunsky@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792520916; l=2932;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=gTH2kexAA/EJvNPz+GCLDxl2HKRZ9qNQnHFrv8bnx/A=;
 b=1t7HqYA5U6ggeRCUvO/xOQ1LgjTa3bTc8sYP5vdhFE+66gXRT/Kqf1T8KfB6+5t+Sn/iNaxZ3
 Hsw/op0cOlyAiCj2QCJUfMRemJtwrbQZj08yB4jhEnSdKO3pB16/try
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com
Content-Transfer-Encoding: 7bit

From: Fil Dunsky <filipp.dunsky@gmail.com>

mt76 enables threaded NAPI for the dma rx queues, but the napi kthreads
stay SCHED_OTHER, unlike the usb and sdio rx/status workers and the tx
worker, which already use sched_set_fifo_low().

On MT7621 (MIPS 1004Kc, 2 cores / 4 threads, PREEMPT_NONE, HZ=100) with
MT7612E (mt76x2e) as a 5 GHz client receiving ~200 Mbit/s while
userspace keeps the CPUs busy, the napi kthread is regularly delayed by
10-30 ms or more and the 256-entry rx ring fills up completely
(instrumented: ~500 full-ring events in 5 minutes). Occasionally the
chip's rx DMA does not resume after such an event: WPDMA_GLO_CFG reports
rx and tx DMA busy, RXQ_STA shows the PBF rx queue at RX_MAX_PCNT, the
host ring has free buffers, beacons are lost, then tx DMA stops (dma_idx
stuck with frames queued), the tx hang watchdog fires, followed by
"MCU message ... timed out" and a second restart. A series of these
sometimes hangs the whole system.

With the napi kthreads at SCHED_FIFO 1 the ring overflowed once in 5
minutes, no watchdog resets occurred in repeated 5 minute runs and rx
throughput in the same setup went from ~210 to ~280 Mbit/s. A larger rx
ring (1024 entries) did not help: it still overflowed and resets were
more frequent.

Set the napi kthread priority right after netif_napi_add(), as done for
the other workers.

Signed-off-by: Fil Dunsky <filipp.dunsky@gmail.com>
---
Tested on Securifi Almond 3 (MT7621, MT7612E + MT7602E) with OpenWrt
25.12.6 (kernel 6.12.112, mt76 2026-03-19 39c960c3 plus this change):
iperf3 bidirectional, 4 streams, 5 GHz client link at -66 dBm, with a
userspace proxy and a display daemon running. Without the change 2-3
watchdog resets in most 5 minute runs and several full-system hangs;
with it 0 resets over 6 runs.

A similar reset chain under full CPU load on MT7620A + MT7612E is
reported in https://github.com/openwrt/openwrt/issues/8984
---
 drivers/net/wireless/mediatek/mt76/dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a67880a92..8e66fad7b 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1128,6 +1128,11 @@ mt76_dma_rx_queue_init(struct mt76_dev *dev, enum mt76_rxq_id qid,
 		       int (*poll)(struct napi_struct *napi, int budget))
 {
 	netif_napi_add(dev->napi_dev, &dev->napi[qid], poll);
+	/* Same as the usb/sdio rx workers: under CPU load a SCHED_OTHER napi
+	 * thread can be starved long enough for the rx ring to overflow.
+	 */
+	if (dev->napi[qid].thread)
+		sched_set_fifo_low(dev->napi[qid].thread);
 	mt76_dma_rx_fill_buf(dev, &dev->q_rx[qid], false);
 	napi_enable(&dev->napi[qid]);
 }

---
base-commit: 6474fa070f2b8013b4b87350b775b8c3be6e8aac
change-id: 20261020-b4-mt76-napi-fifo-dc5ef4fc24b4

Best regards,
--  
Fil Dunsky <filipp.dunsky@gmail.com>


