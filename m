Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip-relay-001.utdallas.edu ([129.110.20.111]:27796 "EHLO
	ip-relay-001.utdallas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2FDXq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 19:46:58 -0400
From: Qasim Javed <qasimj@gmail.com>
To: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Cc: javier@cozybit.com, Qasim Javed <qasimj@gmail.com>
Subject: [PATCH] mac80211: The station fail average is not updated correctly since the IEEE80211_STAT_ACK flag is not set when using wmediumd with mac80211_hwsim. Set this flag when wmediumd indicates that the frame was successfully transmitted (eventually).
Date: Mon,  4 Jun 2012 22:03:43 -0500
Message-Id: <1338865423-11200-1-git-send-email-qasimj@gmail.com> (sfid-20120605_014701_651467_B86F4ED3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Qasim Javed <qasimj@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4c9336c..a0b7cfd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1555,6 +1555,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 			hdr = (struct ieee80211_hdr *) skb->data;
 			mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
 		}
+		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
 	ieee80211_tx_status_irqsafe(data2->hw, skb);
 	return 0;
-- 
1.7.8.2

