Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a-keller-035.fem.tu-ilmenau.de ([141.24.40.99]:57256 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933729Ab3BLTCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:02:31 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [RFCv4 1/2] mac80211: fix WPA with VLAN on AP side with ps-sta
Date: Tue, 12 Feb 2013 19:51:45 +0100
Message-Id: <1360695107-5721-2-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_200233_969527_F54FE387)
In-Reply-To: <1360695107-5721-1-git-send-email-michael-dev@fami-braun.de>
References: <1360695107-5721-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending a broadcast while at least on of the connected stations is
sleeping, it gets queued and send after a DTIM beacon is sent.
If the packet was to be sent on a vlan interface, the vif used for dequeing
from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
required to use the correct per-vlan broadcast/multicast key.

This patch fixes this by restoring the per-vlan sdata using the skb->dev entry.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
V2: fix compile warning
V3: simplify change

 net/mac80211/tx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ef0e19..ee169b1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2770,6 +2770,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
+		sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
-- 
1.7.10.4

