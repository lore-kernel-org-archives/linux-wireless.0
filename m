Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbYCIVvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:16 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:15 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 16/24] rt2x00: Rename config_preamble() to config_erp()
Date: Sun, 9 Mar 2008 22:46:18 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092246.18694.IvDoorn@gmail.com> (sfid-20080309_222458_397476_0B4DE995)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename config_preamble() to config_erp() and cleanup argument
list by putting it all into a single structure.
This will make the function more meaningful and easier to
expand later. This second option is mostly intended to make
the patch "mac80211: proper short-slot handling" from Johannes Berg
easier to apply for rt2x00.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c    |   16 +++++-----
 drivers/net/wireless/rt2x00/rt2500pci.c    |   16 +++++-----
 drivers/net/wireless/rt2x00/rt2500usb.c    |   12 +++----
 drivers/net/wireless/rt2x00/rt2x00.h       |   18 ++++++++---
 drivers/net/wireless/rt2x00/rt2x00config.c |   43 +++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    5 +--
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    6 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   16 ++++------
 drivers/net/wireless/rt2x00/rt61pci.c      |   12 +++----
 drivers/net/wireless/rt2x00/rt73usb.c      |   12 +++----
 10 files changed, 76 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0ac0c6e..70f711e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -304,10 +304,8 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 					      conf->bssid, sizeof(conf->bssid));
 }
 
-static int rt2400pci_config_preamble(struct rt2x00_dev *rt2x00dev,
-				     const int short_preamble,
-				     const int ack_timeout,
-				     const int ack_consume_time)
+static int rt2400pci_config_erp(struct rt2x00_dev *rt2x00dev,
+				struct rt2x00lib_erp *erp)
 {
 	int preamble_mask;
 	u32 reg;
@@ -315,11 +313,13 @@ static int rt2400pci_config_preamble(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = short_preamble << 3;
+	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, ack_timeout);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT,
+			   erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
+			   erp->ack_consume_time);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -1601,7 +1601,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.kick_tx_queue		= rt2400pci_kick_tx_queue,
 	.fill_rxdone		= rt2400pci_fill_rxdone,
 	.config_intf		= rt2400pci_config_intf,
-	.config_preamble	= rt2400pci_config_preamble,
+	.config_erp		= rt2400pci_config_erp,
 	.config			= rt2400pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index d85e1a4..a46206c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -307,10 +307,8 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 					      conf->bssid, sizeof(conf->bssid));
 }
 
-static int rt2500pci_config_preamble(struct rt2x00_dev *rt2x00dev,
-				     const int short_preamble,
-				     const int ack_timeout,
-				     const int ack_consume_time)
+static int rt2500pci_config_erp(struct rt2x00_dev *rt2x00dev,
+				struct rt2x00lib_erp *erp)
 {
 	int preamble_mask;
 	u32 reg;
@@ -318,11 +316,13 @@ static int rt2500pci_config_preamble(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = short_preamble << 3;
+	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, ack_timeout);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT,
+			   erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
+			   erp->ack_consume_time);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -1911,7 +1911,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.kick_tx_queue		= rt2500pci_kick_tx_queue,
 	.fill_rxdone		= rt2500pci_fill_rxdone,
 	.config_intf		= rt2500pci_config_intf,
-	.config_preamble	= rt2500pci_config_preamble,
+	.config_erp		= rt2500pci_config_erp,
 	.config			= rt2500pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 7ea4247..43da93a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -356,10 +356,8 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 					      (3 * sizeof(__le16)));
 }
 
-static int rt2500usb_config_preamble(struct rt2x00_dev *rt2x00dev,
-				     const int short_preamble,
-				     const int ack_timeout,
-				     const int ack_consume_time)
+static int rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
+				struct rt2x00lib_erp *erp)
 {
 	u16 reg;
 
@@ -371,12 +369,12 @@ static int rt2500usb_config_preamble(struct rt2x00_dev *rt2x00dev,
 		return -EAGAIN;
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR1, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR1_ACK_TIMEOUT, ack_timeout);
+	rt2x00_set_field16(&reg, TXRX_CSR1_ACK_TIMEOUT, erp->ack_timeout);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR1, reg);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR10, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR10_AUTORESPOND_PREAMBLE,
-			   !!short_preamble);
+			   !!erp->short_preamble);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR10, reg);
 
 	return 0;
