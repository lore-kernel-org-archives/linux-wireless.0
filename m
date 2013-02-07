Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45532 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3BGMsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 07:48:22 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <eliad@wizery.com>, <arik@wizery.com>
Subject: [PATCH] wlcore: fix wrong remote rates when starting STA role
Date: Thu, 7 Feb 2013 14:47:24 +0200
Message-ID: <1360241244-15832-1-git-send-email-coelho@ti.com> (sfid-20130207_134826_707653_145E11A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wl18xx, we use a new ACX command in order to set the remote
supported rates, once we know it (ie. after association).  The wl12xx
firmware doesn't support changing the rates after the STA is started,
so we need to use all supported rates.

Commit 530abe19 (wlcore: add ACX_PEER_CAP command) broke that by using
wlvif->rate_set when starting the STA role.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 1201aca..6331f9e 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -510,10 +510,12 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.hlid = wlvif->sta.hlid;
 	cmd->sta.session = wl->session_ids[wlvif->sta.hlid];
 	/*
-	 * We don't have the correct remote rates in this stage. the rates
-	 * will be reconfigured later, after authorization.
+	 * We don't have the correct remote rates in this stage.  The
+	 * rates will be reconfigured later, after association, if the
+	 * firmware supports ACX_PEER_CAP.  Otherwise, there's nothing
+	 * we can do, so use all supported_rates here.
 	 */
-	cmd->sta.remote_rates = cpu_to_le32(wlvif->rate_set);
+	cmd->sta.remote_rates = cpu_to_le32(supported_rates);
 
 	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
 		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
-- 
1.7.10.4

