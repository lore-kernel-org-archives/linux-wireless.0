Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659933;
	b=2jjG1NsAl20wgcQ+8qNlUVgfK4yVa53pJmexiBtqB8pjO38o0+mxnZCHTAxI1Dd97ulT
	 eTo/RMP/eE4s3BtxeGF86mrL8p7PJPJwiCI9DkTfIIagL93V+vJ9ATPX3Zy1WiJKO5lIJ
	 edcZvPJI5hTTm0mUMMq5DANYuCI5yyvKJwkAAzjtUedGQhUCN20hd0soYfuv68+kHHM4a
	 LGgPSN1HjpWC3jrngTvJXXsG3u5adUynTF12tULhBFH8/c0ijUNDuEBl9Rs7VCVsrvSM1
	 al8ST+H6jAK5E2s0SOJMu5TOIYiqgiOTjyajNsfi6TqtHQ0NZI7ygPw/uxpOXT8VRgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659933;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4lfvLxZU2+QNlhQ5TIQ/WB48GBF4osf/Z52ednXK17E=;
	b=TKooTdfgMJcFFpXVUFaIFQG03i9Qx7d/8QzHAC//cJw7oECVpSw20wW62bes20NYJ9uu
	 +uq99yUv1dEoTqquJqq61Y8N7+q+F2RHTeMruDLFfdOXljndJOop/iFO3XFu0Ne1X9jp0
	 ieIp3w25zmI8H7+7fcS9vZqd7R5btABoNlnrv7xaK+aGeDL4kyICPUj2sOs+V1GoJdeEK
	 ZJbnqnaVXEYKCH2jR6YP0ImZbEpf/dF1MvBfUP9Ls+3JCHhrwO9dqmhZTPXHUJeJIXDPg
	 3sQqjr9g6u6t/yzbNtZZSAzmbpiUZGhUTPLIm9bS8+FfvMfcZrFPJal2F8c6rdZAjbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=AiL0PcZc;
	arc=none smtp.remote-ip=91.218.175.45
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E8606D801
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531E8606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=AiL0PcZc
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pUTCvzdg+v4gmfitrml4BUgXdrrwNA7eRDpocfMXH+k=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793659927; v=1; x=1794264727;
 b=AiL0PcZcCt5LpvrEo90hbXS/TKY20LkKyIlTeeck6SyRpgx1hrwE1hLS4Gkl76Fw6aFOctyc
 qH3h/4VjvQ9hQSrc6MdDBKkHrGn2DdL8ETM8EL93d+NFj0PMgcFYHZ4iqG9Cb5bDGW2dIJPId4b
 RsXTjniZpXDCdh4aFvSGgtkeySfXN4KVG5TvDr9LWPDrwqGcf6zD+KMvEaTjLC21fjR1XX280i9
 +m8VW7hBEnqwgziQuaaNfAc8KgeE02GobIo4vDEaDh2H7w6SH19aFaztr8eTJ2wzcZPX87vyJsU
 GgkQUaZCdoa5/W9LvLwuqYqijAbliFc3b50oPbWIEhklQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d92317b42c0e722c;
	Mon, 02 Nov 2026 22:52:07 +0000
X-Mizu-Trace-ID: d92317b42c0e722c
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Xiong <xiong.huang@mediatek.com>,
	Charlie-cy Wu <charlie-cy.wu@mediatek.corp-partner.google.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Eason Lai <eason.lai@mediatek.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mt76: mt7921e: fix unregister deadlock
Date: Mon,  2 Nov 2026 15:52:00 -0700
Message-ID: <20261102225200.16172-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <aujjJPq-Qth7UyMp@casper.infradead.org>
References: <aujjJPq-Qth7UyMp@casper.infradead.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removing the driver can hang forever when the chip stops answering.

Removal disables NAPI and only then waits for the reset work, which a
failing chip keeps queuing. That reset disables NAPI again and never
returns.

Do what mt7925e does: mark the device removed once it is unregistered,
so no new reset is queued, and cancel the reset work before disabling
NAPI.

Fixes: 3d78c46423c6 ("wifi: mt76: mt7921e: stop chip reset worker in unregister hook")
Reported-by: Matthew Wilcox <willy@infradead.org>
Closes: https://lore.kernel.org/all/aujjJPq-Qth7UyMp@casper.infradead.org/
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
Reproduced on an MT7922 by putting the chip in D3hot under the driver:
the same driver own and chip reset failures, then rmmod waiting in the
same stack while the reset work is stuck disabling NAPI.

  dead chip, rmmod                  result
  6.18.52, in-tree                  hangs
  mt76 03dd150dbd36                 returns
    with this patch                 returns
    75673ab3c0e4 reverted           hangs
    reverted, with this patch       returns, 3 of 3

Since 75673ab3c0e4 the reset stops early when driver own fails, so
current mt76 gets through a fully dead chip. That commit is not in
v7.3, and any reset that gets as far as NAPI still hangs.

This needs the removed check in the reset helper from 79941e85f4b3. A
normal rmmod and a debugfs chip reset work as before.

Matthew, thanks for the stack trace.

 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index f87c44f2a8b6..1ff219005d14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -52,11 +52,12 @@ static void mt7921e_unregister_device(struct mt792x_dev *dev)
 
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
+	set_bit(MT76_REMOVED, &dev->mphy.state);
+	cancel_work_sync(&dev->reset_work);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
-	cancel_work_sync(&dev->reset_work);
 
 	mt76_connac2_tx_token_put(&dev->mt76);
 	__mt792x_mcu_drv_pmctrl(dev);
@@ -460,7 +461,6 @@ static void mt7921_pci_remove(struct pci_dev *pdev)
 		device_init_wakeup(dev->mt76.dev, false);
 
 	mt7921e_unregister_device(dev);
-	set_bit(MT76_REMOVED, &mdev->phy.state);
 	devm_free_irq(&pdev->dev, pdev->irq, dev);
 	mt76_free_device(&dev->mt76);
 	pci_free_irq_vectors(pdev);
-- 
2.56.0

