Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXEKDGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:06:55 -0400
Subject: [PATCH 19/19] libertas: 64-bit cleanups
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:10:18 -0400
Message-Id: <1178853018.8607.54.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cmd.c     |   12 ++++++------
 drivers/net/wireless/libertas/debugfs.c |   14 +++++++++-----
 drivers/net/wireless/libertas/if_usb.c  |    2 +-
 drivers/net/wireless/libertas/join.c    |    3 ---
 drivers/net/wireless/libertas/rx.c      |    4 ++--
 drivers/net/wireless/libertas/scan.c    |    4 ++--
 drivers/net/wireless/libertas/tx.c      |    2 +-
 7 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 96df746..4022b93 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -948,8 +948,8 @@ void libertas_queue_cmd(wlan_adapter * adapter, struct cmd_ctrl_node *cmdnode, u
 
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
 
-	lbs_pr_debug(1, "QUEUE_CMD: Inserted node=0x%x, cmd=0x%x in cmdpendingq\n",
-	       (u32) cmdnode,
+	lbs_pr_debug(1, "QUEUE_CMD: Inserted node=%p, cmd=0x%x in cmdpendingq\n",
+	       cmdnode,
 	       ((struct cmd_ds_gen*)cmdnode->bufvirtualaddr)->command);
 
 done:
@@ -977,8 +977,8 @@ static int DownloadcommandToStation(wlan_private * priv,
 	ENTER();
 
 	if (!adapter || !cmdnode) {
-		lbs_pr_debug(1, "DNLD_CMD: adapter = %#x, cmdnode = %#x\n",
-		       (int)adapter, (int)cmdnode);
+		lbs_pr_debug(1, "DNLD_CMD: adapter = %p, cmdnode = %p\n",
+		       adapter, cmdnode);
 		if (cmdnode) {
 			spin_lock_irqsave(&adapter->driver_lock, flags);
 			__libertas_cleanup_and_insert_cmd(priv, cmdnode);
@@ -1175,8 +1175,8 @@ int libertas_prepare_and_send_command(wlan_private * priv,
 
 	cmdptr = (struct cmd_ds_command *)cmdnode->bufvirtualaddr;
 
-	lbs_pr_debug(1, "PREP_CMD: Val of cmd ptr =0x%x, command=0x%X\n",
-	       (u32) cmdptr, cmd_no);
+	lbs_pr_debug(1, "PREP_CMD: Val of cmd ptr=%p, command=0x%X\n",
+	       cmdptr, cmd_no);
 
 	if (!cmdptr) {
 		lbs_pr_debug(1, "PREP_CMD: bufvirtualaddr of cmdnode is NULL\n");
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 61cbd47..7d7bc5e 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -277,7 +277,7 @@ static void libertas_parse_ssid(char *buf, size_t count,
 	if (!end)
 		end = buf + count - 1;
 
-	size = min(IW_ESSID_MAX_SIZE, end - hold);
+	size = min((size_t)IW_ESSID_MAX_SIZE, (size_t) (end - hold));
 	strncpy(scan_cfg->specificSSID, hold, size);
 
 	return;
@@ -1779,7 +1779,7 @@ void libertas_debugfs_remove_one(wlan_private *priv)
 struct debug_data {
 	char name[32];
 	u32 size;
-	u32 addr;
+	size_t addr;
 };
 
 /* To debug any member of wlan_adapter, simply add one line here.
@@ -1826,6 +1826,8 @@ static ssize_t wlan_debugfs_read(struct file *file, char __user *userbuf,
 			val = *((u16 *) d[i].addr);
 		else if (d[i].size == 4)
 			val = *((u32 *) d[i].addr);
+		else if (d[i].size == 8)
+			val = *((u64 *) d[i].addr);
 
 		pos += sprintf(p + pos, "%s=%d\n", d[i].name, val);
 	}
@@ -1845,7 +1847,7 @@ static ssize_t wlan_debugfs_read(struct file *file, char __user *userbuf,
  *  @param data    data to write
  *  @return 	   number of data
  */
-static int wlan_debugfs_write(struct file *f, const char __user *buf,
+static ssize_t wlan_debugfs_write(struct file *f, const char __user *buf,
 			    size_t cnt, loff_t *ppos)
 {
 	int r, i;
@@ -1887,12 +1889,14 @@ static int wlan_debugfs_write(struct file *f, const char __user *buf,
 				*((u16 *) d[i].addr) = (u16) r;
 			else if (d[i].size == 4)
 				*((u32 *) d[i].addr) = (u32) r;
+			else if (d[i].size == 8)
+				*((u64 *) d[i].addr) = (u64) r;
 			break;
 		} while (1);
 	}
 	kfree(pdata);
 
-	return cnt;
+	return (ssize_t)cnt;
 }
 
 static struct file_operations libertas_debug_fops = {
@@ -1917,7 +1921,7 @@ void libertas_debug_init(wlan_private * priv, struct net_device *dev)
 		return;
 
 	for (i = 0; i < num_of_items; i++)
-		items[i].addr += (u32) priv->adapter;
+		items[i].addr += (size_t) priv->adapter;
 
 	priv->debugfs_debug = debugfs_create_file("debug", 0644,
 						  priv->debugfs_dir, &items[0],
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index f2d37d9..ae6f72a 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -388,7 +388,7 @@ static int __if_usb_submit_rx_urb(wlan_private * priv,
 	usb_fill_bulk_urb(cardp->rx_urb, cardp->udev,
 			  usb_rcvbulkpipe(cardp->udev,
 					  cardp->bulk_in_endpointAddr),
-			  skb->tail + IPFIELD_ALIGN_OFFSET,
+			  (void *) (skb->tail + (size_t) IPFIELD_ALIGN_OFFSET),
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
 			  rinfo);
 
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index b61e8a8..4909951 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -663,9 +663,6 @@ int libertas_cmd_80211_ad_hoc_join(wlan_private * priv,
 	       padhocjoin->bssdescriptor.BSSID[5],
 	       padhocjoin->bssdescriptor.SSID);
 
-	lbs_pr_debug(1, "ADHOC_J_CMD: Data Rate = %x\n",
-	       (u32) padhocjoin->bssdescriptor.datarates);
-
 	/* failtimeout */
 	padhocjoin->failtimeout = cpu_to_le16(MRVDRV_ASSOCIATION_TIME_OUT);
 
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 7e3f78f..d17924f 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -210,7 +210,7 @@ int libertas_process_rxed_packet(wlan_private * priv, struct sk_buff *skb)
 		goto done;
 	}
 
-	lbs_pr_debug(1, "RX Data: skb->len - sizeof(RxPd) = %d - %d = %d\n",
+	lbs_pr_debug(1, "RX Data: skb->len - sizeof(RxPd) = %d - %zd = %zd\n",
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
 	lbs_dbg_hex("RX Data: Dest", p_rx_pkt->eth803_hdr.dest_addr,
@@ -364,7 +364,7 @@ static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
 		priv->stats.rx_errors++;
 	}
 
-	lbs_pr_debug(1, "RX Data: skb->len - sizeof(RxPd) = %d - %d = %d\n",
+	lbs_pr_debug(1, "RX Data: skb->len - sizeof(RxPd) = %d - %zd = %zd\n",
 	       skb->len, sizeof(struct rxpd), skb->len - sizeof(struct rxpd));
 
 	/* create the exported radio header */
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 6c0cbb5..fac2b44 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -1085,7 +1085,7 @@ static int InterpretBSSDescriptionWithIE(struct bss_descriptor * pBSSEntry,
 			    sizeof(pcountryinfo->countrycode)
 			    || pcountryinfo->len > 254) {
 				lbs_pr_debug(1, "InterpretIE: 11D- Err "
-				       "CountryInfo len =%d min=%d max=254\n",
+				       "CountryInfo len =%d min=%zd max=254\n",
 				       pcountryinfo->len,
 				       sizeof(pcountryinfo->countrycode));
 				LEAVE();
@@ -1551,7 +1551,7 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
 	for (i = 0; i < adapter->numinscantable; i++) {
 		if ((current_ev + MAX_SCAN_CELL_SIZE) >= end_buf) {
 			lbs_pr_debug(1, "i=%d break out: current_ev=%p end_buf=%p "
-			       "MAX_SCAN_CELL_SIZE=%d\n",
+			       "MAX_SCAN_CELL_SIZE=%zd\n",
 			       i, current_ev, end_buf, MAX_SCAN_CELL_SIZE);
 			break;
 		}
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 82d0622..d4b1347 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -78,7 +78,7 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
 			 min_t(unsigned int, skb->len, 100));
 
 	if (!skb->len || (skb->len > MRVDRV_ETH_TX_PACKET_BUFFER_SIZE)) {
-		lbs_pr_debug(1, "Tx error: Bad skb length %d : %d\n",
+		lbs_pr_debug(1, "Tx error: Bad skb length %d : %zd\n",
 		       skb->len, MRVDRV_ETH_TX_PACKET_BUFFER_SIZE);
 		ret = -1;
 		goto done;
-- 
1.5.0.6



