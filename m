Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:57762 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508Ab2HGXTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 19:19:13 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: fix powerpc64-linux- compilation warnings
Date: Tue,  7 Aug 2012 16:08:08 -0700
Message-Id: <1344380888-13731-1-git-send-email-bzhao@marvell.com> (sfid-20120808_011922_991124_FABA578D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings can be detected by using powerpc64-linux toolchain
(gcc-4.6.3-nolibc).

  CC [M]  drivers/net/wireless/mwifiex/sta_event.o
drivers/net/wireless/mwifiex/sta_event.c: In function 'mwifiex_process_sta_event':
drivers/net/wireless/mwifiex/sta_event.c:388:4: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  CC [M]  drivers/net/wireless/mwifiex/uap_event.o
drivers/net/wireless/mwifiex/uap_event.c: In function 'mwifiex_process_uap_event':
drivers/net/wireless/mwifiex/uap_event.c:258:11: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Use min_t() instead of min() to fix the warnings.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_event.c |    9 +++++----
 drivers/net/wireless/mwifiex/uap_event.c |    9 ++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 2aad148..4758d30 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -186,6 +186,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u32 eventcause = adapter->event_cause;
+	u16 ctrl;
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
@@ -382,11 +383,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 					      adapter->event_body);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
-		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
-			*(u16 *) adapter->event_body);
+		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
+		dev_dbg(adapter->dev, "event: AMSDU_AGGR_CTRL %d\n", ctrl);
+
 		adapter->tx_buf_size =
-			min(adapter->curr_tx_buf_size,
-			    le16_to_cpu(*(__le16 *) adapter->event_body));
+				min_t(u16, adapter->curr_tx_buf_size, ctrl);
 		dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
 			adapter->tx_buf_size);
 		break;
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 14d4f04..1703abf 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -170,6 +170,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 	struct mwifiex_sta_node *node;
 	u8 *deauth_mac;
 	struct host_cmd_ds_11n_batimeout *ba_timeout;
+	u16 ctrl;
 
 	switch (eventcause) {
 	case EVENT_UAP_STA_ASSOC:
@@ -250,14 +251,12 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
 		break;
 	case EVENT_AMSDU_AGGR_CTRL:
-		dev_dbg(adapter->dev, "event:  AMSDU_AGGR_CTRL %d\n",
-			*(u16 *)adapter->event_body);
+		ctrl = le16_to_cpu(*(__le16 *)adapter->event_body);
+		dev_dbg(adapter->dev, "event: AMSDU_AGGR_CTRL %d\n", ctrl);
 
 		if (priv->media_connected) {
 			adapter->tx_buf_size =
-			       min(adapter->curr_tx_buf_size,
-				   le16_to_cpu(*(__le16 *)adapter->event_body));
-
+				min_t(u16, adapter->curr_tx_buf_size, ctrl);
 			dev_dbg(adapter->dev, "event: tx_buf_size %d\n",
 				adapter->tx_buf_size);
 		}
-- 
1.7.0.2

