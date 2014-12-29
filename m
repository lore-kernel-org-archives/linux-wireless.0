Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51745 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaL2GYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:37 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so18145029wgg.11
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:36 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.34
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:35 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/13] wlcore: add dfs region to reg domain update cmd
Date: Mon, 29 Dec 2014 08:24:12 +0200
Message-Id: <1419834253-18331-12-git-send-email-eliad@wizery.com> (sfid-20141229_074347_019289_6EC84849)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Mishol <guym@ti.com>

Add dfs region to the reg domain channel update command.

Signed-off-by: Guy Mishol <guym@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c    | 1 +
 drivers/net/wireless/ti/wlcore/cmd.h    | 2 ++
 drivers/net/wireless/ti/wlcore/main.c   | 4 ++++
 drivers/net/wireless/ti/wlcore/wlcore.h | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 50ca10c..c26fc21 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1736,6 +1736,7 @@ int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
 
 	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
 	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
+	cmd->dfs_region = wl->dfs_region;
 
 	wl1271_debug(DEBUG_CMD,
 		     "cmd reg domain bitmap1: 0x%08x, bitmap2: 0x%08x",
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 06bdee2..e14cd40 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -648,6 +648,8 @@ struct wl12xx_cmd_regdomain_dfs_config {
 
 	__le32 ch_bit_map1;
 	__le32 ch_bit_map2;
+	u8 dfs_region;
+	u8 padding[3];
 } __packed;
 
 struct wl12xx_cmd_config_fwlog {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d99f289..ebb03b9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -82,6 +82,10 @@ static void wl1271_reg_notify(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct wl1271 *wl = hw->priv;
 
+	/* copy the current dfs region */
+	if (request)
+		wl->dfs_region = request->dfs_region;
+
 	wlcore_regdomain_config(wl);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 581c479..d599c86 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -465,6 +465,9 @@ struct wl1271 {
 	/* HW HT (11n) capabilities */
 	struct ieee80211_sta_ht_cap ht_cap[WLCORE_NUM_BANDS];
 
+	/* the current dfs region */
+	enum nl80211_dfs_regions dfs_region;
+
 	/* size of the private FW status data */
 	size_t fw_status_len;
 	size_t fw_status_priv_len;
-- 
1.8.5.2.229.g4448466.dirty