@@ -1842,7 +1840,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.kick_tx_queue		= rt2500usb_kick_tx_queue,
 	.fill_rxdone		= rt2500usb_fill_rxdone,
 	.config_intf		= rt2500usb_config_intf,
-	.config_preamble	= rt2500usb_config_preamble,
+	.config_erp		= rt2500usb_config_erp,
 	.config			= rt2500usb_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8718ad3..a324ff3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -384,7 +384,7 @@ struct rt2x00_intf {
 	 */
 	unsigned int delayed_flags;
 #define DELAYED_UPDATE_BEACON		0x00000001
-#define DELAYED_CONFIG_PREAMBLE		0x00000002
+#define DELAYED_CONFIG_ERP		0x00000002
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
@@ -451,6 +451,16 @@ struct rt2x00lib_conf {
 };
 
 /*
+ * Configuration structure for erp settings.
+ */
+struct rt2x00lib_erp {
+	int short_preamble;
+
+	int ack_timeout;
+	int ack_consume_time;
+};
+
+/*
  * Configuration structure wrapper around the
  * rt2x00 interface configuration handler.
  */
@@ -558,10 +568,8 @@ struct rt2x00lib_ops {
 #define CONFIG_UPDATE_MAC		( 1 << 2 )
 #define CONFIG_UPDATE_BSSID		( 1 << 3 )
 
-	int (*config_preamble) (struct rt2x00_dev *rt2x00dev,
-				const int short_preamble,
-				const int ack_timeout,
-				const int ack_consume_time);
+	int (*config_erp) (struct rt2x00_dev *rt2x00dev,
+			   struct rt2x00lib_erp *erp);
 	void (*config) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_conf *libconf,
 			const unsigned int flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 6995912..7211169 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -75,43 +75,40 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->ops->lib->config_intf(rt2x00dev, intf, &conf, flags);
 }
 
-void rt2x00lib_config_preamble(struct rt2x00_dev *rt2x00dev,
-			       struct rt2x00_intf *intf,
-			       const unsigned int short_preamble)
+void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
+			  struct rt2x00_intf *intf,
+			  struct ieee80211_bss_conf *bss_conf)
 {
+	struct rt2x00lib_erp erp;
 	int retval;
-	int ack_timeout;
-	int ack_consume_time;
 
-	ack_timeout = PLCP + get_duration(ACK_SIZE, 10);
-	ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
+	memset(&erp, 0, sizeof(erp));
+
+	erp.short_preamble = bss_conf->use_short_preamble;
+	erp.ack_timeout = PLCP + get_duration(ACK_SIZE, 10);
+	erp.ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
 
 	if (rt2x00dev->hw->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME)
-		ack_timeout += SHORT_DIFS;
+		erp.ack_timeout += SHORT_DIFS;
 	else
-		ack_timeout += DIFS;
+		erp.ack_timeout += DIFS;
 
-	if (short_preamble) {
-		ack_timeout += SHORT_PREAMBLE;
-		ack_consume_time += SHORT_PREAMBLE;
+	if (bss_conf->use_short_preamble) {
+		erp.ack_timeout += SHORT_PREAMBLE;
+		erp.ack_consume_time += SHORT_PREAMBLE;
 	} else {
-		ack_timeout += PREAMBLE;
-		ack_consume_time += PREAMBLE;
+		erp.ack_timeout += PREAMBLE;
+		erp.ack_consume_time += PREAMBLE;
 	}
 
-	retval = rt2x00dev->ops->lib->config_preamble(rt2x00dev,
-						      short_preamble,
-						      ack_timeout,
-						      ack_consume_time);
-
-	spin_lock(&intf->lock);
+	retval = rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 
 	if (retval) {
-		intf->delayed_flags |= DELAYED_CONFIG_PREAMBLE;
+		spin_lock(&intf->lock);
+		intf->delayed_flags |= DELAYED_CONFIG_ERP;
 		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
+		spin_unlock(&intf->lock);
 	}
-
-	spin_unlock(&intf->lock);
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 455d076..d6b1278 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -447,9 +447,8 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 		}
 	}
 
