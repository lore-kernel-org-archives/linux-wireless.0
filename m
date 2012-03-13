Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:33776 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757591Ab2CMCiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:38:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 10/15] mwifiex: fix checkpatch --strict warnings/errors  Part 4
Date: Mon, 12 Mar 2012 19:38:06 -0700
Message-Id: <1331606291-322-1-git-send-email-bzhao@marvell.com> (sfid-20120313_033819_222742_95635C8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For files main.c, main.h and pcie.c

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |   44 +++---
 drivers/net/wireless/mwifiex/main.h |    4 +-
 drivers/net/wireless/mwifiex/pcie.c |  249 ++++++++++++++++++-----------------
 3 files changed, 150 insertions(+), 147 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 790a379..61d2026 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -65,10 +65,10 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 
 	/* Allocate memory for private structure */
 	adapter->priv[0] = kzalloc(sizeof(struct mwifiex_private),
-			GFP_KERNEL);
+				   GFP_KERNEL);
 	if (!adapter->priv[0]) {
 		dev_err(adapter->dev, "%s: failed to alloc priv[0]\n",
-		       __func__);
+			__func__);
 		goto error;
 	}
 
@@ -169,8 +169,8 @@ process_start:
 		if ((adapter->ps_state == PS_STATE_SLEEP) &&
 		    (adapter->pm_wakeup_card_req &&
 		     !adapter->pm_wakeup_fw_try) &&
-		    (is_command_pending(adapter)
-		     || !mwifiex_wmm_lists_empty(adapter))) {
+		    (is_command_pending(adapter) ||
+		     !mwifiex_wmm_lists_empty(adapter))) {
 			adapter->pm_wakeup_fw_try = true;
 			adapter->if_ops.wakeup(adapter);
 			continue;
@@ -187,10 +187,10 @@ process_start:
 			    adapter->tx_lock_flag)
 				break;
 
-			if (adapter->scan_processing || adapter->data_sent
-			    || mwifiex_wmm_lists_empty(adapter)) {
-				if (adapter->cmd_sent || adapter->curr_cmd
-				    || (!is_command_pending(adapter)))
+			if (adapter->scan_processing || adapter->data_sent ||
+			    mwifiex_wmm_lists_empty(adapter)) {
+				if (adapter->cmd_sent || adapter->curr_cmd ||
+				    (!is_command_pending(adapter)))
 					break;
 			}
 		}
@@ -223,10 +223,10 @@ process_start:
 		/* * The ps_state may have been changed during processing of
 		 * Sleep Request event.
 		 */
-		if ((adapter->ps_state == PS_STATE_SLEEP)
-		    || (adapter->ps_state == PS_STATE_PRE_SLEEP)
-		    || (adapter->ps_state == PS_STATE_SLEEP_CFM)
-		    || adapter->tx_lock_flag)
+		if ((adapter->ps_state == PS_STATE_SLEEP) ||
+		    (adapter->ps_state == PS_STATE_PRE_SLEEP) ||
+		    (adapter->ps_state == PS_STATE_SLEEP_CFM) ||
+		    adapter->tx_lock_flag)
 			continue;
 
 		if (!adapter->cmd_sent && !adapter->curr_cmd) {
@@ -249,8 +249,8 @@ process_start:
 		}
 
 		if (adapter->delay_null_pkt && !adapter->cmd_sent &&
-		    !adapter->curr_cmd && !is_command_pending(adapter)
-		    && mwifiex_wmm_lists_empty(adapter)) {
+		    !adapter->curr_cmd && !is_command_pending(adapter) &&
+		    mwifiex_wmm_lists_empty(adapter)) {
 			if (!mwifiex_send_null_packet
 			    (mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
 			     MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
@@ -371,7 +371,7 @@ mwifiex_fill_buffer(struct sk_buff *skb)
 		iph = ip_hdr(skb);
 		tid = IPTOS_PREC(iph->tos);
 		pr_debug("data: packet type ETH_P_IP: %04x, tid=%#x prio=%#x\n",
-		       eth->h_proto, tid, skb->priority);
+			 eth->h_proto, tid, skb->priority);
 		break;
 	case __constant_htons(ETH_P_ARP):
 		pr_debug("data: ARP packet: %04x\n", eth->h_proto);
@@ -425,7 +425,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct mwifiex_txinfo *tx_info;
 
 	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
-				jiffies, priv->bss_type, priv->bss_num);
+		jiffies, priv->bss_type, priv->bss_num);
 
 	if (priv->adapter->surprise_removed) {
 		kfree_skb(skb);
@@ -441,7 +441,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb_headroom(skb) < MWIFIEX_MIN_DATA_HEADER_LEN) {
 		dev_dbg(priv->adapter->dev,
 			"data: Tx: insufficient skb headroom %d\n",
-		       skb_headroom(skb));
+			skb_headroom(skb));
 		/* Insufficient skb headroom - allocate a new skb */
 		new_skb =
 			skb_realloc_headroom(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
@@ -454,7 +454,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		kfree_skb(skb);
 		skb = new_skb;
 		dev_dbg(priv->adapter->dev, "info: new skb headroomd %d\n",
-				skb_headroom(skb));
+			skb_headroom(skb));
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
@@ -495,7 +495,7 @@ mwifiex_set_mac_address(struct net_device *dev, void *addr)
 		memcpy(priv->netdev->dev_addr, priv->curr_addr, ETH_ALEN);
 	else
 		dev_err(priv->adapter->dev, "set mac address failed: ret=%d"
-					    "\n", ret);
+			"\n", ret);
 
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 
@@ -533,7 +533,7 @@ mwifiex_tx_timeout(struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	dev_err(priv->adapter->dev, "%lu : Tx timeout, bss_type-num = %d-%d\n",
-				jiffies, priv->bss_type, priv->bss_num);
+		jiffies, priv->bss_type, priv->bss_num);
 	mwifiex_set_trans_start(dev);
 	priv->num_tx_timeout++;
 }
