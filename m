Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D0AC10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 14:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DB4320825
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 14:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfDOO04 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 10:26:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59292 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfDOO04 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 10:26:56 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hG2ZN-0000e8-UC; Mon, 15 Apr 2019 14:26:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix spelling mistake "capabilties" -> "capabilities"
Date:   Mon, 15 Apr 2019 15:26:49 +0100
Message-Id: <20190415142649.18452-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There various spelling mistakes in function names and in message
text. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 12 ++++++------
 drivers/net/wireless/marvell/mwifiex/uap_event.c |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index a327fc5b36e3..8b3123cb84c8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -27,9 +27,9 @@
 
 #define MWIFIEX_IBSS_CONNECT_EVT_FIX_SIZE    12
 
-static int mwifiex_check_ibss_peer_capabilties(struct mwifiex_private *priv,
-					       struct mwifiex_sta_node *sta_ptr,
-					       struct sk_buff *event)
+static int mwifiex_check_ibss_peer_capabilities(struct mwifiex_private *priv,
+					        struct mwifiex_sta_node *sta_ptr,
+					        struct sk_buff *event)
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
@@ -937,8 +937,8 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 			    ibss_sta_addr);
 		sta_ptr = mwifiex_add_sta_entry(priv, ibss_sta_addr);
 		if (sta_ptr && adapter->adhoc_11n_enabled) {
-			mwifiex_check_ibss_peer_capabilties(priv, sta_ptr,
-							    adapter->event_skb);
+			mwifiex_check_ibss_peer_capabilities(priv, sta_ptr,
+							     adapter->event_skb);
 			if (sta_ptr->is_11n_enabled)
 				for (i = 0; i < MAX_NUM_TID; i++)
 					sta_ptr->ampdu_sta[i] =
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_event.c b/drivers/net/wireless/marvell/mwifiex/uap_event.c
index ca759d9c0253..86bfa1b9ef9d 100644
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
@@ -201,7 +201,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		       ETH_ALEN);
 		if (priv->hist_data)
 			mwifiex_hist_data_reset(priv);
-		mwifiex_check_uap_capabilties(priv, adapter->event_skb);
+		mwifiex_check_uap_capabilities(priv, adapter->event_skb);
 		break;
 	case EVENT_UAP_MIC_COUNTERMEASURES:
 		/* For future development */
-- 
2.20.1

