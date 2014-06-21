Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48403 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbaFUAIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 20:08:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] Revert "mwifiex: Use the proper interfaces"
Date: Fri, 20 Jun 2014 17:07:42 -0700
Message-ID: <1403309262-5737-1-git-send-email-bzhao@marvell.com> (sfid-20140621_020912_744550_36C3BE58)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit a82fc3b4a2bceb7c6587249cb690342eb5065979.

Thomas corrected me on that I misunderstood Johannes' comment
for net_timedelta() and the ktime_get_real() usage inside
__net_timestamp().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 4 +++-
 drivers/net/wireless/mwifiex/main.c     | 4 +++-
 drivers/net/wireless/mwifiex/tdls.c     | 8 ++++++--
 drivers/net/wireless/mwifiex/uap_txrx.c | 4 +++-
 drivers/net/wireless/mwifiex/wmm.c      | 9 ++++++++-
 5 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1a72b2f..6ec2ee3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -121,6 +121,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 	u8 addr[ETH_ALEN] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	u16 pkt_len;
 	u32 tx_control = 0, pkt_type = PKT_TYPE_MGMT;
+	struct timeval tv;
 
 	pkt_len = len + ETH_ALEN;
 
@@ -142,7 +143,8 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 	       len - sizeof(struct ieee80211_hdr_3addr));
 
 	skb->priority = LOW_PRIO_TID;
-	__net_timestamp(skb);
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 3e5194f..22ca50c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -609,6 +609,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
 		jiffies, priv->bss_type, priv->bss_num);
@@ -656,7 +657,8 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * firmware for aggregate delay calculation for stats and
 	 * MSDU lifetime expiry.
 	 */
-	__net_timestamp(skb);
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 
 	mwifiex_queue_tx_pkt(priv, skb);
 
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 3efbcbe..e73034f 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -530,6 +530,7 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
 	int ret;
 	u16 skb_len;
 
@@ -607,7 +608,8 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-	__net_timestamp(skb);
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
@@ -700,6 +702,7 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
 	u8 *pos;
 	u32 pkt_type, tx_control;
 	u16 pkt_len, skb_len;
@@ -764,7 +767,8 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
 	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
 	       sizeof(pkt_len));
-	__net_timestamp(skb);
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index ddfc3c6..57fa47d 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -96,6 +96,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
+	struct timeval tv;
 	struct ethhdr *p_ethhdr;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -191,7 +192,8 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		tx_info->pkt_len = skb->len;
 	}
 
-	__net_timestamp(skb);
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index e8556b6..8cd123e 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -878,8 +878,15 @@ u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 				  const struct sk_buff *skb)
 {
-	u32 queue_delay = ktime_to_ms(ktime_sub(ktime_get(), skb->tstamp));
 	u8 ret_val;
+	struct timeval out_tstamp, in_tstamp;
+	u32 queue_delay;
+
+	do_gettimeofday(&out_tstamp);
+	in_tstamp = ktime_to_timeval(skb->tstamp);
+
+	queue_delay = (out_tstamp.tv_sec - in_tstamp.tv_sec) * 1000;
+	queue_delay += (out_tstamp.tv_usec - in_tstamp.tv_usec) / 1000;
 
 	/*
 	 * Queue delay is passed as a uint8 in units of 2ms (ms shifted
-- 
1.8.2.3

