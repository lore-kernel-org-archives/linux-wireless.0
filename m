Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19629 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbaEVFCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:02:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] mwifiex: avoid TDLS check for packets destined to AP
Date: Wed, 21 May 2014 22:02:27 -0700
Message-ID: <1400734951-6851-1-git-send-email-bzhao@marvell.com> (sfid-20140522_070255_802153_09474638)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

In station role if TDLS is supported, we traverse TDLS peer list
to see if packet's destination address matches with TDLS peer.
Packets destined to AP are not sent over TDLS link and hence
avoid this list traversal for such packets.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 94b6c74..f364d5f 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -648,7 +648,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 		if (ntohs(eth_hdr->h_proto) == ETH_P_TDLS)
 			dev_dbg(adapter->dev,
 				"TDLS setup packet for %pM. Don't block\n", ra);
-		else
+		else if (memcmp(priv->cfg_bssid, ra, ETH_ALEN))
 			tdls_status = mwifiex_get_tdls_link_status(priv, ra);
 	}
 
-- 
1.8.2.3

