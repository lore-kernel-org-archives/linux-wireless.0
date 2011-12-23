Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab1LWHOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 02:14:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/10] iwlegacy: 3945: fix hw passive scan on radar channels
Date: Fri, 23 Dec 2011 08:13:50 +0100
Message-Id: <1324624430-3688-10-git-send-email-sgruszka@redhat.com> (sfid-20111223_081425_663088_444006C9)
In-Reply-To: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
References: <1324624430-3688-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
 drivers/net/wireless/iwlegacy/3945-mac.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index c817975..54b2d39 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2623,12 +2623,12 @@ il3945_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	}
 
 	/*
-	 * If active scaning is requested but a certain channel
-	 * is marked passive, we can do active scanning if we
-	 * detect transmissions.
+	 * If active scaning is requested but a certain channel is marked
+	 * passive, we can do active scanning if we detect transmissions. For
+	 * passive only scanning disable switching to active on any channel.
 	 */
 	scan->good_CRC_th =
-	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_DISABLED;
+	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_NEVER;
 
 	len =
 	    il_fill_probe_req(il, (struct ieee80211_mgmt *)scan->data,
-- 
1.7.4.4

