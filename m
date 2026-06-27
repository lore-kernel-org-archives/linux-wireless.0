Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D319E96D
	for <linux-wireless@vger.kernel.org>; Sat, 27 Jun 2026 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782592199; cv=none; b=XqUCMu04oXwhXf/oBEM1KdDIjX4YM+KcFIuj60Qq/wpV0u5o9wZz6PThCQtH58g/CCzakwyExxX/tEM12QgHVXP5x/1btMK57W9ZmfkSB8s5m7g9ktvpDmhs+urap3yzFO/Tah2kbGKvkyv42DyqPXNzDabMqQwYMVhwBWSJAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782592199; c=relaxed/simple;
	bh=WFxHOKFuU4ZLdOCEL2akXHBapOGC3sY+m8YzWg/lMmw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qw44AvNze4aw/bXvCd2b5djtFWgmFzb91/oKvRor5zp2p1VIdhRmUl0edRsAxl1q0lVRbJZIGD4vnw4PW3A8MbzpET7HMcaxpXRTEbUdXEoaFdIFX347VQqFrcGaq1ypoYOrjg+vJHMgaJoAZOiodGTkWbainTdQ3ynJv6S2C+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=c5QkCS3R; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="c5QkCS3R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=justthetip.ca;
	s=key1; t=1782592193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cX//rKQbRWujMDX+iR1QZ8ujdfSkPwyBBiatuoAXbNY=;
	b=c5QkCS3RQx7WAPeD9ocM4c3RfWaVZ+Mgan6Z1kyMwTtZMvPz4urWZzbvQEArEVAuTbYNh2
	FaY1cVziqUF+C7iv6SzeeHSAinbbf7CThF4+F9TckoO3AsW0e5ZYbhbVy5FXD1J+9XiVl7
	PRrvQUch9xoPotzkCNyVoSCUWPMaUWSadpzVKKusx1eBgOWXgNIcH7iyFZbCp7sgH7Mj1F
	fIemLOfeZubl2aBy1aANiwgDjQUwyPrQ2o+0YQpZNfaTiPh7MbbNhvT8y1Gbq0Em7erzz7
	/oJ6xaCuybUSkmVvJgnqxME9JUHCLvqlwVHA7EjVuc77XETW/kwjNqAqzAwMBQ==
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	linux-wireless@vger.kernel.org
Cc: Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mt76: mt7925: cancel mlo_pm_work on stop
Date: Sat, 27 Jun 2026 13:29:46 -0700
Message-ID: <20260627202946.25598-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

mt7925 queues mlo_pm_work with a 5 second delay during multi-link
power-save setup and never cancels it on the stop path. If the device is
torn down inside that window, the work outlives the teardown and its timer
fires afterwards, trying to queue onto the workqueue that is already gone:

  workqueue: cannot queue mt7925_mlo_pm_work [mt7925_common] on wq phy0
  WARNING: kernel/workqueue.c:2283 at __queue_work+0x59/0xa0, CPU#1: swapper/1/0
   call_timer_fn+0x2a/0x140
   __run_timers+0x203/0x330
   run_timer_softirq+0x86/0xf0

mt7921 already has its own stop callback, so add one for mt7925 that
cancels the work before calling mt792x_stop(). mt7925_ops backs both the
PCIe and USB drivers, so this covers both.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Tested-by: Traockl <281473483+Traockl@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a9059866b701..9156530272c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2481,10 +2481,19 @@ static void mt7925_channel_switch_rx_beacon(struct ieee80211_hw *hw,
 	}
 }
 
+static void mt7925_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
+
+	mt792x_stop(hw, suspend);
+}
+
 const struct ieee80211_ops mt7925_ops = {
 	.tx = mt792x_tx,
 	.start = mt7925_start,
-	.stop = mt792x_stop,
+	.stop = mt7925_stop,
 	.add_interface = mt7925_add_interface,
 	.remove_interface = mt792x_remove_interface,
 	.config = mt7925_config,
-- 
2.54.0

