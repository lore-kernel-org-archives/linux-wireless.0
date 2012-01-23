Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2AWPWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 10:22:31 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -stable 3.0] iwlegacy: 3945: fix hw passive scan on radar channels
Date: Mon, 23 Jan 2012 16:22:28 +0100
Message-Id: <1327332148-10983-1-git-send-email-sgruszka@redhat.com> (sfid-20120123_162233_798894_C1B3F071)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 68acc4afb040d98ddfd2cae0de09e2f4e1ee127f upstream.

Patch fix firmware error on "iw dev wlan0 scan passive" for
hardware scanning (with disable_hw_scan=0 module parameter).

 iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
 iwl3945 0000:03:00.0: Loaded firmware version: 15.32.2.9
 iwl3945 0000:03:00.0: Start IWL Error Log Dump:
 iwl3945 0000:03:00.0: Status: 0x0002A2E4, count: 1
 iwl3945 0000:03:00.0: Desc       Time       asrtPC blink2 ilink1  nmiPC   Line
 iwl3945 0000:03:00.0: SYSASSERT     (0x5) 0041263900 0x13756 0x0031C 0x00000 764
 iwl3945 0000:03:00.0: Error Reply type 0x000002FC cmd C_SCAN (0x80) seq 0x443E ser 0x00340000
 iwl3945 0000:03:00.0: Command C_SCAN failed: FW Error
 iwl3945 0000:03:00.0: Can't stop Rx DMA.

We have disable ability to change passive scanning to active on
particular channel when traffic is detected on that channel. Otherwise
firmware will report error, when we try to do passive scan on radar
channels.

Reported-and-debugged-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 421d5c8..a935585 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -2910,14 +2910,13 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		IWL_WARN(priv, "Invalid scan band\n");
 		return -EIO;
 	}
-
 	/*
-	 * If active scaning is requested but a certain channel
-	 * is marked passive, we can do active scanning if we
-	 * detect transmissions.
+	 * If active scaning is requested but a certain channel is marked
+	 * passive, we can do active scanning if we detect transmissions. For
+	 * passive only scanning disable switching to active on any channel.
 	 */
 	scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-					IWL_GOOD_CRC_TH_DISABLED;
+					IWL_GOOD_CRC_TH_NEVER;
 
 	if (!priv->is_internal_short_scan) {
 		scan->tx_cmd.len = cpu_to_le16(
-- 
1.7.1

