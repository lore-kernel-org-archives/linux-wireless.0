Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36596 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714Ab2IZD2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 23:28:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/15] mwifiex: implement cfg80211 mgmt_tx handler
Date: Tue, 25 Sep 2012 20:23:32 -0700
Message-Id: <1348629825-12001-3-git-send-email-bzhao@marvell.com> (sfid-20120926_052845_979137_B440829B)
In-Reply-To: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
References: <1348629825-12001-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stone Piao <piaoyun@marvell.com>

Implement mgmt_tx in cfg80211 ops through data path.
Advertise probe resp offload and skip to send probe resp in AP
or GO mode.

Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   92 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/decl.h     |    3 +
 drivers/net/wireless/mwifiex/main.c     |   34 +++++++----
 drivers/net/wireless/mwifiex/main.h     |   12 ++++
 drivers/net/wireless/mwifiex/sta_tx.c   |   12 ++++-
 drivers/net/wireless/mwifiex/wmm.c      |    7 +-
 6 files changed, 143 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6fd4fa6..11942e5 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -139,6 +139,94 @@ mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 /*
+ * This function forms an skb for management frame.
+ */
+static int
+mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
+{
+	u8 addr[ETH_ALEN] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
+	u16 pkt_len;
+	u32 tx_control = 0, pkt_type = PKT_TYPE_MGMT;
+	struct timeval tv;
+
+	pkt_len = len + ETH_ALEN;
+
+	skb_reserve(skb, MWIFIEX_MIN_DATA_HEADER_LEN +
+		    MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(pkt_len));
+	memcpy(skb_push(skb, sizeof(pkt_len)), &pkt_len, sizeof(pkt_len));
+
+	memcpy(skb_push(skb, sizeof(tx_control)),
+	       &tx_control, sizeof(tx_control));
+
+	memcpy(skb_push(skb, sizeof(pkt_type)), &pkt_type, sizeof(pkt_type));
+
+	/* Add packet data and address4 */
+	memcpy(skb_put(skb, sizeof(struct ieee80211_hdr_3addr)), buf,
+	       sizeof(struct ieee80211_hdr_3addr));
+	memcpy(skb_put(skb, ETH_ALEN), addr, ETH_ALEN);
+	memcpy(skb_put(skb, len - sizeof(struct ieee80211_hdr_3addr)),
+	       buf + sizeof(struct ieee80211_hdr_3addr),
+	       len - sizeof(struct ieee80211_hdr_3addr));
+
+	skb->priority = LOW_PRIO_TID;
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
+
+	return 0;
+}
+
+/*
+ * CFG802.11 operation handler to transmit a management frame.
+ */
+static int
+mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
+			 struct ieee80211_channel *chan, bool offchan,
+			 enum nl80211_channel_type channel_type,
+			 bool channel_type_valid, unsigned int wait,
+			 const u8 *buf, size_t len, bool no_cck,
+			 bool dont_wait_for_ack, u64 *cookie)
+{
+	struct sk_buff *skb;
+	u16 pkt_len;
+	const struct ieee80211_mgmt *mgmt;
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+
+	if (!buf || !len) {
+		wiphy_err(wiphy, "invalid buffer and length\n");
+		return -EFAULT;
+	}
+
+	mgmt = (const struct ieee80211_mgmt *)buf;
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA &&
+	    ieee80211_is_probe_resp(mgmt->frame_control)) {
+		/* Since we support offload probe resp, we need to skip probe
+		 * resp in AP or GO mode */
+		wiphy_dbg(wiphy,
+			  "info: skip to send probe resp in AP or GO mode\n");
+		return 0;
+	}
+
+	pkt_len = len + ETH_ALEN;
+	skb = dev_alloc_skb(MWIFIEX_MIN_DATA_HEADER_LEN +
+			    MWIFIEX_MGMT_FRAME_HEADER_SIZE +
+			    pkt_len + sizeof(pkt_len));
+
+	if (!skb) {
+		wiphy_err(wiphy, "allocate skb failed for management frame\n");
+		return -ENOMEM;
+	}
+
+	mwifiex_form_mgmt_frame(skb, buf, len);
+	mwifiex_queue_tx_pkt(priv, skb);
+
+	*cookie = random32() | 1;
+	cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true, GFP_ATOMIC);
+
+	wiphy_dbg(wiphy, "info: management frame transmitted\n");
+	return 0;
+}
+
+/*
  * CFG802.11 operation handler to set Tx power.
  */
 static int
@@ -1810,6 +1898,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
 	.add_key = mwifiex_cfg80211_add_key,
 	.del_key = mwifiex_cfg80211_del_key,
+	.mgmt_tx = mwifiex_cfg80211_mgmt_tx,
 	.set_default_key = mwifiex_cfg80211_set_default_key,
 	.set_power_mgmt = mwifiex_cfg80211_set_power_mgmt,
 	.set_tx_power = mwifiex_cfg80211_set_tx_power,
@@ -1872,7 +1961,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy_apply_custom_regulatory(wiphy, &mwifiex_world_regdom_custom);
 
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
-				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
+				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P;
 
 	wiphy->available_antennas_tx = BIT(adapter->number_of_antenna) - 1;
 	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 400d360..d21bcc1 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -33,6 +33,9 @@
 #define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
 					 *   + 4 byte alignment
 					 */
