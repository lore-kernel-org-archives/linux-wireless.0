Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:9207 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYAJTAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 14:00:53 -0500
Received: by ug-out-1314.google.com with SMTP id z38so337396ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 11:00:50 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: proper short-slot handling
Date: Thu, 10 Jan 2008 20:00:44 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
References: <1199974496.3861.80.camel@johannes.berg>
In-Reply-To: <1199974496.3861.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801102000.44722.IvDoorn@gmail.com> (sfid-20080110_190058_392910_14F124A1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> If you think it is the right approach, maybe try converting your driver
> and see if that results in any problems, if not, send me the patch and
> I'll integrate it.

The convertion was very easy, and like I said cleaned up some hacks. :)

---

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a05fd0e..98706de 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -308,22 +308,35 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
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
 
+	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
+	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
+	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
+	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
+	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
+	rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
+	rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
+	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = short_preamble << 3;
+	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, ack_timeout);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
+			   erp->ack_consume_time);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -477,20 +490,6 @@ static void rt2400pci_config_duration(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
-	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, libconf->slot_time);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
-	rt2x00_set_field32(&reg, CSR18_SIFS, libconf->sifs);
-	rt2x00_set_field32(&reg, CSR18_PIFS, libconf->pifs);
-	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
-	rt2x00_set_field32(&reg, CSR19_DIFS, libconf->difs);
-	rt2x00_set_field32(&reg, CSR19_EIFS, libconf->eifs);
-	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
-
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
 	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
@@ -517,7 +516,7 @@ static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt2400pci_config_antenna(rt2x00dev, &libconf->ant);
-	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
+	if (flags & CONFIG_UPDATE_BEACON_INT)
 		rt2400pci_config_duration(rt2x00dev, libconf);
 }
 
@@ -1560,7 +1559,7 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 	.config_mac_addr	= rt2400pci_config_mac_addr,
 	.config_bssid		= rt2400pci_config_bssid,
 	.config_type		= rt2400pci_config_type,
-	.config_preamble	= rt2400pci_config_preamble,
+	.config_erp		= rt2400pci_config_erp,
 	.config			= rt2400pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 6242615..99c7557 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -312,22 +312,35 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
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
 
+	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
+	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, erp->slot_time);
+	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
+	rt2x00_set_field32(&reg, CSR18_SIFS, erp->sifs);
+	rt2x00_set_field32(&reg, CSR18_PIFS, erp->pifs);
+	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
+
+	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
+	rt2x00_set_field32(&reg, CSR19_DIFS, erp->difs);
+	rt2x00_set_field32(&reg, CSR19_EIFS, erp->eifs);
+	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
+
 	/*
 	 * When short preamble is enabled, we should set bit 0x08
 	 */
-	preamble_mask = short_preamble << 3;
+	preamble_mask = erp->short_preamble << 3;
 
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, ack_timeout);
-	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME, ack_consume_time);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_TIMEOUT, erp->ack_timeout);
+	rt2x00_set_field32(&reg, TXCSR1_ACK_CONSUME_TIME,
+			   erp->ack_consume_time);
 	rt2x00pci_register_write(rt2x00dev, TXCSR1, reg);
 
 	rt2x00pci_register_read(rt2x00dev, ARCSR2, &reg);
@@ -526,20 +539,6 @@ static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, CSR11, &reg);
-	rt2x00_set_field32(&reg, CSR11_SLOT_TIME, libconf->slot_time);
-	rt2x00pci_register_write(rt2x00dev, CSR11, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR18, &reg);
-	rt2x00_set_field32(&reg, CSR18_SIFS, libconf->sifs);
-	rt2x00_set_field32(&reg, CSR18_PIFS, libconf->pifs);
-	rt2x00pci_register_write(rt2x00dev, CSR18, reg);
-
-	rt2x00pci_register_read(rt2x00dev, CSR19, &reg);
-	rt2x00_set_field32(&reg, CSR19_DIFS, libconf->difs);
-	rt2x00_set_field32(&reg, CSR19_EIFS, libconf->eifs);
-	rt2x00pci_register_write(rt2x00dev, CSR19, reg);
-
 	rt2x00pci_register_read(rt2x00dev, TXCSR1, &reg);
 	rt2x00_set_field32(&reg, TXCSR1_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00_set_field32(&reg, TXCSR1_AUTORESPONDER, 1);
@@ -567,7 +566,7 @@ static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt2500pci_config_antenna(rt2x00dev, &libconf->ant);
-	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
+	if (flags & CONFIG_UPDATE_BEACON_INT)
 		rt2500pci_config_duration(rt2x00dev, libconf);
 }
 
