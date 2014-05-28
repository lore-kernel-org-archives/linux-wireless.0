Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22902 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaE1Ejs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 00:39:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix a crash in extended scan event processing
Date: Tue, 27 May 2014 21:39:32 -0700
Message-ID: <1401251974-18738-1-git-send-email-bzhao@marvell.com> (sfid-20140528_063951_347235_8992EA8A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

[113.967694] Unable to handle kernel NULL pointer dereference
               at virtual address 00000020
............
[113.967859] PC is at mwifiex_update_rxreor_flags+0xfc/0x430
............
[113.968110] mwifiex_update_rxreor_flags+0xfc/0x430
[113.968129] mwifiex_handle_event_ext_scan_report+0x1e4/0x21c
[113.968148] mwifiex_process_sta_event+0x410/0x508
[113.968165] mwifiex_process_event+0x184/0x1e0
[113.968181] mwifiex_main_process+0x220/0x48c
[113.968197] mwifiex_sdio_interrupt+0xc8/0x1cc
[113.968210] sdio_irq_thread+0x11c/0x290

In case of legacy scan, adapter->curr_cmd is guranteed to be
non-NULL in check_next_scan_cmd. This may not be case in
extended scan where scan command response would come earlier and
set curr_cmd to NULL. Extended scan event comes later and while
trying to complete IOCTL for scan, driver would crash in
dereferencing adapter->curr_cmd->wait_q_enabled.

Avoid this by completing IOCTL in case of legacy scans only.
Internal scan would be completed while handling extended scan
command response.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index d75f4eb..45c5b34 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1738,6 +1738,19 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 	return 0;
 }
 
+static void mwifiex_complete_scan(struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (adapter->curr_cmd->wait_q_enabled) {
+		adapter->cmd_wait_q.status = 0;
+		if (!priv->scan_request) {
+			dev_dbg(adapter->dev, "complete internal scan\n");
+			mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+		}
+	}
+}
+
 static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1751,16 +1764,9 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-		/* Need to indicate IOCTL complete */
-		if (adapter->curr_cmd->wait_q_enabled) {
-			adapter->cmd_wait_q.status = 0;
-			if (!priv->scan_request) {
-				dev_dbg(adapter->dev,
-					"complete internal scan\n");
-				mwifiex_complete_cmd(adapter,
-						     adapter->curr_cmd);
-			}
-		}
+		if (!adapter->ext_scan)
+			mwifiex_complete_scan(priv);
+
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
 
@@ -1965,6 +1971,9 @@ int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
 int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)
 {
 	dev_dbg(priv->adapter->dev, "info: EXT scan returns successfully\n");
+
+	mwifiex_complete_scan(priv);
+
 	return 0;
 }
 
-- 
1.8.2.3

