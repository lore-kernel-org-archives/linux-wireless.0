Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0092.outbound.protection.outlook.com ([157.55.234.92]:62688
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753617AbbGUPFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:05:21 -0400
From: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: [PATCH] ath10k: suppress 'failed to process fft' warning messages.
Date: Tue, 21 Jul 2015 15:50:15 +0100
Message-ID: <1437490215-11214-1-git-send-email-kevin@darbyshire-bryant.me.uk> (sfid-20150721_170524_207149_DDA65FE7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using DFS channels on Ath10k, kernel log has repeated warning message
'failed to process fft: -22' typically under medium/heavy traffic.

This patch switches the warnings to driver debug (WMI events) mode only
thus reducing log file noise.

DFS and spectral scan share underlying HW mechanisms and enabling one
(DFS) enables the other (spectral scan) as far as event reporting from
firmware to driver is concerned. Spectral scan events take no part in
processing of DFS radar pulses which are delivered as distinct events,
so the fft (spectral event) warning is harmless and DFS interference
detection/protection still occurs.

Symptoms seen & fix tested in both debug & non-debug modes on TP-Link
Archer C7 v2 platform.

Signed-off-by: Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 0791a43..1435614 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3498,7 +3498,7 @@ void ath10k_wmi_event_spectral_scan(struct ath10k *ar,
 							  fftr, fftr_len,
 							  tsf);
 			if (res < 0) {
-				ath10k_warn(ar, "failed to process fft report: %d\n",
+				ath10k_dbg(ar, ATH10K_DBG_WMI, "failed to process fft report: %d\n",
 					    res);
 				return;
 			}
-- 
1.9.1

