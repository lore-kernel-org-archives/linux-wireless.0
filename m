Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:60198 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZCKC5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 22:57:14 -0400
Received: by an-out-0708.google.com with SMTP id c2so1358966anc.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 19:57:12 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk> <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk>
	 <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 22:57:04 -0400
Message-Id: <1236740224.6686.15.camel@rainbow> (sfid-20090311_035741_742820_ED04953D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I am not sure how your repository looks at this stage. What is your
> > latest wireless-testing commit and what patches do you have on top of
> > it?
> 
> The repo looks like this:
> git checkout -f ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
> patch -p1 < ../iwl-tx-cmd-conversion.patch
> patch -p1 < ../iwl-rb_stts.patch
> patch -p1 < ../iwl-BUG-to-WARN.patch

Attached is my current changes on top of
ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f "iwl3945: sync tx queue data
structure with iwlagn".  With it, I receive the Microcode SW errors and
515 mode of operation.  The previous commit
8a2ca8fa9131c4030375caa07ce4f3fac42dd5f7 "iwl3945: adding utils ops",
with the changes works.  So something in the tx_queue modification is
introducing an error.

I will take a look at the other suggestions, but it would be great if
someone could take a look at "iwl3945: sync tx queue data structures
with iwlagn" or point me to a fix that may have been applied later.

Thanks,

Jason

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 41556b4..622a03b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -761,6 +761,7 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds39[0];
 	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
+	int index = txq->q.read_ptr;
 	int i;
 	int counter;
 
@@ -777,6 +778,13 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 		return 0;
 	}
 
+	/* Unmap tx_cmd */
+	if (counter)
+		pci_unmap_single(dev,
+				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
+				pci_unmap_len(&txq->cmd[index]->meta, len),
+				PCI_DMA_TODEVICE);
+
 	/* unmap chunks if any */
 
 	for (i = 1; i < counter; i++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 98f5b7f..5209671 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -511,7 +511,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 
 	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
+		IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
 
 	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
 					len, PCI_DMA_TODEVICE);
