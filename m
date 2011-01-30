Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:57740 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1A3STd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:33 -0500
Message-ID: <4D45A7A0.5010408@davizone.at>
Date: Sun, 30 Jan 2011 19:02:08 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 16/18] wl1251: fix channel switching in monitor mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the ENABLE_RX command for channel switching when no interface is present
(monitor mode only).
The advantage of ENABLE_RX is that it leaves the tx data path disabled in
firmware, whereas the usual JOIN command seems to transmit some frames at
firmware level.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/main.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index edafa98..c931a3a 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -610,8 +610,19 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (channel != wl->channel) {
 		wl->channel = channel;
 
-		ret = wl1251_join(wl, wl->bss_type, wl->channel,
-				  wl->beacon_int, wl->dtim_period);
+		/*
+		 * Use ENABLE_RX command for channel switching when no
+		 * interface is present (monitor mode only).
+		 * This leaves the tx path disabled in firmware, whereas
+		 * the usual JOIN command seems to transmit some frames
+		 * at firmware level.
+		 */
+		if (wl->vif == NULL) {
+			ret = wl1251_cmd_data_path_rx(wl, wl->channel, 1);
+		} else {
+			ret = wl1251_join(wl, wl->bss_type, wl->channel,
+					  wl->beacon_int, wl->dtim_period);
+		}
 		if (ret < 0)
 			goto out_sleep;
 	}
-- 
1.7.0.4


