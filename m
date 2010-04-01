Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:44352 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0DAIiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:38:50 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] wl1271: Fix keep-alive related command error
Date: Thu,  1 Apr 2010 11:38:19 +0300
Message-Id: <1270111104-29549-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The firmware does not like the host configuring the keep-alive after it has
been once configured after a join-operation. Instead, it will complain about
invalid parameters, which do not break functionality, but do not look nice
in the syslog either.

This patch prevents the complaints by only configuring the keep-alive once
for an association, after the first time join is performed with the correct
bssid.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 033cef0..2494c96 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1569,6 +1569,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	enum wl1271_cmd_ps_mode mode;
 	struct wl1271 *wl = hw->priv;
 	bool do_join = false;
+	bool do_keepalive = false;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
@@ -1685,6 +1686,14 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 
+			/*
+			 * This is awkward. The keep-alive configs must be done
+			 * *after* the join command, because otherwise it will
+			 * not work, but it must only be done *once* because
+			 * otherwise the firmware will start complaining.
+			 */
+			do_keepalive = true;
+
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
 			if (ret < 0)
@@ -1763,6 +1772,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		ret = wl1271_acx_aid(wl, wl->aid);
 		if (ret < 0)
 			goto out_sleep;
+	}
+
+	if (do_keepalive) {
 		ret = wl1271_cmd_build_klv_null_data(wl);
 		if (ret < 0)
 			goto out_sleep;
-- 
1.6.3.3

