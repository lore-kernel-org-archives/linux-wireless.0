Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51300 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2DPK5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 06:57:20 -0400
Date: Mon, 16 Apr 2012 13:57:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] wlcore: release lock on error in wl1271_op_suspend()
Message-ID: <20120416105702.GA25234@elgon.mountain> (sfid-20120416_125725_098886_D91F368F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should release this lock before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2b0f987..23fc0d2 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1364,6 +1364,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		ret = wl1271_configure_suspend(wl, wlvif);
 		if (ret < 0) {
+			mutex_unlock(&wl->mutex);
 			wl1271_warning("couldn't prepare device to suspend");
 			return ret;
 		}
