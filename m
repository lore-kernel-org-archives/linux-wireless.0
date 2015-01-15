Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46923 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbAOLnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 06:43:24 -0500
Date: Thu, 15 Jan 2015 14:43:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>, Ram Amrani <ramrani@ti.com>
Cc: Eliad Peller <eliad@wizery.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wlcore: unlock on error in wl1271_op_suspend()
Message-ID: <20150115114340.GC17976@mwanda> (sfid-20150115_124328_874599_80AA315A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We recently introduced a new error path which needs an unlock.

Fixes: 6d5a748d4836 ('wlcore: add ability to reduce FW interrupts during suspend')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker fix.  It's possible that wl1271_ps_elp_wakeup() unlocks
on error but I didn't see it, and that would be an ugly API.

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index e90fb78..02f0e86 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1785,8 +1785,10 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	mutex_lock(&wl->mutex);
 
 	ret = wl1271_ps_elp_wakeup(wl);
-	if (ret < 0)
+	if (ret < 0) {
+		mutex_unlock(&wl->mutex);
 		return ret;
+	}
 
 	wl->wow_enabled = true;
 	wl12xx_for_each_wlvif(wl, wlvif) {