@@ -704,7 +704,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	rtnl_lock();
 	/* Create station interface by default */
 	if (!mwifiex_add_virtual_intf(priv->wdev->wiphy, "mlan%d",
-				NL80211_IFTYPE_STATION, NULL, NULL)) {
+				      NL80211_IFTYPE_STATION, NULL, NULL)) {
 		rtnl_unlock();
 		dev_err(adapter->dev, "cannot create default station"
 				" interface\n");
@@ -781,7 +781,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 		if (priv && priv->netdev) {
 			if (!netif_queue_stopped(priv->netdev))
 				mwifiex_stop_net_dev_queue(priv->netdev,
-								adapter);
+							   adapter);
 			if (netif_carrier_ok(priv->netdev))
 				netif_carrier_off(priv->netdev);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index c0df48f..35225e9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -841,8 +841,8 @@ mwifiex_get_priv_by_id(struct mwifiex_adapter *adapter,
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
-			if ((adapter->priv[i]->bss_num == bss_num)
-			    && (adapter->priv[i]->bss_type == bss_type))
+			if ((adapter->priv[i]->bss_num == bss_num) &&
+			    (adapter->priv[i]->bss_type == bss_type))
 				break;
 		}
 	}
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 1033f00..1a5bc93 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -83,7 +83,7 @@ static int mwifiex_pcie_probe(struct pci_dev *pdev,
 	struct pcie_service_card *card;
 
 	pr_debug("info: vendor=0x%4.04X device=0x%4.04X rev=%d\n",
-				pdev->vendor, pdev->device, pdev->revision);
+		 pdev->vendor, pdev->device, pdev->revision);
 
 	card = kzalloc(sizeof(struct pcie_service_card), GFP_KERNEL);
 	if (!card) {
@@ -110,6 +110,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 {
 	struct pcie_service_card *card;
 	struct mwifiex_adapter *adapter;
+	struct mwifiex_private *priv;
 	int i;
 
 	card = pci_get_drvdata(pdev);
@@ -128,16 +129,15 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 
 		for (i = 0; i < adapter->priv_num; i++)
 			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-						MWIFIEX_BSS_ROLE_STA) &&
-					adapter->priv[i]->media_connected)
+			     MWIFIEX_BSS_ROLE_STA) &&
+			    adapter->priv[i]->media_connected)
 				mwifiex_deauthenticate(adapter->priv[i], NULL);
 
-		mwifiex_disable_auto_ds(mwifiex_get_priv(adapter,
-						 MWIFIEX_BSS_ROLE_ANY));
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-						MWIFIEX_BSS_ROLE_ANY),
-					 MWIFIEX_FUNC_SHUTDOWN);
+		mwifiex_disable_auto_ds(priv);
+
+		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
@@ -221,7 +221,7 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
 			netif_carrier_on(adapter->priv[i]->netdev);
 
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			      MWIFIEX_ASYNC_CMD);
+			  MWIFIEX_ASYNC_CMD);
 
 	return 0;
 }
@@ -380,9 +380,9 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	/* allocate shared memory for the BD ring and divide the same in to
 	   several descriptors */
 	card->txbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
