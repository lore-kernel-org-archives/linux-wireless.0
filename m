Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:8948 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932367AbXJPNUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 09:20:55 -0400
From: Bruno Randolf <bruno@thinktube.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/3] consistently use ath5k in printks
Date: Tue, 16 Oct 2007 22:20:38 +0900
Message-Id: <1192540838-26985-4-git-send-email-bruno@thinktube.com> (sfid-20071016_142100_724914_42FE5458)
In-Reply-To: <1192540838-26985-3-git-send-email-bruno@thinktube.com>
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changed all ocurrences of "ath_pci" and "ath" in printks and debug messages to
"ath5k", to avoid confusion with the madwifi driver.

changed the module version to "0.0.1 (EXPERIMENTAL)" instead of the old one
which came from the madwifi-bsd branch.

the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/base.c |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 15004b2..7ef73c8 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -39,7 +39,7 @@
  * THE POSSIBILITY OF SUCH DAMAGES.
  *
  */
-#define	ATH_PCI_VERSION	"0.9.5.0-BSD"
+#define	ATH5K_VERSION	"0.0.1 (EXPERIMENTAL)"
 
 #include <linux/version.h>
 #include <linux/module.h>
@@ -214,7 +214,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
-			printk(KERN_ERR "ath: error %d while processing "
+			printk(KERN_ERR "ath5k: error %d while processing "
 				"queue %u\n", ret, txq->qnum);
 			break;
 		}
