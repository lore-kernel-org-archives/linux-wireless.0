Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31282 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbaEVFDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:03:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/5] mwifiex: silence TDLS link delete failure for nonexistent link
Date: Wed, 21 May 2014 22:02:28 -0700
Message-ID: <1400734951-6851-2-git-send-email-bzhao@marvell.com> (sfid-20140522_070310_423309_B7E2A82C)
In-Reply-To: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
References: <1400734951-6851-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

If TDLS link delete command fails because of non-existent peer
or TDLS peer is absent from driver's entry, it means link was
already deleted. In such case print debug messages with lower
severity.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index bfebb01..577f297 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -865,14 +865,20 @@ static int mwifiex_ret_tdls_oper(struct mwifiex_private *priv,
 
 	switch (action) {
 	case ACT_TDLS_DELETE:
-		if (reason)
-			dev_err(priv->adapter->dev,
-				"TDLS link delete for %pM failed: reason %d\n",
-				cmd_tdls_oper->peer_mac, reason);
-		else
+		if (reason) {
+			if (!node || reason == TDLS_ERR_LINK_NONEXISTENT)
+				dev_dbg(priv->adapter->dev,
+					"TDLS link delete for %pM failed: reason %d\n",
+					cmd_tdls_oper->peer_mac, reason);
+			else
+				dev_err(priv->adapter->dev,
+					"TDLS link delete for %pM failed: reason %d\n",
+					cmd_tdls_oper->peer_mac, reason);
+		} else {
 			dev_dbg(priv->adapter->dev,
-				"TDLS link config for %pM successful\n",
+				"TDLS link delete for %pM successful\n",
 				cmd_tdls_oper->peer_mac);
+		}
 		break;
 	case ACT_TDLS_CREATE:
 		if (reason) {
-- 
1.8.2.3

