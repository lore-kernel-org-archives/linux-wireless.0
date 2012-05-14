Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:42783 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab2ENNKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 09:10:03 -0400
Received: by obcni5 with SMTP id ni5so9839462obc.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 06:10:01 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: wait for roc complete only for the first roc command
Date: Mon, 14 May 2012 16:07:38 +0300
Message-Id: <1337000858-13620-1-git-send-email-victorg@ti.com> (sfid-20120514_151013_728846_7907DF4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some multi role scenarios the driver might send multi
roc requests without sending a croc first, the fw queues
those requests and starts service the next roc request as
soon as the driver sends a croc for the previous one. So,
if the fw rocs on channel X and driver asks to roc also
on channel Y, the fw will not start service Y (and will
not send roc complete event for this request) until the
driver releases the fw with croc X.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 5b128a9..a742554 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1573,19 +1573,25 @@ out:
 int wl12xx_roc(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 role_id)
 {
 	int ret = 0;
+	bool is_first_roc;
 
 	if (WARN_ON(test_bit(role_id, wl->roc_map)))
 		return 0;
 
+	is_first_roc = (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) >=
+			WL12XX_MAX_ROLES);
+
 	ret = wl12xx_cmd_roc(wl, wlvif, role_id);
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_cmd_wait_for_event(wl,
-					REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID);
-	if (ret < 0) {
-		wl1271_error("cmd roc event completion error");
-		goto out;
+	if (is_first_roc) {
+		ret = wl1271_cmd_wait_for_event(wl,
+					   REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID);
+		if (ret < 0) {
+			wl1271_error("cmd roc event completion error");
+			goto out;
+		}
 	}
 
 	__set_bit(role_id, wl->roc_map);
-- 
1.7.5.4

