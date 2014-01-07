Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58607 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaAGMJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:09:43 -0500
Date: Tue, 7 Jan 2014 13:09:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 08/13] wl1251: fix channel switching in monitor mode
Message-ID: <20140107120942.GH10836@amd.pavel.ucw.cz> (sfid-20140107_130946_426509_48EBD894)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

Use the ENABLE_RX command for channel switching when no interface is present
(monitor mode only).
The advantage of ENABLE_RX is that it leaves the tx data path disabled in
firmware, whereas the usual JOIN command seems to transmit some frames at
firmware level.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
 drivers/net/wireless/ti/wl1251/main.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 1223bc6..b6f11b8 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -616,8 +616,19 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
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
