Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50083 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294AbaGLD5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:57:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: remove redundant TDLS setup action frame check
Date: Fri, 11 Jul 2014 20:57:12 -0700
Message-ID: <1405137435-14045-1-git-send-email-bzhao@marvell.com> (sfid-20140712_055749_445661_7DDA57CE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's already been taken cared by the 'default' case in the
switch/case below.

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index a414161..57f972d 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -791,19 +791,15 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 		return;
 
 	peer = buf + ETH_ALEN;
-	action = *(buf + sizeof(struct ethhdr) + 2);
 
-	/* just handle TDLS setup request/response/confirm */
-	if (action > WLAN_TDLS_SETUP_CONFIRM)
+	sta_ptr = mwifiex_add_sta_entry(priv, peer);
+	if (!sta_ptr)
 		return;
 
+	action = *(buf + sizeof(struct ethhdr) + 2);
 	dev_dbg(priv->adapter->dev,
 		"rx:tdls action: peer=%pM, action=%d\n", peer, action);
 
-	sta_ptr = mwifiex_add_sta_entry(priv, peer);
-	if (!sta_ptr)
-		return;
-
 	switch (action) {
 	case WLAN_TDLS_SETUP_REQUEST:
 		if (len < (sizeof(struct ethhdr) + TDLS_REQ_FIX_LEN))
-- 
1.8.2.3

