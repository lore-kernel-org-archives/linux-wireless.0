Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbcCRQUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 12:20:53 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>, Arik Nemtsov <arik@wizery.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Avraham Stern <avraham.stern@intel.com>,
	Eliad Peller <eliad@wizery.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] wl12xx: remove redundant null check on wl->scan.ssid
Date: Fri, 18 Mar 2016 16:20:48 +0000
Message-Id: <1458318048-28184-1-git-send-email-colin.king@canonical.com> (sfid-20160318_172114_613939_503EA889)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

ssid is an array of u8, so it can never be null, so the null check on
wl->scan.ssid is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ti/wl12xx/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
index ebed13a..a0dfc59 100644
--- a/drivers/net/wireless/ti/wl12xx/scan.c
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -149,7 +149,7 @@ static int wl1271_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	else
 		cmd->params.band = WL1271_SCAN_BAND_5_GHZ;
 
-	if (wl->scan.ssid_len && wl->scan.ssid) {
+	if (wl->scan.ssid_len) {
 		cmd->params.ssid_len = wl->scan.ssid_len;
 		memcpy(cmd->params.ssid, wl->scan.ssid, wl->scan.ssid_len);
 	}
-- 
2.7.3