@@ -1875,7 +1874,7 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 	.config_mac_addr	= rt2500pci_config_mac_addr,
 	.config_bssid		= rt2500pci_config_bssid,
 	.config_type		= rt2500pci_config_type,
-	.config_preamble	= rt2500pci_config_preamble,
+	.config_erp		= rt2500pci_config_erp,
 	.config			= rt2500pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 3084e24..53b7b4c 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -356,10 +356,8 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 }
 
-static int rt2500usb_config_preamble(struct rt2x00_dev *rt2x00dev,
-				     const int short_preamble,
-				     const int ack_timeout,
-				     const int ack_consume_time)
+static int rt2500usb_config_erp(struct rt2x00_dev *rt2x00dev,
+				struct rt2x00lib_erp *erp)
 {
 	u16 reg;
 
@@ -370,13 +368,15 @@ static int rt2500usb_config_preamble(struct rt2x00_dev *rt2x00dev,
 	if (in_atomic())
 		return -EAGAIN;
 
+	rt2500usb_register_write(rt2x00dev, MAC_CSR10, erp->slot_time);
+
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
@@ -531,8 +531,6 @@ static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
 {
 	u16 reg;
 
-	rt2500usb_register_write(rt2x00dev, MAC_CSR10, libconf->slot_time);
-
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL,
 			   libconf->conf->beacon_int * 4);
@@ -554,7 +552,7 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
 					 libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt2500usb_config_antenna(rt2x00dev, &libconf->ant);
-	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
+	if (flags & CONFIG_UPDATE_BEACON_INT)
 		rt2500usb_config_duration(rt2x00dev, libconf);
 }
 
@@ -1833,7 +1831,7 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 	.config_mac_addr	= rt2500usb_config_mac_addr,
 	.config_bssid		= rt2500usb_config_bssid,
 	.config_type		= rt2500usb_config_type,
-	.config_preamble	= rt2500usb_config_preamble,
+	.config_erp		= rt2500usb_config_erp,
 	.config			= rt2500usb_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index f9e1bef..40c88c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -398,7 +398,7 @@ struct rt2x00_intf {
 	 */
 	unsigned int delayed_flags;
 #define DELAYED_UPDATE_BEACON		0x00000001
-#define DELAYED_CONFIG_PREAMBLE		0x00000002
+#define DELAYED_CONFIG_ERP		0x00000002
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
@@ -446,10 +446,20 @@ struct rt2x00lib_conf {
 	struct antenna_setup ant;
 
 	int phymode;
-
 	int basic_rates;
+};
+
+/*
+ * Configuration structure for erp related settings,
+ * 
+ */
+struct rt2x00lib_erp {
+	int short_preamble;
 	int slot_time;
 
+	int ack_timeout;
+	int ack_consume_time;
+
 	short sifs;
 	short pifs;
 	short difs;
@@ -527,19 +537,16 @@ struct rt2x00lib_ops {
 	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, __le32 *mac);
 	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, __le32 *bssid);
 	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type,
-							   const int tsf_sync);
-	int (*config_preamble) (struct rt2x00_dev *rt2x00dev,
-				const int short_preamble,
-				const int ack_timeout,
-				const int ack_consume_time);
+			     const int tsf_sync);
+	int (*config_erp) (struct rt2x00_dev *rt2x00dev,
+			   struct rt2x00lib_erp *erp);
 	void (*config) (struct rt2x00_dev *rt2x00dev, const unsigned int flags,
 			struct rt2x00lib_conf *libconf);
 #define CONFIG_UPDATE_PHYMODE		( 1 << 1 )
 #define CONFIG_UPDATE_CHANNEL		( 1 << 2 )
 #define CONFIG_UPDATE_TXPOWER		( 1 << 3 )
 #define CONFIG_UPDATE_ANTENNA		( 1 << 4 )
-#define CONFIG_UPDATE_SLOT_TIME 	( 1 << 5 )
-#define CONFIG_UPDATE_BEACON_INT	( 1 << 6 )
+#define CONFIG_UPDATE_BEACON_INT	( 1 << 5 )
 #define CONFIG_UPDATE_ALL		0xffff
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 19c1e07..91ee317 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -89,45 +89,51 @@ void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type)
 	rt2x00dev->ops->lib->config_type(rt2x00dev, type, tsf_sync);
 }
 
