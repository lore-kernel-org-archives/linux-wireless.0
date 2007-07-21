Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:48188 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757067AbXGUU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:11 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: fix rx rate stats
Message-Id: <20070721205912.AA3FD7B40A1@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:59:12 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

Andy Green provided a patch to fix the rate reporting of zd1211rw
for mac80211. He introduced a new function to do that, however
zd_rx_rate() has only one use, so I decided to update it directly
and not to introduce a new function.

Background: mac80211 converts the reported rate itself to the
values required by radiotap assuming that the device reports the
reception rates using the same values as for transmission. This is
not true for ZD1211. The device reports whether it has received a
CCK or OFDM packet and includes the PLCP header in the received
frame. The driver is computing the rate based on this, which is
later converted to the radiotap format by the mac80211 stack.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.c |   31 ++++++++++-----------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
index 4952cda..23ad520 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -1464,36 +1464,35 @@ u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
 		cck_qual_percent(status->signal_quality_cck);
 }
 
+/**
+ * zd_rx_rate - report rate as expected by mac80211
+ * @rx_frame - received frame
+ * @rx_status - rx_status as given by the device
+ *
+ * This function converts the rate as provided in struct rx_status to the
+ * format expected by the mac80211 stack. The stack expects the reported rate
+ * to use the same format as used in the rates table. This driver has to use
+ * the same values as used in the tx control set.
+ */
 u16 zd_rx_rate(const void *rx_frame, const struct rx_status *status)
 {
-	static const u16 ofdm_rates[] = {
-		[ZD_OFDM_RATE_6M]  = 60,
-		[ZD_OFDM_RATE_9M]  = 90,
-		[ZD_OFDM_RATE_12M] = 120,
-		[ZD_OFDM_RATE_18M] = 180,
-		[ZD_OFDM_RATE_24M] = 240,
-		[ZD_OFDM_RATE_36M] = 360,
-		[ZD_OFDM_RATE_48M] = 480,
-		[ZD_OFDM_RATE_54M] = 540,
-	};
 	u16 rate;
 	if (status->frame_status & ZD_RX_OFDM) {
-		u8 ofdm_rate = zd_ofdm_plcp_header_rate(rx_frame);
-		rate = ofdm_rates[ofdm_rate & 0xf];
+		rate = ZD_CS_OFDM | zd_ofdm_plcp_header_rate(rx_frame);
 	} else {
 		u8 cck_rate = zd_cck_plcp_header_rate(rx_frame);
 		switch (cck_rate) {
 		case ZD_CCK_SIGNAL_1M:
-			rate = 10;
+			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_1M;
 			break;
 		case ZD_CCK_SIGNAL_2M:
-			rate = 20;
+			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_2M;
 			break;
 		case ZD_CCK_SIGNAL_5M5:
-			rate = 55;
+			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_5_5M;
 			break;
 		case ZD_CCK_SIGNAL_11M:
-			rate = 110;
+			rate = ZD_CS_CCK | ZD_CS_CCK_RATE_11M;
 			break;
 		default:
 			rate = 0;
-- 
1.5.2.2

