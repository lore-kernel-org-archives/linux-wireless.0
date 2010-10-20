Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28101 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0JTMVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 08:21:42 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9KCLeqY002381
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 15:21:41 +0300
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: exit ELP mode when setting enabled rates in tx
Date: Wed, 20 Oct 2010 15:21:40 +0300
Message-Id: <1287577300-9240-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

This bug was being triggered by a call to acx_rate_policies in tx_work
without calling ps_elp_wakeup first.  If we have full PSM enabled, this
happens rather often, immediately after association.

Reported-by: Tuomas Katila <ext-tuomas.2.katila@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 46fafe0..279be5b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -261,6 +261,11 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 
 	/* if rates have changed, re-configure the rate policy */
 	if (unlikely(sta_rates)) {
+		ret = wl1271_ps_elp_wakeup(wl, false);
+		if (ret < 0)
+			goto out;
+		woken_up = true;
+
 		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
 		wl1271_acx_rate_policies(wl);
 	}
-- 
1.7.0.4

