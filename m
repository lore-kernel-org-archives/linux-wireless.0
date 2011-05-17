Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28959 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1EQHfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:35:12 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:34:42 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath_hw: Fix bssid mask documentation
Date: Tue, 17 May 2011 13:05:05 +0530
Message-ID: <1305617705-2940-1-git-send-email-mshajakhan@atheros.com> (sfid-20110517_093517_428167_77747497)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/hw.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index cc11d66..3f508e5 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -43,7 +43,7 @@
  * set of  ~ ( MAC XOR BSSID ) for all bssids we handle.
  *
  * When you do this you are essentially computing the common bits of all your
- * BSSes. Later it is assumed the harware will "and" (&) the BSSID mask with
+ * BSSes. Later it is assumed the hardware will "and" (&) the BSSID mask with
  * the MAC address to obtain the relevant bits and compare the result with
  * (frame's BSSID & mask) to see if they match.
  *
@@ -71,8 +71,8 @@
  *             On loop iteration for BSSID-02:
  *             bssid_mask &= ~(0001   ^   1001)
  *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
- *             bssid_mask =   (1010)  & ~(1001)
- *             bssid_mask =   (1010)  &  (0110)
+ *             bssid_mask =   (1010)  & ~(1000)
+ *             bssid_mask =   (1010)  &  (0111)
  *             bssid_mask =   0010
  *
  * A bssid_mask of 0010 means "only pay attention to the second least
@@ -102,11 +102,9 @@
  *
  * IFRAME-02:  0001 (we should allow)
  *
- *     allow = (0001 & 1010) == 1010
- *
  *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
  *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
- *  --> allow = (0010) == (0010)
+ *  --> allow = (0000) == (0000)
  *  --> allow = 1
  *
  * Other examples:
-- 
1.7.0.4

