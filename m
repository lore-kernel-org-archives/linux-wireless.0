Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1H2UAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 16:00:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl12xx/sdio_test.c: fix build breakage from WL127X_FW_NAME change
Date: Mon, 29 Aug 2011 15:53:42 -0400
Message-Id: <1314647622-23164-1-git-send-email-linville@tuxdriver.com> (sfid-20110829_220025_097893_71F239FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit c302b2c959164622558474871ae942da0e484a38 ("wl12xx: Use a single
fw for both STA and AP roles") changed the name of the firmware name
definition, breaking the build of wl12xx/sdio_test.c.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/sdio_test.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index f289153..c361049 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -193,7 +193,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		ret = request_firmware(&fw, WL128X_FW_NAME,
 				       wl1271_wl_to_dev(wl));
 	else
-		ret = request_firmware(&fw, WL1271_FW_NAME,
+		ret = request_firmware(&fw, WL127X_FW_NAME,
 				       wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
-- 
1.7.4.4

