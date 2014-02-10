Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:46548 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBJLro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:44 -0500
Received: by mail-we0-f169.google.com with SMTP id t61so4190939wes.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/18] wlcore: memset wl->rx_filter_enabled to zero after recovery
Date: Mon, 10 Feb 2014 13:47:17 +0200
Message-Id: <1392032854-28126-2-git-send-email-eliad@wizery.com> (sfid-20140210_124747_970294_9824429B)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nadim Zubidat <nadimz@ti.com>

zero rx_filter_enabled array after recovery to avoid
cases were the driver will keep trying to clear a
filter which is not configured in FW.

Such case will cause consecutive recoveries due to
command execution failures.

While on it, convert rx_filter_enabled to bitmap,
to save some memory and make sparse happy (it
doesn't like sizeof(bool array)).

Signed-off-by: Nadim Zubidat <nadimz@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c   | 1 +
 drivers/net/wireless/ti/wlcore/rx.c     | 9 ++++++---
 drivers/net/wireless/ti/wlcore/wlcore.h | 2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b46b311..da268e8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1914,6 +1914,7 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
 	memset(wl->session_ids, 0, sizeof(wl->session_ids));
+	memset(wl->rx_filter_enabled, 0, sizeof(wl->rx_filter_enabled));
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
 
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 6791a1a..94ab445 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -302,7 +302,7 @@ int wl1271_rx_filter_enable(struct wl1271 *wl,
 {
 	int ret;
 
-	if (wl->rx_filter_enabled[index] == enable) {
+	if (!!test_bit(index, wl->rx_filter_enabled) == enable) {
 		wl1271_warning("Request to enable an already "
 			     "enabled rx filter %d", index);
 		return 0;
@@ -316,7 +316,10 @@ int wl1271_rx_filter_enable(struct wl1271 *wl,
 		return ret;
 	}
 
-	wl->rx_filter_enabled[index] = enable;
+	if (enable)
+		__set_bit(index, wl->rx_filter_enabled);
+	else
+		__clear_bit(index, wl->rx_filter_enabled);
 
 	return 0;
 }
@@ -326,7 +329,7 @@ int wl1271_rx_filter_clear_all(struct wl1271 *wl)
 	int i, ret = 0;
 
 	for (i = 0; i < WL1271_MAX_RX_FILTERS; i++) {
-		if (!wl->rx_filter_enabled[i])
+		if (!test_bit(i, wl->rx_filter_enabled))
 			continue;
 		ret = wl1271_rx_filter_enable(wl, i, 0, NULL);
 		if (ret)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 06efc12..a3cc117 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -451,7 +451,7 @@ struct wl1271 {
 	size_t fw_status_priv_len;
 
 	/* RX Data filter rule state - enabled/disabled */
-	bool rx_filter_enabled[WL1271_MAX_RX_FILTERS];
+	unsigned long rx_filter_enabled[BITS_TO_LONGS(WL1271_MAX_RX_FILTERS)];
 
 	/* size of the private static data */
 	size_t static_data_priv_len;
-- 
1.8.5.2.229.g4448466.dirty