-				MWIFIEX_MAX_TXRX_BD;
+							MWIFIEX_MAX_TXRX_BD;
 	dev_dbg(adapter->dev, "info: txbd_ring: Allocating %d bytes\n",
-				card->txbd_ring_size);
+		card->txbd_ring_size);
 	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
 	if (!card->txbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer for txbd ring.\n");
@@ -391,15 +391,16 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
 
 	dev_dbg(adapter->dev, "info: txbd_ring - base: %p, pbase: %#x:%x,"
-			"len: %x\n", card->txbd_ring_vbase,
-			(u32)card->txbd_ring_pbase,
-			(u32)((u64)card->txbd_ring_pbase >> 32),
-			card->txbd_ring_size);
+		"len: %x\n", card->txbd_ring_vbase,
+		(u32)card->txbd_ring_pbase,
+		(u32)((u64)card->txbd_ring_pbase >> 32),
+		card->txbd_ring_size);
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		card->txbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				(card->txbd_ring_vbase +
-				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+				     (card->txbd_ring_vbase +
+				      (sizeof(struct mwifiex_pcie_buf_desc)
+				       * i));
 
 		/* Allocate buffer here so that firmware can DMA data from it */
 		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
@@ -412,10 +413,9 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 
 		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
 		dev_dbg(adapter->dev, "info: TX ring: add new skb base: %p, "
-				"buf_base: %p, buf_pbase: %#x:%x, "
-				"buf_len: %#x\n", skb, skb->data,
-				(u32)*buf_pa, (u32)(((u64)*buf_pa >> 32)),
-				skb->len);
+			"buf_base: %p, buf_pbase: %#x:%x, "
+			"buf_len: %#x\n", skb, skb->data,
+			(u32)*buf_pa, (u32)(((u64)*buf_pa >> 32)), skb->len);
 
 		card->tx_buf_list[i] = skb;
 		card->txbd_ring[i]->paddr = *buf_pa;
@@ -469,9 +469,9 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	card->rxbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
 
 	card->rxbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
-				MWIFIEX_MAX_TXRX_BD;
+							MWIFIEX_MAX_TXRX_BD;
 	dev_dbg(adapter->dev, "info: rxbd_ring: Allocating %d bytes\n",
-				card->rxbd_ring_size);
+		card->rxbd_ring_size);
 	card->rxbd_ring_vbase = kzalloc(card->rxbd_ring_size, GFP_KERNEL);
 	if (!card->rxbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer for "
@@ -481,15 +481,16 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	card->rxbd_ring_pbase = virt_to_phys(card->rxbd_ring_vbase);
 
 	dev_dbg(adapter->dev, "info: rxbd_ring - base: %p, pbase: %#x:%x,"
-			"len: %#x\n", card->rxbd_ring_vbase,
-			(u32)card->rxbd_ring_pbase,
-			(u32)((u64)card->rxbd_ring_pbase >> 32),
-			card->rxbd_ring_size);
+		"len: %#x\n", card->rxbd_ring_vbase,
+		(u32)card->rxbd_ring_pbase,
+		(u32)((u64)card->rxbd_ring_pbase >> 32),
+		card->rxbd_ring_size);
 
 	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
 		card->rxbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				(card->rxbd_ring_vbase +
-				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+				     (card->rxbd_ring_vbase +
+				      (sizeof(struct mwifiex_pcie_buf_desc)
+				       * i));
 
 		/* Allocate skb here so that firmware can DMA data from it */
 		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
@@ -502,10 +503,10 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 		skb_put(skb, MWIFIEX_RX_DATA_BUF_SIZE);
 
 		dev_dbg(adapter->dev, "info: RX ring: add new skb base: %p, "
-				"buf_base: %p, buf_pbase: %#x:%x, "
-				"buf_len: %#x\n", skb, skb->data,
-				(u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
-				skb->len);
+			"buf_base: %p, buf_pbase: %#x:%x, "
+			"buf_len: %#x\n", skb, skb->data,
+			(u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+			skb->len);
 
 		card->rx_buf_list[i] = skb;
 		card->rxbd_ring[i]->paddr = *buf_pa;
@@ -562,27 +563,28 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	card->evtbd_rdptr |= MWIFIEX_BD_FLAG_ROLLOVER_IND;
 
 	card->evtbd_ring_size = sizeof(struct mwifiex_pcie_buf_desc) *
-				MWIFIEX_MAX_EVT_BD;
+							MWIFIEX_MAX_EVT_BD;
 	dev_dbg(adapter->dev, "info: evtbd_ring: Allocating %d bytes\n",
-				card->evtbd_ring_size);
+		card->evtbd_ring_size);
 	card->evtbd_ring_vbase = kzalloc(card->evtbd_ring_size, GFP_KERNEL);
 	if (!card->evtbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer. "
-				"Terminating download\n");
+			"Terminating download\n");
 		return -ENOMEM;
 	}
 	card->evtbd_ring_pbase = virt_to_phys(card->evtbd_ring_vbase);
 
 	dev_dbg(adapter->dev, "info: CMDRSP/EVT bd_ring - base: %p, "
-		       "pbase: %#x:%x, len: %#x\n", card->evtbd_ring_vbase,
-		       (u32)card->evtbd_ring_pbase,
-		       (u32)((u64)card->evtbd_ring_pbase >> 32),
-		       card->evtbd_ring_size);
+		"pbase: %#x:%x, len: %#x\n", card->evtbd_ring_vbase,
+		(u32)card->evtbd_ring_pbase,
+		(u32)((u64)card->evtbd_ring_pbase >> 32),
+		card->evtbd_ring_size);
 
 	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
 		card->evtbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				(card->evtbd_ring_vbase +
-				(sizeof(struct mwifiex_pcie_buf_desc) * i));
+				      (card->evtbd_ring_vbase +
+				       (sizeof(struct mwifiex_pcie_buf_desc)
+					* i));
 
 		/* Allocate skb here so that firmware can DMA data from it */
 		skb = dev_alloc_skb(MAX_EVENT_SIZE);
