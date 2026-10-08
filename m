Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C91373C1A
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 05:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791437110; cv=none; b=BUbj5X15tKhKVecCUvi/CC2M8MJA8fd4uAW4S4ax+JypqsZZI7EHLoiSSyol1v79qf/M8uPLpqyfyUZlRkCrV0vnuTIx8dTcilltPhv9t9bAsU1nLO+ms5iSJ14A+aS1/9u92Rxz1p31S9MfNGwJ2wAM44+QBQANHO0TUhmFFpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791437110; c=relaxed/simple;
	bh=7KhcOGrGoWDxS+0zbMVo71nXrQNFAeMV9emjoiKNtS4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZBkM++DoSWxHr0FdeiE2AwpCcIocLKSoDrZBynXbgAnf3PGvyKVG68ShsO7oi2aVMDaFBru6No/qWWPLORpYk0GXs4UsxXxHqIu/wusY9XGNKP/pA6lUXNJoF095qLpETjrb9rfw0ypbB/IDGpnj2Hv1S9SKTcjCqqkPOtk2RK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TGBx3jY4; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TGBx3jY4"
X-UUID: 9a558fecc2d811f1b1788b6acf885367-20261008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=cBapcVUEPq2DV9/lbtDCUq2OC1ML+XYqyYlRGjTF2Cw=;
	b=TGBx3jY4i3NoKFKGp/g/eA5xKJiB48GFZvP+xxuSlJtnD4DErTmc3/cao+KpnhKwUqQbKyQ27Qu14fT2YC8p94ELlN2J2YI6bK5KqbuTo2grk3vmpytaW/aqrw4C6lyNBQCOU17NzNfgvOKGSMoxKYDGsVngrXQo76TZVpUenx4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:6c6246ae-e039-46b4-a44d-36e51f931b16,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:74521820-2f17-48f6-b8a0-2bb5971c52b4,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9a558fecc2d811f1b1788b6acf885367-20261008
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1133545021; Thu, 08 Oct 2026 13:24:58 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Oct 2026 13:24:57 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 8 Oct 2026 13:24:57 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <jeff.hsu@mediatek.com>,
	<eason.lai@mediatek.com>, Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: Fixes: Fix SER will panic when connect to AP
Date: Thu, 8 Oct 2026 13:24:53 +0800
Message-ID: <20261008052453.3977058-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Jeff Hsu <Jeff.Hsu@mediatek.com>

MAC reset(mt7925e_mac_reset) not check all the RX Q and stop napi
it will result racing then happen panic

kernel: wlp1s0: associated
kernel: wlp1s0: Limiting TX power to 30 (30 - 0) dBm as advertised by 02:0c:43:36:60:c8
kernel: ------------[ cut here ]------------
kernel: kernel BUG at net/core/dev.c:7436!
kernel: Oops: invalid opcode: 0000 [#1] SMP NOPTI
kernel: CPU: 1 UID: 0 PID: 459 Comm: kworker/u48:8 Tainted: G S         OE       6.17.0-061700-generic #202509282239 PREEMPT(voluntary)
kernel: Tainted: [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
kernel: Hardware name: HP HP ProDesk 600 G6 Microtower PC/8712, BIOS S02 Ver. 02.05.01 01/05/2021
kernel: Workqueue: mt76 mt7925_mac_reset_work [mt7925_common]
kernel: RIP: 0010:napi_enable_locked+0x1cb/0x220
kernel: Code: 48 c7 c7 10 2c 1e 87 e8 93 c4 2f 00 4c 8b 6d e0 e9 e9 fe ff ff e8 75 31 ff ff 48 8b 45 e0 48 8d 53 10 a8 01 0f 85 02 ff ff ff <0f> 0b 8b bb a0 01 00 00 48 83 c6 18 e8 04 59 20 ff 48 8b b3 e8 01
kernel: RSP: 0018:ffffd1e8418afd48 EFLAGS: 00010246
kernel: RAX: 0000000000000110 RBX: ffff8a2921952cf8 RCX: 0000000000000000
kernel: RDX: ffff8a2921952d08 RSI: 0000000000000000 RDI: 0000000000000000
kernel: RBP: ffffd1e8418afd68 R08: 0000000000000000 R09: 0000000000000000
kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff8a2921955658
kernel: R13: 0000000000000110 R14: ffff8a2921952918 R15: ffff8a2921955758
kernel: FS:  0000000000000000(0000) GS:ffff8a3088300000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000561733e012d8 CR3: 000000011aa40005 CR4: 00000000003726f0
kernel: Call Trace:
kernel:  <TASK>
kernel:  napi_enable+0x25/0x50
kernel:  mt7925e_mac_reset+0x1a9/0x480 [mt7925e]
kernel:  mt7925_mac_reset_work+0x9a/0x1a0 [mt7925_common]
kernel:  ? __schedule+0x2f6/0x7c0
kernel:  process_one_work+0x18d/0x370
kernel:  worker_thread+0x33a/0x480
kernel:  ? _raw_spin_lock_irqsave+0xe/0x20
kernel:  ? __pfx_worker_thread+0x10/0x10
kernel:  kthread+0x108/0x220
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork+0x124/0x140
kernel:  ? __pfx_kthread+0x10/0x10
kernel:  ret_from_fork_asm+0x1a/0x30

Fixes: c4edf9e3e0e5 ("wifi: mt76: mt7925: replace shared rx irq masks with per-chip definitions")
Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/pci_mac.c   | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 2549d4e9e3a4..c3db814b2788 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -90,16 +90,11 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	mt76_txq_schedule_all(&dev->mphy);
 
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	if (irq_map->rx.data_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MAIN]);
-	if (irq_map->rx.wm_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MCU]);
-	if (irq_map->rx.wm2_complete_mask)
-		napi_disable(&dev->mt76.napi[MT_RXQ_MCU_WA]);
-	if (is_mt7928(&dev->mt76) && (irq_map->rx.wm4_complete_mask))
-		napi_disable(&dev->mt76.napi[MT_RXQ_ICS]);
-	if (irq_map->tx.all_complete_mask)
-		napi_disable(&dev->mt76.tx_napi);
+
+	mt76_for_each_q_rx(&dev->mt76, i)
+		napi_disable(&dev->mt76.napi[i]);
+
+	napi_disable(&dev->mt76.tx_napi);
 
 	mt7925_tx_token_put(dev);
 	idr_init(&dev->mt76.token);
-- 
2.45.2

