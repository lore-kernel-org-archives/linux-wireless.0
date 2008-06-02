Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:51299 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbYFBDtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 23:49:23 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m523nMVY024827
 for <linux-wireless@vger.kernel.org>; Mon, 2 Jun 2008 12:49:22 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m523nKU8018225
 for <linux-wireless@vger.kernel.org>; Mon, 2 Jun 2008 12:49:20 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m523nJHP018214
 for <linux-wireless@vger.kernel.org>; Mon, 2 Jun 2008 12:49:20 +0900 (JST)
Date: Mon, 02 Jun 2008 12:49:16 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3 v2] PS3: gelic: Add support for ESSID scan
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530162420.473C.40F06B3A@sm.sony.co.jp>
References: <20080530132951.4720.40F06B3A@sm.sony.co.jp> <20080530162420.473C.40F06B3A@sm.sony.co.jp>
Message-Id: <20080602124503.4765.40F06B3A@sm.sony.co.jp> (sfid-20080602_054945_943337_12306577)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the support for ESSID scanning

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 v2
	Add IW_SCAN_CAPA_ESSID capability flag

 drivers/net/ps3_gelic_wireless.c |   65 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 7 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -45,7 +45,8 @@
 #include "ps3_gelic_wireless.h"
 
 
-static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan);
+static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
+			       u8 *essid, size_t essid_len);
 static int gelic_wl_try_associate(struct net_device *netdev);
 
 /*
@@ -105,6 +106,7 @@ static const struct eurus_cmd_arg_info c
 	[GELIC_EURUS_CMD_GET_WEP_CFG]    = { .post_arg = 1},
 	[GELIC_EURUS_CMD_GET_WPA_CFG]    = { .post_arg = 1},
 	[GELIC_EURUS_CMD_GET_RSSI_CFG]   = { .post_arg = 1},
+	[GELIC_EURUS_CMD_START_SCAN]     = { .pre_arg = 1},
 	[GELIC_EURUS_CMD_GET_SCAN]       = { .post_arg = 1},
 };
 
@@ -163,7 +165,9 @@ static void gelic_eurus_sync_cmd_worker(
 	card = port_to_card(wl_port(wl));
 
 	if (cmd_info[cmd->cmd].pre_arg) {
-		arg1 = ps3_mm_phys_to_lpar(__pa(cmd->buffer));
+		arg1 = (cmd->buffer) ?
+			ps3_mm_phys_to_lpar(__pa(cmd->buffer)) :
+			0;
 		arg2 = cmd->buf_size;
 	} else {
 		arg1 = 0;
@@ -359,6 +363,9 @@ static int gelic_wl_get_range(struct net
 	range->num_encoding_sizes = 3;
 	range->max_encoding_tokens = GELIC_WEP_KEYS;
 
+	/* scan capability */
+	range->scan_capa = IW_SCAN_CAPA_ESSID;
+
 	pr_debug("%s: ->\n", __func__);
 	return 0;
 
@@ -370,8 +377,18 @@ static int gelic_wl_set_scan(struct net_
 			   union iwreq_data *wrqu, char *extra)
 {
 	struct gelic_wl_info *wl = port_wl(netdev_priv(netdev));
-
-	return gelic_wl_start_scan(wl, 1);
+	struct iw_scan_req *req;
+	u8 *essid = NULL;
+	size_t essid_len = 0;
+
+	if (wrqu->data.length == sizeof(struct iw_scan_req) &&
+	    wrqu->data.flags & IW_SCAN_THIS_ESSID) {
+		req = (struct iw_scan_req*)extra;
+		essid = req->essid;
+		essid_len = req->essid_len;
+		pr_debug("%s: ESSID scan =%s\n", __func__, essid);
+	}
+	return gelic_wl_start_scan(wl, 1, essid, essid_len);
 }
 
 #define OUI_LEN 3
@@ -1554,10 +1571,13 @@ static struct iw_statistics *gelic_wl_ge
 /*
  *  scanning helpers
  */
-static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan)
+static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
+			       u8 *essid, size_t essid_len)
 {
 	struct gelic_eurus_cmd *cmd;
 	int ret = 0;
+	void *buf = NULL;
+	size_t len;
 
 	pr_debug("%s: <- always=%d\n", __func__, always_scan);
 	if (mutex_lock_interruptible(&wl->scan_lock))
@@ -1580,12 +1600,27 @@ static int gelic_wl_start_scan(struct ge
 		complete(&wl->scan_done);
 		goto out;
 	}
+
+	/* ESSID scan ? */
+	if (essid_len && essid) {
+		buf = (void *)__get_free_page(GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		len = IW_ESSID_MAX_SIZE; /* hypervisor always requires 32 */
+		memset(buf, 0, len);
+		memcpy(buf, essid, essid_len);
+		pr_debug("%s: essid scan='%s'\n", __func__, (char *)buf);
+	} else
+		len = 0;
+
 	/*
 	 * issue start scan request
 	 */
 	wl->scan_stat = GELIC_WL_SCAN_STAT_SCANNING;
 	cmd = gelic_eurus_sync_cmd(wl, GELIC_EURUS_CMD_START_SCAN,
-				   NULL, 0);
+				   buf, len);
 	if (!cmd || cmd->status || cmd->cmd_status) {
 		wl->scan_stat = GELIC_WL_SCAN_STAT_INIT;
 		complete(&wl->scan_done);
@@ -1594,6 +1629,7 @@ static int gelic_wl_start_scan(struct ge
 	}
 	kfree(cmd);
 out:
+	free_page((unsigned long)buf);
 	mutex_unlock(&wl->scan_lock);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
@@ -2281,6 +2317,9 @@ static void gelic_wl_assoc_worker(struct
 
 	struct gelic_wl_scan_info *best_bss;
 	int ret;
+	unsigned long irqflag;
+	u8 *essid;
+	size_t essid_len;
 
 	wl = container_of(work, struct gelic_wl_info, assoc_work.work);
 
@@ -2289,7 +2328,19 @@ static void gelic_wl_assoc_worker(struct
 	if (wl->assoc_stat != GELIC_WL_ASSOC_STAT_DISCONN)
 		goto out;
 
-	ret = gelic_wl_start_scan(wl, 0);
+	spin_lock_irqsave(&wl->lock, irqflag);
+	if (test_bit(GELIC_WL_STAT_ESSID_SET, &wl->stat)) {
+		pr_debug("%s: assoc ESSID configured %s\n", __func__,
+			 wl->essid);
+		essid = wl->essid;
+		essid_len = wl->essid_len;
+	} else {
+		essid = NULL;
+		essid_len = 0;
+	}
+	spin_unlock_irqrestore(&wl->lock, irqflag);
+
+	ret = gelic_wl_start_scan(wl, 0, essid, essid_len);
 	if (ret == -ERESTARTSYS) {
 		pr_debug("%s: scan start failed association\n", __func__);
 		schedule_delayed_work(&wl->assoc_work, HZ/10); /*FIXME*/

