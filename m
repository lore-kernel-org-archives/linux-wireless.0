Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gast-001.fem.tu-ilmenau.de ([141.24.44.1]:37044 "EHLO
	a251.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932267Ab3BLQfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:35:48 -0500
From: Michael Braun <michael-dev@fami-braun.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
	Michael Braun <michael-dev@fami-braun.de>
Subject: [konusllaptop] [PATCHv2 1/1] mac80211: fix WPA with VLAN on AP side with ps-sta
Date: Tue, 12 Feb 2013 17:35:37 +0100
Message-Id: <1360686937-17277-2-git-send-email-michael-dev@fami-braun.de> (sfid-20130212_173550_764851_399348D4)
In-Reply-To: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de>
References: <1360686937-17277-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending a broadcast while at least on of the connected stations is
sleeping, it gets queued and send after a DTIM beacon is sent.
If the packet was to be sent on a vlan interface, the vif used for dequeing
from the per-bss queue does not hold the per-vlan sdata. The correct sdata is
required to use the correct per-vlan broadcast/multicast key.

This patch fixes this by restoring the per-vlan sdata using the skb->dev entry.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

V2: fix compile warning
---
 net/mac80211/tx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2ef0e19..583c025 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2728,6 +2728,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct ps_data *ps;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_sub_if_data *frame_sdata;
 
 	sdata = vif_to_sdata(vif);
 
@@ -2770,7 +2771,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (!ieee80211_tx_prepare(sdata, &tx, skb))
+		frame_sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+		if (!ieee80211_tx_prepare(frame_sdata, &tx, skb))
 			break;
 		dev_kfree_skb_any(skb);
 	}
-- 
1.7.10.4
