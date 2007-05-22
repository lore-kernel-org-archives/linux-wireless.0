Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3940 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936418AbXEVPc4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 11:32:56 -0400
Date: Tue, 22 May 2007 11:17:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: netdev@vger.kernel.og, linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070522151751.GA5993@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 55b637c6a003a8c4850b41a2c2fd6942d8a7f530:
  Linus Torvalds (1):
        Linux v2.6.22-rc2

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

Eugene Teo (2):
      drivers/net/wireless/libertas/fw.c: fix use-before-check
      drivers/net/wireless/libertas/rx.c: fix use-after-free

Florin Malita (1):
      libertas: skb dereferenced after netif_rx

 drivers/net/wireless/libertas/decl.h |    2 +-
 drivers/net/wireless/libertas/fw.c   |   14 +++++++++-----
 drivers/net/wireless/libertas/rx.c   |   24 +++++-------------------
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index 606bdd0..dfe2764 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -46,7 +46,7 @@ u32 libertas_index_to_data_rate(u8 index);
 u8 libertas_data_rate_to_index(u32 rate);
 void libertas_get_fwversion(wlan_adapter * adapter, char *fwversion, int maxlen);
 
-int libertas_upload_rx_packet(wlan_private * priv, struct sk_buff *skb);
+void libertas_upload_rx_packet(wlan_private * priv, struct sk_buff *skb);
 
 /** The proc fs interface */
 int libertas_process_rx_command(wlan_private * priv);
diff --git a/drivers/net/wireless/libertas/fw.c b/drivers/net/wireless/libertas/fw.c
index 441123c..5c63c9b 100644
--- a/drivers/net/wireless/libertas/fw.c
+++ b/drivers/net/wireless/libertas/fw.c
@@ -333,18 +333,22 @@ static void command_timer_fn(unsigned long data)
 	unsigned long flags;
 
 	ptempnode = adapter->cur_cmd;
+	if (ptempnode == NULL) {
+		lbs_pr_debug(1, "PTempnode Empty\n");
+		return;
+	}
+
 	cmd = (struct cmd_ds_command *)ptempnode->bufvirtualaddr;
+	if (!cmd) {
+		lbs_pr_debug(1, "cmd is NULL\n");
+		return;
+	}
 
 	lbs_pr_info("command_timer_fn fired (%x)\n", cmd->command);
 
 	if (!adapter->fw_ready)
 		return;
 
-	if (ptempnode == NULL) {
-		lbs_pr_debug(1, "PTempnode Empty\n");
-		return;
-	}
-
 	spin_lock_irqsave(&adapter->driver_lock, flags);
 	adapter->cur_cmd = NULL;
 	spin_unlock_irqrestore(&adapter->driver_lock, flags);
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index d17924f..96619a3 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -136,7 +136,7 @@ static void wlan_compute_rssi(wlan_private * priv, struct rxpd *p_rx_pd)
 	LEAVE();
 }
 
-int libertas_upload_rx_packet(wlan_private * priv, struct sk_buff *skb)
+void libertas_upload_rx_packet(wlan_private * priv, struct sk_buff *skb)
 {
 	lbs_pr_debug(1, "skb->data=%p\n", skb->data);
 
@@ -148,8 +148,6 @@ int libertas_upload_rx_packet(wlan_private * priv, struct sk_buff *skb)
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	netif_rx(skb);
-
-	return 0;
 }
 
 /**
@@ -269,15 +267,11 @@ int libertas_process_rxed_packet(wlan_private * priv, struct sk_buff *skb)
 	wlan_compute_rssi(priv, p_rx_pd);
 
 	lbs_pr_debug(1, "RX Data: size of actual packet = %d\n", skb->len);
-	if (libertas_upload_rx_packet(priv, skb)) {
-		lbs_pr_debug(1, "RX error: libertas_upload_rx_packet"
-		       " returns failure\n");
-		ret = -1;
-		goto done;
-	}
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 
+	libertas_upload_rx_packet(priv, skb);
+
 	ret = 0;
 done:
 	LEAVE();
@@ -438,22 +432,14 @@ static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
 	wlan_compute_rssi(priv, prxpd);
 
 	lbs_pr_debug(1, "RX Data: size of actual packet = %d\n", skb->len);
-
-	if (libertas_upload_rx_packet(priv, skb)) {
-		lbs_pr_debug(1, "RX error: libertas_upload_rx_packet "
-			"returns failure\n");
-		ret = -1;
-		goto done;
-	}
-
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 
+	libertas_upload_rx_packet(priv, skb);
+
 	ret = 0;
 done:
 	LEAVE();
 
-	skb->protocol = __constant_htons(0x0019);	/* ETH_P_80211_RAW */
-
 	return (ret);
 }
-- 
John W. Linville
linville@tuxdriver.com
