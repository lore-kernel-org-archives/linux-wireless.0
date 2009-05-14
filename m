Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41000 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120AbZENNMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 09:12:12 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 06:12:14 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] mac80211: Initialize RX's last received sequence number
Date: Thu, 14 May 2009 18:42:08 +0530
Message-ID: <1242306728-15178-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The STA may drop the very first frame if it happens to be a retried
frame. This is because we maintian the last received sequence number
per TID for QoS frames and it is initialized to zero through kzalloc
during sta_info_alloc and the sequence number of the very first date
frame received would be ZERO (as per IEEE 802.11-2007, 7.1.3.4.1).

If the frame dropped happens to be an EAP Request Identity(very first
frame from the AP), then wpa_supplicnat disconnects the STA and the
whole procedure starts again.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 net/mac80211/sta_info.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c5f14e6..c75d031 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -292,6 +292,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
 
+	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+		sta->last_seq_ctrl[i] = cpu_to_le16(USHORT_MAX);
+
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Allocated STA %pM\n",
 	       wiphy_name(local->hw.wiphy), sta->sta.addr);
-- 
1.6.0.4

