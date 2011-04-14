Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44815 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1DNAW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 20:22:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: rename function mwifiex_is_ba_stream_avail
Date: Wed, 13 Apr 2011 17:27:09 -0700
Message-Id: <1302740829-21315-4-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
References: <1302740829-21315-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old function name sounds like checking for existing BA
stream. The function actually checks if we have room for
creating new BA stream or not.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h |    5 +++--
 drivers/net/wireless/mwifiex/wmm.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 9128d2c..02602ff 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -92,9 +92,10 @@ mwifiex_is_amsdu_allowed(struct mwifiex_private *priv, int tid)
 }
 
 /*
- * This function checks whether a BA stream is available or not.
+ * This function checks whether a space is available for new BA stream or not.
  */
-static inline u8 mwifiex_is_ba_stream_avail(struct mwifiex_adapter *adapter)
+static inline u8 mwifiex_space_avail_for_new_ba_stream(
+					struct mwifiex_adapter *adapter)
 {
 	struct mwifiex_private *priv;
 	u8 i;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 57b98c5..99e8431 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1186,7 +1186,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		   mwifiex_send_single_packet() */
 	} else {
 		if (mwifiex_is_ampdu_allowed(priv, tid)) {
-			if (mwifiex_is_ba_stream_avail(adapter)) {
+			if (mwifiex_space_avail_for_new_ba_stream(adapter)) {
 				mwifiex_11n_create_tx_ba_stream_tbl(priv,
 						ptr->ra, tid,
 						BA_STREAM_SETUP_INPROGRESS);
-- 
1.7.0.2