@@ -595,10 +597,10 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 		skb_put(skb, MAX_EVENT_SIZE);
 
 		dev_dbg(adapter->dev, "info: Evt ring: add new skb. base: %p, "
-			       "buf_base: %p, buf_pbase: %#x:%x, "
-			       "buf_len: %#x\n", skb, skb->data,
-			       (u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
-			       skb->len);
+			"buf_base: %p, buf_pbase: %#x:%x, "
+			"buf_len: %#x\n", skb, skb->data,
+			(u32)*buf_pa, (u32)((u64)*buf_pa >> 32),
+			skb->len);
 
 		card->evt_buf_list[i] = skb;
 		card->evtbd_ring[i]->paddr = *buf_pa;
@@ -703,7 +705,7 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 	skb = dev_alloc_skb(sizeof(u32));
 	if (!skb) {
 		dev_err(adapter->dev, "Unable to allocate skb for sleep "
-				      "cookie!\n");
+			"cookie!\n");
 		return -ENOMEM;
 	}
 	mwifiex_update_sk_buff_pa(skb);
@@ -713,7 +715,7 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 	*(u32 *)skb->data = FW_AWAKE_COOKIE;
 
 	dev_dbg(adapter->dev, "alloc_scook: sleep cookie=0x%x\n",
-				*((u32 *)skb->data));
+		*((u32 *)skb->data));
 
 	/* Save the sleep cookie */
 	card->sleep_cookie = skb;
@@ -758,14 +760,14 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	/* Read the TX ring read pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_TXBD_RDPTR, &rdptr)) {
 		dev_err(adapter->dev, "SEND DATA: failed to read "
-				      "REG_TXBD_RDPTR\n");
+			"REG_TXBD_RDPTR\n");
 		return -1;
 	}
 
 	wrindx = card->txbd_wrptr & MWIFIEX_TXBD_MASK;
 
 	dev_dbg(adapter->dev, "info: SEND DATA: <Rd: %#x, Wr: %#x>\n", rdptr,
-				card->txbd_wrptr);
+		card->txbd_wrptr);
 	if (((card->txbd_wrptr & MWIFIEX_TXBD_MASK) !=
 			(rdptr & MWIFIEX_TXBD_MASK)) ||
 	    ((card->txbd_wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) !=
@@ -797,9 +799,9 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 		/* Write the TX ring write pointer in to REG_TXBD_WRPTR */
 		if (mwifiex_write_reg(adapter, REG_TXBD_WRPTR,
-							card->txbd_wrptr)) {
+				      card->txbd_wrptr)) {
 			dev_err(adapter->dev, "SEND DATA: failed to write "
-					      "REG_TXBD_WRPTR\n");
+				"REG_TXBD_WRPTR\n");
 			return 0;
 		}
 
