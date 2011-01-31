Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:45755 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1AaSrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:47:53 -0500
Subject: [PATCH 05/22] zd1211rw: move set_multicast_hash and set_rx_filter
	from workers to configure_filter
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	Jussi Kivilinna <jussi.kivilina@mbnet.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:47:46 +0200
Message-ID: <20110131184746.10044.66051.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Workers not needed anymore since configure_filter may sleep. Keep
mac->multicast_hash for later use (hw reset).

Signed-off-by: Jussi Kivilinna <jussi.kivilina@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   38 ++++++--------------------------
 drivers/net/wireless/zd1211rw/zd_mac.h |    2 --
 2 files changed, 7 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 8b3d779..75d9a13 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -927,31 +927,6 @@ static void zd_process_intr(struct work_struct *work)
 }
 
 
-static void set_multicast_hash_handler(struct work_struct *work)
-{
-	struct zd_mac *mac =
-		container_of(work, struct zd_mac, set_multicast_hash_work);
-	struct zd_mc_hash hash;
-
-	spin_lock_irq(&mac->lock);
-	hash = mac->multicast_hash;
-	spin_unlock_irq(&mac->lock);
-
-	zd_chip_set_multicast_hash(&mac->chip, &hash);
-}
-
-static void set_rx_filter_handler(struct work_struct *work)
-{
-	struct zd_mac *mac =
-		container_of(work, struct zd_mac, set_rx_filter_work);
-	int r;
-
-	dev_dbg_f(zd_mac_dev(mac), "\n");
-	r = set_rx_filter(mac);
-	if (r)
-		dev_err(zd_mac_dev(mac), "set_rx_filter_handler error %d\n", r);
-}
-
 static u64 zd_op_prepare_multicast(struct ieee80211_hw *hw,
 				   struct netdev_hw_addr_list *mc_list)
 {
@@ -983,6 +958,7 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	};
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
+	int r;
 
 	/* Only deal with supported flags */
 	changed_flags &= SUPPORTED_FIF_FLAGS;
@@ -1004,11 +980,13 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	mac->multicast_hash = hash;
 	spin_unlock_irqrestore(&mac->lock, flags);
 
-	/* XXX: these can be called here now, can sleep now! */
-	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+	zd_chip_set_multicast_hash(&mac->chip, &hash);
 
-	if (changed_flags & FIF_CONTROL)
-		queue_work(zd_workqueue, &mac->set_rx_filter_work);
+	if (changed_flags & FIF_CONTROL) {
+		r = set_rx_filter(mac);
+		if (r)
+			dev_err(zd_mac_dev(mac), "set_rx_filter error %d\n", r);
+	}
 
 	/* no handling required for FIF_OTHER_BSS as we don't currently
 	 * do BSSID filtering */
@@ -1164,9 +1142,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
-	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
 	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
-	INIT_WORK(&mac->set_rx_filter_work, set_rx_filter_handler);
 	INIT_WORK(&mac->process_intr, zd_process_intr);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index a6d86b9..f28ecb9 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -173,9 +173,7 @@ struct zd_mac {
 	spinlock_t intr_lock;
 	struct ieee80211_hw *hw;
 	struct housekeeping housekeeping;
-	struct work_struct set_multicast_hash_work;
 	struct work_struct set_rts_cts_work;
-	struct work_struct set_rx_filter_work;
 	struct work_struct process_intr;
 	struct zd_mc_hash multicast_hash;
 	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];

