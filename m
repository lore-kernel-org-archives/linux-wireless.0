Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E95C1A680B
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785198060; cv=none; b=GgqouieHMZylRYcbyrS5Bl/pXdM0M5SR46YFYHtVUItESyAvU4EFUWG5JxRKYMHsUe0ssdWe4/ARu9dwCV7xxT769F7/rFrZbSyMfsJoBKhMwVUj/B7pA+4Gw0V0oBtkehRdhqI6yw1qBkWydqc+U1bf70AhRYsgJ6mI2+7HW7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785198060; c=relaxed/simple;
	bh=AZBQH6sw52yRt+5IEYJ7WV8tHhvOu6zLPIHly2NM52c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eFpVswqbxD/d3GNL/76KJw1dSM4mBsXBGgPdgVfHWPnBvSzKrAP4q7MXVPDHwwDMkfVbaxnhw3F+0yb3KFsVPp6e5OHX2T/Dc4kd9nYjeXsoGYqWrHB/a+OOP9iIvHnX0gmXzA5R8YZPtY7N3TKiLrVBIgvTIj5ks3qVfgHWXmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hestyPTV; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hestyPTV"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b00d083818so381969e87.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 17:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785198056; x=1785802856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FMLSvv5jcG839oN8ASkK2rci5K2oL9ElHsLObCCCdZM=;
        b=hestyPTVZZV92Z0NGXqpw+heGpnluKespgcvOuDwRUGi/MNrJX3dZFCQ5QS54NrOLO
         WGbazGN+BM5S8SA9/27iR2ftcgcQtLDiA+wpez0VgGymxBLK49XnVXy3AVaJs8z4+nxj
         h3X+0fSC4BKmojvbsHB6wGjvsjTfQMvb63arcT9KZbfqZvXqTGXugGBfi/3mJektIF8c
         FFZrtn45PA6SWbcqdJ4xatr1tHqiv41HNNFFh4u64aiBC4+QMG1QjcQ2lT2jHvr0qL++
         LBGy0NrnHVYQrLrfOfZpXerqfYGWGu1kolkBuzNjP8G6VNi/id29GPMDuRhgBIv1YZQn
         RyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785198056; x=1785802856;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FMLSvv5jcG839oN8ASkK2rci5K2oL9ElHsLObCCCdZM=;
        b=J9uLblZ5mPrM2bBnHmGbZa3dvkT2Qq6U6RqLMJg/4b1hHfWn38DT2qTAUrvxJViDEV
         Ef3hsE1ffPElLRX9QxjIyvb2x+qE+GiKehdf2mzZdfaoA5V+geYn2eugNdv8OVTGJMW9
         btP7mpwWlV/3ymrXiNTCmnFkTAG5xMzavgSf579M/ZpLzVmKmUYMCragJXaziDjJcotE
         MhA6uFqT2mhyFW59Rq1wRb2DElbdBeMWhcPP2ibEJ9dyEGCvwPVBuis0FwDckubWTvuE
         dcRm0Aq9nquEcjtw391B3GZ3uxmzl3nlAusk5VtMqWJUoK8Vkh3L+Q1M4yzQYfqWxNFz
         oUYA==
X-Gm-Message-State: AOJu0Yz8uYbs4/SgkAG6lUMVmrr1v2EW8gIR9TG822vBwOVhFQuUy3/H
	ZxhiuL+Q1hLJsECh6nc0Qb7HHXe3uPNwTMvE7MTluaenw/YNqORMiPBgCHh0WFDnmlcHjA==
X-Gm-Gg: AR+sD13JG9nJv7f4a5NlgqxCXQNnIi8YQRaSWXyOD04MvQvvvmdWK4GFbQMf6Q2Iit+
	l3PZlRWRIlrb66ecbnAV3UaKKeJtdZG51YgNkhDt75bwNeIT57jKgTFCCUrOHoyIaK9U6PXRn5R
	QMrZ1CjR/qRzle+yO646oteF96OjLwPZ4O8UVOoV4zLLocYkcQQJO/PmmDP1NBxaahwxewXQOpl
	zboCOte2or6jXcz49L6npgOdXI35NOJ1XsTnBPlMEUSx50QMULOQFqTFGUPQFf393Ut+fX9gt93
	DFPX/JhUoCZzemt/t6rPzFNionVDGIi42lZxGL1zDS2VtbZf2df2zKfJPijceYyHKpDWQo08+Cz
	M4syXIqZTD4CBEzSA6cGrHNkzuglgUQugBBM+TqlrJ3Jy5RMssjOjObTnWQdHm+q48DTvtMi45R
	v8PUKIV+E7Ne4=
