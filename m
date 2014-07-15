Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34738 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757461AbaGODy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 23:54:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7 v2] mwifiex: remove redundant TDLS setup action frame check and avoid leaks
Date: Mon, 14 Jul 2014 20:53:34 -0700
Message-ID: <1405396414-19493-1-git-send-email-bzhao@marvell.com> (sfid-20140715_055514_567290_B2DE39C6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The unwanted frame types are already handled in 'default' case
of the switch/case below.
The str_ptr is allocated but it can be leaked if the length check
fails in the REQUEST/RESP cases. Fix it by allocating sta_ptr
after the length checks.

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
v2: fix possible leak of sta_ptr

 drivers/net/wireless/mwifiex/tdls.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index a414161..4c5fd95 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -781,6 +781,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 	struct mwifiex_sta_node *sta_ptr;
 	u8 *peer, *pos, *end;
 	u8 i, action, basic;
+	__le16 cap = 0;
 	int ie_len = 0;
 
 	if (len < (sizeof(struct ethhdr) + 3))
@@ -792,18 +793,9 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 	peer = buf + ETH_ALEN;
 	action = *(buf + sizeof(struct ethhdr) + 2);
-
-	/* just handle TDLS setup request/response/confirm */
-	if (action > WLAN_TDLS_SETUP_CONFIRM)
-		return;
-
 	dev_dbg(priv->adapter->dev,
 		"rx:tdls action: peer=%pM, action=%d\n", peer, action);
 
-	sta_ptr = mwifiex_add_sta_entry(priv, peer);
-	if (!sta_ptr)
-		return;
-
 	switch (action) {
 	case WLAN_TDLS_SETUP_REQUEST:
 		if (len < (sizeof(struct ethhdr) + TDLS_REQ_FIX_LEN))
@@ -811,7 +803,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 
 		pos = buf + sizeof(struct ethhdr) + 4;
 		/* payload 1+ category 1 + action 1 + dialog 1 */
-		sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
+		cap = cpu_to_le16(*(u16 *)pos);
 		ie_len = len - sizeof(struct ethhdr) - TDLS_REQ_FIX_LEN;
 		pos += 2;
 		break;
@@ -821,7 +813,7 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 			return;
 		/* payload 1+ category 1 + action 1 + dialog 1 + status code 2*/
 		pos = buf + sizeof(struct ethhdr) + 6;
-		sta_ptr->tdls_cap.capab = cpu_to_le16(*(u16 *)pos);
+		cap = cpu_to_le16(*(u16 *)pos);
 		ie_len = len - sizeof(struct ethhdr) - TDLS_RESP_FIX_LEN;
 		pos += 2;
 		break;
@@ -833,10 +825,16 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 		ie_len = len - sizeof(struct ethhdr) - TDLS_CONFIRM_FIX_LEN;
 		break;
 	default:
-		dev_warn(priv->adapter->dev, "Unknown TDLS frame type.\n");
+		dev_dbg(priv->adapter->dev, "Unknown TDLS frame type.\n");
 		return;
 	}
 
+	sta_ptr = mwifiex_add_sta_entry(priv, peer);
+	if (!sta_ptr)
+		return;
+
+	sta_ptr->tdls_cap.capab = cap;
+
 	for (end = pos + ie_len; pos + 1 < end; pos += 2 + pos[1]) {
 		if (pos + 2 + pos[1] > end)
 			break;
-- 
1.8.2.3