@@ -278,7 +278,7 @@ static int ath_rxbuf_init(struct ath_softc *sc, struct ath_buf *bf)
 		 */
 		skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
 		if (unlikely(skb == NULL)) {
-			printk(KERN_ERR "ath: can't alloc skbuff of size %u\n",
+			printk(KERN_ERR "ath5k: can't alloc skbuff of size %u\n",
 					sc->rxbufsize + sc->cachelsz - 1);
 			return -ENOMEM;
 		}
@@ -382,7 +382,7 @@ static void ath_tasklet_rx(unsigned long data)
 	do {
 		if (unlikely(list_empty(&sc->rxbuf))) {
 			if (net_ratelimit())
-				printk(KERN_WARNING "ath: empty rx buf pool\n");
+				printk(KERN_WARNING "ath5k: empty rx buf pool\n");
 			break;
 		}
 		bf = list_first_entry(&sc->rxbuf, struct ath_buf, list);
@@ -402,14 +402,14 @@ static void ath_tasklet_rx(unsigned long data)
 			break;
 		else if (unlikely(ret)) {
 			if (net_ratelimit())
-				printk(KERN_ERR "ath: error in processing rx "
+				printk(KERN_ERR "ath5k: error in processing rx "
 					"descriptor\n");
 			return;
 		}
 
 		if (unlikely(ds->ds_rxstat.rs_more)) {
 			if (net_ratelimit())
-				printk(KERN_INFO "ath: unsupported jumbo\n");
+				printk(KERN_INFO "ath5k: unsupported jumbo\n");
 			goto next;
 		}
 
@@ -507,7 +507,7 @@ static int ath_beacon_setup(struct ath_softc *sc, struct ath_buf *bf,
 			"skbaddr %llx\n", __func__, skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
 	if (pci_dma_mapping_error(bf->skbaddr)) {
-		printk(KERN_ERR "ath: beacon DMA mapping failed\n");
+		printk(KERN_ERR "ath5k: beacon DMA mapping failed\n");
 		return -EIO;
 	}
 
@@ -566,7 +566,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 
 	if (unlikely(bf->skb == NULL || sc->opmode == IEEE80211_IF_TYPE_STA ||
 			sc->opmode == IEEE80211_IF_TYPE_MNTR)) {
-		printk(KERN_WARNING "ath: bf=%p bf_skb=%p\n", bf,
+		printk(KERN_WARNING "ath5k: bf=%p bf_skb=%p\n", bf,
 				bf ? bf->skb : NULL);
 		return;
 	}
@@ -603,7 +603,7 @@ static void ath_beacon_send(struct ath_softc *sc)
 	 * are still pending on the queue.
 	 */
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
-		printk(KERN_WARNING "ath: beacon queue %u didn't stop?\n",
+		printk(KERN_WARNING "ath5k: beacon queue %u didn't stop?\n",
 				sc->bhalq);
 		/* NB: the HW still stops DMA, so proceed */
 	}
@@ -1235,7 +1235,7 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		pad = hdrlen % 4;
 		if (skb_headroom(skb) < pad) {
 			if (net_ratelimit())
-				printk(KERN_ERR "ath: tx hdrlen not %%4: %d "
+				printk(KERN_ERR "ath5k: tx hdrlen not %%4: %d "
 					"not enough headroom to pad %d\n",
 					hdrlen, pad);
 			return -1;
@@ -1249,7 +1249,7 @@ static int ath_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	spin_lock_irqsave(&sc->txbuflock, flags);
 	if (list_empty(&sc->txbuf)) {
 		if (net_ratelimit())
-			printk(KERN_ERR "ath: no further txbuf available, "
+			printk(KERN_ERR "ath5k: no further txbuf available, "
 				"dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
 		ieee80211_stop_queue(hw, ctl->queue);
@@ -1296,14 +1296,14 @@ static int ath_reset(struct ieee80211_hw *hw)
 
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ath: can't reset hardware (%d)\n", ret);
+		printk(KERN_ERR "ath5k: can't reset hardware (%d)\n", ret);
 		goto err;
 	}
 	ath_update_txpow(sc);
 
 	ret = ath_startrecv(sc);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "ath: can't start recv logic\n");
+		printk(KERN_ERR "ath5k: can't start recv logic\n");
 		goto err;
 	}
 	/*
@@ -1563,7 +1563,7 @@ static int ath_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	case SET_KEY:
 		ret = ath5k_hw_set_key(sc->ah, key->keyidx, key, addr);
 		if (ret) {
-			printk(KERN_ERR "ath: can't set the key\n");
+			printk(KERN_ERR "ath5k: can't set the key\n");
 			goto unlock;
 		}
 		__set_bit(key->keyidx, sc->keymap);
@@ -1670,7 +1670,7 @@ static void ath_calibrate(unsigned long data)
 	struct ath_softc *sc = (void *)data;
 	struct ath_hw *ah = sc->ah;
 
-	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath: channel %u/%x\n",
+	DPRINTF(sc, ATH_DEBUG_CALIBRATE, "ath5k: channel %u/%x\n",
 		sc->curchan->chan, sc->curchan->val);
 
 	if (ath5k_hw_get_rf_gain(ah) == AR5K_RFGAIN_NEED_CHANGE) {
@@ -1682,7 +1682,7 @@ static void ath_calibrate(unsigned long data)
 		ath_reset(sc->hw);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
-		printk(KERN_ERR "ath: calibration of channel %u failed\n",
+		printk(KERN_ERR "ath5k: calibration of channel %u failed\n",
 				sc->curchan->chan);
 
 	mod_timer(&sc->calib_tim, round_jiffies(jiffies +
@@ -1801,7 +1801,7 @@ static irqreturn_t ath_intr(int irq, void *dev_id)
 	} while (ath5k_hw_is_intr_pending(ah) && counter-- > 0);
 
 	if (unlikely(!counter && net_ratelimit()))
-		printk(KERN_WARNING "ath: too many interrupts, giving up for "
+		printk(KERN_WARNING "ath5k: too many interrupts, giving up for "
 				"now\n");
 
 	return IRQ_HANDLED;
@@ -2158,7 +2158,7 @@ static struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype,
 		return ERR_PTR(qnum);
 	}
 	if (qnum >= ARRAY_SIZE(sc->txqs)) {
-		printk(KERN_ERR "ath: qnum %u out of range, max %tu!\n",
+		printk(KERN_ERR "ath5k: qnum %u out of range, max %tu!\n",
 			qnum, ARRAY_SIZE(sc->txqs));
 		ath5k_hw_release_tx_queue(ah, qnum);
 		return ERR_PTR(-EINVAL);
@@ -2404,7 +2404,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 	 */
 	pci_write_config_byte(pdev, 0x41, 0);
 
-	ret = pci_request_region(pdev, 0, "ath");
+	ret = pci_request_region(pdev, 0, "ath5k");
 	if (ret) {
 		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
 		goto err_dis;
@@ -2562,7 +2562,7 @@ static int ath_pci_resume(struct pci_dev *pdev)
 #endif /* CONFIG_PM */
 
 static struct pci_driver ath_pci_drv_id = {
-	.name		= "ath_pci",
+	.name		= "ath5k",
 	.id_table	= ath_pci_id_table,
 	.probe		= ath_pci_probe,
 	.remove		= __devexit_p(ath_pci_remove),
@@ -2618,7 +2618,7 @@ static ctl_table ath_static_sysctls[] = {
 };
 static ctl_table ath_ath_table[] = {
 	{
-	  .procname	= "ath",
+	  .procname	= "ath5k",
 	  .mode		= 0555,
 	  .child	= ath_static_sysctls
 	}, { 0 }
@@ -2639,7 +2639,7 @@ static int __init init_ath_pci(void)
 
 	ret = pci_register_driver(&ath_pci_drv_id);
 	if (ret) {
-		printk(KERN_ERR "ath_pci: can't register pci driver\n");
+		printk(KERN_ERR "ath5k: can't register pci driver\n");
 		return ret;
 	}
 	ath_sysctl_header = register_sysctl_table(ath_root_table);
@@ -2661,4 +2661,4 @@ MODULE_AUTHOR("Jiri Slaby");
 MODULE_DESCRIPTION("Support for Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION(ATH_PCI_VERSION " (EXPERIMENTAL)");
+MODULE_VERSION(ATH5K_VERSION);
-- 
1.5.3.4

