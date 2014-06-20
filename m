Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39330 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbaFTEs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:48:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3] mwifiex: Use the proper interfaces
Date: Thu, 19 Jun 2014 21:48:12 -0700
Message-ID: <1403239692-3352-1-git-send-email-bzhao@marvell.com> (sfid-20140620_064831_075199_39F3B06A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Gleixner <tglx@linutronix.de>

Why is converting time formats so desired if there are proper
interfaces for this?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
v3: don't use net_timedelta() (Johannes Berg)
v2: remove unused variables
v1: wireless: mwifiex: Use the proper interfaces

 drivers/net/wireless/mwifiex/cfg80211.c | 4 +---
 drivers/net/wireless/mwifiex/main.c     | 4 +---
 drivers/net/wireless/mwifiex/tdls.c     | 8 ++------
 drivers/net/wireless/mwifiex/uap_txrx.c | 4 +---
 drivers/net/wireless/mwifiex/wmm.c      | 9 +--------
 5 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6ec2ee3..1a72b2f 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -121,7 +121,6 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 	u8 addr[ETH_ALEN] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	u16 pkt_len;
 	u32 tx_control = 0, pkt_type = PKT_TYPE_MGMT;
-	struct timeval tv;
 
 	pkt_len = len + ETH_ALEN;
 
@@ -143,8 +142,7 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 	       len - sizeof(struct ieee80211_hdr_3addr));
 
 	skb->priority = LOW_PRIO_TID;
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 1261d9a..657504c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -609,7 +609,6 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
 		jiffies, priv->bss_type, priv->bss_num);
@@ -656,8 +655,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * firmware for aggregate delay calculation for stats and
 	 * MSDU lifetime expiry.
 	 */
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 
 	mwifiex_queue_tx_pkt(priv, skb);
 
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index e73034f..3efbcbe 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -530,7 +530,6 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 	int ret;
 	u16 skb_len;
 
@@ -608,8 +607,7 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
@@ -702,7 +700,6 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 {
 	struct sk_buff *skb;
 	struct mwifiex_txinfo *tx_info;
-	struct timeval tv;
 	u8 *pos;
 	u32 pkt_type, tx_control;
 	u16 pkt_len, skb_len;
@@ -767,8 +764,7 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv, const u8 *peer,
 	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
 	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
 	       sizeof(pkt_len));
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 57fa47d..ddfc3c6 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -96,7 +96,6 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 	struct sk_buff *new_skb;
 	struct mwifiex_txinfo *tx_info;
 	int hdr_chop;
-	struct timeval tv;
 	struct ethhdr *p_ethhdr;
 
 	uap_rx_pd = (struct uap_rxpd *)(skb->data);
@@ -192,8 +191,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
 		tx_info->pkt_len = skb->len;
 	}
 
-	do_gettimeofday(&tv);
-	skb->tstamp = timeval_to_ktime(tv);
+	__net_timestamp(skb);
 	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&adapter->tx_pending);
 	atomic_inc(&adapter->pending_bridged_pkts);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8cd123e..e8556b6 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -878,15 +878,8 @@ u8
 mwifiex_wmm_compute_drv_pkt_delay(struct mwifiex_private *priv,
 				  const struct sk_buff *skb)
 {
+	u32 queue_delay = ktime_to_ms(ktime_sub(ktime_get(), skb->tstamp));
 	u8 ret_val;
-	struct timeval out_tstamp, in_tstamp;
-	u32 queue_delay;
-
-	do_gettimeofday(&out_tstamp);
-	in_tstamp = ktime_to_timeval(skb->tstamp);
-
-	queue_delay = (out_tstamp.tv_sec - in_tstamp.tv_sec) * 1000;
-	queue_delay += (out_tstamp.tv_usec - in_tstamp.tv_usec) / 1000;
 
 	/*
 	 * Queue delay is passed as a uint8 in units of 2ms (ms shifted
-- 
1.8.2.3

