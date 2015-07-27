Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53719 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbbG0Ohe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 10:37:34 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id t6REbXKl023137
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 09:37:33 -0500
Received: from DLEE70.ent.ti.com (dlee70.ent.ti.com [157.170.170.113])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id t6REbXAg025245
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2015 09:37:33 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore: add antenna diversity reading comments
Date: Mon, 27 Jul 2015 17:25:49 +0300
Message-ID: <1438007149-23044-1-git-send-email-guym@ti.com> (sfid-20150727_163737_162832_F322D57F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add comments to the antenna diversity reading

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wlcore/rx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 7df672a..5b29273 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -74,6 +74,12 @@ static void wl1271_rx_status(struct wl1271 *wl,
 	if (desc->rate <= wl->hw_min_ht_rate)
 		status->flag |= RX_FLAG_HT;
 
+	/*
+	* Read the signal level and antenna diversity indication.
+	* The msb in the signal level is always set as it is a
+	* negative number.
+	* The antenna indication is the msb of the rssi.
+	*/
 	status->signal = ((desc->rssi & RSSI_LEVEL_BITMASK) | BIT(7));
 	status->antenna = ((desc->rssi & ANT_DIVERSITY_BITMASK) >> 7);
 
-- 
1.7.0.4