X-Received: by 2002:a05:6512:3a92:b0:5b2:a3a2:1395 with SMTP id 2adb3069b0e04-5b2d020d7b9mr22054e87.3.1785198055823;
        Mon, 27 Jul 2026 17:20:55 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2be0817c2sm1760096e87.23.2026.07.27.17.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 17:20:54 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bert Karwatzki <spasswolf@web.de>,
	linux-kernel@vger.kernel.org,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in unregister path
Date: Tue, 28 Jul 2026 05:20:48 +0500
Message-ID: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
made mt76_dma_cleanup() disable every RX NAPI instance before deleting
it.  mt7921e_unregister_device() and mt7925e_unregister_device() already
disable the very same instances and only afterwards call
mt792x_dma_cleanup() -> mt76_dma_cleanup(), so each instance is now
disabled twice.

napi_disable() is not idempotent: on return it leaves NAPIF_STATE_SCHED
and NAPIF_STATE_NPSVC set, so a second call without an intervening
napi_enable() spins in usleep_range() forever, waiting for bits that
nobody will clear:

  task:modprobe        state:D stack:25720 pid:7954  tgid:7954
  Call Trace:
   <TASK>
   __schedule+0x11b8/0x26d0
   schedule+0xe7/0x2f0
   schedule_hrtimeout_range_clock+0x218/0x330
   usleep_range_state+0x133/0x1b0
   napi_disable_locked+0x37d/0x5f0
   napi_disable+0x43/0x80
   mt76_dma_cleanup+0x2b4/0x860 [mt76]
   mt7921_pci_remove+0x17f/0x350 [mt7921e]
   pci_device_remove+0xb6/0x1e0
   device_release_driver_internal+0x38d/0x540
   driver_detach+0xd0/0x1b0
   bus_remove_driver+0x127/0x2d0
   pci_unregister_driver+0x2a/0x280
   __do_sys_delete_module+0x36a/0x5b0
   do_syscall_64+0x11c/0x6d0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

mt7921_pci_shutdown() and mt7925_pci_shutdown() reuse the remove path,
so the same deadlock is hit on every reboot and poweroff.  It is silent:
the stuck task keeps sleeping and rescheduling, so neither the hung task
detector nor the lockup detectors fire, and the last line on the console
is "systemd-shutdown[1]: Rebooting."

Drop the driver-side loops and rely on mt76_dma_cleanup() instead.
mt792x_dma_cleanup() stops and resets the WFDMA engine before calling
it, so RX is already quiesced when the NAPI instances are disabled
there.

Fixes: 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
Reported-by: Bert Karwatzki <spasswolf@web.de>
Closes: https://lore.kernel.org/all/20260724151419.26014-1-spasswolf@web.de/
Suggested-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
---

I hit the same hang on an ASRock B650I Lightning WiFi with MT7922
(mt7921e) and bisected it to the same commit.  mt7921e has the same
duplicated napi_disable() as mt7925e, so this covers both; it is
Nicolas' suggestion from [1] extended to mt7921e and with the now
unused 'int i' removed.
 
Tested on 7.2.0-rc5 with KASAN and lockdep enabled, MT7922 / mt7921e.
Before the patch 'modprobe -r mt7921e' hangs (backtrace above, taken
with sysrq-w) and the machine never gets past "Rebooting.".  With the
patch 'modprobe -r mt7921e' and 'modprobe mt7921e' both complete and
the interface comes back up, reboot and poweroff work again, and no
__netif_napi_del_locked() or page_pool_disable_direct_recycling()
warnings are logged.
 
[1] https://lore.kernel.org/all/59c03ab1-ec4a-411b-9b7e-8183ecf3e02b@green-communications.fr/

 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 3 ---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 7728c5ae6791..65d09d13304f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -43,7 +43,6 @@ static int mt7921e_init_reset(struct mt792x_dev *dev)
 
 static void mt7921e_unregister_device(struct mt792x_dev *dev)
 {
-	int i;
 	struct mt76_connac_pm *pm = &dev->pm;
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
@@ -52,8 +51,6 @@ static void mt7921e_unregister_device(struct mt792x_dev *dev)
 
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
-	mt76_for_each_q_rx(&dev->mt76, i)
-		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 	cancel_work_sync(&dev->reset_work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index ea64303283ed..eb1bd60e3d9f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -36,7 +36,6 @@ static int mt7925e_init_reset(struct mt792x_dev *dev)
 
 static void mt7925e_unregister_device(struct mt792x_dev *dev)
 {
-	int i;
 	struct mt76_connac_pm *pm = &dev->pm;
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
@@ -45,8 +44,6 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
-	mt76_for_each_q_rx(&dev->mt76, i)
-		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 	cancel_work_sync(&dev->reset_work);
-- 
2.55.0

