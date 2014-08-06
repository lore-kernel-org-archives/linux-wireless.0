Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24113 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbaHFHc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2014 03:32:27 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 04/13] wil6210: check error in wil_target_reset()
Date: Wed, 6 Aug 2014 10:31:52 +0300
Message-ID: <1407310322-22568-5-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140806_093231_608241_11F29408)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

When resetting target in wil_target_reset(), error may occur.
Indicate error via error code. In case of error, don't attempt to further
interact with card, specifically don't attempt firmware download or
interrupts enabling.

Move wil_rx_fini() to be always executed to prevent memory leak.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index dc22053..5a99342 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -309,7 +309,7 @@ void wil_priv_deinit(struct wil6210_priv *wil)
 	destroy_workqueue(wil->wmi_wq);
 }
 
-static void wil_target_reset(struct wil6210_priv *wil)
+static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
 	u32 hw_state;
@@ -395,7 +395,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 		if (delay++ > 100) {
 			wil_err(wil, "Reset not completed, hw_state 0x%08x\n",
 				hw_state);
-			return;
+			return -ETIME;
 		}
 	} while (hw_state != HW_MACHINE_BOOT_DONE);
 
@@ -407,6 +407,7 @@ static void wil_target_reset(struct wil6210_priv *wil)
 	wmb(); /* order is important here */
 
 	wil_dbg_misc(wil, "Reset completed in %d ms\n", delay);
+	return 0;
 
 #undef R
 #undef W
@@ -471,10 +472,11 @@ int wil_reset(struct wil6210_priv *wil)
 	flush_workqueue(wil->wmi_wq_conn);
 	flush_workqueue(wil->wmi_wq);
 
-	/* TODO: put MAC in reset */
-	wil_target_reset(wil);
-
+	rc = wil_target_reset(wil);
 	wil_rx_fini(wil);
+	if (rc)
+		return rc;
+
 
 	/* init after reset */
 	wil->pending_connect_cid = -1;
-- 
1.8.5.2