-void rt2x00lib_config_preamble(struct rt2x00_dev *rt2x00dev,
-			       struct rt2x00_intf *intf,
-			       const unsigned int short_preamble)
+void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
+			  struct rt2x00_intf *intf,
+			  struct ieee80211_bss_conf *conf)
 {
+	struct rt2x00lib_erp erp;
 	int retval;
-	int ack_timeout;
-	int ack_consume_time;
 
-	ack_timeout = PLCP + get_duration(ACK_SIZE, 10);
-	ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
+	memset(&erp, 0, sizeof(erp));
 
-	if (rt2x00dev->hw->conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME)
-		ack_timeout += SHORT_DIFS;
-	else
-		ack_timeout += DIFS;
+	erp.short_preamble = conf->use_short_preamble;
+	erp.ack_timeout = PLCP + get_duration(ACK_SIZE, 10);
+	erp.ack_consume_time = SIFS + PLCP + get_duration(ACK_SIZE, 10);
+	erp.sifs = SIFS;
+	erp.eifs = EIFS;
 
-	if (short_preamble) {
-		ack_timeout += SHORT_PREAMBLE;
-		ack_consume_time += SHORT_PREAMBLE;
+	if (conf->use_short_slot) {
+		erp.slot_time = SHORT_SLOT_TIME;
+		erp.pifs = SHORT_PIFS;
+		erp.difs = SHORT_DIFS;
+		erp.ack_timeout += SHORT_DIFS;
 	} else {
-		ack_timeout += PREAMBLE;
-		ack_consume_time += PREAMBLE;
+		erp.slot_time = SLOT_TIME;
+		erp.pifs = PIFS;
+		erp.difs = DIFS;
+		erp.ack_timeout += DIFS;
 	}
 
-	retval = rt2x00dev->ops->lib->config_preamble(rt2x00dev,
-						      short_preamble,
-						      ack_timeout,
-						      ack_consume_time);
+	if (conf->use_short_preamble) {
+		erp.ack_timeout += SHORT_PREAMBLE;
+		erp.ack_consume_time += SHORT_PREAMBLE;
+	} else {
+		erp.ack_timeout += PREAMBLE;
+		erp.ack_consume_time += PREAMBLE;
+	}
+
+	retval = rt2x00dev->ops->lib->config_erp(rt2x00dev, &erp);
 
 	spin_lock(&intf->lock);
 
 	if (retval) {
-		intf->delayed_flags |= DELAYED_CONFIG_PREAMBLE;
+		intf->delayed_flags |= DELAYED_CONFIG_ERP;
 		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
 	}
 
 	spin_unlock(&intf->lock);
-
-
 }
 
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
@@ -169,7 +175,6 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	struct antenna_setup *default_ant = &rt2x00dev->default_ant;
 	struct antenna_setup *active_ant = &rt2x00dev->link.ant.active;
 	int flags = 0;
-	int short_slot_time;
 
 	/*
 	 * In some situations we want to force all configurations
@@ -229,7 +234,6 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	 * The following configuration options are never
 	 * stored anywhere and will always be updated.
 	 */
-	flags |= CONFIG_UPDATE_SLOT_TIME;
 	flags |= CONFIG_UPDATE_BEACON_INT;
 
 	/*
@@ -287,17 +291,6 @@ config:
 			libconf.ant.tx = ANTENNA_B;
 	}
 
-	if (flags & CONFIG_UPDATE_SLOT_TIME) {
-		short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
-
-		libconf.slot_time =
-		    short_slot_time ? SHORT_SLOT_TIME : SLOT_TIME;
-		libconf.sifs = SIFS;
-		libconf.pifs = short_slot_time ? SHORT_PIFS : PIFS;
-		libconf.difs = short_slot_time ? SHORT_DIFS : DIFS;
-		libconf.eifs = EIFS;
-	}
-
 	libconf.conf = conf;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index fe98776..1c0ab08 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -512,9 +512,8 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
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
index 54191d1..8472ac5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -53,9 +53,9 @@ void rt2x00lib_stop(struct rt2x00_dev *rt2x00dev);
 void rt2x00lib_config_mac_addr(struct rt2x00_dev *rt2x00dev, u8 *mac);
 void rt2x00lib_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid);
 void rt2x00lib_config_type(struct rt2x00_dev *rt2x00dev, const int type);
-void rt2x00lib_config_preamble(struct rt2x00_dev *rt2x00dev,
-				struct rt2x00_intf *intf,
-				const unsigned int short_preamble);
+void rt2x00lib_config_erp(struct rt2x00_dev *rt2x00dev,
+			  struct rt2x00_intf *intf,
+			  struct ieee80211_bss_conf *conf);
 void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 			      enum antenna rx, enum antenna tx);
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4d02a7f..95940d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -354,17 +354,16 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	/*
-	 * When the preamble mode has changed, we should perform additional
-	 * configuration steps. For all other changes we are already done.
+	 * When the preamble or slot time has changed, we should perform
+	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & BSS_CHANGED_ERP_PREAMBLE) {
-		rt2x00lib_config_preamble(rt2x00dev, intf,
-					  bss_conf->use_short_preamble);
+	if (changes & BSS_CHANGED_ERP_PREAMBLE ||
+	    changes & BSS_CHANGED_ERP_SLOT)
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
index 3e016ce..e4341a4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -376,20 +376,28 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static int rt61pci_config_preamble(struct rt2x00_dev *rt2x00dev,
-				   const int short_preamble,
-				   const int ack_timeout,
-				   const int ack_consume_time)
+static int rt61pci_config_erp(struct rt2x00_dev *rt2x00dev,
+			      struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
+
+	rt2x00pci_register_read(rt2x00dev, MAC_CSR8, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
+	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
+	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
+	rt2x00pci_register_write(rt2x00dev, MAC_CSR8, reg);
+
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
@@ -696,16 +704,6 @@ static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR9, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, libconf->slot_time);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR9, reg);
-
-	rt2x00pci_register_read(rt2x00dev, MAC_CSR8, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, libconf->sifs);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
-	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, libconf->eifs);
-	rt2x00pci_register_write(rt2x00dev, MAC_CSR8, reg);
-
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR0, reg);
@@ -733,7 +731,7 @@ static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
 		rt61pci_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt61pci_config_antenna(rt2x00dev, &libconf->ant);
-	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
+	if (flags & CONFIG_UPDATE_BEACON_INT)
 		rt61pci_config_duration(rt2x00dev, libconf);
 }
 
@@ -2472,7 +2470,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.config_mac_addr	= rt61pci_config_mac_addr,
 	.config_bssid		= rt61pci_config_bssid,
 	.config_type		= rt61pci_config_type,
-	.config_preamble	= rt61pci_config_preamble,
+	.config_erp		= rt61pci_config_erp,
 	.config			= rt61pci_config,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index fe1506a..82dae19 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -381,10 +381,8 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev, const int type,
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static int rt73usb_config_preamble(struct rt2x00_dev *rt2x00dev,
-				   const int short_preamble,
-				   const int ack_timeout,
-				   const int ack_consume_time)
+static int rt73usb_config_erp(struct rt2x00_dev *rt2x00dev,
+			      struct rt2x00lib_erp *erp)
 {
 	u32 reg;
 
@@ -395,13 +393,23 @@ static int rt73usb_config_preamble(struct rt2x00_dev *rt2x00dev,
 	if (in_atomic())
 		return -EAGAIN;
 
+	rt73usb_register_read(rt2x00dev, MAC_CSR9, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, erp->slot_time);
+	rt73usb_register_write(rt2x00dev, MAC_CSR9, reg);
+
+	rt73usb_register_read(rt2x00dev, MAC_CSR8, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, erp->sifs);
+	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
+	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, erp->eifs);
+	rt73usb_register_write(rt2x00dev, MAC_CSR8, reg);
+
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
@@ -639,16 +647,6 @@ static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg;
 
-	rt73usb_register_read(rt2x00dev, MAC_CSR9, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR9_SLOT_TIME, libconf->slot_time);
-	rt73usb_register_write(rt2x00dev, MAC_CSR9, reg);
-
-	rt73usb_register_read(rt2x00dev, MAC_CSR8, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS, libconf->sifs);
-	rt2x00_set_field32(&reg, MAC_CSR8_SIFS_AFTER_RX_OFDM, 3);
-	rt2x00_set_field32(&reg, MAC_CSR8_EIFS, libconf->eifs);
-	rt73usb_register_write(rt2x00dev, MAC_CSR8, reg);
-
 	rt73usb_register_read(rt2x00dev, TXRX_CSR0, &reg);
 	rt2x00_set_field32(&reg, TXRX_CSR0_TSF_OFFSET, IEEE80211_HEADER);
 	rt73usb_register_write(rt2x00dev, TXRX_CSR0, reg);
@@ -676,7 +674,7 @@ static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
 		rt73usb_config_txpower(rt2x00dev, libconf->conf->power_level);
 	if (flags & CONFIG_UPDATE_ANTENNA)
 		rt73usb_config_antenna(rt2x00dev, &libconf->ant);
-	if (flags & (CONFIG_UPDATE_SLOT_TIME | CONFIG_UPDATE_BEACON_INT))
+	if (flags & CONFIG_UPDATE_BEACON_INT)
 		rt73usb_config_duration(rt2x00dev, libconf);
 }
 
@@ -2054,7 +2052,7 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.config_mac_addr	= rt73usb_config_mac_addr,
 	.config_bssid		= rt73usb_config_bssid,
 	.config_type		= rt73usb_config_type,
-	.config_preamble	= rt73usb_config_preamble,
+	.config_erp		= rt73usb_config_erp,
 	.config			= rt73usb_config,
 };
 
