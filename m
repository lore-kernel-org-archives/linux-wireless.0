Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:54483 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYE3H1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:27:40 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7RUD0003133
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:30 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7RUYh024801
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:30 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7RTfo024798
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:27:30 +0900 (JST)
Date: Fri, 30 May 2008 16:27:24 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] PS3: gelic: Allocate the bounce buffer dynamically
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530132951.4720.40F06B3A@sm.sony.co.jp>
References: <20080530132951.4720.40F06B3A@sm.sony.co.jp>
Message-Id: <20080530162153.4736.40F06B3A@sm.sony.co.jp> (sfid-20080530_092744_314703_E15C0470)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allocate the bouce buffer for the wireless command dynamically.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |   40 ++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1524,15 +1524,20 @@ static struct iw_statistics *gelic_wl_ge
 	struct gelic_eurus_cmd *cmd;
 	struct iw_statistics *is;
 	struct gelic_eurus_rssi_info *rssi;
+	void *buf;
 
 	pr_debug("%s: <-\n", __func__);
 
+	buf = (void *)__get_free_page(GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
 	is = &wl->iwstat;
 	memset(is, 0, sizeof(*is));
 	cmd = gelic_eurus_sync_cmd(wl, GELIC_EURUS_CMD_GET_RSSI_CFG,
-				   wl->buf, sizeof(*rssi));
+				   buf, sizeof(*rssi));
 	if (cmd && !cmd->status && !cmd->cmd_status) {
-		rssi = wl->buf;
+		rssi = buf;
 		is->qual.level = be16_to_cpu(rssi->rssi);
 		is->qual.updated = IW_QUAL_LEVEL_UPDATED |
 			IW_QUAL_QUAL_INVALID | IW_QUAL_NOISE_INVALID;
@@ -1541,6 +1546,7 @@ static struct iw_statistics *gelic_wl_ge
 		is->qual.updated = IW_QUAL_ALL_INVALID;
 
 	kfree(cmd);
+	free_page((unsigned long)buf);
 	pr_debug("%s: ->\n", __func__);
 	return is;
 }
@@ -1607,11 +1613,18 @@ static void gelic_wl_scan_complete_event
 	union iwreq_data data;
 	unsigned long this_time = jiffies;
 	unsigned int data_len, i, found, r;
+	void *buf;
 	DECLARE_MAC_BUF(mac);
 
 	pr_debug("%s:start\n", __func__);
 	mutex_lock(&wl->scan_lock);
 
+	buf = (void *)__get_free_page(GFP_KERNEL);
+	if (!buf) {
+		pr_info("%s: scan buffer alloc failed\n", __func__);
+		goto out;
+	}
+
 	if (wl->scan_stat != GELIC_WL_SCAN_STAT_SCANNING) {
 		/*
 		 * stop() may be called while scanning, ignore result
@@ -1622,7 +1635,7 @@ static void gelic_wl_scan_complete_event
 	}
 
 	cmd = gelic_eurus_sync_cmd(wl, GELIC_EURUS_CMD_GET_SCAN,
-				   wl->buf, PAGE_SIZE);
+				   buf, PAGE_SIZE);
 	if (!cmd || cmd->status || cmd->cmd_status) {
 		wl->scan_stat = GELIC_WL_SCAN_STAT_INIT;
 		pr_info("%s:cmd failed\n", __func__);
@@ -1649,7 +1662,7 @@ static void gelic_wl_scan_complete_event
 	}
 
 	/* put them in the newtork_list */
-	for (i = 0, scan_info_size = 0, scan_info = wl->buf;
+	for (i = 0, scan_info_size = 0, scan_info = buf;
 	     scan_info_size < data_len;
 	     i++, scan_info_size += be16_to_cpu(scan_info->size),
 	     scan_info = (void *)scan_info + be16_to_cpu(scan_info->size)) {
@@ -1726,6 +1739,7 @@ static void gelic_wl_scan_complete_event
 	wireless_send_event(port_to_netdev(wl_port(wl)), SIOCGIWSCAN, &data,
 			    NULL);
 out:
+	free_page((unsigned long)buf);
 	complete(&wl->scan_done);
 	mutex_unlock(&wl->scan_lock);
 	pr_debug("%s:end\n", __func__);
@@ -1848,7 +1862,10 @@ static int gelic_wl_do_wep_setup(struct 
 
 	pr_debug("%s: <-\n", __func__);
 	/* we can assume no one should uses the buffer */
-	wep = wl->buf;
+	wep = (struct gelic_eurus_wep_cfg *)__get_free_page(GFP_KERNEL);
+	if (!wep)
+		return -ENOMEM;
+
 	memset(wep, 0, sizeof(*wep));
 
 	if (wl->group_cipher_method == GELIC_WL_CIPHER_WEP) {
@@ -1898,6 +1915,7 @@ static int gelic_wl_do_wep_setup(struct 
 
 	kfree(cmd);
 out:
+	free_page((unsigned long)wep);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
 }
@@ -1941,7 +1959,10 @@ static int gelic_wl_do_wpa_setup(struct 
 
 	pr_debug("%s: <-\n", __func__);
 	/* we can assume no one should uses the buffer */
-	wpa = wl->buf;
+	wpa = (struct gelic_eurus_wpa_cfg *)__get_free_page(GFP_KERNEL);
+	if (!wpa)
+		return -ENOMEM;
+
 	memset(wpa, 0, sizeof(*wpa));
 
 	if (!test_bit(GELIC_WL_STAT_WPA_PSK_SET, &wl->stat))
@@ -2000,6 +2021,7 @@ static int gelic_wl_do_wpa_setup(struct 
 	else if (cmd->status || cmd->cmd_status)
 		ret = -ENXIO;
 	kfree(cmd);
+	free_page((unsigned long)wpa);
 	pr_debug("%s: --> %d\n", __func__, ret);
 	return ret;
 }
@@ -2018,7 +2040,10 @@ static int gelic_wl_associate_bss(struct
 	pr_debug("%s: <-\n", __func__);
 
 	/* do common config */
-	common = wl->buf;
+	common = (struct gelic_eurus_common_cfg *)__get_free_page(GFP_KERNEL);
+	if (!common)
+		return -ENOMEM;
+
 	memset(common, 0, sizeof(*common));
 	common->bss_type = cpu_to_be16(GELIC_EURUS_BSS_INFRA);
 	common->op_mode = cpu_to_be16(GELIC_EURUS_OPMODE_11BG);
@@ -2104,6 +2129,7 @@ static int gelic_wl_associate_bss(struct
 		pr_info("%s: connected\n", __func__);
 	}
 out:
+	free_page((unsigned long)common);
 	pr_debug("%s: ->\n", __func__);
 	return ret;
 }