@@ -807,22 +809,21 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 				      CPU_INTR_DNLD_RDY)) {
 			dev_err(adapter->dev, "SEND DATA: failed to assert "
-					      "door-bell interrupt.\n");
+				"door-bell interrupt.\n");
 			return -1;
 		}
 		dev_dbg(adapter->dev, "info: SEND DATA: Updated <Rd: %#x, Wr: "
-				      "%#x> and sent packet to firmware "
-				      "successfully\n", rdptr,
-				      card->txbd_wrptr);
+			"%#x> and sent packet to firmware successfully\n",
+			rdptr, card->txbd_wrptr);
 	} else {
 		dev_dbg(adapter->dev, "info: TX Ring full, can't send anymore "
-				      "packets to firmware\n");
+			"packets to firmware\n");
 		adapter->data_sent = true;
 		/* Send the TX ready interrupt */
 		if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 				      CPU_INTR_DNLD_RDY))
 			dev_err(adapter->dev, "SEND DATA: failed to assert "
-					      "door-bell interrupt\n");
+				"door-bell interrupt\n");
 		return -EBUSY;
 	}
 
@@ -843,7 +844,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 	/* Read the RX ring Write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
 		dev_err(adapter->dev, "RECV DATA: failed to read "
-				      "REG_TXBD_RDPTR\n");
+			"REG_TXBD_RDPTR\n");
 		ret = -1;
 		goto done;
 	}
@@ -862,11 +863,11 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		   first byte is len, second byte is type */
 		rx_len = *((u16 *)skb_data->data);
 		dev_dbg(adapter->dev, "info: RECV DATA: Rd=%#x, Wr=%#x, "
-				"Len=%d\n", card->rxbd_rdptr, wrptr, rx_len);
+			"Len=%d\n", card->rxbd_rdptr, wrptr, rx_len);
 		skb_tmp = dev_alloc_skb(rx_len);
 		if (!skb_tmp) {
 			dev_dbg(adapter->dev, "info: Failed to alloc skb "
-					      "for RX\n");
+				"for RX\n");
 			ret = -EBUSY;
 			goto done;
 		}
@@ -881,13 +882,13 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 					    MWIFIEX_BD_FLAG_ROLLOVER_IND);
 		}
 		dev_dbg(adapter->dev, "info: RECV DATA: <Rd: %#x, Wr: %#x>\n",
-				card->rxbd_rdptr, wrptr);
+			card->rxbd_rdptr, wrptr);
 
 		/* Write the RX ring read pointer in to REG_RXBD_RDPTR */
 		if (mwifiex_write_reg(adapter, REG_RXBD_RDPTR,
 				      card->rxbd_rdptr)) {
 			dev_err(adapter->dev, "RECV DATA: failed to "
-					      "write REG_RXBD_RDPTR\n");
+				"write REG_RXBD_RDPTR\n");
 			ret = -1;
 			goto done;
 		}
@@ -895,12 +896,12 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
 		/* Read the RX ring Write pointer set by firmware */
 		if (mwifiex_read_reg(adapter, REG_RXBD_WRPTR, &wrptr)) {
 			dev_err(adapter->dev, "RECV DATA: failed to read "
-					      "REG_TXBD_RDPTR\n");
+				"REG_TXBD_RDPTR\n");
 			ret = -1;
 			goto done;
 		}
 		dev_dbg(adapter->dev, "info: RECV DATA: Received packet from "
-				      "firmware successfully\n");
+			"firmware successfully\n");
 		mwifiex_handle_rx_packet(adapter, skb_tmp);
 	}
 
@@ -920,8 +921,8 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	if (!(skb->data && skb->len && *buf_pa)) {
 		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x:%x, "
-				"%x>\n", __func__, skb->data, skb->len,
-				(u32)*buf_pa, (u32)((u64)*buf_pa >> 32));
+			"%x>\n", __func__, skb->data, skb->len,
+			(u32)*buf_pa, (u32)((u64)*buf_pa >> 32));
 		return -1;
 	}
 
@@ -929,7 +930,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	 * register 0 */
 	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_0_REG, (u32)*buf_pa)) {
 		dev_err(adapter->dev, "%s: failed to write download command "
-				      "to boot code.\n", __func__);
+			"to boot code.\n", __func__);
 		return -1;
 	}
 
@@ -938,14 +939,14 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_1_REG,
 			      (u32)((u64)*buf_pa >> 32))) {
 		dev_err(adapter->dev, "%s: failed to write download command "
-				      "to boot code.\n", __func__);
+			"to boot code.\n", __func__);
 		return -1;
 	}
 
 	/* Write the command length to scratch register 2 */
 	if (mwifiex_write_reg(adapter, PCIE_SCRATCH_2_REG, skb->len)) {
 		dev_err(adapter->dev, "%s: failed to write command length to "
-				      "scratch register 2\n", __func__);
+			"scratch register 2\n", __func__);
 		return -1;
 	}
 
