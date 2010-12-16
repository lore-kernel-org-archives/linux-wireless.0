Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33120 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0LPUAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 15:00:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFT] rtlwifi: use alloc_workqueue
Date: Thu, 16 Dec 2010 14:59:49 -0500
Message-Id: <1292529589-5904-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

create_workqueue is deprecated.  The workqueue usage does not seem to
demand any special treatment, so do not set any flags either.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I don't have the hardware to test...

 drivers/net/wireless/rtlwifi/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 9e860ff..24a7cd3 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -225,7 +225,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);
+	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
-- 
1.7.3.3

