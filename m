Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:43788 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbdEaK13 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 06:27:29 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] b43legacy: Fix a sleep-in-atomic bug in b43legacy_attr_interfmode_store
Date: Wed, 31 May 2017 18:29:07 +0800
Message-Id: <1496226547-5921-1-git-send-email-baijiaju1990@163.com> (sfid-20170531_122807_434033_1B771F37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver may sleep under a spin lock, and the function call path is:
b43legacy_attr_interfmode_store (acquire the lock by spin_lock_irqsave)
  b43legacy_radio_set_interference_mitigation
    b43legacy_radio_interference_mitigation_disable
      b43legacy_calc_nrssi_slope
        b43legacy_synth_pu_workaround
          might_sleep and msleep --> may sleep

Fixing it may be complex, and a possible way is to remove 
spin_lock_irqsave and spin_lock_irqrestore in 
b43legacy_attr_interfmode_store, and the code has been protected by
mutex_lock and mutex_unlock.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/net/wireless/broadcom/b43legacy/sysfs.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/sysfs.c b/drivers/net/wireless/broadcom/b43legacy/sysfs.c
index 2a1da15..9ede143 100644
--- a/drivers/net/wireless/broadcom/b43legacy/sysfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/sysfs.c
@@ -137,14 +137,12 @@ static ssize_t b43legacy_attr_interfmode_store(struct device *dev,
 	}
 
 	mutex_lock(&wldev->wl->mutex);
-	spin_lock_irqsave(&wldev->wl->irq_lock, flags);
 
 	err = b43legacy_radio_set_interference_mitigation(wldev, mode);
 	if (err)
 		b43legacyerr(wldev->wl, "Interference Mitigation not "
 		       "supported by device\n");
 	mmiowb();
-	spin_unlock_irqrestore(&wldev->wl->irq_lock, flags);
 	mutex_unlock(&wldev->wl->mutex);
 
 	return err ? err : count;
-- 
1.7.9.5
