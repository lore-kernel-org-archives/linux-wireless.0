Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gast-008.fem.tu-ilmenau.de ([141.24.44.8]:49540 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758454Ab3BLPwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:52:43 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [konusllaptop] [PATCH 1/1] Fix WPA with VLAN on AP side with ps client
Date: Tue, 12 Feb 2013 16:43:26 +0100
Message-Id: <1360683806-15238-2-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_165247_002980_F5F59D43)
In-Reply-To: <1360683806-15238-1-git-send-email-michael-dev@fami-braun.de>
References: <1360683806-15238-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending a broadcast while at least on of the connected stations is
sleeping, it gets queued and send after a DTIM beacon is sent.
If the packet was to be sent on a vlan interface, the vif used for dequeing
from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
required to use the correct per-vlan broadcast/multicast key.

This patch fixes this by restoring the per-vlan sdata using the skb->dev entry.
---
 net/mac80211/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ef0e19..93681f5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2770,7 +2770,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (!ieee80211_tx_prepare(sdata, &tx, skb))
+		struct ieee80211_sub_if_data *frame_sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+		if (!ieee80211_tx_prepare(frame_sdata, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
 	}
-- 
1.7.10.4

