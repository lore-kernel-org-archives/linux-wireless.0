Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55785 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1ELCmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 22:42:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] cfg80211: make stripping of 802.11 header optional from AMSDU
Date: Wed, 11 May 2011 19:47:12 -0700
Message-Id: <1305168432-15569-2-git-send-email-bzhao@marvell.com> (sfid-20110512_044242_112503_4C9E1814)
In-Reply-To: <1305168432-15569-1-git-send-email-bzhao@marvell.com>
References: <1305168432-15569-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Currently the devices that have already stripped IEEE 802.11
header from the AMSDU SKB can not use ieee80211_amsdu_to_8023s
routine. This patch enhances ieee80211_amsdu_to_8023s() API by
changing mandatory removing of IEEE 802.11 header from AMSDU
to optional.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/iwmc3200wifi/rx.c |    3 ++-
 include/net/cfg80211.h                 |    5 ++++-
 net/mac80211/rx.c                      |    2 +-
 net/wireless/util.c                    |   21 +++++++++++++--------
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 9a57cf6..f9bfa10 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1576,7 +1576,8 @@ static void iwm_rx_process_amsdu(struct iwm_priv *iwm, struct sk_buff *skb)
 	IWM_HEXDUMP(iwm, DBG, RX, "A-MSDU: ", skb->data, skb->len);
 
 	__skb_queue_head_init(&list);
-	ieee80211_amsdu_to_8023s(skb, &list, ndev->dev_addr, wdev->iftype, 0);
+	ieee80211_amsdu_to_8023s(skb, &list, ndev->dev_addr, wdev->iftype, 0,
+									false);
 
 	while ((frame = __skb_dequeue(&list))) {
 		ndev->stats.rx_packets++;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1f1e221..cd8f7c6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2173,10 +2173,13 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
+ * @stripped_80211_header: Set it true if SKB is without IEEE 802.11
+ *	header.
  */
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom);
+			      const unsigned int extra_headroom,
+			      bool stripped_80211_header);
 
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b6bde2e..0b36e35 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1783,7 +1783,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
-				 rx->local->hw.extra_tx_headroom);
+				 rx->local->hw.extra_tx_headroom, false);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6a750bc..1da1a7c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -544,7 +544,8 @@ EXPORT_SYMBOL(ieee80211_data_from_8023);
 
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom)
+			      const unsigned int extra_headroom,
+			      bool stripped_80211_header)
 {
 	struct sk_buff *frame = NULL;
 	u16 ethertype;
@@ -553,14 +554,18 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 	int remaining, err;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
 
-	err = ieee80211_data_to_8023(skb, addr, iftype);
-	if (err)
-		goto out;
+	if (!stripped_80211_header) {
+		err = ieee80211_data_to_8023(skb, addr, iftype);
+		if (err)
+			goto out;
 
-	/* skip the wrapping header */
-	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
-	if (!eth)
-		goto out;
+		/* skip the wrapping header */
+		eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
+		if (!eth)
+			goto out;
+	} else {
+		eth = (struct ethhdr *) skb->data;
+	}
 
 	while (skb != frame) {
 		u8 padding;
-- 
1.7.0.2

