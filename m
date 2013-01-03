Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48948 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab3ACH5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:57:32 -0500
Date: Thu, 3 Jan 2013 13:21:25 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: set ack policy to normal
Message-ID: <20130103075120.GA20062@markyou.marvell.com> (sfid-20130103_085736_677717_C34842E3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set ACK policy to NORMAL when its not going to
be an AMPDU packet.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 93dd0ef..c9c9c99 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1926,6 +1926,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 		stream = mwl8k_lookup_stream(hw, sta->addr, tid);
 		if (stream != NULL) {
 			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				WARN_ON(!(qos & MWL8K_QOS_ACK_POLICY_BLOCKACK));
 				txpriority = stream->idx + MWL8K_TX_WMM_QUEUES;
 				index = stream->idx + MWL8K_TX_WMM_QUEUES;
 			} else if (stream->state == AMPDU_STREAM_NEW) {
@@ -1969,6 +1970,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 			}
 		}
 		spin_unlock(&priv->stream_lock);
+	} else {
+		qos &= ~MWL8K_QOS_ACK_POLICY_MASK;
+		qos |= MWL8K_QOS_ACK_POLICY_NORMAL;
 	}
 
 	dma = pci_map_single(priv->pdev, skb->data,
-- 
1.8.0.3

