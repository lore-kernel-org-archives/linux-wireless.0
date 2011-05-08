Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44543 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1EHUuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 16:50:16 -0400
Subject: linux-next: [PATCH] mwifiex: fix null derefs, mem leaks and trivia
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Cc: Yogesh Ashok Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 08 May 2011 22:50:09 +0200
Message-ID: <1304887809.16160.19.camel@mars> (sfid-20110508_225024_253698_7588A29B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch:
 - adds kfree() where necessary
 - prevents potential null dereferences
 - makes use of kfree_skb()
 - replaces -1 for failed kzallocs with -ENOMEM

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c  |    6 ++++--
 drivers/net/wireless/mwifiex/cfg80211.c  |    5 ++++-
 drivers/net/wireless/mwifiex/cmdevt.c    |    2 +-
 drivers/net/wireless/mwifiex/init.c      |    4 ++--
 drivers/net/wireless/mwifiex/main.c      |    8 ++++----
 drivers/net/wireless/mwifiex/scan.c      |    8 ++++----
 drivers/net/wireless/mwifiex/sdio.c      |    5 +++--
 drivers/net/wireless/mwifiex/sta_ioctl.c |    2 +-
 8 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 12cf424..2b2cca5 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -318,7 +318,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		else
 			skb_src = NULL;
 
-		pra_list->total_pkts_size -= skb_src->len;
+		if (skb_src)
+			pra_list->total_pkts_size -= skb_src->len;
 
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -373,7 +374,8 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			(adapter->pps_uapsd_mode) &&
 			(adapter->tx_lock_flag)) {
 				priv->adapter->tx_lock_flag = false;
-				ptx_pd->flags = 0;
+				if (ptx_pd)
+					ptx_pd->flags = 0;
 		}
 
 		skb_queue_tail(&pra_list->skb_head, skb_aggr);
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0c01163..19be887 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1255,8 +1255,10 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 	wdev->wiphy =
 		wiphy_new(&mwifiex_cfg80211_ops,
 			  sizeof(struct mwifiex_private *));
-	if (!wdev->wiphy)
+	if (!wdev->wiphy) {
+		kfree(wdev);
 		return -ENOMEM;
+	}
 	wdev->iftype = NL80211_IFTYPE_STATION;
 	wdev->wiphy->max_scan_ssids = 10;
 	wdev->wiphy->interface_modes =
@@ -1296,6 +1298,7 @@ int mwifiex_register_cfg80211(struct net_device *dev, u8 *mac,
 		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
 						__func__);
 		wiphy_free(wdev->wiphy);
+		kfree(wdev);
 		return ret;
 	} else {
 		dev_dbg(priv->adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index b75cc92..1c8b4f7 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -292,7 +292,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	if (!cmd_array) {
 		dev_err(adapter->dev, "%s: failed to alloc cmd_array\n",
 				__func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	adapter->cmd_pool = cmd_array;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 27ad72b..6a8fd99 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -41,7 +41,7 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 	if (!bss_prio) {
 		dev_err(adapter->dev, "%s: failed to alloc bss_prio\n",
 						__func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	bss_prio->priv = priv;
@@ -161,7 +161,7 @@ static int mwifiex_allocate_adapter(struct mwifiex_adapter *adapter)
 	if (!temp_scan_table) {
 		dev_err(adapter->dev, "%s: failed to alloc temp_scan_table\n",
 		       __func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	adapter->scan_table = temp_scan_table;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index c234b14..f058225 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -69,7 +69,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 	adapter = kzalloc(sizeof(struct mwifiex_adapter), GFP_KERNEL);
 	if (!adapter)
-		return -1;
+		return -ENOMEM;
 
 	g_adapter = adapter;
 	adapter->card = card;
@@ -516,13 +516,13 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				jiffies, priv->bss_index);
 
 	if (priv->adapter->surprise_removed) {
-		kfree(skb);
+		kfree_skb(skb);
 		priv->stats.tx_dropped++;
 		return 0;
 	}
 	if (!skb->len || (skb->len > ETH_FRAME_LEN)) {
 		dev_err(priv->adapter->dev, "Tx: bad skb len %d\n", skb->len);
-		kfree(skb);
+		kfree_skb(skb);
 		priv->stats.tx_dropped++;
 		return 0;
 	}
@@ -535,7 +535,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
 		if (unlikely(!new_skb)) {
 			dev_err(priv->adapter->dev, "Tx: cannot alloca new_skb\n");
-			kfree(skb);
+			kfree_skb(skb);
 			priv->stats.tx_dropped++;
 			return 0;
 		}
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 4968974..5c22860 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2283,7 +2283,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 					GFP_KERNEL);
 	if (!scan_cfg_out) {
 		dev_err(adapter->dev, "failed to alloc scan_cfg_out\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	buf_size = sizeof(struct mwifiex_chan_scan_param_set) *
@@ -2292,7 +2292,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	if (!scan_chan_list) {
 		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
 		kfree(scan_cfg_out);
-		return -1;
+		return -ENOMEM;
 	}
 
 	keep_previous_scan = false;
@@ -2491,7 +2491,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				GFP_KERNEL);
 	if (!bss_new_entry) {
 		dev_err(adapter->dev, " failed to alloc bss_new_entry\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
@@ -2881,7 +2881,7 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
 	if (!scan_cfg) {
 		dev_err(adapter->dev, "failed to alloc scan_cfg\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	memcpy(scan_cfg->ssid_list[0].ssid, req_ssid->ssid,
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 470dbaa..d425dbd 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -68,6 +68,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 
 	if (ret) {
 		pr_err("%s: failed to enable function\n", __func__);
+		kfree(card);
 		return -EIO;
 	}
 
@@ -676,7 +677,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	if (!fwbuf) {
 		dev_err(adapter->dev, "unable to alloc buffer for firmware."
 				" Terminating download\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	/* Perform firmware data transfer */
@@ -1605,7 +1606,7 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	card->mp_regs = kzalloc(MAX_MP_REGS, GFP_KERNEL);
 	if (!card->mp_regs) {
 		dev_err(adapter->dev, "failed to alloc mp_regs\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 4585c1b..75bca56 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -895,7 +895,7 @@ int mwifiex_set_tx_power(struct mwifiex_private *priv,
 	if (!buf) {
 		dev_err(priv->adapter->dev, "%s: failed to alloc cmd buffer\n",
 				__func__);
-		return -1;
+		return -ENOMEM;
 	}
 
 	txp_cfg = (struct host_cmd_ds_txpwr_cfg *) buf;
-- 
1.7.2.3



