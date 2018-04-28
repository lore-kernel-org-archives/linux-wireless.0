Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40968 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759710AbeD1Jg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Apr 2018 05:36:26 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix spelling mistake: "capabilties" -> "capabilities"
Date: Sat, 28 Apr 2018 10:36:21 +0100
Message-Id: <20180428093621.6806-1-colin.king@canonical.com> (sfid-20180428_113645_078214_1836F044)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in function names and text strings

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 10 +++++-----
 drivers/net/wireless/marvell/mwifiex/uap_event.c |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 93dfb76cd8a6..01636c1b7447 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -27,9 +27,9 @@
 
 #define MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE    12
 
-static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
-					       struct mwifiex_sta_node *sta_ptr,
-					       struct sk_buff *event)
+static int mwifiex_check_ibss_peer_capabilities(struct mwifiex_private *priv,
+						struct mwifiex_sta_node *sta_ptr,
+						struct sk_buff *event)
 {
 	int evt_len, ele_len;
 	u8 *curr;
@@ -42,7 +42,7 @@ static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
 	evt_len = event->len;
 	curr = event->data;
 
-	mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilties:",
+	mwifiex_dbg_dump(priv->adapter, EVT_D, "ibss peer capabilities:",
 			 event->data, event->len);
 
 	skb_push(event, MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE);
@@ -933,7 +933,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 			    ibss_sta_addr);
 		sta_ptr = mwifiex_add_sta_entry(priv, ibss_sta_addr);
 		if (sta_ptr && adapter->adhoc_11n_enabled) {
-			mwifiex_check_ibss_peer_capabilties(priv, sta_ptr,
+			mwifiex_check_ibss_peer_capabilities(priv, sta_ptr,
 							     adapter->event_skb);
 			if (sta_ptr->is_11n_enabled)
 				for (i = 0; i < MAX_NUM_TID; i++)
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index e8c8728db15a..5c57efe24f6a 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_event.c
@@ -23,8 +23,8 @@
 
 #define MWIFIEX_BSS_START_EVT_FIX_SIZE    12
 
-static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
-					 struct sk_buff *event)
+static int mwifiex_check_uap_capabilities(struct mwifiex_private *priv,
+					  struct sk_buff *event)
 {
 	int evt_len;
 	u8 *curr;
@@ -38,7 +38,7 @@ static int mwifiex_check_uap_capabilties(struct mwifiex_private *priv,
 	evt_len = event->len;
 	curr = event->data;
 
-	mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilties:",
+	mwifiex_dbg_dump(priv->adapter, EVT_D, "uap capabilities:",
 			 event->data, event->len);
 
 	skb_push(event, MWIFIEX_BSS_START_EVT_FIX_SIZE);
@@ -194,7 +194,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		       ETH_ALEN);
 		if (priv->hist_data)
 			mwifiex_hist_data_reset(priv);
-		mwifiex_check_uap_capabilties(priv, adapter->event_skb);
+		mwifiex_check_uap_capabilities(priv, adapter->event_skb);
 		break;
 	case EVENT_UAP_MIC_COUNTERMEASURES:
 		/* For future development */
-- 
2.17.0