@@ -2081,34 +2081,35 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 {
 	struct iwl3945_hw_key *keyinfo =
 	    &priv->stations_39[info->control.hw_key->hw_key_idx].keyinfo;
+	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(cmd->cmd.tx.key, keyinfo->key, keyinfo->keylen);
+		tx->sec_ctl = TX_CMD_SEC_CCM;
+		memcpy(tx->key, keyinfo->key, keyinfo->keylen);
 		IWL_DEBUG_TX("tx_cmd with AES hwcrypto\n");
 		break;
 
 	case ALG_TKIP:
 #if 0
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_TKIP;
+		tx->sec_ctl = TX_CMD_SEC_TKIP;
 
 		if (last_frag)
-			memcpy(cmd->cmd.tx.tkip_mic.byte, skb_frag->tail - 8,
+			memcpy(tx->tkip_mic.byte, skb_frag->tail - 8,
 			       8);
 		else
-			memset(cmd->cmd.tx.tkip_mic.byte, 0, 8);
+			memset(tx->tkip_mic.byte, 0, 8);
 #endif
 		break;
 
 	case ALG_WEP:
-		cmd->cmd.tx.sec_ctl = TX_CMD_SEC_WEP |
+		tx->sec_ctl = TX_CMD_SEC_WEP |
 		    (info->control.hw_key->hw_key_idx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT;
 
 		if (keyinfo->keylen == 13)
-			cmd->cmd.tx.sec_ctl |= TX_CMD_SEC_KEY128;
+			tx->sec_ctl |= TX_CMD_SEC_KEY128;
 
-		memcpy(&cmd->cmd.tx.key[3], keyinfo->key, keyinfo->keylen);
+		memcpy(&tx->key[3], keyinfo->key, keyinfo->keylen);
 
 		IWL_DEBUG_TX("Configuring packet for WEP encryption "
 			     "with key %d\n", info->control.hw_key->hw_key_idx);
@@ -2130,10 +2131,12 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 				  int is_unicast, u8 std_id)
 {
 	__le16 fc = hdr->frame_control;
-	__le32 tx_flags = cmd->cmd.tx.tx_flags;
+	__le32 tx_flags;
 	u8 rc_flags = info->control.rates[0].flags;
+	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
+	tx_flags = tx->tx_flags;
 
-	cmd->cmd.tx.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	tx->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 		tx_flags |= TX_CMD_FLG_ACK_MSK;
 		if (ieee80211_is_mgmt(fc))
@@ -2146,13 +2149,13 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
-	cmd->cmd.tx.sta_id = std_id;
+	tx->sta_id = std_id;
 	if (ieee80211_has_morefrags(fc))
 		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
 
 	if (ieee80211_is_data_qos(fc)) {
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		cmd->cmd.tx.tid_tspec = qc[0] & 0xf;
+		tx->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
 		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
@@ -2172,19 +2175,19 @@ static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
 	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
 	if (ieee80211_is_mgmt(fc)) {
 		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(3);
+			tx->timeout.pm_frame_timeout = cpu_to_le16(3);
 		else
-			cmd->cmd.tx.timeout.pm_frame_timeout = cpu_to_le16(2);
+			tx->timeout.pm_frame_timeout = cpu_to_le16(2);
 	} else {
-		cmd->cmd.tx.timeout.pm_frame_timeout = 0;
+		tx->timeout.pm_frame_timeout = 0;
 #ifdef CONFIG_IWL3945_LEDS
-		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
+		priv->rxtxpackets += le16_to_cpu(tx->len);
 #endif
 	}
 
-	cmd->cmd.tx.driver_txop = 0;
-	cmd->cmd.tx.tx_flags = tx_flags;
-	cmd->cmd.tx.next_frame_len = 0;
+	tx->driver_txop = 0;
+	tx->tx_flags = tx_flags;
+	tx->next_frame_len = 0;
 }
 
 /**
@@ -2261,6 +2264,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	struct iwl_cmd *out_cmd = NULL;
+	struct iwl3945_tx_cmd *out_tx = NULL;
 	u16 len, idx, len_org, hdr_len;
 	u8 id;
 	u8 unicast;
@@ -2351,8 +2355,9 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
+	out_tx = (struct iwl3945_tx_cmd *)out_cmd->cmd.payload;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
+	memset(out_tx, 0, sizeof(*out_tx));
 
 	/*
 	 * Set up the Tx-command (not MAC!) header.
@@ -2365,7 +2370,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Copy MAC header from skb into command buffer */
-	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
+	memcpy(out_tx->hdr, hdr, hdr_len);
 
 	/*
 	 * Use the first empty entry in this queue's command buffer array
@@ -2425,7 +2430,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
-	out_cmd->cmd.tx.len = cpu_to_le16(len);
+	out_tx->len = cpu_to_le16(len);
 
 	/* TODO need this for burst mode later on */
 	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, unicast, sta_id);
@@ -2433,8 +2438,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
 
-	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
-	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
+	out_tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
+	out_tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -2445,10 +2450,10 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		txq->need_update = 0;
 	}
 
-	iwl_print_hex_dump(priv, IWL_DL_TX, out_cmd->cmd.payload,
-			   sizeof(out_cmd->cmd.tx));
+	iwl_print_hex_dump(priv, IWL_DL_TX, out_tx,
+			   sizeof(*out_tx));
 
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)out_tx->hdr,
 			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
@@ -3154,7 +3159,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 	int cmd_index;
 	struct iwl_cmd *cmd;
 
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		return;
+	}
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
@@ -3476,7 +3488,12 @@ int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
 	if (!rxq->bd)
-		return -ENOMEM;
+		goto err_bd;
+
+        rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
+					&rxq->rb_stts_dma);
+        if (!rxq->rb_stts)
+		goto err_rb;
 
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
@@ -3488,6 +3505,12 @@ int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
 	rxq->free_count = 0;
 	rxq->need_update = 0;
 	return 0;
+
+err_rb:
+	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			    rxq->dma_addr);
+err_bd:
+        return -ENOMEM;
 }
 
 void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)

