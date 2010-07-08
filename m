Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40333 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0GHOuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:25 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 01/13] wl1271: Remove calibration from join command
Date: Thu,  8 Jul 2010 17:49:56 +0300
Message-Id: <1278600608-22411-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch removes the calibration performed on the first join command. The
reasoning is that this is unnecessary as devices get their calibration data
via the NVS file, and because the commands break BT coexistence.

This is actually safe, because of the implementation the calibration
was executed on the first JOIN anyway, after an ifdown/ifup the devices have
relied on the NVS for calibration anyway (== most of the time.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |  104 ------------------------------
 1 files changed, 0 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 530678e..8307f21 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -104,100 +104,6 @@ out:
 	return ret;
 }
 
-static int wl1271_cmd_cal_channel_tune(struct wl1271 *wl)
-{
-	struct wl1271_cmd_cal_channel_tune *cmd;
-	int ret = 0;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	cmd->test.id = TEST_CMD_CHANNEL_TUNE;
-
-	cmd->band = WL1271_CHANNEL_TUNE_BAND_2_4;
-	/* set up any channel, 7 is in the middle of the range */
-	cmd->channel = 7;
-
-	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
-	if (ret < 0)
-		wl1271_warning("TEST_CMD_CHANNEL_TUNE failed");
-
-	kfree(cmd);
-	return ret;
-}
-
-static int wl1271_cmd_cal_update_ref_point(struct wl1271 *wl)
-{
-	struct wl1271_cmd_cal_update_ref_point *cmd;
-	int ret = 0;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	cmd->test.id = TEST_CMD_UPDATE_PD_REFERENCE_POINT;
-
-	/* FIXME: still waiting for the correct values */
-	cmd->ref_power    = 0;
-	cmd->ref_detector = 0;
-
-	cmd->sub_band     = WL1271_PD_REFERENCE_POINT_BAND_B_G;
-
-	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
-	if (ret < 0)
-		wl1271_warning("TEST_CMD_UPDATE_PD_REFERENCE_POINT failed");
-
-	kfree(cmd);
-	return ret;
-}
-
-static int wl1271_cmd_cal_p2g(struct wl1271 *wl)
-{
-	struct wl1271_cmd_cal_p2g *cmd;
-	int ret = 0;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	cmd->test.id = TEST_CMD_P2G_CAL;
-
-	cmd->sub_band_mask = WL1271_CAL_P2G_BAND_B_G;
-
-	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
-	if (ret < 0)
-		wl1271_warning("TEST_CMD_P2G_CAL failed");
-
-	kfree(cmd);
-	return ret;
-}
-
-static int wl1271_cmd_cal(struct wl1271 *wl)
-{
-	/*
-	 * FIXME: we must make sure that we're not sleeping when calibration
-	 * is done
-	 */
-	int ret;
-
-	wl1271_notice("performing tx calibration");
-
-	ret = wl1271_cmd_cal_channel_tune(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_cal_update_ref_point(wl);
-	if (ret < 0)
-		return ret;
-
-	ret = wl1271_cmd_cal_p2g(wl);
-	if (ret < 0)
-		return ret;
-
-	return ret;
-}
-
 int wl1271_cmd_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms_cmd *gen_parms;
@@ -295,20 +201,10 @@ static int wl1271_cmd_wait_for_event(struct wl1271 *wl, u32 mask)
 
 int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 {
-	static bool do_cal = true;
 	struct wl1271_cmd_join *join;
 	int ret, i;
 	u8 *bssid;
 
-	/* FIXME: remove when we get calibration from the factory */
-	if (do_cal) {
-		ret = wl1271_cmd_cal(wl);
-		if (ret < 0)
-			wl1271_warning("couldn't calibrate");
-		else
-			do_cal = false;
-	}
-
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
 	if (!join) {
 		ret = -ENOMEM;
-- 
1.6.3.3