-	if (delayed_flags & DELAYED_CONFIG_PREAMBLE)
-		rt2x00lib_config_preamble(rt2x00dev, intf,
-					  intf->conf.use_short_preamble);
+	if (delayed_flags & DELAYED_CONFIG_ERP)
+		rt2x00lib_config_erp(rt2x00dev, intf, &intf->conf);
 }
 
 static void rt2x00lib_intf_scheduled(struct work_struct *work)
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 34ccb3d..6bd5a01 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -100,9 +100,9 @@ void rt2x00lib_config_intf(struct rt2x00_dev *rt2x00dev,
 			   struct rt2x00_intf *intf,
 			   enum ieee80211_if_types type,
 			   u8 *mac, u8 *bssid);
-void rt2x00lib_config_preamble(struct rt2x00_dev *rt2x00dev,
-			       struct rt2x00_intf *intf,
-			       const unsigned int short_preamble);
+void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
+			  struct rt2x00_intf *intf,
+			  struct ieee80211_bss_conf *conf);
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 			      enum antenna rx, enum antenna tx);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 76a2a7c..0a11c27 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -436,17 +436,15 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	/*
-	 * When the preamble mode has changed, we should perform additional
-	 * configuration steps. For all other changes we are already done.
+	 * When the erp information has changed, we should perform
+	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		rt2x00lib_config_preamble(rt2x00dev, intf,
-					  bss_conf->use_short_preamble);
+	if (changes & BSS_CHANGED_ERP_PREAMBLE)
+		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
 
-		spin_lock(&intf->lock);
-		memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
-		spin_unlock(&intf->lock);
-	}
+	spin_lock(&intf->lock);
+	memcpy(&intf->conf, bss_conf, sizeof(*bss_conf));
+	spin_unlock(&intf->lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 96fde43..62eff52 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -366,20 +366,18 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static int rt61pci_config_preamble(struct rt2x00_dev *rt2x00dev,
-				   const int short_preamble,
-				   const int ack_timeout,
-				   const int ack_consume_time)
+static int rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
+			      struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, ack_timeout);
+	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, erp->ack_timeout);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR4, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
-			   !!short_preamble);
+			   !!erp->short_preamble);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR4, reg);
 
 	return 0;
@@ -2481,7 +2479,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.kick_tx_queue		= rt61pci_kick_tx_queue,
 	.fill_rxdone		= rt61pci_fill_rxdone,
 	.config_intf		= rt61pci_config_intf,
-	.config_preamble	= rt61pci_config_preamble,
+	.config_erp		= rt61pci_config_erp,
 	.config			= rt61pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7729ac2..e0dd3ad 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -378,10 +378,8 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
-static int rt73usb_config_preamble(struct rt2x00_dev *rt2x00dev,
-				   const int short_preamble,
-				   const int ack_timeout,
-				   const int ack_consume_time)
+static int rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
+			      struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
@@ -393,12 +391,12 @@ static int rt73usb_config_preamble(struct rt2x00_dev *rt2x00dev,
 		return -EAGAIN;
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, ack_timeout);
+	rt2x00_set_field32(&reg, TXRX_CSR0_RX_ACK_TIMEOUT, erp->ack_timeout);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR4, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR4_AUTORESPOND_PREAMBLE,
-			   !!short_preamble);
+			   !!erp->short_preamble);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR4, reg);
 
 	return 0;
@@ -2090,7 +2088,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.kick_tx_queue		= rt73usb_kick_tx_queue,
 	.fill_rxdone		= rt73usb_fill_rxdone,
 	.config_intf		= rt73usb_config_intf,
-	.config_preamble	= rt73usb_config_preamble,
+	.config_erp		= rt73usb_config_erp,
 	.config			= rt73usb_config,
 };
 
-- 
1.5.4.3

