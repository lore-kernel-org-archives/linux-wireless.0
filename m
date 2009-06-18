Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbZFRWWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:52 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:54 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 21/23] orinoco: convert scanning to cfg80211
Date: Thu, 18 Jun 2009 23:21:33 +0100
Message-Id: <1245363695-8289-22-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the custom scan cache used by orinoco.

We also have to avoid calling cfg80211_scan_done from the hard
interrupt, so we offload the entirety of scan processing to a workqueue.

This may behave strangely if you start scanning just prior to
suspending...

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c     |   20 ++
 drivers/net/wireless/orinoco/hermes.h  |    2 +-
 drivers/net/wireless/orinoco/hw.c      |   85 ++++++
 drivers/net/wireless/orinoco/hw.h      |    3 +
 drivers/net/wireless/orinoco/main.c    |  167 +++++++----
 drivers/net/wireless/orinoco/orinoco.h |   22 +--
 drivers/net/wireless/orinoco/scan.c    |  285 +++++++++---------
 drivers/net/wireless/orinoco/scan.h    |   21 +-
 drivers/net/wireless/orinoco/wext.c    |  517 +-------------------------------
 9 files changed, 378 insertions(+), 744 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 9e59d90..1a87d3a 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -137,6 +137,26 @@ static int orinoco_change_vif(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
+static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
+			struct cfg80211_scan_request *request)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int err;
+
+	if (!request)
+		return -EINVAL;
+
+	if (priv->scan_request && priv->scan_request != request)
+		return -EBUSY;
+
+	priv->scan_request = request;
+
+	err = orinoco_hw_trigger_scan(priv, request->ssids);
+
+	return err;
+}
+
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
+	.scan = orinoco_scan,
 };
diff --git a/drivers/net/wireless/orinoco/hermes.h b/drivers/net/wireless/orinoco/hermes.h
index c78c442..2dddbb5 100644
--- a/drivers/net/wireless/orinoco/hermes.h
+++ b/drivers/net/wireless/orinoco/hermes.h
@@ -342,7 +342,7 @@ struct agere_ext_scan_info {
 	__le64	timestamp;
 	__le16	beacon_interval;
 	__le16	capabilities;
-	u8	data[316];
+	u8	data[0];
 } __attribute__ ((packed));
 
 #define HERMES_LINKSTATUS_NOT_CONNECTED   (0x0000)
diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index 4600fe4..fa508af 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -1157,3 +1157,88 @@ int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 
 	return 0;
 }
+
+int orinoco_hw_trigger_scan(struct orinoco_private *priv,
+			    const struct cfg80211_ssid *ssid)
+{
+	struct net_device *dev = priv->ndev;
+	hermes_t *hw = &priv->hw;
+	unsigned long flags;
+	int err = 0;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	/* Scanning with port 0 disabled would fail */
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	/* In monitor mode, the scan results are always empty.
+	 * Probe responses are passed to the driver as received
+	 * frames and could be processed in software. */
+	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (priv->has_hostscan) {
+		switch (priv->firmware_type) {
+		case FIRMWARE_TYPE_SYMBOL:
+			err = hermes_write_wordrec(hw, USER_BAP,
+						HERMES_RID_CNFHOSTSCAN_SYMBOL,
+						HERMES_HOSTSCAN_SYMBOL_ONCE |
+						HERMES_HOSTSCAN_SYMBOL_BCAST);
+			break;
+		case FIRMWARE_TYPE_INTERSIL: {
+			__le16 req[3];
+
+			req[0] = cpu_to_le16(0x3fff);	/* All channels */
+			req[1] = cpu_to_le16(0x0001);	/* rate 1 Mbps */
+			req[2] = 0;			/* Any ESSID */
+			err = HERMES_WRITE_RECORD(hw, USER_BAP,
+						  HERMES_RID_CNFHOSTSCAN, &req);
+			break;
+		}
+		case FIRMWARE_TYPE_AGERE:
+			if (ssid->ssid_len > 0) {
+				struct hermes_idstring idbuf;
+				size_t len = ssid->ssid_len;
+
+				idbuf.len = cpu_to_le16(len);
+				memcpy(idbuf.val, ssid->ssid, len);
+
+				err = hermes_write_ltv(hw, USER_BAP,
+					       HERMES_RID_CNFSCANSSID_AGERE,
+					       HERMES_BYTES_TO_RECLEN(len + 2),
+					       &idbuf);
+			} else
+				err = hermes_write_wordrec(hw, USER_BAP,
+						   HERMES_RID_CNFSCANSSID_AGERE,
+						   0);	/* Any ESSID */
+			if (err)
+				break;
+
+			if (priv->has_ext_scan) {
+				err = hermes_write_wordrec(hw, USER_BAP,
+						HERMES_RID_CNFSCANCHANNELS2GHZ,
+						0x7FFF);
+				if (err)
+					goto out;
+
+				err = hermes_inquire(hw,
+						     HERMES_INQ_CHANNELINFO);
+			} else
+				err = hermes_inquire(hw, HERMES_INQ_SCAN);
+
+			break;
+		}
+	} else
+		err = hermes_inquire(hw, HERMES_INQ_SCAN);
+
+ out:
+	orinoco_unlock(priv, &flags);
+
+	return err;
+}
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 210c2b1..27b4276 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/wireless.h>
+#include <net/cfg80211.h>
 
 /* Hardware BAPs */
 #define USER_BAP 0
@@ -47,5 +48,7 @@ int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
 int orinoco_hw_get_freq(struct orinoco_private *priv);
 int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 			       int *numrates, s32 *rates, int max);
+int orinoco_hw_trigger_scan(struct orinoco_private *priv,
+			    const struct cfg80211_ssid *ssid);
 
 #endif /* _ORINOCO_HW_H_ */
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index ebf92ae..90e2d32 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -206,6 +206,13 @@ struct orinoco_rx_data {
 	struct list_head list;
 };
 
+struct orinoco_scan_data {
+	void *buf;
+	size_t len;
+	int type;
+	struct list_head list;
+};
+
 /********************************************************************/
 /* Function prototypes                                              */
 /********************************************************************/