+#define MWIFIEX_MGMT_FRAME_HEADER_SIZE	8	/* sizeof(pkt_type)
+						 *   + sizeof(tx_control)
+						 */
 
 #define MWIFIEX_MAX_TX_BASTREAM_SUPPORTED	2
 #define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED	16
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index bfd6667..3bb3417 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -469,6 +469,27 @@ mwifiex_close(struct net_device *dev)
 }
 
 /*
+ * Add buffer into wmm tx queue and queue work to transmit it.
+ */
+int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
+{
+	mwifiex_wmm_add_buf_txqueue(priv, skb);
+	atomic_inc(&priv->adapter->tx_pending);
+
+	if (priv->adapter->scan_delay_cnt)
+		atomic_set(&priv->adapter->is_tx_received, true);
+
+	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
+		mwifiex_set_trans_start(priv->netdev);
+		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
+	}
+
+	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
+
+	return 0;
+}
+
+/*
  * CFG802.11 network device handler for data transmission.
  */
 static int
@@ -516,18 +537,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_info->bss_type = priv->bss_type;
 	mwifiex_fill_buffer(skb);
 
-	mwifiex_wmm_add_buf_txqueue(priv, skb);
-	atomic_inc(&priv->adapter->tx_pending);
-
-	if (priv->adapter->scan_delay_cnt)
-		atomic_set(&priv->adapter->is_tx_received, true);
-
-	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
-		mwifiex_set_trans_start(dev);
-		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
-	}
-
-	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
+	mwifiex_queue_tx_pkt(priv, skb);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 90b64b0..092fbfa 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -98,6 +98,8 @@ enum {
 #define MWIFIEX_OUI_NOT_PRESENT			0
 #define MWIFIEX_OUI_PRESENT				1
 
+#define PKT_TYPE_MGMT	0xE5
+
 /*
  * Do not check for data_received for USB, as data_received
  * is handled in mwifiex_usb_recv for USB
@@ -960,6 +962,14 @@ mwifiex_netdev_get_priv(struct net_device *dev)
 	return (struct mwifiex_private *) (*(unsigned long *) netdev_priv(dev));
 }
 
+/*
+ * This function checks if a skb holds a management frame.
+ */
+static inline bool mwifiex_is_skb_mgmt_frame(struct sk_buff *skb)
+{
+	return (*(u32 *)skb->data == PKT_TYPE_MGMT);
+}
+
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
@@ -1022,6 +1032,8 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 
 int mwifiex_main_process(struct mwifiex_adapter *);
 
+int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb);
+
 int mwifiex_get_bss_info(struct mwifiex_private *,
 			 struct mwifiex_bss_info *);
 int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 0a046d3..7b581af 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -48,6 +48,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	struct txpd *local_tx_pd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 	u8 pad;
+	u16 pkt_type, pkt_offset;
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n", skb->len);
@@ -55,6 +56,8 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		return skb->data;
 	}
 
+	pkt_type = mwifiex_is_skb_mgmt_frame(skb) ? PKT_TYPE_MGMT : 0;
+
 	/* If skb->data is not aligned; add padding */
 	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
 
@@ -93,7 +96,14 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	}
 
 	/* Offset of actual data */
-	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd) + pad);
+	pkt_offset = sizeof(struct txpd) + pad;
+	if (pkt_type == PKT_TYPE_MGMT) {
+		/* Set the packet type and add header for management frame */
+		local_tx_pd->tx_pkt_type = cpu_to_le16(pkt_type);
+		pkt_offset += MWIFIEX_MGMT_FRAME_HEADER_SIZE;
+	}
+
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(pkt_offset);
 
 	/* make space for INTF_HEADER_LEN */
 	skb_push(skb, INTF_HEADER_LEN);
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 07a4540..600d819 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -648,7 +648,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	u8 ra[ETH_ALEN], tid_down;
 	unsigned long flags;
 
-	if (!priv->media_connected) {
+	if (!priv->media_connected && !mwifiex_is_skb_mgmt_frame(skb)) {
 		dev_dbg(adapter->dev, "data: drop packet in disconnect\n");
 		mwifiex_write_data_complete(adapter, skb, -1);
 		return;
@@ -663,7 +663,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	/* In case of infra as we have already created the list during
 	   association we just don't have to call get_queue_raptr, we will
 	   have only 1 raptr for a tid in case of infra */
-	if (!mwifiex_queuing_ra_based(priv)) {
+	if (!mwifiex_queuing_ra_based(priv) &&
+	    !mwifiex_is_skb_mgmt_frame(skb)) {
 		if (!list_empty(&priv->wmm.tid_tbl_ptr[tid_down].ra_list))
 			ra_list = list_first_entry(
 				&priv->wmm.tid_tbl_ptr[tid_down].ra_list,
@@ -672,7 +673,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 			ra_list = NULL;
 	} else {
 		memcpy(ra, skb->data, ETH_ALEN);
-		if (ra[0] & 0x01)
+		if (ra[0] & 0x01 || mwifiex_is_skb_mgmt_frame(skb))
 			memset(ra, 0xff, ETH_ALEN);
 		ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down, ra);
 	}
-- 
1.7.0.2