@@ -953,7 +954,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	if (mwifiex_write_reg(adapter, PCIE_CPU_INT_EVENT,
 			      CPU_INTR_DOOR_BELL)) {
 		dev_err(adapter->dev, "%s: failed to assert door-bell "
-				      "interrupt.\n", __func__);
+			"interrupt.\n", __func__);
 		return -1;
 	}
 
@@ -973,14 +974,14 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	if (!(skb->data && skb->len)) {
 		dev_err(adapter->dev, "Invalid parameter in %s <%p, %#x>\n",
-				      __func__, skb->data, skb->len);
+			__func__, skb->data, skb->len);
 		return -1;
 	}
 
 	/* Make sure a command response buffer is available */
 	if (!card->cmdrsp_buf) {
 		dev_err(adapter->dev, "No response buffer available, send "
-				      "command failed\n");
+			"command failed\n");
 		return -EBUSY;
 	}
 
@@ -1011,7 +1012,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		/* Write the lower 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_LO,
-					(u32)*cmdrsp_buf_pa)) {
+				      (u32)*cmdrsp_buf_pa)) {
 			dev_err(adapter->dev, "Failed to write download command to boot code.\n");
 			ret = -1;
 			goto done;
@@ -1019,7 +1020,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		/* Write the upper 32bits of the cmdrsp buffer physical
 		   address */
 		if (mwifiex_write_reg(adapter, REG_CMDRSP_ADDR_HI,
-					(u32)((u64)*cmdrsp_buf_pa >> 32))) {
+				      (u32)((u64)*cmdrsp_buf_pa >> 32))) {
 			dev_err(adapter->dev, "Failed to write download command"
 					      " to boot code.\n");
 			ret = -1;
@@ -1029,8 +1030,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 
 	cmd_buf_pa = MWIFIEX_SKB_PACB(card->cmd_buf);
 	/* Write the lower 32bits of the physical address to REG_CMD_ADDR_LO */
-	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO,
-				(u32)*cmd_buf_pa)) {
+	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_LO, (u32)*cmd_buf_pa)) {
 		dev_err(adapter->dev, "Failed to write download command "
 				      "to boot code.\n");
 		ret = -1;
@@ -1038,7 +1038,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	}
 	/* Write the upper 32bits of the physical address to REG_CMD_ADDR_HI */
 	if (mwifiex_write_reg(adapter, REG_CMD_ADDR_HI,
-				(u32)((u64)*cmd_buf_pa >> 32))) {
+			      (u32)((u64)*cmd_buf_pa >> 32))) {
 		dev_err(adapter->dev, "Failed to write download command "
 				      "to boot code.\n");
 		ret = -1;
@@ -1046,8 +1046,7 @@ mwifiex_pcie_send_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 	}
 
 	/* Write the command length to REG_CMD_SIZE */
-	if (mwifiex_write_reg(adapter, REG_CMD_SIZE,
-				card->cmd_buf->len)) {
+	if (mwifiex_write_reg(adapter, REG_CMD_SIZE, card->cmd_buf->len)) {
 		dev_err(adapter->dev, "Failed to write command length to "
 				      "REG_CMD_SIZE\n");
 		ret = -1;
@@ -1076,16 +1075,16 @@ done:
 static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb = card->cmdrsp_buf;
 	int count = 0;
 
 	dev_dbg(adapter->dev, "info: Rx CMD Response\n");
 
 	if (!adapter->curr_cmd) {
-		skb_pull(card->cmdrsp_buf, INTF_HEADER_LEN);
+		skb_pull(skb, INTF_HEADER_LEN);
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
-			mwifiex_process_sleep_confirm_resp(adapter,
-					card->cmdrsp_buf->data,
-					card->cmdrsp_buf->len);
+			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
+							   skb->len);
 			while (mwifiex_pcie_ok_to_access_hw(adapter) &&
 							(count++ < 10))
 				usleep_range(50, 60);
@@ -1093,13 +1092,12 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 			dev_err(adapter->dev, "There is no command but "
 					      "got cmdrsp\n");
 		}
-		memcpy(adapter->upld_buf, card->cmdrsp_buf->data,
-		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER,
-			     card->cmdrsp_buf->len));
-		skb_push(card->cmdrsp_buf, INTF_HEADER_LEN);
+		memcpy(adapter->upld_buf, skb->data,
+		       min_t(u32, MWIFIEX_SIZE_OF_CMD_BUFFER, skb->len));
+		skb_push(skb, INTF_HEADER_LEN);
 	} else if (mwifiex_pcie_ok_to_access_hw(adapter)) {
-		skb_pull(card->cmdrsp_buf, INTF_HEADER_LEN);
-		adapter->curr_cmd->resp_skb = card->cmdrsp_buf;
+		skb_pull(skb, INTF_HEADER_LEN);
+		adapter->curr_cmd->resp_skb = skb;
 		adapter->cmd_resp_received = true;
 		/* Take the pointer and set it to CMD node and will
 		   return in the response complete callback */
@@ -1152,7 +1150,7 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 
 	if (adapter->event_received) {
 		dev_dbg(adapter->dev, "info: Event being processed, "\
-				"do not process this interrupt just yet\n");
+			"do not process this interrupt just yet\n");
 		return 0;
 	}
 