@@ -1265,6 +1272,78 @@ static void orinoco_send_wevents(struct work_struct *work)
 	orinoco_unlock(priv, &flags);
 }
 
+static void qbuf_scan(struct orinoco_private *priv, void *buf,
+		      int len, int type)
+{
+	struct orinoco_scan_data *sd;
+	unsigned long flags;
+
+	sd = kmalloc(sizeof(*sd), GFP_ATOMIC);
+	sd->buf = buf;
+	sd->len = len;
+	sd->type = type;
+
+	spin_lock_irqsave(priv->scan_lock, flags);
+	list_add_tail(&sd->list, &priv->scan_list);
+	spin_unlock_irqrestore(priv->scan_lock, flags);
+
+	schedule_work(&priv->process_scan);
+}
+
+static void qabort_scan(struct orinoco_private *priv)
+{
+	struct orinoco_scan_data *sd;
+	unsigned long flags;
+
+	sd = kmalloc(sizeof(*sd), GFP_ATOMIC);
+	sd->len = -1; /* Abort */
+
+	spin_lock_irqsave(priv->scan_lock, flags);
+	list_add_tail(&sd->list, &priv->scan_list);
+	spin_unlock_irqrestore(priv->scan_lock, flags);
+
+	schedule_work(&priv->process_scan);
+}
+
+static void orinoco_process_scan_results(struct work_struct *work)
+{
+	struct orinoco_private *priv =
+		container_of(work, struct orinoco_private, process_scan);
+	struct orinoco_scan_data *sd, *temp;
+	unsigned long flags;
+	void *buf;
+	int len;
+	int type;
+
+	spin_lock_irqsave(priv->scan_lock, flags);
+	list_for_each_entry_safe(sd, temp, &priv->scan_list, list) {
+		spin_unlock_irqrestore(priv->scan_lock, flags);
+
+		buf = sd->buf;
+		len = sd->len;
+		type = sd->type;
+
+		list_del(&sd->list);
+		kfree(sd);
+
+		if (len > 0) {
+			if (type == HERMES_INQ_CHANNELINFO)
+				orinoco_add_extscan_result(priv, buf, len);
+			else
+				orinoco_add_hostscan_results(priv, buf, len);
+
+			kfree(buf);
+		} else if (priv->scan_request) {
+			/* Either abort or complete the scan */
+			cfg80211_scan_done(priv->scan_request, (len < 0));
+			priv->scan_request = NULL;
+		}
+
+		spin_lock_irqsave(priv->scan_lock, flags);
+	}
+	spin_unlock_irqrestore(priv->scan_lock, flags);
+}
+
 static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1351,7 +1430,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		 * the hostscan frame can be requested.  */
 		if (newstatus == HERMES_LINKSTATUS_AP_OUT_OF_RANGE &&
 		    priv->firmware_type == FIRMWARE_TYPE_SYMBOL &&
-		    priv->has_hostscan && priv->scan_inprogress) {
+		    priv->has_hostscan && priv->scan_request) {
 			hermes_inquire(hw, HERMES_INQ_HOSTSCAN_SYMBOL);
 			break;
 		}
@@ -1377,7 +1456,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 	}
 	break;
 	case HERMES_INQ_SCAN:
-		if (!priv->scan_inprogress && priv->bssid_fixed &&
+		if (!priv->scan_request && priv->bssid_fixed &&
 		    priv->firmware_type == FIRMWARE_TYPE_INTERSIL) {
 			schedule_work(&priv->join_work);
 			break;
@@ -1387,30 +1466,30 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 	case HERMES_INQ_HOSTSCAN_SYMBOL: {
 		/* Result of a scanning. Contains information about
 		 * cells in the vicinity - Jean II */
-		union iwreq_data	wrqu;
 		unsigned char *buf;
 
-		/* Scan is no longer in progress */
-		priv->scan_inprogress = 0;
-
 		/* Sanity check */
 		if (len > 4096) {
 			printk(KERN_WARNING "%s: Scan results too large (%d bytes)\n",
 			       dev->name, len);
+			qabort_scan(priv);
 			break;
 		}
 
 		/* Allocate buffer for results */
 		buf = kmalloc(len, GFP_ATOMIC);
-		if (buf == NULL)
+		if (buf == NULL) {
 			/* No memory, so can't printk()... */
+			qabort_scan(priv);
 			break;
+		}
 
 		/* Read scan data */
 		err = hermes_bap_pread(hw, IRQ_BAP, (void *) buf, len,
 				       infofid, sizeof(info));
 		if (err) {
 			kfree(buf);
+			qabort_scan(priv);
 			break;
 		}
 
@@ -1424,24 +1503,14 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		}
 #endif	/* ORINOCO_DEBUG */
 
-		if (orinoco_process_scan_results(priv, buf, len) == 0) {
-			/* Send an empty event to user space.
-			 * We don't send the received data on the event because
-			 * it would require us to do complex transcoding, and
-			 * we want to minimise the work done in the irq handler
-			 * Use a request to extract the data - Jean II */
-			wrqu.data.length = 0;
-			wrqu.data.flags = 0;
-			wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
-		}
-		kfree(buf);
+		qbuf_scan(priv, buf, len, type);
 	}
 	break;
 	case HERMES_INQ_CHANNELINFO:
 	{
 		struct agere_ext_scan_info *bss;
 
-		if (!priv->scan_inprogress) {
+		if (!priv->scan_request) {
 			printk(KERN_DEBUG "%s: Got chaninfo without scan, "
 			       "len=%d\n", dev->name, len);
 			break;
@@ -1449,25 +1518,12 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 
 		/* An empty result indicates that the scan is complete */
 		if (len == 0) {
-			union iwreq_data	wrqu;
-
-			/* Scan is no longer in progress */
-			priv->scan_inprogress = 0;
-
-			wrqu.data.length = 0;
-			wrqu.data.flags = 0;
-			wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+			qbuf_scan(priv, NULL, len, type);
 			break;
 		}
 
 		/* Sanity check */
-		else if (len > sizeof(*bss)) {
-			printk(KERN_WARNING
-			       "%s: Ext scan results too large (%d bytes). "
-			       "Truncating results to %zd bytes.\n",
-			       dev->name, len, sizeof(*bss));
-			len = sizeof(*bss);
-		} else if (len < (offsetof(struct agere_ext_scan_info,
+		else if (len < (offsetof(struct agere_ext_scan_info,
 					   data) + 2)) {
 			/* Drop this result now so we don't have to
 			 * keep checking later */
@@ -1477,21 +1533,18 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 			break;
 		}
 
-		bss = kmalloc(sizeof(*bss), GFP_ATOMIC);
+		bss = kmalloc(len, GFP_ATOMIC);
 		if (bss == NULL)
 			break;
 
 		/* Read scan data */
 		err = hermes_bap_pread(hw, IRQ_BAP, (void *) bss, len,
 				       infofid, sizeof(info));
-		if (err) {
+		if (err)
 			kfree(bss);
-			break;
-		}
-
-		orinoco_add_ext_scan_result(priv, bss);
+		else
+			qbuf_scan(priv, bss, len, type);
 
-		kfree(bss);
 		break;
 	}
 	case HERMES_INQ_SEC_STAT_AGERE:
@@ -1506,6 +1559,8 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		/* We don't actually do anything about it */
 		break;
 	}
+
+	return;
 }
 
 static void __orinoco_ev_infdrop(struct net_device *dev, hermes_t *hw)
@@ -1649,9 +1704,11 @@ void orinoco_reset(struct work_struct *work)
 
 	orinoco_unlock(priv, &flags);
 
-	/* Scanning support: Cleanup of driver struct */
-	orinoco_clear_scan_results(priv, 0);
-	priv->scan_inprogress = 0;
+	/* Scanning support: Notify scan cancellation */
+	if (priv->scan_request) {
+		cfg80211_scan_done(priv->scan_request, 1);
+		priv->scan_request = NULL;
+	}
 
 	if (priv->hard_reset) {
 		err = (*priv->hard_reset)(priv);
@@ -1965,12 +2022,6 @@ int orinoco_init(struct orinoco_private *priv)
 		}
 	}
 
-	/* Now we have the firmware capabilities, allocate appropiate
-	 * sized scan buffers */
-	if (orinoco_bss_data_allocate(priv))
-		goto out;
-	orinoco_bss_data_init(priv);
-
 	err = orinoco_hw_read_card_settings(priv, wiphy->perm_addr);
 	if (err)
 		goto out;
@@ -2100,6 +2151,10 @@ struct orinoco_private
 	tasklet_init(&priv->rx_tasklet, orinoco_rx_isr_tasklet,
 		     (unsigned long) priv);
 
+	spin_lock_init(&priv->scan_lock);
+	INIT_LIST_HEAD(&priv->scan_list);
+	INIT_WORK(&priv->process_scan, orinoco_process_scan_results);
+
 	priv->last_linkstatus = 0xffff;
 
 #if defined(CONFIG_HERMES_CACHE_FW_ON_INIT) || defined(CONFIG_PM_SLEEP)
@@ -2192,6 +2247,7 @@ void free_orinocodev(struct orinoco_private *priv)
 {
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct orinoco_rx_data *rx_data, *temp;
+	struct orinoco_scan_data *sd, *sdtemp;
 
 	wiphy_unregister(wiphy);
 
@@ -2209,13 +2265,22 @@ void free_orinocodev(struct orinoco_private *priv)
 		kfree(rx_data);
 	}
 
+	cancel_work_sync(&priv->process_scan);
+	/* Explicitly drain priv->scan_list */
+	list_for_each_entry_safe(sd, sdtemp, &priv->scan_list, list) {
+		list_del(&sd->list);
+
+		if ((sd->len > 0) && sd->buf)
+			kfree(sd->buf);
+		kfree(sd);
+	}
+
 	orinoco_unregister_pm_notifier(priv);
 	orinoco_uncache_fw(priv);
 
 	priv->wpa_ie_len = 0;
 	kfree(priv->wpa_ie);
 	orinoco_mic_free(priv);
-	orinoco_bss_data_free(priv);
 	wiphy_free(wiphy);
 }
 EXPORT_SYMBOL(free_orinocodev);
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 0c89c28..5f4f5c9 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -48,18 +48,6 @@ typedef enum {
 	FIRMWARE_TYPE_SYMBOL
 } fwtype_t;
 
-struct bss_element {
-	union hermes_scan_info bss;
-	unsigned long last_scanned;
-	struct list_head list;
-};
-
-struct xbss_element {
-	struct agere_ext_scan_info bss;
-	unsigned long last_scanned;
-	struct list_head list;
-};
-
 struct firmware;
 
 struct orinoco_private {
@@ -145,12 +133,10 @@ struct orinoco_private {
 	int promiscuous, mc_count;
 
 	/* Scanning support */
-	struct list_head bss_list;
-	struct list_head bss_free_list;
-	void *bss_xbss_data;
-
-	int	scan_inprogress;	/* Scan pending... */
-	u32	scan_mode;		/* Type of scan done */
+	struct cfg80211_scan_request *scan_request;
+	struct work_struct process_scan;
+	struct list_head scan_list;
+	spinlock_t scan_lock; /* protects the scan list */
 
 	/* WPA support */
 	u8 *wpa_ie;
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index 89d699d..522eb98 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -5,147 +5,166 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/etherdevice.h>
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 
 #include "hermes.h"
 #include "orinoco.h"
+#include "main.h"
 
 #include "scan.h"
 
-#define ORINOCO_MAX_BSS_COUNT	64
+#define ZERO_DBM_OFFSET 0x95
+#define MAX_SIGNAL_LEVEL 0x8A
+#define MIN_SIGNAL_LEVEL 0x2F
 
-#define PRIV_BSS	((struct bss_element *)priv->bss_xbss_data)
-#define PRIV_XBSS	((struct xbss_element *)priv->bss_xbss_data)
+#define SIGNAL_TO_DBM(x)					\
+	(clamp_t(s32, (x), MIN_SIGNAL_LEVEL, MAX_SIGNAL_LEVEL)	\
+	 - ZERO_DBM_OFFSET)
+#define SIGNAL_TO_MBM(x) (SIGNAL_TO_DBM(x) * 100)
 
-int orinoco_bss_data_allocate(struct orinoco_private *priv)
+static int symbol_build_supp_rates(u8 *buf, const __le16 *rates)
 {
-	if (priv->bss_xbss_data)
-		return 0;
-
-	if (priv->has_ext_scan)
-		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
-					      sizeof(struct xbss_element),
-					      GFP_KERNEL);
-	else
-		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
-					      sizeof(struct bss_element),
-					      GFP_KERNEL);
-
-	if (!priv->bss_xbss_data) {
-		printk(KERN_WARNING "Out of memory allocating beacons");
-		return -ENOMEM;
+	int i;
+	u8 rate;
+
+	buf[0] = WLAN_EID_SUPP_RATES;
+	for (i = 0; i < 5; i++) {
+		rate = le16_to_cpu(rates[i]);
+		/* NULL terminated */
+		if (rate == 0x0)
+			break;
+		buf[i + 2] = rate;
 	}
-	return 0;
-}
+	buf[1] = i;
 
-void orinoco_bss_data_free(struct orinoco_private *priv)
-{
-	kfree(priv->bss_xbss_data);
-	priv->bss_xbss_data = NULL;
+	return i + 2;
 }
 
-void orinoco_bss_data_init(struct orinoco_private *priv)
+static int prism_build_supp_rates(u8 *buf, const u8 *rates)
 {
 	int i;
 
-	INIT_LIST_HEAD(&priv->bss_free_list);
-	INIT_LIST_HEAD(&priv->bss_list);
-	if (priv->has_ext_scan)
-		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
-			list_add_tail(&(PRIV_XBSS[i].list),
-				      &priv->bss_free_list);
-	else
-		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
-			list_add_tail(&(PRIV_BSS[i].list),
-				      &priv->bss_free_list);
-
-}
-
-void orinoco_clear_scan_results(struct orinoco_private *priv,
-				unsigned long scan_age)
-{
-	if (priv->has_ext_scan) {
-		struct xbss_element *bss;
-		struct xbss_element *tmp_bss;
-
-		/* Blow away current list of scan results */
-		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
-			if (!scan_age ||
-			    time_after(jiffies, bss->last_scanned + scan_age)) {
-				list_move_tail(&bss->list,
-					       &priv->bss_free_list);
-				/* Don't blow away ->list, just BSS data */
-				memset(&bss->bss, 0, sizeof(bss->bss));
-				bss->last_scanned = 0;
-			}
-		}
-	} else {
-		struct bss_element *bss;
-		struct bss_element *tmp_bss;
-
-		/* Blow away current list of scan results */
-		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
-			if (!scan_age ||
-			    time_after(jiffies, bss->last_scanned + scan_age)) {
-				list_move_tail(&bss->list,
-					       &priv->bss_free_list);
-				/* Don't blow away ->list, just BSS data */
-				memset(&bss->bss, 0, sizeof(bss->bss));
-				bss->last_scanned = 0;
-			}
+	buf[0] = WLAN_EID_SUPP_RATES;
+	for (i = 0; i < 8; i++) {
+		/* NULL terminated */
+		if (rates[i] == 0x0)
+			break;
+		buf[i + 2] = rates[i];
+	}
+	buf[1] = i;
+
+	/* We might still have another 2 rates, which need to go in
+	 * extended supported rates */
+	if (i == 8 && rates[i] > 0) {
+		buf[10] = WLAN_EID_EXT_SUPP_RATES;
+		for (; i < 10; i++) {
+			/* NULL terminated */
+			if (rates[i] == 0x0)
+				break;
+			buf[i + 2] = rates[i];
 		}
+		buf[11] = i - 8;
 	}
+
+	return (i < 8) ? i + 2 : i + 4;
 }
 
-void orinoco_add_ext_scan_result(struct orinoco_private *priv,
-				 struct agere_ext_scan_info *atom)
+static void orinoco_add_hostscan_result(struct orinoco_private *priv,
+					const union hermes_scan_info *bss)
 {
-	struct xbss_element *bss = NULL;
-	int found = 0;
-
-	/* Try to update an existing bss first */
-	list_for_each_entry(bss, &priv->bss_list, list) {
-		if (compare_ether_addr(bss->bss.bssid, atom->bssid))
-			continue;
-		/* ESSID lengths */
-		if (bss->bss.data[1] != atom->data[1])
-			continue;
-		if (memcmp(&bss->bss.data[2], &atom->data[2],
-			   atom->data[1]))
-			continue;
-		found = 1;
+	struct wiphy *wiphy = priv_to_wiphy(priv);
+	struct ieee80211_channel *channel;
+	u8 *ie;
+	u8 ie_buf[46];
+	u64 timestamp;
+	s32 signal;
+	u16 capability;
+	u16 beacon_interval;
+	int ie_len;
+	int freq;
+	int len;
+
+	len = le16_to_cpu(bss->a.essid_len);
+
+	/* Reconstruct SSID and bitrate IEs to pass up */
+	ie_buf[0] = WLAN_EID_SSID;
+	ie_buf[1] = len;
+	memcpy(&ie_buf[2], bss->a.essid, len);
+
+	ie = ie_buf + len + 2;
+	ie_len = ie_buf[1] + 2;
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_SYMBOL:
+		ie_len += symbol_build_supp_rates(ie, bss->s.rates);
 		break;
-	}
 
-	/* Grab a bss off the free list */
-	if (!found && !list_empty(&priv->bss_free_list)) {
-		bss = list_entry(priv->bss_free_list.next,
-				 struct xbss_element, list);
-		list_del(priv->bss_free_list.next);
+	case FIRMWARE_TYPE_INTERSIL:
+		ie_len += prism_build_supp_rates(ie, bss->p.rates);
+		break;
 
-		list_add_tail(&bss->list, &priv->bss_list);
+	case FIRMWARE_TYPE_AGERE:
+	default:
+		break;
 	}
 
-	if (bss) {
-		/* Always update the BSS to get latest beacon info */
-		memcpy(&bss->bss, atom, sizeof(bss->bss));
-		bss->last_scanned = jiffies;
-	}
+	freq = ieee80211_dsss_chan_to_freq(le16_to_cpu(bss->a.channel));
+	channel = ieee80211_get_channel(wiphy, freq);
+	timestamp = 0;
+	capability = le16_to_cpu(bss->a.capabilities);
+	beacon_interval = le16_to_cpu(bss->a.beacon_interv);
+	signal = SIGNAL_TO_MBM(le16_to_cpu(bss->a.level));
+
+	cfg80211_inform_bss(wiphy, channel, bss->a.bssid, timestamp,
+			    capability, beacon_interval, ie_buf, ie_len,
+			    signal, GFP_KERNEL);
 }
 
-int orinoco_process_scan_results(struct orinoco_private *priv,
-				 unsigned char *buf,
-				 int len)
+void orinoco_add_extscan_result(struct orinoco_private *priv,
+				struct agere_ext_scan_info *bss,
+				size_t len)
 {
-	int			offset;		/* In the scan data */
-	union hermes_scan_info *atom;
-	int			atom_len;
+	struct wiphy *wiphy = priv_to_wiphy(priv);
+	struct ieee80211_channel *channel;
+	u8 *ie;
+	u64 timestamp;
+	s32 signal;
+	u16 capability;
+	u16 beacon_interval;
+	size_t ie_len;
+	int chan, freq;
+
+	ie_len = len - sizeof(*bss);
+	ie = orinoco_get_ie(bss->data, ie_len, WLAN_EID_DS_PARAMS);
+	chan = ie ? ie[2] : 0;
+	freq = ieee80211_dsss_chan_to_freq(chan);
+	channel = ieee80211_get_channel(wiphy, freq);
+
+	timestamp = le64_to_cpu(bss->timestamp);
+	capability = le16_to_cpu(bss->capabilities);
+	beacon_interval = le16_to_cpu(bss->beacon_interval);
+	ie = bss->data;
+	signal = SIGNAL_TO_MBM(bss->level);
+
+	cfg80211_inform_bss(wiphy, channel, bss->bssid, timestamp,
+			    capability, beacon_interval, ie, ie_len,
+			    signal, GFP_KERNEL);
+}
+
+void orinoco_add_hostscan_results(struct orinoco_private *priv,
+				  unsigned char *buf,
+				  size_t len)
+{
+	int offset;		/* In the scan data */
+	size_t atom_len;
+	bool abort = false;
 
 	switch (priv->firmware_type) {
 	case FIRMWARE_TYPE_AGERE:
 		atom_len = sizeof(struct agere_scan_apinfo);
 		offset = 0;
 		break;
+
 	case FIRMWARE_TYPE_SYMBOL:
 		/* Lack of documentation necessitates this hack.
 		 * Different firmwares have 68 or 76 byte long atoms.
@@ -163,6 +182,7 @@ int orinoco_process_scan_results(struct orinoco_private *priv,
 			atom_len = 68;
 		offset = 0;
 		break;
+
 	case FIRMWARE_TYPE_INTERSIL:
 		offset = 4;
 		if (priv->has_hostscan) {
@@ -172,13 +192,16 @@ int orinoco_process_scan_results(struct orinoco_private *priv,
 				printk(KERN_ERR "%s: Invalid atom_len in scan "
 				       "data: %d\n", priv->ndev->name,
 				       atom_len);
-				return -EIO;
+				abort = true;
+				goto scan_abort;
 			}
 		} else
 			atom_len = offsetof(struct prism2_scan_apinfo, atim);
 		break;
+
 	default:
-		return -EOPNOTSUPP;
+		abort = true;
+		goto scan_abort;
 	}
 
 	/* Check that we got an whole number of atoms */
@@ -186,48 +209,22 @@ int orinoco_process_scan_results(struct orinoco_private *priv,
 		printk(KERN_ERR "%s: Unexpected scan data length %d, "
 		       "atom_len %d, offset %d\n", priv->ndev->name, len,
 		       atom_len, offset);
-		return -EIO;
+		abort = true;
+		goto scan_abort;
 	}
 
-	orinoco_clear_scan_results(priv, msecs_to_jiffies(15000));
-
-	/* Read the entries one by one */
+	/* Process the entries one by one */
 	for (; offset + atom_len <= len; offset += atom_len) {
-		int found = 0;
-		struct bss_element *bss = NULL;
+		union hermes_scan_info *atom;
 
-		/* Get next atom */
 		atom = (union hermes_scan_info *) (buf + offset);
 
-		/* Try to update an existing bss first */
-		list_for_each_entry(bss, &priv->bss_list, list) {
-			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
-				continue;
-			if (le16_to_cpu(bss->bss.a.essid_len) !=
-			      le16_to_cpu(atom->a.essid_len))
-				continue;
-			if (memcmp(bss->bss.a.essid, atom->a.essid,
-			      le16_to_cpu(atom->a.essid_len)))
-				continue;
-			found = 1;
-			break;
-		}
-
-		/* Grab a bss off the free list */
-		if (!found && !list_empty(&priv->bss_free_list)) {
-			bss = list_entry(priv->bss_free_list.next,
-					 struct bss_element, list);
-			list_del(priv->bss_free_list.next);
-
-			list_add_tail(&bss->list, &priv->bss_list);
-		}
-
-		if (bss) {
-			/* Always update the BSS to get latest beacon info */
-			memcpy(&bss->bss, atom, sizeof(bss->bss));
-			bss->last_scanned = jiffies;
-		}
+		orinoco_add_hostscan_result(priv, atom);
 	}
 
-	return 0;
+ scan_abort:
+	if (priv->scan_request) {
+		cfg80211_scan_done(priv->scan_request, abort);
+		priv->scan_request = NULL;
+	}
 }
diff --git a/drivers/net/wireless/orinoco/scan.h b/drivers/net/wireless/orinoco/scan.h
index f319f74..2dc4e04 100644
--- a/drivers/net/wireless/orinoco/scan.h
+++ b/drivers/net/wireless/orinoco/scan.h
@@ -9,21 +9,12 @@
 struct orinoco_private;
 struct agere_ext_scan_info;
 
-/* Setup and free memory for scan results */
-int orinoco_bss_data_allocate(struct orinoco_private *priv);
-void orinoco_bss_data_free(struct orinoco_private *priv);
-void orinoco_bss_data_init(struct orinoco_private *priv);
-
 /* Add scan results */
-void orinoco_add_ext_scan_result(struct orinoco_private *priv,
-				 struct agere_ext_scan_info *atom);
-int orinoco_process_scan_results(struct orinoco_private *dev,
-				 unsigned char *buf,
-				 int len);
-
-/* Clear scan results */
-void orinoco_clear_scan_results(struct orinoco_private *priv,
-				unsigned long scan_age);
-
+void orinoco_add_extscan_result(struct orinoco_private *priv,
+				struct agere_ext_scan_info *atom,
+				size_t len);
+void orinoco_add_hostscan_results(struct orinoco_private *dev,
+				  unsigned char *buf,
+				  size_t len);
 
 #endif /* _ORINOCO_SCAN_H_ */
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 9cd991a..082ea0a 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1583,519 +1583,6 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 	return err;
 }
 
-/* Trigger a scan (look for other cells in the vicinity) */
-static int orinoco_ioctl_setscan(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *srq,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	struct iw_scan_req *si = (struct iw_scan_req *) extra;
-	int err = 0;
-	unsigned long flags;
-
-	/* Note : you may have realised that, as this is a SET operation,
-	 * this is privileged and therefore a normal user can't
-	 * perform scanning.
-	 * This is not an error, while the device perform scanning,
-	 * traffic doesn't flow, so it's a perfect DoS...
-	 * Jean II */
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* Scanning with port 0 disabled would fail */
-	if (!netif_running(dev)) {
-		err = -ENETDOWN;
-		goto out;
-	}
-
-	/* In monitor mode, the scan results are always empty.
-	 * Probe responses are passed to the driver as received
-	 * frames and could be processed in software. */
-	if (priv->iw_mode == NL80211_IFTYPE_MONITOR) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* Note : because we don't lock out the irq handler, the way
-	 * we access scan variables in priv is critical.
-	 *	o scan_inprogress : not touched by irq handler
-	 *	o scan_mode : not touched by irq handler
-	 * Before modifying anything on those variables, please think hard !
-	 * Jean II */
-
-	/* Save flags */
-	priv->scan_mode = srq->flags;
-
-	/* Always trigger scanning, even if it's in progress.
-	 * This way, if the info frame get lost, we will recover somewhat
-	 * gracefully  - Jean II */
-
-	if (priv->has_hostscan) {
-		switch (priv->firmware_type) {
-		case FIRMWARE_TYPE_SYMBOL:
-			err = hermes_write_wordrec(hw, USER_BAP,
-						HERMES_RID_CNFHOSTSCAN_SYMBOL,
-						HERMES_HOSTSCAN_SYMBOL_ONCE |
-						HERMES_HOSTSCAN_SYMBOL_BCAST);
-			break;
-		case FIRMWARE_TYPE_INTERSIL: {
-			__le16 req[3];
-
-			req[0] = cpu_to_le16(0x3fff);	/* All channels */
-			req[1] = cpu_to_le16(0x0001);	/* rate 1 Mbps */
-			req[2] = 0;			/* Any ESSID */
-			err = HERMES_WRITE_RECORD(hw, USER_BAP,
-						  HERMES_RID_CNFHOSTSCAN, &req);
-		}
-		break;
-		case FIRMWARE_TYPE_AGERE:
-			if (priv->scan_mode & IW_SCAN_THIS_ESSID) {
-				struct hermes_idstring idbuf;
-				size_t len = min(sizeof(idbuf.val),
-						 (size_t) si->essid_len);
-				idbuf.len = cpu_to_le16(len);
-				memcpy(idbuf.val, si->essid, len);
-
-				err = hermes_write_ltv(hw, USER_BAP,
-					       HERMES_RID_CNFSCANSSID_AGERE,
-					       HERMES_BYTES_TO_RECLEN(len + 2),
-					       &idbuf);
-			} else
-				err = hermes_write_wordrec(hw, USER_BAP,
-						   HERMES_RID_CNFSCANSSID_AGERE,
-						   0);	/* Any ESSID */
-			if (err)
-				break;
-
-			if (priv->has_ext_scan) {
-				/* Clear scan results at the start of
-				 * an extended scan */
-				orinoco_clear_scan_results(priv,
-						msecs_to_jiffies(15000));
-
-				/* TODO: Is this available on older firmware?
-				 *   Can we use it to scan specific channels
-				 *   for IW_SCAN_THIS_FREQ? */
-				err = hermes_write_wordrec(hw, USER_BAP,
-						HERMES_RID_CNFSCANCHANNELS2GHZ,
-						0x7FFF);
-				if (err)
-					goto out;
-
-				err = hermes_inquire(hw,
-						     HERMES_INQ_CHANNELINFO);
-			} else
-				err = hermes_inquire(hw, HERMES_INQ_SCAN);
-			break;
-		}
-	} else
-		err = hermes_inquire(hw, HERMES_INQ_SCAN);
-
-	/* One more client */
-	if (!err)
-		priv->scan_inprogress = 1;
-
- out:
-	orinoco_unlock(priv, &flags);
-	return err;
-}
-
-#define MAX_CUSTOM_LEN 64
-
-/* Translate scan data returned from the card to a card independant
- * format that the Wireless Tools will understand - Jean II */
-static inline char *orinoco_translate_scan(struct net_device *dev,
-					   struct iw_request_info *info,
-					   char *current_ev,
-					   char *end_buf,
-					   union hermes_scan_info *bss,
-					   unsigned long last_scanned)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	u16			capabilities;
-	u16			channel;
-	struct iw_event		iwe;		/* Temporary buffer */
-	char custom[MAX_CUSTOM_LEN];
-
-	memset(&iwe, 0, sizeof(iwe));
-
-	/* First entry *MUST* be the AP MAC address */
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bss->a.bssid, ETH_ALEN);
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-					  &iwe, IW_EV_ADDR_LEN);
-
-	/* Other entries will be displayed in the order we give them */
-
-	/* Add the ESSID */
-	iwe.u.data.length = le16_to_cpu(bss->a.essid_len);
-	if (iwe.u.data.length > 32)
-		iwe.u.data.length = 32;
-	iwe.cmd = SIOCGIWESSID;
-	iwe.u.data.flags = 1;
-	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, bss->a.essid);
-
-	/* Add mode */
-	iwe.cmd = SIOCGIWMODE;
-	capabilities = le16_to_cpu(bss->a.capabilities);
-	if (capabilities & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
-		if (capabilities & WLAN_CAPABILITY_ESS)
-			iwe.u.mode = IW_MODE_MASTER;
-		else
-			iwe.u.mode = IW_MODE_ADHOC;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_UINT_LEN);
-	}
-
-	channel = bss->s.channel;
-	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
-		/* Add channel and frequency */
-		iwe.cmd = SIOCGIWFREQ;
-		iwe.u.freq.m = channel;
-		iwe.u.freq.e = 0;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_FREQ_LEN);
-
-		iwe.u.freq.m = ieee80211_dsss_chan_to_freq(channel) * 100000;
-		iwe.u.freq.e = 1;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_FREQ_LEN);
-	}
-
-	/* Add quality statistics. level and noise in dB. No link quality */
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.updated = IW_QUAL_DBM | IW_QUAL_QUAL_INVALID;
-	iwe.u.qual.level = (__u8) le16_to_cpu(bss->a.level) - 0x95;
-	iwe.u.qual.noise = (__u8) le16_to_cpu(bss->a.noise) - 0x95;
-	/* Wireless tools prior to 27.pre22 will show link quality
-	 * anyway, so we provide a reasonable value. */
-	if (iwe.u.qual.level > iwe.u.qual.noise)
-		iwe.u.qual.qual = iwe.u.qual.level - iwe.u.qual.noise;
-	else
-		iwe.u.qual.qual = 0;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-					  &iwe, IW_EV_QUAL_LEN);
-
-	/* Add encryption capability */
-	iwe.cmd = SIOCGIWENCODE;
-	if (capabilities & WLAN_CAPABILITY_PRIVACY)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, NULL);
-
-	/* Bit rate is not available in Lucent/Agere firmwares */
-	if (priv->firmware_type != FIRMWARE_TYPE_AGERE) {
-		char *current_val = current_ev + iwe_stream_lcp_len(info);
-		int i;
-		int step;
-
-		if (priv->firmware_type == FIRMWARE_TYPE_SYMBOL)
-			step = 2;
-		else
-			step = 1;
-
-		iwe.cmd = SIOCGIWRATE;
-		/* Those two flags are ignored... */
-		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-		/* Max 10 values */
-		for (i = 0; i < 10; i += step) {
-			/* NULL terminated */
-			if (bss->p.rates[i] == 0x0)
-				break;
-			/* Bit rate given in 500 kb/s units (+ 0x80) */
-			iwe.u.bitrate.value =
-				((bss->p.rates[i] & 0x7f) * 500000);
-			current_val = iwe_stream_add_value(info, current_ev,
-							   current_val,
-							   end_buf, &iwe,
-							   IW_EV_PARAM_LEN);
-		}
-		/* Check if we added any event */
-		if ((current_val - current_ev) > iwe_stream_lcp_len(info))
-			current_ev = current_val;
-	}
-
-	/* Beacon interval */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     "bcn_int=%d",
-				     le16_to_cpu(bss->a.beacon_interv));
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	/* Capabilites */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     "capab=0x%04x",
-				     capabilities);
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	/* Add EXTRA: Age to display seconds since last beacon/probe response
-	 * for given network. */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     " Last beacon: %dms ago",
-				     jiffies_to_msecs(jiffies - last_scanned));
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	return current_ev;
-}
-
-static inline char *orinoco_translate_ext_scan(struct net_device *dev,
-					       struct iw_request_info *info,
-					       char *current_ev,
-					       char *end_buf,
-					       struct agere_ext_scan_info *bss,
-					       unsigned long last_scanned)
-{
-	u16			capabilities;
-	u16			channel;
-	struct iw_event		iwe;		/* Temporary buffer */
-	char custom[MAX_CUSTOM_LEN];
-	u8 *ie;
-
-	memset(&iwe, 0, sizeof(iwe));
-
-	/* First entry *MUST* be the AP MAC address */
-	iwe.cmd = SIOCGIWAP;
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	memcpy(iwe.u.ap_addr.sa_data, bss->bssid, ETH_ALEN);
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-					  &iwe, IW_EV_ADDR_LEN);
-
-	/* Other entries will be displayed in the order we give them */
-
-	/* Add the ESSID */
-	ie = bss->data;
-	iwe.u.data.length = ie[1];
-	if (iwe.u.data.length) {
-		if (iwe.u.data.length > 32)
-			iwe.u.data.length = 32;
-		iwe.cmd = SIOCGIWESSID;
-		iwe.u.data.flags = 1;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, &ie[2]);
-	}
-
-	/* Add mode */
-	capabilities = le16_to_cpu(bss->capabilities);
-	if (capabilities & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)) {
-		iwe.cmd = SIOCGIWMODE;
-		if (capabilities & WLAN_CAPABILITY_ESS)
-			iwe.u.mode = IW_MODE_MASTER;
-		else
-			iwe.u.mode = IW_MODE_ADHOC;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_UINT_LEN);
-	}
-
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_DS_PARAMS);
-	channel = ie ? ie[2] : 0;
-	if ((channel >= 1) && (channel <= NUM_CHANNELS)) {
-		/* Add channel and frequency */
-		iwe.cmd = SIOCGIWFREQ;
-		iwe.u.freq.m = channel;
-		iwe.u.freq.e = 0;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_FREQ_LEN);
-
-		iwe.u.freq.m = ieee80211_dsss_chan_to_freq(channel) * 100000;
-		iwe.u.freq.e = 1;
-		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-						  &iwe, IW_EV_FREQ_LEN);
-	}
-
-	/* Add quality statistics. level and noise in dB. No link quality */
-	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.updated = IW_QUAL_DBM | IW_QUAL_QUAL_INVALID;
-	iwe.u.qual.level = bss->level - 0x95;
-	iwe.u.qual.noise = bss->noise - 0x95;
-	/* Wireless tools prior to 27.pre22 will show link quality
-	 * anyway, so we provide a reasonable value. */
-	if (iwe.u.qual.level > iwe.u.qual.noise)
-		iwe.u.qual.qual = iwe.u.qual.level - iwe.u.qual.noise;
-	else
-		iwe.u.qual.qual = 0;
-	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
-					  &iwe, IW_EV_QUAL_LEN);
-
-	/* Add encryption capability */
-	iwe.cmd = SIOCGIWENCODE;
-	if (capabilities & WLAN_CAPABILITY_PRIVACY)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-					  &iwe, NULL);
-
-	/* WPA IE */
-	ie = orinoco_get_wpa_ie(bss->data, sizeof(bss->data));
-	if (ie) {
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = ie[1] + 2;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, ie);
-	}
-
-	/* RSN IE */
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_RSN);
-	if (ie) {
-		iwe.cmd = IWEVGENIE;
-		iwe.u.data.length = ie[1] + 2;
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, ie);
-	}
-
-	ie = orinoco_get_ie(bss->data, sizeof(bss->data), WLAN_EID_SUPP_RATES);
-	if (ie) {
-		char *p = current_ev + iwe_stream_lcp_len(info);
-		int i;
-
-		iwe.cmd = SIOCGIWRATE;
-		/* Those two flags are ignored... */
-		iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
-
-		for (i = 2; i < (ie[1] + 2); i++) {
-			iwe.u.bitrate.value = ((ie[i] & 0x7F) * 500000);
-			p = iwe_stream_add_value(info, current_ev, p, end_buf,
-						 &iwe, IW_EV_PARAM_LEN);
-		}
-		/* Check if we added any event */
-		if (p > (current_ev + iwe_stream_lcp_len(info)))
-			current_ev = p;
-	}
-
-	/* Timestamp */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length =
-		snprintf(custom, MAX_CUSTOM_LEN, "tsf=%016llx",
-			 (unsigned long long) le64_to_cpu(bss->timestamp));
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	/* Beacon interval */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     "bcn_int=%d",
-				     le16_to_cpu(bss->beacon_interval));
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	/* Capabilites */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     "capab=0x%04x",
-				     capabilities);
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	/* Add EXTRA: Age to display seconds since last beacon/probe response
-	 * for given network. */
-	iwe.cmd = IWEVCUSTOM;
-	iwe.u.data.length = snprintf(custom, MAX_CUSTOM_LEN,
-				     " Last beacon: %dms ago",
-				     jiffies_to_msecs(jiffies - last_scanned));
-	if (iwe.u.data.length)
-		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-						  &iwe, custom);
-
-	return current_ev;
-}
-
-/* Return results of a scan */
-static int orinoco_ioctl_getscan(struct net_device *dev,
-				 struct iw_request_info *info,
-				 struct iw_point *srq,
-				 char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int err = 0;
-	unsigned long flags;
-	char *current_ev = extra;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if (priv->scan_inprogress) {
-		/* Important note : we don't want to block the caller
-		 * until results are ready for various reasons.
-		 * First, managing wait queues is complex and racy.
-		 * Second, we grab some rtnetlink lock before comming
-		 * here (in dev_ioctl()).
-		 * Third, we generate an Wireless Event, so the
-		 * caller can wait itself on that - Jean II */
-		err = -EAGAIN;
-		goto out;
-	}
-
-	if (priv->has_ext_scan) {
-		struct xbss_element *bss;
-
-		list_for_each_entry(bss, &priv->bss_list, list) {
-			/* Translate this entry to WE format */
-			current_ev =
-				orinoco_translate_ext_scan(dev, info,
-							   current_ev,
-							   extra + srq->length,
-							   &bss->bss,
-							   bss->last_scanned);
-
-			/* Check if there is space for one more entry */
-			if ((extra + srq->length - current_ev)
-			    <= IW_EV_ADDR_LEN) {
-				/* Ask user space to try again with a
-				 * bigger buffer */
-				err = -E2BIG;
-				goto out;
-			}
-		}
-
-	} else {
-		struct bss_element *bss;
-
-		list_for_each_entry(bss, &priv->bss_list, list) {
-			/* Translate this entry to WE format */
-			current_ev = orinoco_translate_scan(dev, info,
-							    current_ev,
-							    extra + srq->length,
-							    &bss->bss,
-							    bss->last_scanned);
-
-			/* Check if there is space for one more entry */
-			if ((extra + srq->length - current_ev)
-			    <= IW_EV_ADDR_LEN) {
-				/* Ask user space to try again with a
-				 * bigger buffer */
-				err = -E2BIG;
-				goto out;
-			}
-		}
-	}
-
-	srq->length = (current_ev - extra);
-	srq->flags = (__u16) priv->scan_mode;
-
-out:
-	orinoco_unlock(priv, &flags);
-	return err;
-}
 
 /* Commit handler, called after set operations */
 static int orinoco_ioctl_commit(struct net_device *dev,
@@ -2161,8 +1648,8 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
 	STD_IW_HANDLER(SIOCSIWAP,	orinoco_ioctl_setwap),
 	STD_IW_HANDLER(SIOCGIWAP,	orinoco_ioctl_getwap),
-	STD_IW_HANDLER(SIOCSIWSCAN,	orinoco_ioctl_setscan),
-	STD_IW_HANDLER(SIOCGIWSCAN,	orinoco_ioctl_getscan),
+	STD_IW_HANDLER(SIOCSIWSCAN,	cfg80211_wext_siwscan),
+	STD_IW_HANDLER(SIOCGIWSCAN,	cfg80211_wext_giwscan),
 	STD_IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
 	STD_IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
 	STD_IW_HANDLER(SIOCSIWNICKN,	orinoco_ioctl_setnick),
-- 
1.6.0.6

