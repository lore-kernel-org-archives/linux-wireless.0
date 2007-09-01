Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63607 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbXIAEei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:38 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id DE25E618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:37 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 04/35] Avoid overuse of NULL
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:37 -0400
Message-ID: <20070901043437.2498.68801.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   76 +++++++++++++++++++--------------------
 1 files changed, 37 insertions(+), 39 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index d1d604e..0bb159d 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -313,7 +313,7 @@ static int at76_usbdfu_download(struct usb_device *udev, u8 *dfu_buffer,
 	}
 
 	block = kmalloc(DFU_PACKETSIZE, GFP_KERNEL);
-	if (block == NULL)
+	if (!block)
 		return -ENOMEM;
 
 	do {
@@ -734,11 +734,11 @@ static int at76_download_external_fw(struct usb_device *udev, u8 *buf, int size)
 
 	if (size < 0)
 		return -EINVAL;
-	if ((size > 0) && (buf == NULL))
+	if (size > 0 && !buf)
 		return -EFAULT;
 
 	block = kmalloc(EXT_FW_BLOCK_SIZE, GFP_KERNEL);
-	if (block == NULL)
+	if (!block)
 		return -ENOMEM;
 
 	at76_dbg(DBG_DEVSTART, "downloading external firmware");
@@ -1552,7 +1552,7 @@ static int at76_join_bss(struct at76_priv *priv, struct bss_info *ptr)
 {
 	struct at76_req_join join;
 
-	BUG_ON(ptr == NULL);
+	BUG_ON(!ptr);
 
 	memset(&join, 0, sizeof(struct at76_req_join));
 	memcpy(join.bssid, ptr->bssid, ETH_ALEN);
@@ -1739,8 +1739,8 @@ static int at76_auth_req(struct at76_priv *priv, struct bss_info *bss,
 	int buf_len = (seq_nr != 3 ? AUTH_FRAME_SIZE :
 		       AUTH_FRAME_SIZE + 1 + 1 + challenge->len);
 
-	BUG_ON(bss == NULL);
-	BUG_ON(seq_nr == 3 && challenge == NULL);
+	BUG_ON(!bss);
+	BUG_ON(seq_nr == 3 && !challenge);
 	tx_buffer = kmalloc(buf_len + MAX_PADDING_SIZE, GFP_ATOMIC);
 	if (!tx_buffer)
 		return -ENOMEM;
@@ -1791,7 +1791,7 @@ static int at76_assoc_req(struct at76_priv *priv, struct bss_info *bss)
 	int len;
 	u16 capa;
 
-	BUG_ON(bss == NULL);
+	BUG_ON(!bss);
 
 	tx_buffer = kmalloc(ASSOCREQ_MAX_SIZE + MAX_PADDING_SIZE, GFP_ATOMIC);
 	if (!tx_buffer)
@@ -1926,7 +1926,7 @@ static void at76_work_assoc_done(struct work_struct *work)
 	mutex_lock(&priv->mtx);
 
 	WARN_ON(priv->mac_state != MAC_ASSOC);
-	WARN_ON(priv->curr_bss == NULL);
+	WARN_ON(!priv->curr_bss);
 	if (priv->mac_state != MAC_ASSOC || !priv->curr_bss)
 		goto exit;
 
@@ -1983,21 +1983,20 @@ static void at76_delete_device(struct at76_priv *priv)
 	/* assuming we used keventd, it must quiesce too */
 	flush_scheduled_work();
 
-	if (priv->bulk_out_buffer != NULL)
-		kfree(priv->bulk_out_buffer);
+	kfree(priv->bulk_out_buffer);
 
-	if (priv->write_urb != NULL) {
+	if (priv->write_urb) {
 		usb_kill_urb(priv->write_urb);
 		usb_free_urb(priv->write_urb);
 	}
-	if (priv->read_urb != NULL) {
+	if (priv->read_urb) {
 		usb_kill_urb(priv->read_urb);
 		usb_free_urb(priv->read_urb);
 	}
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: unlinked urbs", __func__);
 
-	if (priv->rx_skb != NULL)
+	if (priv->rx_skb)
 		kfree_skb(priv->rx_skb);
 
 	at76_free_bss_list(priv);
@@ -2011,7 +2010,7 @@ static void at76_delete_device(struct at76_priv *priv)
 		at76_iwevent_bss_disconnect(priv->netdev);
 
 	for (i = 0; i < NR_RX_DATA_BUF; i++)
-		if (priv->rx_data[i].skb != NULL) {
+		if (priv->rx_data[i].skb) {
 			dev_kfree_skb(priv->rx_data[i].skb);
 			priv->rx_data[i].skb = NULL;
 		}
@@ -2475,7 +2474,6 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 	struct at76_priv *priv = netdev_priv(netdev);
 	unsigned long flags;
 	int ret = 0;
-	struct iw_scan_req *req = NULL;
 
 	at76_dbg(DBG_IOCTL, "%s: SIOCSIWSCAN", netdev->name);
 
@@ -2517,7 +2515,7 @@ static int at76_iw_handler_set_scan(struct net_device *netdev,
 	/* Try to do passive or active scan if WE asks as. */
 	if (wrqu->data.length
 	    && wrqu->data.length == sizeof(struct iw_scan_req)) {
-		req = (struct iw_scan_req *)extra;
+		struct iw_scan_req *req = (struct iw_scan_req *)extra;
 
 		if (req->scan_type == IW_SCAN_TYPE_PASSIVE)
 			priv->scan_mode = SCAN_TYPE_PASSIVE;
@@ -3556,14 +3554,14 @@ static int at76_submit_read_urb(struct at76_priv *priv)
 	int size;
 	struct sk_buff *skb = priv->rx_skb;
 
-	if (priv->read_urb == NULL) {
+	if (!priv->read_urb) {
 		err("%s: priv->read_urb is NULL", __func__);
 		return -EFAULT;
 	}
 
-	if (skb == NULL) {
+	if (!skb) {
 		skb = dev_alloc_skb(sizeof(struct at76_rx_buffer));
-		if (skb == NULL) {
+		if (!skb) {
 			err("%s: unable to allocate rx skbuff.",
 			    priv->netdev->name);
 			ret = -ENOMEM;
@@ -3977,7 +3975,7 @@ static struct bss_info *at76_match_bss(struct at76_priv *priv,
 	struct bss_info *ptr = NULL;
 	struct list_head *curr;
 
-	curr = last != NULL ? last->list.next : priv->bss_list.next;
+	curr = last ? last->list.next : priv->bss_list.next;
 	while (curr != &priv->bss_list) {
 		ptr = list_entry(curr, struct bss_info, list);
 		if (at76_match_essid(priv, ptr) && at76_match_mode(priv, ptr)
@@ -4015,7 +4013,7 @@ static void at76_work_join(struct work_struct *work)
 	priv->curr_bss = at76_match_bss(priv, priv->curr_bss);
 	spin_unlock_irqrestore(&priv->bss_list_spinlock, flags);
 
-	if (priv->curr_bss == NULL) {
+	if (!priv->curr_bss) {
 		/* here we haven't found a matching (i)bss ... */
 		if (priv->iw_mode == IW_MODE_ADHOC) {
 			at76_set_mac_state(priv, MAC_OWN_IBSS);
@@ -4545,7 +4543,7 @@ static void at76_rx_mgmt_assoc(struct at76_priv *priv,
 		return;
 	}
 
-	BUG_ON(priv->curr_bss == NULL);
+	BUG_ON(!priv->curr_bss);
 
 	if (status == WLAN_STATUS_SUCCESS) {
 		struct bss_info *ptr = priv->curr_bss;
@@ -4581,7 +4579,7 @@ static void at76_rx_mgmt_disassoc(struct at76_priv *priv,
 
 	/* We are not connected, ignore */
 	if (priv->mac_state == MAC_SCANNING || priv->mac_state == MAC_INIT
-	    || priv->curr_bss == NULL)
+	    || !priv->curr_bss)
 		return;
 
 	/* Not our BSSID, ignore */
@@ -4642,7 +4640,7 @@ static void at76_rx_mgmt_auth(struct at76_priv *priv,
 		return;
 	}
 
-	BUG_ON(priv->curr_bss == NULL);
+	BUG_ON(!priv->curr_bss);
 
 	/* Not our BSSID or not for our STA, ignore */
 	if (compare_ether_addr(mgmt->addr3, priv->curr_bss->bssid)
@@ -4696,7 +4694,7 @@ static void at76_rx_mgmt_deauth(struct at76_priv *priv,
 		return;
 	}
 
-	BUG_ON(priv->curr_bss == NULL);
+	BUG_ON(!priv->curr_bss);
 
 	/* Not our BSSID, ignore */
 	if (compare_ether_addr(mgmt->addr3, priv->curr_bss->bssid))
@@ -4741,7 +4739,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 	if (priv->mac_state == MAC_CONNECTED) {
 		/* in state MAC_CONNECTED we use the mgmt_timer to control
 		   the beacon of the BSS */
-		BUG_ON(priv->curr_bss == NULL);
+		BUG_ON(!priv->curr_bss);
 
 		if (!compare_ether_addr(priv->curr_bss->bssid, mgmt->addr3)) {
 			/* We got our AP's beacon, defer the timeout handler.
@@ -4770,7 +4768,7 @@ static void at76_rx_mgmt_beacon(struct at76_priv *priv,
 		}
 	}
 
-	if (match == NULL) {
+	if (!match) {
 		/* BSS not in the list - append it */
 		match = kmalloc(sizeof(struct bss_info), GFP_ATOMIC);
 		if (!match) {
@@ -4977,10 +4975,10 @@ static void at76_rx_mgmt(struct at76_priv *priv, struct at76_rx_buffer *buf)
 		   only read link quality info from management packets.
 		   Atmel driver actually averages the present, and previous
 		   values, we just present the raw value at the moment - TJS */
-		if (priv->iw_mode == IW_MODE_ADHOC ||
-		    (priv->curr_bss != NULL
-		     && !compare_ether_addr(mgmt->addr3,
-					    priv->curr_bss->bssid)))
+		if (priv->iw_mode == IW_MODE_ADHOC
+		    || (priv->curr_bss
+			&& !compare_ether_addr(mgmt->addr3,
+					       priv->curr_bss->bssid)))
 			at76_update_wstats(priv, buf);
 	}
 
@@ -5183,7 +5181,7 @@ static struct sk_buff *at76_check_for_rx_frags(struct at76_priv *priv)
 	bptr = priv->rx_data;
 	optr = NULL;
 	for (i = 0; i < NR_RX_DATA_BUF; i++, bptr++) {
-		if (bptr->skb == NULL) {
+		if (!bptr->skb) {
 			optr = bptr;
 			oldest = 0UL;
 			continue;
@@ -5192,7 +5190,7 @@ static struct sk_buff *at76_check_for_rx_frags(struct at76_priv *priv)
 		if (!compare_ether_addr(i802_11_hdr->addr2, bptr->sender))
 			break;
 
-		if (optr == NULL) {
+		if (!optr) {
 			optr = bptr;
 			oldest = bptr->last_rx;
 		} else if (bptr->last_rx < oldest)
@@ -5284,8 +5282,8 @@ static struct sk_buff *at76_check_for_rx_frags(struct at76_priv *priv)
 		return NULL;
 	}
 
-	BUG_ON(optr == NULL);
-	if (optr->skb != NULL) {
+	BUG_ON(!optr);
+	if (optr->skb) {
 		/* swap the skb's */
 		skb = optr->skb;
 		optr->skb = priv->rx_skb;
@@ -5331,7 +5329,7 @@ static void at76_rx_data(struct at76_priv *priv)
 		at76_dbg_dumpbuf("packet", skb->data + AT76_RX_HDRLEN, length);
 
 	skb = at76_check_for_rx_frags(priv);
-	if (skb == NULL)
+	if (!skb)
 		return;
 
 	/* Atmel header and the FCS are already removed */
@@ -5383,7 +5381,7 @@ static void at76_rx_monitor_mode(struct at76_priv *priv)
 	skblen = sizeof(struct at76_rx_radiotap) + length;
 
 	skb = dev_alloc_skb(skblen);
-	if (skb == NULL) {
+	if (!skb) {
 		err("%s: MONITOR MODE: dev_alloc_skb for radiotap header "
 		    "returned NULL", priv->netdev->name);
 		return;
@@ -5522,12 +5520,12 @@ exit:
 static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 {
 	struct net_device *netdev;
-	struct at76_priv *priv = NULL;
+	struct at76_priv *priv;
 	int i;
 
 	/* allocate memory for our device state and initialize it */
 	netdev = alloc_etherdev(sizeof(struct at76_priv));
-	if (netdev == NULL) {
+	if (!netdev) {
 		err("out of memory");
 		return NULL;
 	}