@@ -1163,14 +1161,15 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
-		dev_err(adapter->dev, "EventReady: failed to read REG_EVTBD_WRPTR\n");
+		dev_err(adapter->dev,
+			"EventReady: failed to read REG_EVTBD_WRPTR\n");
 		return -1;
 	}
 
 	dev_dbg(adapter->dev, "info: EventReady: Initial <Rd: 0x%x, Wr: 0x%x>",
-			card->evtbd_rdptr, wrptr);
-	if (((wrptr & MWIFIEX_EVTBD_MASK) !=
-	     (card->evtbd_rdptr & MWIFIEX_EVTBD_MASK)) ||
+		card->evtbd_rdptr, wrptr);
+	if (((wrptr & MWIFIEX_EVTBD_MASK) != (card->evtbd_rdptr
+					      & MWIFIEX_EVTBD_MASK)) ||
 	    ((wrptr & MWIFIEX_BD_FLAG_ROLLOVER_IND) ==
 	     (card->evtbd_rdptr & MWIFIEX_BD_FLAG_ROLLOVER_IND))) {
 		struct sk_buff *skb_cmd;
@@ -1230,7 +1229,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 
 	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
 		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
-					rdptr);
+			rdptr);
 		return -EINVAL;
 	}
 
@@ -1250,8 +1249,8 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 		skb = NULL;
 	} else {
 		dev_dbg(adapter->dev, "info: ERROR: Buffer is still valid at "
-				      "index %d, <%p, %p>\n", rdptr,
-				      card->evt_buf_list[rdptr], skb);
+			"index %d, <%p, %p>\n", rdptr,
+			card->evt_buf_list[rdptr], skb);
 	}
 
 	if ((++card->evtbd_rdptr & MWIFIEX_EVTBD_MASK) == MWIFIEX_MAX_EVT_BD) {
@@ -1261,7 +1260,7 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	}
 
 	dev_dbg(adapter->dev, "info: Updated <Rd: 0x%x, Wr: 0x%x>",
-				card->evtbd_rdptr, wrptr);
+		card->evtbd_rdptr, wrptr);
 
 	/* Write the event ring read pointer in to REG_EVTBD_RDPTR */
 	if (mwifiex_write_reg(adapter, REG_EVTBD_RDPTR, card->evtbd_rdptr)) {
@@ -1300,16 +1299,16 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	if (!firmware || !firmware_len) {
 		dev_err(adapter->dev, "No firmware image found! "
-				      "Terminating download\n");
+			"Terminating download\n");
 		return -1;
 	}
 
 	dev_dbg(adapter->dev, "info: Downloading FW image (%d bytes)\n",
-				firmware_len);
+		firmware_len);
 
 	if (mwifiex_pcie_disable_host_int(adapter)) {
 		dev_err(adapter->dev, "%s: Disabling interrupts"
-				      " failed.\n", __func__);
+			" failed.\n", __func__);
 		return -1;
 	}
 
@@ -1344,7 +1343,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			break;
 		} else if (len > MWIFIEX_UPLD_SIZE) {
 			pr_err("FW download failure @ %d, invalid length %d\n",
-				offset, len);
+			       offset, len);
 			ret = -1;
 			goto done;
 		}
@@ -1360,8 +1359,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				goto done;
 			}
 			dev_err(adapter->dev, "FW CRC error indicated by the "
-					      "helper: len = 0x%04X, txlen = "
-					      "%d\n", len, txlen);
+				"helper: len = 0x%04X, txlen = %d\n",
+				len, txlen);
 			len &= ~BIT(0);
 			/* Setting this to 0 to resend from same offset */
 			txlen = 0;
@@ -1374,9 +1373,9 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 			dev_dbg(adapter->dev, ".");
 
-			tx_blocks =
-				(txlen + MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD - 1) /
-				MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD;
+			tx_blocks = (txlen +
+				     MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD - 1) /
+				     MWIFIEX_PCIE_BLOCK_SIZE_FW_DNLD;
 
 			/* Copy payload to buffer */
 			memmove(skb->data, &firmware[offset], txlen);
