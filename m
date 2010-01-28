Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vervifontaine.sonycom.com ([80.88.33.193]:58802 "EHLO
	pophost.sonytel.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873Ab0A1MXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 07:23:38 -0500
From: Hamish Guthrie <hamish.guthrie@sonycom.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	cbe-oss-dev@ozlabs.org, Hamish Guthrie <hamish.guthrie@sonycom.com>
Subject: [PATCH 2/2] ps3_gelic_wireless: fix directed ssid scan
Date: Thu, 28 Jan 2010 12:54:10 +0100
Message-Id: <1264679650-14201-3-git-send-email-hamish.guthrie@sonycom.com>
In-Reply-To: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com>
References: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the association worker requests a directed ssid scan and a bss list
already exists, the directed scan is not done. This patch corrects this
and cleans up a few typos and debug messages.

Signed-off-by: Hamish Guthrie <hamish.guthrie@sonycom.com>
---
 drivers/net/ps3_gelic_wireless.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 7571dbb..d520e9e 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1449,7 +1449,8 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
 	void *buf = NULL;
 	size_t len;
 
-	pr_debug("%s: <- always=%d\n", __func__, always_scan);
+	pr_debug("%s: <- always=%d essid_len=%d\n", __func__,
+		 always_scan, essid_len);
 	if (mutex_lock_interruptible(&wl->scan_lock))
 		return -ERESTARTSYS;
 
@@ -1464,8 +1465,10 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
 	init_completion(&wl->scan_done);
 	/*
 	 * If we have already a bss list, don't try to get new
+	 * unless we are doing an ESSID scan
 	 */
-	if (!always_scan && wl->scan_stat == GELIC_WL_SCAN_STAT_GOT_LIST) {
+	if ((!essid_len && !always_scan)
+	    && wl->scan_stat == GELIC_WL_SCAN_STAT_GOT_LIST) {
 		pr_debug("%s: already has the list\n", __func__);
 		complete(&wl->scan_done);
 		goto out;
@@ -1566,7 +1569,7 @@ static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 		}
 	}
 
-	/* put them in the newtork_list */
+	/* put them in the network_list */
 	for (i = 0, scan_info_size = 0, scan_info = buf;
 	     scan_info_size < data_len;
 	     i++, scan_info_size += be16_to_cpu(scan_info->size),
@@ -1902,7 +1905,7 @@ static int gelic_wl_do_wpa_setup(struct gelic_wl_info *wl)
 	/* PSK type */
 	wpa->psk_type = cpu_to_be16(wl->psk_type);
 #ifdef DEBUG
-	pr_debug("%s: sec=%s psktype=%s\nn", __func__,
+	pr_debug("%s: sec=%s psktype=%s\n", __func__,
 		 wpasecstr(wpa->security),
 		 (wpa->psk_type == GELIC_EURUS_WPA_PSK_BIN) ?
 		 "BIN" : "passphrase");
@@ -1912,9 +1915,9 @@ static int gelic_wl_do_wpa_setup(struct gelic_wl_info *wl)
 	 * the debug log because this dumps your precious
 	 * passphrase/key.
 	 */
-	pr_debug("%s: psk=%s\n",
+	pr_debug("%s: psk=%s\n", __func__,
 		 (wpa->psk_type == GELIC_EURUS_WPA_PSK_BIN) ?
-		 (char *)"N/A" : (char *)wpa->psk);
+		 "N/A" : wpa->psk);
 #endif
 #endif
 	/* issue wpa setup */
-- 
1.6.2.4