@@ -1396,8 +1395,8 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (mwifiex_read_reg(adapter, PCIE_CPU_INT_STATUS,
 					     &ireg_intr)) {
 				dev_err(adapter->dev, "%s: Failed to read "
-						      "interrupt status during "
-						      "fw dnld.\n", __func__);
+					"interrupt status during fw dnld.\n",
+					__func__);
 				ret = -1;
 				goto done;
 			}
@@ -1407,7 +1406,7 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 	} while (true);
 
 	dev_dbg(adapter->dev, "info:\nFW download over, size %d bytes\n",
-				offset);
+		offset);
 
 	ret = 0;
 
@@ -1430,7 +1429,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 
 	/* Mask spurios interrupts */
 	if (mwifiex_write_reg(adapter, PCIE_HOST_INT_STATUS_MASK,
-				HOST_INTR_MASK)) {
+			      HOST_INTR_MASK)) {
 		dev_warn(adapter->dev, "Write register failed\n");
 		return -1;
 	}
@@ -1469,7 +1468,7 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 			ret = -1;
 		} else {
 			dev_err(adapter->dev, "PCI-E is not the winner <%#x, %d>, exit download\n",
-					ret, adapter->winner);
+				ret, adapter->winner);
 			ret = 0;
 		}
 	}
@@ -1512,10 +1511,11 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 			    (adapter->ps_state == PS_STATE_SLEEP)) {
 				mwifiex_pcie_enable_host_int(adapter);
 				if (mwifiex_write_reg(adapter,
-						PCIE_CPU_INT_EVENT,
-						CPU_INTR_SLEEP_CFM_DONE)) {
+						      PCIE_CPU_INT_EVENT,
+						      CPU_INTR_SLEEP_CFM_DONE)
+						      ) {
 					dev_warn(adapter->dev, "Write register"
-							       " failed\n");
+						 " failed\n");
 					return;
 
 				}
@@ -1551,7 +1551,7 @@ static irqreturn_t mwifiex_pcie_interrupt(int irq, void *context)
 	card = (struct pcie_service_card *) pci_get_drvdata(pdev);
 	if (!card || !card->adapter) {
 		pr_debug("info: %s: card=%p adapter=%p\n", __func__, card,
-						card ? card->adapter : NULL);
+			 card ? card->adapter : NULL);
 		goto exit;
 	}
 	adapter = card->adapter;
@@ -1616,7 +1616,8 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		if (adapter->int_status & HOST_INTR_CMD_DONE) {
 			adapter->int_status &= ~HOST_INTR_CMD_DONE;
 			if (adapter->cmd_sent) {
-				dev_dbg(adapter->dev, "info: CMD sent Interrupt\n");
+				dev_dbg(adapter->dev,
+					"info: CMD sent Interrupt\n");
 				adapter->cmd_sent = false;
 			}
 			/* Handle command response */
@@ -1628,15 +1629,17 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		if (mwifiex_pcie_ok_to_access_hw(adapter)) {
 			if (mwifiex_read_reg(adapter, PCIE_HOST_INT_STATUS,
 					     &pcie_ireg)) {
-				dev_warn(adapter->dev, "Read register failed\n");
+				dev_warn(adapter->dev,
+					 "Read register failed\n");
 				return -1;
 			}
 
 			if ((pcie_ireg != 0xFFFFFFFF) && (pcie_ireg)) {
 				if (mwifiex_write_reg(adapter,
-					PCIE_HOST_INT_STATUS, ~pcie_ireg)) {
+						      PCIE_HOST_INT_STATUS,
+						      ~pcie_ireg)) {
 					dev_warn(adapter->dev, "Write register"
-							       " failed\n");
+						 " failed\n");
 					return -1;
 				}
 				adapter->int_status |= pcie_ireg;
@@ -1646,7 +1649,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		}
 	}
 	dev_dbg(adapter->dev, "info: cmd_sent=%d data_sent=%d\n",
-	       adapter->cmd_sent, adapter->data_sent);
+		adapter->cmd_sent, adapter->data_sent);
 	mwifiex_pcie_enable_host_int(adapter);
 
 	return 0;
@@ -1738,7 +1741,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 	}
 
 	dev_dbg(adapter->dev, "PCI memory map Virt0: %p PCI memory map Virt2: "
-			      "%p\n", card->pci_mmap, card->pci_mmap1);
+		"%p\n", card->pci_mmap, card->pci_mmap1);
 
 	card->cmdrsp_buf = NULL;
 	ret = mwifiex_pcie_create_txbd_ring(adapter);
-- 
1.7.0.2

