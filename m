Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57357 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbYKKWBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 17:01:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC PATCH 1/4] lib80211: absorb crypto bits from net/ieee80211
Date: Tue, 11 Nov 2008 16:51:02 -0500
Message-Id: <1226440265-21240-1-git-send-email-linville@tuxdriver.com> (sfid-20081111_230123_705976_B77EAE9B)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These bits are shared already between ipw2x00 and hostap, and could
probably be shared both more cleanly and with other drivers.  This
commit simply relocates the code to lib80211 and adjusts the drivers
appropriately.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/hostap/Kconfig                |    6 +-
 drivers/net/wireless/hostap/hostap.h               |    2 +-
 drivers/net/wireless/hostap/hostap_80211.h         |    2 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c      |   10 +-
 drivers/net/wireless/hostap/hostap_80211_tx.c      |    8 +-
 drivers/net/wireless/hostap/hostap_ap.c            |   12 +-
 drivers/net/wireless/hostap/hostap_ap.h            |    8 +-
 drivers/net/wireless/hostap/hostap_hw.c            |   36 ++--
 drivers/net/wireless/hostap/hostap_ioctl.c         |  110 ++++++------
 drivers/net/wireless/hostap/hostap_main.c          |   19 +-
 drivers/net/wireless/hostap/hostap_proc.c          |   20 +-
 drivers/net/wireless/hostap/hostap_wlan.h          |    6 +-
 drivers/net/wireless/ipw2100.c                     |   12 +-
 drivers/net/wireless/ipw2200.c                     |   12 +-
 include/net/ieee80211.h                            |   10 +-
 include/net/ieee80211_crypt.h                      |  108 ----------
 include/net/lib80211.h                             |  108 ++++++++++
 net/ieee80211/Kconfig                              |   15 +--
 net/ieee80211/Makefile                             |    4 -
 net/ieee80211/ieee80211_crypt.c                    |  206 --------------------
 net/ieee80211/ieee80211_module.c                   |   23 ++-
 net/ieee80211/ieee80211_rx.c                       |    8 +-
 net/ieee80211/ieee80211_tx.c                       |    7 +-
 net/ieee80211/ieee80211_wx.c                       |   68 ++++----
 net/wireless/Kconfig                               |    9 +
 net/wireless/Makefile                              |    3 +
 net/wireless/lib80211.c                            |  191 ++++++++++++++++++-
 .../lib80211_crypt_ccmp.c}                         |  118 ++++++------
 .../lib80211_crypt_tkip.c}                         |  154 ++++++++-------
 .../lib80211_crypt_wep.c}                          |   79 ++++----
 30 files changed, 680 insertions(+), 694 deletions(-)
 delete mode 100644 include/net/ieee80211_crypt.h
 delete mode 100644 net/ieee80211/ieee80211_crypt.c
 rename net/{ieee80211/ieee80211_crypt_ccmp.c => wireless/lib80211_crypt_ccmp.c} (77%)
 rename net/{ieee80211/ieee80211_crypt_tkip.c => wireless/lib80211_crypt_tkip.c} (82%)
 rename net/{ieee80211/ieee80211_crypt_wep.c => wireless/lib80211_crypt_wep.c} (74%)

diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index 1fef331..87bbd4d 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -2,8 +2,10 @@ config HOSTAP
 	tristate "IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)"
 	depends on WLAN_80211
 	select WIRELESS_EXT
-	select IEEE80211
-	select IEEE80211_CRYPT_WEP
+	select LIB80211
+	select LIB80211_CRYPT_WEP
+	select LIB80211_CRYPT_TKIP
+	select LIB80211_CRYPT_CCMP
 	---help---
 	Shared driver code for IEEE 802.11b wireless cards based on
 	Intersil Prism2/2.5/3 chipset. This driver supports so called
diff --git a/drivers/net/wireless/hostap/hostap.h b/drivers/net/wireless/hostap/hostap.h
index 3a386a6..2453dea 100644
--- a/drivers/net/wireless/hostap/hostap.h
+++ b/drivers/net/wireless/hostap/hostap.h
@@ -63,7 +63,7 @@ void ap_control_flush_macs(struct mac_restrictions *mac_restrictions);
 int ap_control_kick_mac(struct ap_data *ap, struct net_device *dev, u8 *mac);
 void ap_control_kickall(struct ap_data *ap);
 void * ap_crypt_get_ptrs(struct ap_data *ap, u8 *addr, int permanent,
-			 struct ieee80211_crypt_data ***crypt);
+			 struct lib80211_crypt_data ***crypt);
 int prism2_ap_get_sta_qual(local_info_t *local, struct sockaddr addr[],
 			   struct iw_quality qual[], int buf_size,
 			   int aplist);
diff --git a/drivers/net/wireless/hostap/hostap_80211.h b/drivers/net/wireless/hostap/hostap_80211.h
index 3694b1e..3a9474d 100644
--- a/drivers/net/wireless/hostap/hostap_80211.h
+++ b/drivers/net/wireless/hostap/hostap_80211.h
@@ -2,7 +2,7 @@
 #define HOSTAP_80211_H
 
 #include <linux/types.h>
-#include <net/ieee80211_crypt.h>
+#include <net/ieee80211.h>
 
 struct hostap_ieee80211_mgmt {
 	__le16 frame_control;
diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index f106bc1..4dbd774 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -1,5 +1,5 @@
 #include <linux/etherdevice.h>
-#include <net/ieee80211_crypt.h>
+#include <net/lib80211.h>
 
 #include "hostap_80211.h"
 #include "hostap.h"
@@ -652,7 +652,7 @@ static int hostap_is_eapol_frame(local_info_t *local, struct sk_buff *skb)
 /* Called only as a tasklet (software IRQ) */
 static int
 hostap_rx_frame_decrypt(local_info_t *local, struct sk_buff *skb,
-			struct ieee80211_crypt_data *crypt)
+			struct lib80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_4addr *hdr;
 	int res, hdrlen;
@@ -696,7 +696,7 @@ hostap_rx_frame_decrypt(local_info_t *local, struct sk_buff *skb,
 /* Called only as a tasklet (software IRQ) */
 static int
 hostap_rx_frame_decrypt_msdu(local_info_t *local, struct sk_buff *skb,
-			     int keyidx, struct ieee80211_crypt_data *crypt)
+			     int keyidx, struct lib80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_4addr *hdr;
 	int res, hdrlen;
@@ -743,7 +743,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 	int from_assoc_ap = 0;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
-	struct ieee80211_crypt_data *crypt = NULL;
+	struct lib80211_crypt_data *crypt = NULL;
 	void *sta = NULL;
 	int keyidx = 0;
 
@@ -795,7 +795,7 @@ void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
 			idx = skb->data[hdrlen + 3] >> 6;
-		crypt = local->crypt[idx];
+		crypt = local->crypt_info.crypt[idx];
 		sta = NULL;
 
 		/* Use station specific key to override default keys if the
diff --git a/drivers/net/wireless/hostap/hostap_80211_tx.c b/drivers/net/wireless/hostap/hostap_80211_tx.c
index 921c984..86a0d37 100644
--- a/drivers/net/wireless/hostap/hostap_80211_tx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_tx.c
@@ -307,7 +307,7 @@ int hostap_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 /* Called only from software IRQ */
 static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
-					  struct ieee80211_crypt_data *crypt)
+					  struct lib80211_crypt_data *crypt)
 {
 	struct hostap_interface *iface;
 	local_info_t *local;
@@ -408,7 +408,7 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (local->host_encrypt) {
 		/* Set crypt to default algorithm and key; will be replaced in
 		 * AP code if STA has own alg/key */
-		tx.crypt = local->crypt[local->tx_keyidx];
+		tx.crypt = local->crypt_info.crypt[local->crypt_info.tx_keyidx];
 		tx.host_encrypt = 1;
 	} else {
 		tx.crypt = NULL;
@@ -490,7 +490,9 @@ int hostap_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (tx.crypt && (!tx.crypt->ops || !tx.crypt->ops->encrypt_mpdu))
 		tx.crypt = NULL;
-	else if ((tx.crypt || local->crypt[local->tx_keyidx]) && !no_encrypt) {
+	else if ((tx.crypt ||
+		 local->crypt_info.crypt[local->crypt_info.tx_keyidx]) &&
+		 !no_encrypt) {
 		/* Add ISWEP flag both for firmware and host based encryption
 		 */
 		fc |= IEEE80211_FCTL_PROTECTED;
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index af3d4ef..48a4415 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -1221,7 +1221,7 @@ static void prism2_check_tx_rates(struct sta_info *sta)
 
 static void ap_crypt_init(struct ap_data *ap)
 {
-	ap->crypt = ieee80211_get_crypto_ops("WEP");
+	ap->crypt = lib80211_get_crypto_ops("WEP");
 
 	if (ap->crypt) {
 		if (ap->crypt->init) {
@@ -1239,7 +1239,7 @@ static void ap_crypt_init(struct ap_data *ap)
 
 	if (ap->crypt == NULL) {
 		printk(KERN_WARNING "AP could not initialize WEP: load module "
-		       "ieee80211_crypt_wep.ko\n");
+		       "lib80211_crypt_wep.ko\n");
 	}
 }
 
@@ -1308,7 +1308,7 @@ static void handle_authen(local_info_t *local, struct sk_buff *skb,
 	__le16 *pos;
 	u16 resp = WLAN_STATUS_SUCCESS, fc;
 	struct sta_info *sta = NULL;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	char *txt = "";
 
 	len = skb->len - IEEE80211_MGMT_HDR_LEN;
@@ -1336,7 +1336,7 @@ static void handle_authen(local_info_t *local, struct sk_buff *skb,
 		int idx = 0;
 		if (skb->len >= hdrlen + 3)
 			idx = skb->data[hdrlen + 3] >> 6;
-		crypt = local->crypt[idx];
+		crypt = local->crypt_info.crypt[idx];
 	}
 
 	pos = (__le16 *) (skb->data + IEEE80211_MGMT_HDR_LEN);
@@ -3142,7 +3142,7 @@ ap_rx_ret hostap_handle_sta_rx(local_info_t *local, struct net_device *dev,
 /* Called only as a tasklet (software IRQ) */
 int hostap_handle_sta_crypto(local_info_t *local,
 			     struct ieee80211_hdr_4addr *hdr,
-			     struct ieee80211_crypt_data **crypt,
+			     struct lib80211_crypt_data **crypt,
 			     void **sta_ptr)
 {
 	struct sta_info *sta;
@@ -3290,7 +3290,7 @@ void hostap_update_rates(local_info_t *local)
 
 
 void * ap_crypt_get_ptrs(struct ap_data *ap, u8 *addr, int permanent,
-			 struct ieee80211_crypt_data ***crypt)
+			 struct lib80211_crypt_data ***crypt)
 {
 	struct sta_info *sta;
 
diff --git a/drivers/net/wireless/hostap/hostap_ap.h b/drivers/net/wireless/hostap/hostap_ap.h
index 2fa2452..d36e4b1 100644
--- a/drivers/net/wireless/hostap/hostap_ap.h
+++ b/drivers/net/wireless/hostap/hostap_ap.h
@@ -74,7 +74,7 @@ struct sta_info {
 	u32 tx_since_last_failure;
 	u32 tx_consecutive_exc;
 
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 
 	int ap; /* whether this station is an AP */
 
@@ -209,7 +209,7 @@ struct ap_data {
 
 	/* WEP operations for generating challenges to be used with shared key
 	 * authentication */
-	struct ieee80211_crypto_ops *crypt;
+	struct lib80211_crypto_ops *crypt;
 	void *crypt_priv;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 };
@@ -229,7 +229,7 @@ typedef enum {
 struct hostap_tx_data {
 	struct sk_buff *skb;
 	int host_encrypt;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	void *sta_ptr;
 };
 ap_tx_ret hostap_handle_sta_tx(local_info_t *local, struct hostap_tx_data *tx);
@@ -244,7 +244,7 @@ ap_rx_ret hostap_handle_sta_rx(local_info_t *local, struct net_device *dev,
 			       struct hostap_80211_rx_status *rx_stats,
 			       int wds);
 int hostap_handle_sta_crypto(local_info_t *local, struct ieee80211_hdr_4addr *hdr,
-			     struct ieee80211_crypt_data **crypt,
+			     struct lib80211_crypt_data **crypt,
 			     void **sta_ptr);
 int hostap_is_sta_assoc(struct ap_data *ap, u8 *sta_addr);
 int hostap_is_sta_authorized(struct ap_data *ap, u8 *sta_addr);
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index 3153fe9..5c5dfd6 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -47,7 +47,7 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
-#include <net/ieee80211_crypt.h>
+#include <net/lib80211.h>
 #include <asm/irq.h>
 
 #include "hostap_80211.h"
@@ -2795,11 +2795,12 @@ static void prism2_check_sta_fw_version(local_info_t *local)
 static void prism2_crypt_deinit_entries(local_info_t *local, int force)
 {
 	struct list_head *ptr, *n;
-	struct ieee80211_crypt_data *entry;
+	struct lib80211_crypt_data *entry;
 
-	for (ptr = local->crypt_deinit_list.next, n = ptr->next;
-	     ptr != &local->crypt_deinit_list; ptr = n, n = ptr->next) {
-		entry = list_entry(ptr, struct ieee80211_crypt_data, list);
+	for (ptr = local->crypt_info.crypt_deinit_list.next, n = ptr->next;
+	     ptr != &local->crypt_info.crypt_deinit_list;
+	     ptr = n, n = ptr->next) {
+		entry = list_entry(ptr, struct lib80211_crypt_data, list);
 
 		if (atomic_read(&entry->refcnt) != 0 && !force)
 			continue;
@@ -2820,11 +2821,11 @@ static void prism2_crypt_deinit_handler(unsigned long data)
 
 	spin_lock_irqsave(&local->lock, flags);
 	prism2_crypt_deinit_entries(local, 0);
-	if (!list_empty(&local->crypt_deinit_list)) {
+	if (!list_empty(&local->crypt_info.crypt_deinit_list)) {
 		printk(KERN_DEBUG "%s: entries remaining in delayed crypt "
 		       "deletion list\n", local->dev->name);
-		local->crypt_deinit_timer.expires = jiffies + HZ;
-		add_timer(&local->crypt_deinit_timer);
+		local->crypt_info.crypt_deinit_timer.expires = jiffies + HZ;
+		add_timer(&local->crypt_info.crypt_deinit_timer);
 	}
 	spin_unlock_irqrestore(&local->lock, flags);
 
@@ -3254,10 +3255,13 @@ while (0)
 
 	INIT_LIST_HEAD(&local->cmd_queue);
 	init_waitqueue_head(&local->hostscan_wq);
-	INIT_LIST_HEAD(&local->crypt_deinit_list);
-	init_timer(&local->crypt_deinit_timer);
-	local->crypt_deinit_timer.data = (unsigned long) local;
-	local->crypt_deinit_timer.function = prism2_crypt_deinit_handler;
+
+	local->crypt_info.name = dev->name;
+	local->crypt_info.lock = &local->lock;
+	INIT_LIST_HEAD(&local->crypt_info.crypt_deinit_list);
+	init_timer(&local->crypt_info.crypt_deinit_timer);
+	local->crypt_info.crypt_deinit_timer.data = (unsigned long) local;
+	local->crypt_info.crypt_deinit_timer.function = prism2_crypt_deinit_handler;
 
 	init_timer(&local->passive_scan_timer);
 	local->passive_scan_timer.data = (unsigned long) local;
@@ -3358,8 +3362,8 @@ static void prism2_free_local_data(struct net_device *dev)
 
 	flush_scheduled_work();
 
-	if (timer_pending(&local->crypt_deinit_timer))
-		del_timer(&local->crypt_deinit_timer);
+	if (timer_pending(&local->crypt_info.crypt_deinit_timer))
+		del_timer(&local->crypt_info.crypt_deinit_timer);
 	prism2_crypt_deinit_entries(local, 1);
 
 	if (timer_pending(&local->passive_scan_timer))
@@ -3378,12 +3382,12 @@ static void prism2_free_local_data(struct net_device *dev)
 		prism2_callback(local, PRISM2_CALLBACK_DISABLE);
 
 	for (i = 0; i < WEP_KEYS; i++) {
-		struct ieee80211_crypt_data *crypt = local->crypt[i];
+		struct lib80211_crypt_data *crypt = local->crypt_info.crypt[i];
 		if (crypt) {
 			if (crypt->ops)
 				crypt->ops->deinit(crypt->priv);
 			kfree(crypt);
-			local->crypt[i] = NULL;
+			local->crypt_info.crypt[i] = NULL;
 		}
 	}
 
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 3f8b1d7..baf0a26 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2,7 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/ethtool.h>
-#include <net/ieee80211_crypt.h>
+#include <net/lib80211.h>
 
 #include "hostap_wlan.h"
 #include "hostap.h"
@@ -117,9 +117,9 @@ static int prism2_get_name(struct net_device *dev,
 
 
 static void prism2_crypt_delayed_deinit(local_info_t *local,
-					struct ieee80211_crypt_data **crypt)
+					struct lib80211_crypt_data **crypt)
 {
-	struct ieee80211_crypt_data *tmp;
+	struct lib80211_crypt_data *tmp;
 	unsigned long flags;
 
 	tmp = *crypt;
@@ -133,10 +133,10 @@ static void prism2_crypt_delayed_deinit(local_info_t *local,
 	 * locking. */
 
 	spin_lock_irqsave(&local->lock, flags);
-	list_add(&tmp->list, &local->crypt_deinit_list);
-	if (!timer_pending(&local->crypt_deinit_timer)) {
-		local->crypt_deinit_timer.expires = jiffies + HZ;
-		add_timer(&local->crypt_deinit_timer);
+	list_add(&tmp->list, &local->crypt_info.crypt_deinit_list);
+	if (!timer_pending(&local->crypt_info.crypt_deinit_timer)) {
+		local->crypt_info.crypt_deinit_timer.expires = jiffies + HZ;
+		add_timer(&local->crypt_info.crypt_deinit_timer);
 	}
 	spin_unlock_irqrestore(&local->lock, flags);
 }
@@ -149,20 +149,20 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 	struct hostap_interface *iface;
 	local_info_t *local;
 	int i;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypt_data **crypt;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
 
 	i = erq->flags & IW_ENCODE_INDEX;
 	if (i < 1 || i > 4)
-		i = local->tx_keyidx;
+		i = local->crypt_info.tx_keyidx;
 	else
 		i--;
 	if (i < 0 || i >= WEP_KEYS)
 		return -EINVAL;
 
-	crypt = &local->crypt[i];
+	crypt = &local->crypt_info.crypt[i];
 
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		if (*crypt)
@@ -177,17 +177,17 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 	}
 
 	if (*crypt == NULL) {
-		struct ieee80211_crypt_data *new_crypt;
+		struct lib80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
+		new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
-			request_module("ieee80211_crypt_wep");
-			new_crypt->ops = ieee80211_get_crypto_ops("WEP");
+			request_module("lib80211_crypt_wep");
+			new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		}
 		if (new_crypt->ops)
 			new_crypt->priv = new_crypt->ops->init(i);
@@ -210,16 +210,16 @@ static int prism2_ioctl_siwencode(struct net_device *dev,
 			memset(keybuf + erq->length, 0, len - erq->length);
 		(*crypt)->ops->set_key(keybuf, len, NULL, (*crypt)->priv);
 		for (j = 0; j < WEP_KEYS; j++) {
-			if (j != i && local->crypt[j]) {
+			if (j != i && local->crypt_info.crypt[j]) {
 				first = 0;
 				break;
 			}
 		}
 		if (first)
-			local->tx_keyidx = i;
+			local->crypt_info.tx_keyidx = i;
 	} else {
 		/* No key data - just set the default TX key index */
-		local->tx_keyidx = i;
+		local->crypt_info.tx_keyidx = i;
 	}
 
  done:
@@ -252,20 +252,20 @@ static int prism2_ioctl_giwencode(struct net_device *dev,
 	local_info_t *local;
 	int i, len;
 	u16 val;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
 
 	i = erq->flags & IW_ENCODE_INDEX;
 	if (i < 1 || i > 4)
-		i = local->tx_keyidx;
+		i = local->crypt_info.tx_keyidx;
 	else
 		i--;
 	if (i < 0 || i >= WEP_KEYS)
 		return -EINVAL;
 
-	crypt = local->crypt[i];
+	crypt = local->crypt_info.crypt[i];
 	erq->flags = i + 1;
 
 	if (crypt == NULL || crypt->ops == NULL) {
@@ -3229,8 +3229,8 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	local_info_t *local = iface->local;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
 	int i, ret = 0;
-	struct ieee80211_crypto_ops *ops;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypto_ops *ops;
+	struct lib80211_crypt_data **crypt;
 	void *sta_ptr;
 	u8 *addr;
 	const char *alg, *module;
@@ -3239,7 +3239,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	if (i > WEP_KEYS)
 		return -EINVAL;
 	if (i < 1 || i > WEP_KEYS)
-		i = local->tx_keyidx;
+		i = local->crypt_info.tx_keyidx;
 	else
 		i--;
 	if (i < 0 || i >= WEP_KEYS)
@@ -3249,7 +3249,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	if (addr[0] == 0xff && addr[1] == 0xff && addr[2] == 0xff &&
 	    addr[3] == 0xff && addr[4] == 0xff && addr[5] == 0xff) {
 		sta_ptr = NULL;
-		crypt = &local->crypt[i];
+		crypt = &local->crypt_info.crypt[i];
 	} else {
 		if (i != 0)
 			return -EINVAL;
@@ -3262,7 +3262,7 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 				 * is emulated by using default key idx 0.
 				 */
 				i = 0;
-				crypt = &local->crypt[i];
+				crypt = &local->crypt_info.crypt[i];
 			} else
 				return -EINVAL;
 		}
@@ -3278,15 +3278,15 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	switch (ext->alg) {
 	case IW_ENCODE_ALG_WEP:
 		alg = "WEP";
-		module = "ieee80211_crypt_wep";
+		module = "lib80211_crypt_wep";
 		break;
 	case IW_ENCODE_ALG_TKIP:
 		alg = "TKIP";
-		module = "ieee80211_crypt_tkip";
+		module = "lib80211_crypt_tkip";
 		break;
 	case IW_ENCODE_ALG_CCMP:
 		alg = "CCMP";
-		module = "ieee80211_crypt_ccmp";
+		module = "lib80211_crypt_ccmp";
 		break;
 	default:
 		printk(KERN_DEBUG "%s: unsupported algorithm %d\n",
@@ -3295,10 +3295,10 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 		goto done;
 	}
 
-	ops = ieee80211_get_crypto_ops(alg);
+	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
 		request_module(module);
-		ops = ieee80211_get_crypto_ops(alg);
+		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
 		printk(KERN_DEBUG "%s: unknown crypto alg '%s'\n",
@@ -3317,11 +3317,11 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 	}
 
 	if (*crypt == NULL || (*crypt)->ops != ops) {
-		struct ieee80211_crypt_data *new_crypt;
+		struct lib80211_crypt_data *new_crypt;
 
 		prism2_crypt_delayed_deinit(local, crypt);
 
-		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL) {
 			ret = -ENOMEM;
@@ -3356,20 +3356,20 @@ static int prism2_ioctl_siwencodeext(struct net_device *dev,
 
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
 		if (!sta_ptr)
-			local->tx_keyidx = i;
+			local->crypt_info.tx_keyidx = i;
 	}
 
 
 	if (sta_ptr == NULL && ext->key_len > 0) {
 		int first = 1, j;
 		for (j = 0; j < WEP_KEYS; j++) {
-			if (j != i && local->crypt[j]) {
+			if (j != i && local->crypt_info.crypt[j]) {
 				first = 0;
 				break;
 			}
 		}
 		if (first)
-			local->tx_keyidx = i;
+			local->crypt_info.tx_keyidx = i;
 	}
 
  done:
@@ -3401,7 +3401,7 @@ static int prism2_ioctl_giwencodeext(struct net_device *dev,
 {
 	struct hostap_interface *iface = netdev_priv(dev);
 	local_info_t *local = iface->local;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypt_data **crypt;
 	void *sta_ptr;
 	int max_key_len, i;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
@@ -3413,7 +3413,7 @@ static int prism2_ioctl_giwencodeext(struct net_device *dev,
 
 	i = erq->flags & IW_ENCODE_INDEX;
 	if (i < 1 || i > WEP_KEYS)
-		i = local->tx_keyidx;
+		i = local->crypt_info.tx_keyidx;
 	else
 		i--;
 
@@ -3421,7 +3421,7 @@ static int prism2_ioctl_giwencodeext(struct net_device *dev,
 	if (addr[0] == 0xff && addr[1] == 0xff && addr[2] == 0xff &&
 	    addr[3] == 0xff && addr[4] == 0xff && addr[5] == 0xff) {
 		sta_ptr = NULL;
-		crypt = &local->crypt[i];
+		crypt = &local->crypt_info.crypt[i];
 	} else {
 		i = 0;
 		sta_ptr = ap_crypt_get_ptrs(local->ap, addr, 0, &crypt);
@@ -3470,8 +3470,8 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 				       int param_len)
 {
 	int ret = 0;
-	struct ieee80211_crypto_ops *ops;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypto_ops *ops;
+	struct lib80211_crypt_data **crypt;
 	void *sta_ptr;
 
 	param->u.crypt.err = 0;
@@ -3488,7 +3488,7 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 		if (param->u.crypt.idx >= WEP_KEYS)
 			return -EINVAL;
 		sta_ptr = NULL;
-		crypt = &local->crypt[param->u.crypt.idx];
+		crypt = &local->crypt_info.crypt[param->u.crypt.idx];
 	} else {
 		if (param->u.crypt.idx)
 			return -EINVAL;
@@ -3509,16 +3509,16 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 		goto done;
 	}
 
-	ops = ieee80211_get_crypto_ops(param->u.crypt.alg);
+	ops = lib80211_get_crypto_ops(param->u.crypt.alg);
 	if (ops == NULL && strcmp(param->u.crypt.alg, "WEP") == 0) {
-		request_module("ieee80211_crypt_wep");
-		ops = ieee80211_get_crypto_ops(param->u.crypt.alg);
+		request_module("lib80211_crypt_wep");
+		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
 	} else if (ops == NULL && strcmp(param->u.crypt.alg, "TKIP") == 0) {
-		request_module("ieee80211_crypt_tkip");
-		ops = ieee80211_get_crypto_ops(param->u.crypt.alg);
+		request_module("lib80211_crypt_tkip");
+		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
 	} else if (ops == NULL && strcmp(param->u.crypt.alg, "CCMP") == 0) {
-		request_module("ieee80211_crypt_ccmp");
-		ops = ieee80211_get_crypto_ops(param->u.crypt.alg);
+		request_module("lib80211_crypt_ccmp");
+		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
 	}
 	if (ops == NULL) {
 		printk(KERN_DEBUG "%s: unknown crypto alg '%s'\n",
@@ -3533,11 +3533,11 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 	local->host_decrypt = local->host_encrypt = 1;
 
 	if (*crypt == NULL || (*crypt)->ops != ops) {
-		struct ieee80211_crypt_data *new_crypt;
+		struct lib80211_crypt_data *new_crypt;
 
 		prism2_crypt_delayed_deinit(local, crypt);
 
-		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				GFP_KERNEL);
 		if (new_crypt == NULL) {
 			ret = -ENOMEM;
@@ -3570,7 +3570,7 @@ static int prism2_ioctl_set_encryption(local_info_t *local,
 
 	if (param->u.crypt.flags & HOSTAP_CRYPT_FLAG_SET_TX_KEY) {
 		if (!sta_ptr)
-			local->tx_keyidx = param->u.crypt.idx;
+			local->crypt_info.tx_keyidx = param->u.crypt.idx;
 		else if (param->u.crypt.idx) {
 			printk(KERN_DEBUG "%s: TX key idx setting failed\n",
 			       local->dev->name);
@@ -3606,7 +3606,7 @@ static int prism2_ioctl_get_encryption(local_info_t *local,
 				       struct prism2_hostapd_param *param,
 				       int param_len)
 {
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypt_data **crypt;
 	void *sta_ptr;
 	int max_key_len;
 
@@ -3622,8 +3622,8 @@ static int prism2_ioctl_get_encryption(local_info_t *local,
 	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
 		sta_ptr = NULL;
 		if (param->u.crypt.idx >= WEP_KEYS)
-			param->u.crypt.idx = local->tx_keyidx;
-		crypt = &local->crypt[param->u.crypt.idx];
+			param->u.crypt.idx = local->crypt_info.tx_keyidx;
+		crypt = &local->crypt_info.crypt[param->u.crypt.idx];
 	} else {
 		param->u.crypt.idx = 0;
 		sta_ptr = ap_crypt_get_ptrs(local->ap, param->sta_addr, 0,
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index 756ab56..1410906 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -27,7 +27,7 @@
 #include <net/net_namespace.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
-#include <net/ieee80211_crypt.h>
+#include <net/lib80211.h>
 #include <asm/uaccess.h>
 
 #include "hostap_wlan.h"
@@ -343,10 +343,11 @@ int hostap_set_encryption(local_info_t *local)
 	char keybuf[WEP_KEY_LEN + 1];
 	enum { NONE, WEP, OTHER } encrypt_type;
 
-	idx = local->tx_keyidx;
-	if (local->crypt[idx] == NULL || local->crypt[idx]->ops == NULL)
+	idx = local->crypt_info.tx_keyidx;
+	if (local->crypt_info.crypt[idx] == NULL ||
+	    local->crypt_info.crypt[idx]->ops == NULL)
 		encrypt_type = NONE;
-	else if (strcmp(local->crypt[idx]->ops->name, "WEP") == 0)
+	else if (strcmp(local->crypt_info.crypt[idx]->ops->name, "WEP") == 0)
 		encrypt_type = WEP;
 	else
 		encrypt_type = OTHER;
@@ -394,17 +395,17 @@ int hostap_set_encryption(local_info_t *local)
 	/* 104-bit support seems to require that all the keys are set to the
 	 * same keylen */
 	keylen = 6; /* first 5 octets */
-	len = local->crypt[idx]->ops->get_key(keybuf, sizeof(keybuf),
-					      NULL, local->crypt[idx]->priv);
+	len = local->crypt_info.crypt[idx]->ops->get_key(keybuf, sizeof(keybuf), NULL,
+							   local->crypt_info.crypt[idx]->priv);
 	if (idx >= 0 && idx < WEP_KEYS && len > 5)
 		keylen = WEP_KEY_LEN + 1; /* first 13 octets */
 
 	for (i = 0; i < WEP_KEYS; i++) {
 		memset(keybuf, 0, sizeof(keybuf));
-		if (local->crypt[i]) {
-			(void) local->crypt[i]->ops->get_key(
+		if (local->crypt_info.crypt[i]) {
+			(void) local->crypt_info.crypt[i]->ops->get_key(
 				keybuf, sizeof(keybuf),
-				NULL, local->crypt[i]->priv);
+				NULL, local->crypt_info.crypt[i]->priv);
 		}
 		if (local->func->set_rid(local->dev,
 					 HFA384X_RID_CNFDEFAULTKEY0 + i,
diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
index b035360..c2249fa 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -2,7 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/proc_fs.h>
-#include <net/ieee80211_crypt.h>
+#include <net/lib80211.h>
 
 #include "hostap_wlan.h"
 #include "hostap.h"
@@ -36,9 +36,10 @@ static int prism2_debug_proc_read(char *page, char **start, off_t off,
 	p += sprintf(p, "dev_enabled=%d\n", local->dev_enabled);
 	p += sprintf(p, "sw_tick_stuck=%d\n", local->sw_tick_stuck);
 	for (i = 0; i < WEP_KEYS; i++) {
-		if (local->crypt[i] && local->crypt[i]->ops) {
-			p += sprintf(p, "crypt[%d]=%s\n",
-				     i, local->crypt[i]->ops->name);
+		if (local->crypt_info.crypt[i] &&
+		    local->crypt_info.crypt[i]->ops) {
+			p += sprintf(p, "crypt[%d]=%s\n", i,
+				     local->crypt_info.crypt[i]->ops->name);
 		}
 	}
 	p += sprintf(p, "pri_only=%d\n", local->pri_only);
@@ -208,12 +209,13 @@ static int prism2_crypt_proc_read(char *page, char **start, off_t off,
 		return 0;
 	}
 
-	p += sprintf(p, "tx_keyidx=%d\n", local->tx_keyidx);
+	p += sprintf(p, "tx_keyidx=%d\n", local->crypt_info.tx_keyidx);
 	for (i = 0; i < WEP_KEYS; i++) {
-		if (local->crypt[i] && local->crypt[i]->ops &&
-		    local->crypt[i]->ops->print_stats) {
-			p = local->crypt[i]->ops->print_stats(
-				p, local->crypt[i]->priv);
+		if (local->crypt_info.crypt[i] &&
+		    local->crypt_info.crypt[i]->ops &&
+		    local->crypt_info.crypt[i]->ops->print_stats) {
+			p = local->crypt_info.crypt[i]->ops->print_stats(
+				p, local->crypt_info.crypt[i]->priv);
 		}
 	}
 
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index 8431030..0cad877 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -6,6 +6,7 @@
 #include <linux/mutex.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211_radiotap.h>
+#include <net/lib80211.h>
 
 #include "hostap_config.h"
 #include "hostap_common.h"
@@ -763,10 +764,7 @@ struct local_info {
 
 #define WEP_KEYS 4
 #define WEP_KEY_LEN 13
-	struct ieee80211_crypt_data *crypt[WEP_KEYS];
-	int tx_keyidx; /* default TX key index (crypt[tx_keyidx]) */
-	struct timer_list crypt_deinit_timer;
-	struct list_head crypt_deinit_list;
+	struct lib80211_crypt_info crypt_info;
 
 	int open_wep; /* allow unencrypted frames */
 	int host_encrypt;
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 836618f..bf7fadd 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -4013,7 +4013,7 @@ static ssize_t show_internals(struct device *d, struct device_attribute *attr,
 	else
 		len += sprintf(buf + len, "not connected\n");
 
-	DUMP_VAR(ieee->crypt[priv->ieee->tx_keyidx], "p");
+	DUMP_VAR(ieee->crypt_info.crypt[priv->ieee->crypt_info.tx_keyidx], "p");
 	DUMP_VAR(status, "08lx");
 	DUMP_VAR(config, "08lx");
 	DUMP_VAR(capability, "08lx");
@@ -5522,7 +5522,7 @@ static int ipw2100_configure_security(struct ipw2100_priv *priv, int batch_mode)
 			}
 		}
 
-		ipw2100_set_key_index(priv, priv->ieee->tx_keyidx, 1);
+		ipw2100_set_key_index(priv, priv->ieee->crypt_info.tx_keyidx, 1);
 	}
 
 	/* Always enable privacy so the Host can filter WEP packets if
@@ -7632,7 +7632,7 @@ static int ipw2100_wx_set_auth(struct net_device *dev,
 	struct ipw2100_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee;
 	struct iw_param *param = &wrqu->param;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	unsigned long flags;
 	int ret = 0;
 
@@ -7647,7 +7647,7 @@ static int ipw2100_wx_set_auth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:
-		crypt = priv->ieee->crypt[priv->ieee->tx_keyidx];
+		crypt = priv->ieee->crypt_info.crypt[priv->ieee->crypt_info.tx_keyidx];
 		if (!crypt || !crypt->ops->set_flags || !crypt->ops->get_flags)
 			break;
 
@@ -7724,7 +7724,7 @@ static int ipw2100_wx_get_auth(struct net_device *dev,
 {
 	struct ipw2100_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
 	int ret = 0;
 
@@ -7740,7 +7740,7 @@ static int ipw2100_wx_get_auth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:
-		crypt = priv->ieee->crypt[priv->ieee->tx_keyidx];
+		crypt = priv->ieee->crypt_info.crypt[priv->ieee->crypt_info.tx_keyidx];
 		if (!crypt || !crypt->ops->get_flags) {
 			IPW_DEBUG_WARNING("Can't get TKIP countermeasures: "
 					  "crypt not set!\n");
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 65a733d..c73173a 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -6611,7 +6611,7 @@ static int ipw_wx_set_auth(struct net_device *dev,
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee;
 	struct iw_param *param = &wrqu->param;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	unsigned long flags;
 	int ret = 0;
 
@@ -6633,7 +6633,7 @@ static int ipw_wx_set_auth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:
-		crypt = priv->ieee->crypt[priv->ieee->tx_keyidx];
+		crypt = priv->ieee->crypt_info.crypt[priv->ieee->crypt_info.tx_keyidx];
 		if (!crypt || !crypt->ops->set_flags || !crypt->ops->get_flags)
 			break;
 
@@ -6710,7 +6710,7 @@ static int ipw_wx_get_auth(struct net_device *dev,
 {
 	struct ipw_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
 	int ret = 0;
 
@@ -6726,7 +6726,7 @@ static int ipw_wx_get_auth(struct net_device *dev,
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:
-		crypt = priv->ieee->crypt[priv->ieee->tx_keyidx];
+		crypt = priv->ieee->crypt_info.crypt[priv->ieee->crypt_info.tx_keyidx];
 		if (!crypt || !crypt->ops->get_flags)
 			break;
 
@@ -10277,8 +10277,8 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 		case SEC_LEVEL_1:
 			tfd->u.data.tfd.tfd_24.mchdr.frame_ctl |=
 			    cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-			tfd->u.data.key_index = priv->ieee->tx_keyidx;
-			if (priv->ieee->sec.key_sizes[priv->ieee->tx_keyidx] <=
+			tfd->u.data.key_index = priv->ieee->crypt_info.tx_keyidx;
+			if (priv->ieee->sec.key_sizes[priv->ieee->crypt_info.tx_keyidx] <=
 			    40)
 				tfd->u.data.key_index |= DCT_WEP_KEY_64Bit;
 			else
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index 738734a..7ab3ed2 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -30,6 +30,8 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 
+#include <net/lib80211.h>
+
 #define IEEE80211_VERSION "git-1.1.13"
 
 #define IEEE80211_DATA_LEN		2304
@@ -355,8 +357,6 @@ struct ieee80211_stats {
 
 struct ieee80211_device;
 
-#include "ieee80211_crypt.h"
-
 #define SEC_KEY_1		(1<<0)
 #define SEC_KEY_2		(1<<1)
 #define SEC_KEY_3		(1<<2)
@@ -937,11 +937,7 @@ struct ieee80211_device {
 	size_t wpa_ie_len;
 	u8 *wpa_ie;
 
-	struct list_head crypt_deinit_list;
-	struct ieee80211_crypt_data *crypt[WEP_KEYS];
-	int tx_keyidx;		/* default TX key index (crypt[tx_keyidx]) */
-	struct timer_list crypt_deinit_timer;
-	int crypt_quiesced;
+	struct lib80211_crypt_info crypt_info;
 
 	int bcrx_sta_key;	/* use individual keys to override default keys even
 				 * with RX of broad/multicast frames */
diff --git a/include/net/ieee80211_crypt.h b/include/net/ieee80211_crypt.h
deleted file mode 100644
index b3d65e0..0000000
--- a/include/net/ieee80211_crypt.h
+++ /dev/null
@@ -1,108 +0,0 @@
-/*
- * Original code based on Host AP (software wireless LAN access point) driver
- * for Intersil Prism2/2.5/3.
- *
- * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
- * <j@w1.fi>
- * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
- *
- * Adaption to a generic IEEE 802.11 stack by James Ketrenos
- * <jketreno@linux.intel.com>
- *
- * Copyright (c) 2004, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation. See README and COPYING for
- * more details.
- */
-
-/*
- * This file defines the interface to the ieee80211 crypto module.
- */
-#ifndef IEEE80211_CRYPT_H
-#define IEEE80211_CRYPT_H
-
-#include <linux/types.h>
-#include <linux/list.h>
-#include <net/ieee80211.h>
-#include <asm/atomic.h>
-
-enum {
-	IEEE80211_CRYPTO_TKIP_COUNTERMEASURES = (1 << 0),
-};
-
-struct sk_buff;
-struct module;
-
-struct ieee80211_crypto_ops {
-	const char *name;
-	struct list_head list;
-
-	/* init new crypto context (e.g., allocate private data space,
-	 * select IV, etc.); returns NULL on failure or pointer to allocated
-	 * private data on success */
-	void *(*init) (int keyidx);
-
-	/* deinitialize crypto context and free allocated private data */
-	void (*deinit) (void *priv);
-
-	int (*build_iv) (struct sk_buff * skb, int hdr_len,
-			 u8 *key, int keylen, void *priv);
-
-	/* encrypt/decrypt return < 0 on error or >= 0 on success. The return
-	 * value from decrypt_mpdu is passed as the keyidx value for
-	 * decrypt_msdu. skb must have enough head and tail room for the
-	 * encryption; if not, error will be returned; these functions are
-	 * called for all MPDUs (i.e., fragments).
-	 */
-	int (*encrypt_mpdu) (struct sk_buff * skb, int hdr_len, void *priv);
-	int (*decrypt_mpdu) (struct sk_buff * skb, int hdr_len, void *priv);
-
-	/* These functions are called for full MSDUs, i.e. full frames.
-	 * These can be NULL if full MSDU operations are not needed. */
-	int (*encrypt_msdu) (struct sk_buff * skb, int hdr_len, void *priv);
-	int (*decrypt_msdu) (struct sk_buff * skb, int keyidx, int hdr_len,
-			     void *priv);
-
-	int (*set_key) (void *key, int len, u8 * seq, void *priv);
-	int (*get_key) (void *key, int len, u8 * seq, void *priv);
-
-	/* procfs handler for printing out key information and possible
-	 * statistics */
-	char *(*print_stats) (char *p, void *priv);
-
-	/* Crypto specific flag get/set for configuration settings */
-	unsigned long (*get_flags) (void *priv);
-	unsigned long (*set_flags) (unsigned long flags, void *priv);
-
-	/* maximum number of bytes added by encryption; encrypt buf is
-	 * allocated with extra_prefix_len bytes, copy of in_buf, and
-	 * extra_postfix_len; encrypt need not use all this space, but
-	 * the result must start at the beginning of the buffer and correct
-	 * length must be returned */
-	int extra_mpdu_prefix_len, extra_mpdu_postfix_len;
-	int extra_msdu_prefix_len, extra_msdu_postfix_len;
-
-	struct module *owner;
-};
-
-struct ieee80211_crypt_data {
-	struct list_head list;	/* delayed deletion list */
-	struct ieee80211_crypto_ops *ops;
-	void *priv;
-	atomic_t refcnt;
-};
-
-struct ieee80211_device;
-
-int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops);
-int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops);
-struct ieee80211_crypto_ops *ieee80211_get_crypto_ops(const char *name);
-void ieee80211_crypt_deinit_entries(struct ieee80211_device *, int);
-void ieee80211_crypt_deinit_handler(unsigned long);
-void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
-				    struct ieee80211_crypt_data **crypt);
-void ieee80211_crypt_quiescing(struct ieee80211_device *ieee);
-
-#endif
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index e1558a1..dd1079f 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -3,11 +3,32 @@
  *
  * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
  *
+ * Some bits copied from old ieee80211 component, w/ original copyright
+ * notices below:
+ *
+ * Original code based on Host AP (software wireless LAN access point) driver
+ * for Intersil Prism2/2.5/3.
+ *
+ * Copyright (c) 2001-2002, SSH Communications Security Corp and Jouni Malinen
+ * <j@w1.fi>
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
+ *
+ * Adaption to a generic IEEE 802.11 stack by James Ketrenos
+ * <jketreno@linux.intel.com>
+ *
+ * Copyright (c) 2004, Intel Corporation
+ *
  */
 
 #ifndef LIB80211_H
 #define LIB80211_H
 
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <asm/atomic.h>
+#include <linux/if.h>
+#include <linux/skbuff.h>
 #include <linux/ieee80211.h>
 
 /* print_ssid() is intended to be used in debug (and possibly error)
@@ -15,4 +36,91 @@
 const char *print_ssid(char *buf, const char *ssid, u8 ssid_len);
 #define DECLARE_SSID_BUF(var) char var[IEEE80211_MAX_SSID_LEN * 4 + 1] __maybe_unused
 
+#define NUM_WEP_KEYS	4
+
+enum {
+	IEEE80211_CRYPTO_TKIP_COUNTERMEASURES = (1 << 0),
+};
+
+struct lib80211_crypto_ops {
+	const char *name;
+	struct list_head list;
+
+	/* init new crypto context (e.g., allocate private data space,
+	 * select IV, etc.); returns NULL on failure or pointer to allocated
+	 * private data on success */
+	void *(*init) (int keyidx);
+
+	/* deinitialize crypto context and free allocated private data */
+	void (*deinit) (void *priv);
+
+	int (*build_iv) (struct sk_buff * skb, int hdr_len,
+			 u8 *key, int keylen, void *priv);
+
+	/* encrypt/decrypt return < 0 on error or >= 0 on success. The return
+	 * value from decrypt_mpdu is passed as the keyidx value for
+	 * decrypt_msdu. skb must have enough head and tail room for the
+	 * encryption; if not, error will be returned; these functions are
+	 * called for all MPDUs (i.e., fragments).
+	 */
+	int (*encrypt_mpdu) (struct sk_buff * skb, int hdr_len, void *priv);
+	int (*decrypt_mpdu) (struct sk_buff * skb, int hdr_len, void *priv);
+
+	/* These functions are called for full MSDUs, i.e. full frames.
+	 * These can be NULL if full MSDU operations are not needed. */
+	int (*encrypt_msdu) (struct sk_buff * skb, int hdr_len, void *priv);
+	int (*decrypt_msdu) (struct sk_buff * skb, int keyidx, int hdr_len,
+			     void *priv);
+
+	int (*set_key) (void *key, int len, u8 * seq, void *priv);
+	int (*get_key) (void *key, int len, u8 * seq, void *priv);
+
+	/* procfs handler for printing out key information and possible
+	 * statistics */
+	char *(*print_stats) (char *p, void *priv);
+
+	/* Crypto specific flag get/set for configuration settings */
+	unsigned long (*get_flags) (void *priv);
+	unsigned long (*set_flags) (unsigned long flags, void *priv);
+
+	/* maximum number of bytes added by encryption; encrypt buf is
+	 * allocated with extra_prefix_len bytes, copy of in_buf, and
+	 * extra_postfix_len; encrypt need not use all this space, but
+	 * the result must start at the beginning of the buffer and correct
+	 * length must be returned */
+	int extra_mpdu_prefix_len, extra_mpdu_postfix_len;
+	int extra_msdu_prefix_len, extra_msdu_postfix_len;
+
+	struct module *owner;
+};
+
+struct lib80211_crypt_data {
+	struct list_head list;	/* delayed deletion list */
+	struct lib80211_crypto_ops *ops;
+	void *priv;
+	atomic_t refcnt;
+};
+
+struct lib80211_crypt_info {
+	char *name;
+	/* Most clients will already have a lock,
+	   so just point to that. */
+	spinlock_t *lock;
+
+	struct lib80211_crypt_data *crypt[NUM_WEP_KEYS];
+	int tx_keyidx;		/* default TX key index (crypt[tx_keyidx]) */
+	struct list_head crypt_deinit_list;
+	struct timer_list crypt_deinit_timer;
+	int crypt_quiesced;
+};
+
+int lib80211_register_crypto_ops(struct lib80211_crypto_ops *ops);
+int lib80211_unregister_crypto_ops(struct lib80211_crypto_ops *ops);
+struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name);
+void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *, int);
+void lib80211_crypt_deinit_handler(unsigned long);
+void lib80211_crypt_delayed_deinit(struct lib80211_crypt_info *info,
+				    struct lib80211_crypt_data **crypt);
+void lib80211_crypt_quiescing(struct lib80211_crypt_info *info);
+
 #endif /* LIB80211_H */
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index d2282bb..46f24f4 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -8,10 +8,10 @@ config IEEE80211
 	select CRYPTO_MICHAEL_MIC
 	select CRYPTO_ECB
 	select CRC32
-	select IEEE80211_CRYPT_WEP
-	select IEEE80211_CRYPT_TKIP
-	select IEEE80211_CRYPT_CCMP
 	select LIB80211
+	select LIB80211_CRYPT_WEP
+	select LIB80211_CRYPT_TKIP
+	select LIB80211_CRYPT_CCMP
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.  This component is deprecated in favor of the
@@ -39,12 +39,3 @@ config IEEE80211_DEBUG
 
 	  If you are not trying to debug or develop the ieee80211
 	  subsystem, you most likely want to say N here.
-
-config IEEE80211_CRYPT_WEP
-	tristate
-
-config IEEE80211_CRYPT_CCMP
-	tristate
-
-config IEEE80211_CRYPT_TKIP
-	tristate
diff --git a/net/ieee80211/Makefile b/net/ieee80211/Makefile
index f988417..158963f 100644
--- a/net/ieee80211/Makefile
+++ b/net/ieee80211/Makefile
@@ -1,8 +1,4 @@
 obj-$(CONFIG_IEEE80211) += ieee80211.o
-obj-$(CONFIG_IEEE80211) += ieee80211_crypt.o
-obj-$(CONFIG_IEEE80211_CRYPT_WEP) += ieee80211_crypt_wep.o
-obj-$(CONFIG_IEEE80211_CRYPT_CCMP) += ieee80211_crypt_ccmp.o
-obj-$(CONFIG_IEEE80211_CRYPT_TKIP) += ieee80211_crypt_tkip.o
 ieee80211-objs := \
 	ieee80211_module.o \
 	ieee80211_tx.o \
diff --git a/net/ieee80211/ieee80211_crypt.c b/net/ieee80211/ieee80211_crypt.c
deleted file mode 100644
index df5592c..0000000
--- a/net/ieee80211/ieee80211_crypt.c
+++ /dev/null
@@ -1,206 +0,0 @@
-/*
- * Host AP crypto routines
- *
- * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
- * Portions Copyright (C) 2004, Intel Corporation <jketreno@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation. See README and COPYING for
- * more details.
- *
- */
-
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <net/ieee80211.h>
-
-MODULE_AUTHOR("Jouni Malinen");
-MODULE_DESCRIPTION("HostAP crypto");
-MODULE_LICENSE("GPL");
-
-struct ieee80211_crypto_alg {
-	struct list_head list;
-	struct ieee80211_crypto_ops *ops;
-};
-
-static LIST_HEAD(ieee80211_crypto_algs);
-static DEFINE_SPINLOCK(ieee80211_crypto_lock);
-
-void ieee80211_crypt_deinit_entries(struct ieee80211_device *ieee, int force)
-{
-	struct ieee80211_crypt_data *entry, *next;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ieee->lock, flags);
-	list_for_each_entry_safe(entry, next, &ieee->crypt_deinit_list, list) {
-		if (atomic_read(&entry->refcnt) != 0 && !force)
-			continue;
-
-		list_del(&entry->list);
-
-		if (entry->ops) {
-			entry->ops->deinit(entry->priv);
-			module_put(entry->ops->owner);
-		}
-		kfree(entry);
-	}
-	spin_unlock_irqrestore(&ieee->lock, flags);
-}
-
-/* After this, crypt_deinit_list won't accept new members */
-void ieee80211_crypt_quiescing(struct ieee80211_device *ieee)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ieee->lock, flags);
-	ieee->crypt_quiesced = 1;
-	spin_unlock_irqrestore(&ieee->lock, flags);
-}
-
-void ieee80211_crypt_deinit_handler(unsigned long data)
-{
-	struct ieee80211_device *ieee = (struct ieee80211_device *)data;
-	unsigned long flags;
-
-	ieee80211_crypt_deinit_entries(ieee, 0);
-
-	spin_lock_irqsave(&ieee->lock, flags);
-	if (!list_empty(&ieee->crypt_deinit_list) && !ieee->crypt_quiesced) {
-		printk(KERN_DEBUG "%s: entries remaining in delayed crypt "
-		       "deletion list\n", ieee->dev->name);
-		ieee->crypt_deinit_timer.expires = jiffies + HZ;
-		add_timer(&ieee->crypt_deinit_timer);
-	}
-	spin_unlock_irqrestore(&ieee->lock, flags);
-}
-
-void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
-				    struct ieee80211_crypt_data **crypt)
-{
-	struct ieee80211_crypt_data *tmp;
-	unsigned long flags;
-
-	if (*crypt == NULL)
-		return;
-
-	tmp = *crypt;
-	*crypt = NULL;
-
-	/* must not run ops->deinit() while there may be pending encrypt or
-	 * decrypt operations. Use a list of delayed deinits to avoid needing
-	 * locking. */
-
-	spin_lock_irqsave(&ieee->lock, flags);
-	if (!ieee->crypt_quiesced) {
-		list_add(&tmp->list, &ieee->crypt_deinit_list);
-		if (!timer_pending(&ieee->crypt_deinit_timer)) {
-			ieee->crypt_deinit_timer.expires = jiffies + HZ;
-			add_timer(&ieee->crypt_deinit_timer);
-		}
-	}
-	spin_unlock_irqrestore(&ieee->lock, flags);
-}
-
-int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops)
-{
-	unsigned long flags;
-	struct ieee80211_crypto_alg *alg;
-
-	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
-	if (alg == NULL)
-		return -ENOMEM;
-
-	alg->ops = ops;
-
-	spin_lock_irqsave(&ieee80211_crypto_lock, flags);
-	list_add(&alg->list, &ieee80211_crypto_algs);
-	spin_unlock_irqrestore(&ieee80211_crypto_lock, flags);
-
-	printk(KERN_DEBUG "ieee80211_crypt: registered algorithm '%s'\n",
-	       ops->name);
-
-	return 0;
-}
-
-int ieee80211_unregister_crypto_ops(struct ieee80211_crypto_ops *ops)
-{
-	struct ieee80211_crypto_alg *alg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ieee80211_crypto_lock, flags);
-	list_for_each_entry(alg, &ieee80211_crypto_algs, list) {
-		if (alg->ops == ops)
-			goto found;
-	}
-	spin_unlock_irqrestore(&ieee80211_crypto_lock, flags);
-	return -EINVAL;
-
-      found:
-	printk(KERN_DEBUG "ieee80211_crypt: unregistered algorithm "
-	       "'%s'\n", ops->name);
-	list_del(&alg->list);
-	spin_unlock_irqrestore(&ieee80211_crypto_lock, flags);
-	kfree(alg);
-	return 0;
-}
-
-struct ieee80211_crypto_ops *ieee80211_get_crypto_ops(const char *name)
-{
-	struct ieee80211_crypto_alg *alg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ieee80211_crypto_lock, flags);
-	list_for_each_entry(alg, &ieee80211_crypto_algs, list) {
-		if (strcmp(alg->ops->name, name) == 0)
-			goto found;
-	}
-	spin_unlock_irqrestore(&ieee80211_crypto_lock, flags);
-	return NULL;
-
-      found:
-	spin_unlock_irqrestore(&ieee80211_crypto_lock, flags);
-	return alg->ops;
-}
-
-static void *ieee80211_crypt_null_init(int keyidx)
-{
-	return (void *)1;
-}
-
-static void ieee80211_crypt_null_deinit(void *priv)
-{
-}
-
-static struct ieee80211_crypto_ops ieee80211_crypt_null = {
-	.name = "NULL",
-	.init = ieee80211_crypt_null_init,
-	.deinit = ieee80211_crypt_null_deinit,
-	.owner = THIS_MODULE,
-};
-
-static int __init ieee80211_crypto_init(void)
-{
-	return ieee80211_register_crypto_ops(&ieee80211_crypt_null);
-}
-
-static void __exit ieee80211_crypto_deinit(void)
-{
-	ieee80211_unregister_crypto_ops(&ieee80211_crypt_null);
-	BUG_ON(!list_empty(&ieee80211_crypto_algs));
-}
-
-EXPORT_SYMBOL(ieee80211_crypt_deinit_entries);
-EXPORT_SYMBOL(ieee80211_crypt_deinit_handler);
-EXPORT_SYMBOL(ieee80211_crypt_delayed_deinit);
-EXPORT_SYMBOL(ieee80211_crypt_quiescing);
-
-EXPORT_SYMBOL(ieee80211_register_crypto_ops);
-EXPORT_SYMBOL(ieee80211_unregister_crypto_ops);
-EXPORT_SYMBOL(ieee80211_get_crypto_ops);
-
-module_init(ieee80211_crypto_init);
-module_exit(ieee80211_crypto_deinit);
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index d34d4e7..cf21f0b 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -180,13 +180,16 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 	ieee->host_open_frag = 1;
 	ieee->ieee802_1x = 1;	/* Default to supporting 802.1x */
 
-	INIT_LIST_HEAD(&ieee->crypt_deinit_list);
-	setup_timer(&ieee->crypt_deinit_timer, ieee80211_crypt_deinit_handler,
-			(unsigned long)ieee);
-	ieee->crypt_quiesced = 0;
-
 	spin_lock_init(&ieee->lock);
 
+	ieee->crypt_info.name = dev->name;
+	ieee->crypt_info.lock = &ieee->lock;
+	INIT_LIST_HEAD(&ieee->crypt_info.crypt_deinit_list);
+	setup_timer(&ieee->crypt_info.crypt_deinit_timer,
+			lib80211_crypt_deinit_handler,
+			(unsigned long)&ieee->crypt_info);
+	ieee->crypt_info.crypt_quiesced = 0;
+
 	ieee->wpa_enabled = 0;
 	ieee->drop_unencrypted = 0;
 	ieee->privacy_invoked = 0;
@@ -205,19 +208,19 @@ void free_ieee80211(struct net_device *dev)
 
 	int i;
 
-	ieee80211_crypt_quiescing(ieee);
-	del_timer_sync(&ieee->crypt_deinit_timer);
-	ieee80211_crypt_deinit_entries(ieee, 1);
+	lib80211_crypt_quiescing(&ieee->crypt_info);
+	del_timer_sync(&ieee->crypt_info.crypt_deinit_timer);
+	lib80211_crypt_deinit_entries(&ieee->crypt_info, 1);
 
 	for (i = 0; i < WEP_KEYS; i++) {
-		struct ieee80211_crypt_data *crypt = ieee->crypt[i];
+		struct lib80211_crypt_data *crypt = ieee->crypt_info.crypt[i];
 		if (crypt) {
 			if (crypt->ops) {
 				crypt->ops->deinit(crypt->priv);
 				module_put(crypt->ops->owner);
 			}
 			kfree(crypt);
-			ieee->crypt[i] = NULL;
+			ieee->crypt_info.crypt[i] = NULL;
 		}
 	}
 
diff --git a/net/ieee80211/ieee80211_rx.c b/net/ieee80211/ieee80211_rx.c
index d6d5317..3e6f38a 100644
--- a/net/ieee80211/ieee80211_rx.c
+++ b/net/ieee80211/ieee80211_rx.c
@@ -268,7 +268,7 @@ static int ieee80211_is_eapol_frame(struct ieee80211_device *ieee,
 /* Called only as a tasklet (software IRQ), by ieee80211_rx */
 static int
 ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
-			   struct ieee80211_crypt_data *crypt)
+			   struct lib80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_3addr *hdr;
 	int res, hdrlen;
@@ -304,7 +304,7 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 static int
 ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee,
 				struct sk_buff *skb, int keyidx,
-				struct ieee80211_crypt_data *crypt)
+				struct lib80211_crypt_data *crypt)
 {
 	struct ieee80211_hdr_3addr *hdr;
 	int res, hdrlen;
@@ -356,7 +356,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 #endif
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
-	struct ieee80211_crypt_data *crypt = NULL;
+	struct lib80211_crypt_data *crypt = NULL;
 	int keyidx = 0;
 	int can_be_decrypted = 0;
 	DECLARE_MAC_BUF(mac);
@@ -440,7 +440,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		 * is only allowed 2-bits of storage, no value of keyidx can
 		 * be provided via above code that would result in keyidx
 		 * being out of range */
-		crypt = ieee->crypt[keyidx];
+		crypt = ieee->crypt_info.crypt[keyidx];
 
 #ifdef NOT_YET
 		sta = NULL;
diff --git a/net/ieee80211/ieee80211_tx.c b/net/ieee80211/ieee80211_tx.c
index d996547..f78f57e 100644
--- a/net/ieee80211/ieee80211_tx.c
+++ b/net/ieee80211/ieee80211_tx.c
@@ -152,7 +152,8 @@ static int ieee80211_copy_snap(u8 * data, __be16 h_proto)
 static int ieee80211_encrypt_fragment(struct ieee80211_device *ieee,
 					     struct sk_buff *frag, int hdr_len)
 {
-	struct ieee80211_crypt_data *crypt = ieee->crypt[ieee->tx_keyidx];
+	struct lib80211_crypt_data *crypt =
+		ieee->crypt_info.crypt[ieee->crypt_info.tx_keyidx];
 	int res;
 
 	if (crypt == NULL)
@@ -270,7 +271,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		.qos_ctl = 0
 	};
 	u8 dest[ETH_ALEN], src[ETH_ALEN];
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	int priority = skb->priority;
 	int snapped = 0;
 
@@ -294,7 +295,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	ether_type = ((struct ethhdr *)skb->data)->h_proto;
 
-	crypt = ieee->crypt[ieee->tx_keyidx];
+	crypt = ieee->crypt_info.crypt[ieee->crypt_info.tx_keyidx];
 
 	encrypt = !(ether_type == htons(ETH_P_PAE) && ieee->ieee802_1x) &&
 	    ieee->sec.encrypt;
diff --git a/net/ieee80211/ieee80211_wx.c b/net/ieee80211/ieee80211_wx.c
index 4435523..1c4a426 100644
--- a/net/ieee80211/ieee80211_wx.c
+++ b/net/ieee80211/ieee80211_wx.c
@@ -308,7 +308,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		.flags = 0
 	};
 	int i, key, key_provided, len;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypt_data **crypt;
 	int host_crypto = ieee->host_encrypt || ieee->host_decrypt || ieee->host_build_iv;
 	DECLARE_SSID_BUF(ssid);
 
@@ -322,30 +322,30 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		key_provided = 1;
 	} else {
 		key_provided = 0;
-		key = ieee->tx_keyidx;
+		key = ieee->crypt_info.tx_keyidx;
 	}
 
 	IEEE80211_DEBUG_WX("Key: %d [%s]\n", key, key_provided ?
 			   "provided" : "default");
 
-	crypt = &ieee->crypt[key];
+	crypt = &ieee->crypt_info.crypt[key];
 
 	if (erq->flags & IW_ENCODE_DISABLED) {
 		if (key_provided && *crypt) {
 			IEEE80211_DEBUG_WX("Disabling encryption on key %d.\n",
 					   key);
-			ieee80211_crypt_delayed_deinit(ieee, crypt);
+			lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 		} else
 			IEEE80211_DEBUG_WX("Disabling encryption.\n");
 
 		/* Check all the keys to see if any are still configured,
 		 * and if no key index was provided, de-init them all */
 		for (i = 0; i < WEP_KEYS; i++) {
-			if (ieee->crypt[i] != NULL) {
+			if (ieee->crypt_info.crypt[i] != NULL) {
 				if (key_provided)
 					break;
-				ieee80211_crypt_delayed_deinit(ieee,
-							       &ieee->crypt[i]);
+				lib80211_crypt_delayed_deinit(&ieee->crypt_info,
+							       &ieee->crypt_info.crypt[i]);
 			}
 		}
 
@@ -367,21 +367,21 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 	    strcmp((*crypt)->ops->name, "WEP") != 0) {
 		/* changing to use WEP; deinit previously used algorithm
 		 * on this key */
-		ieee80211_crypt_delayed_deinit(ieee, crypt);
+		lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 	}
 
 	if (*crypt == NULL && host_crypto) {
-		struct ieee80211_crypt_data *new_crypt;
+		struct lib80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct lib80211_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
+		new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
-			request_module("ieee80211_crypt_wep");
-			new_crypt->ops = ieee80211_get_crypto_ops("WEP");
+			request_module("lib80211_crypt_wep");
+			new_crypt->ops = lib80211_get_crypto_ops("WEP");
 		}
 
 		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
@@ -392,7 +392,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 			new_crypt = NULL;
 
 			printk(KERN_WARNING "%s: could not initialize WEP: "
-			       "load module ieee80211_crypt_wep\n", dev->name);
+			       "load module lib80211_crypt_wep\n", dev->name);
 			return -EOPNOTSUPP;
 		}
 		*crypt = new_crypt;
@@ -441,7 +441,7 @@ int ieee80211_wx_set_encode(struct ieee80211_device *ieee,
 		if (key_provided) {
 			IEEE80211_DEBUG_WX("Setting key %d to default Tx "
 					   "key.\n", key);
-			ieee->tx_keyidx = key;
+			ieee->crypt_info.tx_keyidx = key;
 			sec.active_key = key;
 			sec.flags |= SEC_ACTIVE_KEY;
 		}
@@ -486,7 +486,7 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 {
 	struct iw_point *erq = &(wrqu->encoding);
 	int len, key;
-	struct ieee80211_crypt_data *crypt;
+	struct lib80211_crypt_data *crypt;
 	struct ieee80211_security *sec = &ieee->sec;
 
 	IEEE80211_DEBUG_WX("GET_ENCODE\n");
@@ -497,9 +497,9 @@ int ieee80211_wx_get_encode(struct ieee80211_device *ieee,
 			return -EINVAL;
 		key--;
 	} else
-		key = ieee->tx_keyidx;
+		key = ieee->crypt_info.tx_keyidx;
 
-	crypt = ieee->crypt[key];
+	crypt = ieee->crypt_info.crypt[key];
 	erq->flags = key + 1;
 
 	if (!sec->enabled) {
@@ -532,8 +532,8 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	int i, idx, ret = 0;
 	int group_key = 0;
 	const char *alg, *module;
-	struct ieee80211_crypto_ops *ops;
-	struct ieee80211_crypt_data **crypt;
+	struct lib80211_crypto_ops *ops;
+	struct lib80211_crypt_data **crypt;
 
 	struct ieee80211_security sec = {
 		.flags = 0,
@@ -545,17 +545,17 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 			return -EINVAL;
 		idx--;
 	} else
-		idx = ieee->tx_keyidx;
+		idx = ieee->crypt_info.tx_keyidx;
 
 	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-		crypt = &ieee->crypt[idx];
+		crypt = &ieee->crypt_info.crypt[idx];
 		group_key = 1;
 	} else {
 		/* some Cisco APs use idx>0 for unicast in dynamic WEP */
 		if (idx != 0 && ext->alg != IW_ENCODE_ALG_WEP)
 			return -EINVAL;
 		if (ieee->iw_mode == IW_MODE_INFRA)
-			crypt = &ieee->crypt[idx];
+			crypt = &ieee->crypt_info.crypt[idx];
 		else
 			return -EINVAL;
 	}
@@ -564,10 +564,10 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	if ((encoding->flags & IW_ENCODE_DISABLED) ||
 	    ext->alg == IW_ENCODE_ALG_NONE) {
 		if (*crypt)
-			ieee80211_crypt_delayed_deinit(ieee, crypt);
+			lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 
 		for (i = 0; i < WEP_KEYS; i++)
-			if (ieee->crypt[i] != NULL)
+			if (ieee->crypt_info.crypt[i] != NULL)
 				break;
 
 		if (i == WEP_KEYS) {
@@ -590,15 +590,15 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	switch (ext->alg) {
 	case IW_ENCODE_ALG_WEP:
 		alg = "WEP";
-		module = "ieee80211_crypt_wep";
+		module = "lib80211_crypt_wep";
 		break;
 	case IW_ENCODE_ALG_TKIP:
 		alg = "TKIP";
-		module = "ieee80211_crypt_tkip";
+		module = "lib80211_crypt_tkip";
 		break;
 	case IW_ENCODE_ALG_CCMP:
 		alg = "CCMP";
-		module = "ieee80211_crypt_ccmp";
+		module = "lib80211_crypt_ccmp";
 		break;
 	default:
 		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
@@ -607,10 +607,10 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 		goto done;
 	}
 
-	ops = ieee80211_get_crypto_ops(alg);
+	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
 		request_module(module);
-		ops = ieee80211_get_crypto_ops(alg);
+		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
 		IEEE80211_DEBUG_WX("%s: unknown crypto alg %d\n",
@@ -620,9 +620,9 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 	}
 
 	if (*crypt == NULL || (*crypt)->ops != ops) {
-		struct ieee80211_crypt_data *new_crypt;
+		struct lib80211_crypt_data *new_crypt;
 
-		ieee80211_crypt_delayed_deinit(ieee, crypt);
+		lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
 
 		new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
 		if (new_crypt == NULL) {
@@ -650,7 +650,7 @@ int ieee80211_wx_set_encodeext(struct ieee80211_device *ieee,
 
       skip_host_crypt:
 	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-		ieee->tx_keyidx = idx;
+		ieee->crypt_info.tx_keyidx = idx;
 		sec.active_key = idx;
 		sec.flags |= SEC_ACTIVE_KEY;
 	}
@@ -716,7 +716,7 @@ int ieee80211_wx_get_encodeext(struct ieee80211_device *ieee,
 			return -EINVAL;
 		idx--;
 	} else
-		idx = ieee->tx_keyidx;
+		idx = ieee->crypt_info.tx_keyidx;
 
 	if (!(ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) &&
 	    ext->alg != IW_ENCODE_ALG_WEP)
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index ae7f226..f7c64db 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -82,3 +82,12 @@ config LIB80211
 
 	  Drivers should select this themselves if needed.  Say Y if
 	  you want this built into your kernel.
+
+config LIB80211_CRYPT_WEP
+	tristate
+
+config LIB80211_CRYPT_CCMP
+	tristate
+
+config LIB80211_CRYPT_TKIP
+	tristate
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index d2d848d..cc547ed 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,6 +1,9 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 obj-$(CONFIG_LIB80211) += lib80211.o
+obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
+obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
+obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index e71f7d0..d681721 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -3,11 +3,23 @@
  *
  * Copyright(c) 2008 John W. Linville <linville@tuxdriver.com>
  *
+ * Portions copied from old ieee80211 component, w/ original copyright
+ * notices below:
+ *
+ * Host AP crypto routines
+ *
+ * Copyright (c) 2002-2003, Jouni Malinen <j@w1.fi>
+ * Portions Copyright (C) 2004, Intel Corporation <jketreno@linux.intel.com>
+ *
  */
 
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/ieee80211.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #include <net/lib80211.h>
 
@@ -19,6 +31,14 @@ MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR("John W. Linville <linville@tuxdriver.com>");
 MODULE_LICENSE("GPL");
 
+struct lib80211_crypto_alg {
+	struct list_head list;
+	struct lib80211_crypto_ops *ops;
+};
+
+static LIST_HEAD(lib80211_crypto_algs);
+static DEFINE_SPINLOCK(lib80211_crypto_lock);
+
 const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 {
 	const char *s = ssid;
@@ -51,15 +71,176 @@ const char *print_ssid(char *buf, const char *ssid, u8 ssid_len)
 }
 EXPORT_SYMBOL(print_ssid);
 
-static int __init ieee80211_init(void)
+void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info, int force)
 {
-	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION "\n");
+	struct lib80211_crypt_data *entry, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(info->lock, flags);
+	list_for_each_entry_safe(entry, next, &info->crypt_deinit_list, list) {
+		if (atomic_read(&entry->refcnt) != 0 && !force)
+			continue;
+
+		list_del(&entry->list);
+
+		if (entry->ops) {
+			entry->ops->deinit(entry->priv);
+			module_put(entry->ops->owner);
+		}
+		kfree(entry);
+	}
+	spin_unlock_irqrestore(info->lock, flags);
+}
+EXPORT_SYMBOL(lib80211_crypt_deinit_entries);
+
+/* After this, crypt_deinit_list won't accept new members */
+void lib80211_crypt_quiescing(struct lib80211_crypt_info *info)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(info->lock, flags);
+	info->crypt_quiesced = 1;
+	spin_unlock_irqrestore(info->lock, flags);
+}
+EXPORT_SYMBOL(lib80211_crypt_quiescing);
+
+void lib80211_crypt_deinit_handler(unsigned long data)
+{
+	struct lib80211_crypt_info *info = (struct lib80211_crypt_info *)data;
+	unsigned long flags;
+
+	lib80211_crypt_deinit_entries(info, 0);
+
+	spin_lock_irqsave(info->lock, flags);
+	if (!list_empty(&info->crypt_deinit_list) && !info->crypt_quiesced) {
+		printk(KERN_DEBUG "%s: entries remaining in delayed crypt "
+		       "deletion list\n", info->name);
+		info->crypt_deinit_timer.expires = jiffies + HZ;
+		add_timer(&info->crypt_deinit_timer);
+	}
+	spin_unlock_irqrestore(info->lock, flags);
+}
+EXPORT_SYMBOL(lib80211_crypt_deinit_handler);
+
+void lib80211_crypt_delayed_deinit(struct lib80211_crypt_info *info,
+				    struct lib80211_crypt_data **crypt)
+{
+	struct lib80211_crypt_data *tmp;
+	unsigned long flags;
+
+	if (*crypt == NULL)
+		return;
+
+	tmp = *crypt;
+	*crypt = NULL;
+
+	/* must not run ops->deinit() while there may be pending encrypt or
+	 * decrypt operations. Use a list of delayed deinits to avoid needing
+	 * locking. */
+
+	spin_lock_irqsave(info->lock, flags);
+	if (!info->crypt_quiesced) {
+		list_add(&tmp->list, &info->crypt_deinit_list);
+		if (!timer_pending(&info->crypt_deinit_timer)) {
+			info->crypt_deinit_timer.expires = jiffies + HZ;
+			add_timer(&info->crypt_deinit_timer);
+		}
+	}
+	spin_unlock_irqrestore(info->lock, flags);
+}
+EXPORT_SYMBOL(lib80211_crypt_delayed_deinit);
+
+int lib80211_register_crypto_ops(struct lib80211_crypto_ops *ops)
+{
+	unsigned long flags;
+	struct lib80211_crypto_alg *alg;
+
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
+	if (alg == NULL)
+		return -ENOMEM;
+
+	alg->ops = ops;
+
+	spin_lock_irqsave(&lib80211_crypto_lock, flags);
+	list_add(&alg->list, &lib80211_crypto_algs);
+	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
+
+	printk(KERN_DEBUG "lib80211_crypt: registered algorithm '%s'\n",
+	       ops->name);
+
+	return 0;
+}
+EXPORT_SYMBOL(lib80211_register_crypto_ops);
+
+int lib80211_unregister_crypto_ops(struct lib80211_crypto_ops *ops)
+{
+	struct lib80211_crypto_alg *alg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lib80211_crypto_lock, flags);
+	list_for_each_entry(alg, &lib80211_crypto_algs, list) {
+		if (alg->ops == ops)
+			goto found;
+	}
+	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
+	return -EINVAL;
+
+      found:
+	printk(KERN_DEBUG "lib80211_crypt: unregistered algorithm "
+	       "'%s'\n", ops->name);
+	list_del(&alg->list);
+	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
+	kfree(alg);
 	return 0;
 }
+EXPORT_SYMBOL(lib80211_unregister_crypto_ops);
+
+struct lib80211_crypto_ops *lib80211_get_crypto_ops(const char *name)
+{
+	struct lib80211_crypto_alg *alg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lib80211_crypto_lock, flags);
+	list_for_each_entry(alg, &lib80211_crypto_algs, list) {
+		if (strcmp(alg->ops->name, name) == 0)
+			goto found;
+	}
+	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
+	return NULL;
+
+      found:
+	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
+	return alg->ops;
+}
+EXPORT_SYMBOL(lib80211_get_crypto_ops);
+
+static void *lib80211_crypt_null_init(int keyidx)
+{
+	return (void *)1;
+}
+
+static void lib80211_crypt_null_deinit(void *priv)
+{
+}
+
+static struct lib80211_crypto_ops lib80211_crypt_null = {
+	.name = "NULL",
+	.init = lib80211_crypt_null_init,
+	.deinit = lib80211_crypt_null_deinit,
+	.owner = THIS_MODULE,
+};
+
+static int __init lib80211_init(void)
+{
+	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION "\n");
+	return lib80211_register_crypto_ops(&lib80211_crypt_null);
+}
 
-static void __exit ieee80211_exit(void)
+static void __exit lib80211_exit(void)
 {
+	lib80211_unregister_crypto_ops(&lib80211_crypt_null);
+	BUG_ON(!list_empty(&lib80211_crypto_algs));
 }
 
-module_init(ieee80211_init);
-module_exit(ieee80211_exit);
+module_init(lib80211_init);
+module_exit(lib80211_exit);
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
similarity index 77%
rename from net/ieee80211/ieee80211_crypt_ccmp.c
rename to net/wireless/lib80211_crypt_ccmp.c
index 208bf35..b8f16ae 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -1,7 +1,8 @@
 /*
- * Host AP crypt: host-based CCMP encryption implementation for Host AP driver
+ * lib80211 crypt: host-based CCMP encryption implementation for lib80211
  *
  * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
+ * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,10 +23,12 @@
 #include <asm/string.h>
 #include <linux/wireless.h>
 
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 
 #include <linux/crypto.h>
 
+#include <net/lib80211.h>
+
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: CCMP");
 MODULE_LICENSE("GPL");
@@ -36,7 +39,7 @@ MODULE_LICENSE("GPL");
 #define CCMP_TK_LEN 16
 #define CCMP_PN_LEN 6
 
-struct ieee80211_ccmp_data {
+struct lib80211_ccmp_data {
 	u8 key[CCMP_TK_LEN];
 	int key_set;
 
@@ -57,15 +60,15 @@ struct ieee80211_ccmp_data {
 	u8 rx_b0[AES_BLOCK_LEN], rx_b[AES_BLOCK_LEN], rx_a[AES_BLOCK_LEN];
 };
 
-static inline void ieee80211_ccmp_aes_encrypt(struct crypto_cipher *tfm,
+static inline void lib80211_ccmp_aes_encrypt(struct crypto_cipher *tfm,
 					      const u8 pt[16], u8 ct[16])
 {
 	crypto_cipher_encrypt_one(tfm, ct, pt);
 }
 
-static void *ieee80211_ccmp_init(int key_idx)
+static void *lib80211_ccmp_init(int key_idx)
 {
-	struct ieee80211_ccmp_data *priv;
+	struct lib80211_ccmp_data *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
@@ -74,7 +77,7 @@ static void *ieee80211_ccmp_init(int key_idx)
 
 	priv->tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tfm)) {
-		printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_ccmp: could not allocate "
 		       "crypto API aes\n");
 		priv->tfm = NULL;
 		goto fail;
@@ -92,9 +95,9 @@ static void *ieee80211_ccmp_init(int key_idx)
 	return NULL;
 }
 
-static void ieee80211_ccmp_deinit(void *priv)
+static void lib80211_ccmp_deinit(void *priv)
 {
-	struct ieee80211_ccmp_data *_priv = priv;
+	struct lib80211_ccmp_data *_priv = priv;
 	if (_priv && _priv->tfm)
 		crypto_free_cipher(_priv->tfm);
 	kfree(priv);
@@ -108,20 +111,17 @@ static inline void xor_block(u8 * b, u8 * a, size_t len)
 }
 
 static void ccmp_init_blocks(struct crypto_cipher *tfm,
-			     struct ieee80211_hdr_4addr *hdr,
+			     struct ieee80211_hdr *hdr,
 			     u8 * pn, size_t dlen, u8 * b0, u8 * auth, u8 * s0)
 {
 	u8 *pos, qc = 0;
 	size_t aad_len;
-	u16 fc;
 	int a4_included, qc_included;
 	u8 aad[2 * AES_BLOCK_LEN];
 
-	fc = le16_to_cpu(hdr->frame_ctl);
-	a4_included = ((fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		       (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS));
-	qc_included = ((WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_DATA) &&
-		       (WLAN_FC_GET_STYPE(fc) & IEEE80211_STYPE_QOS_DATA));
+	a4_included = ieee80211_has_a4(hdr->frame_control);
+	qc_included = ieee80211_is_data_qos(hdr->frame_control);
+
 	aad_len = 22;
 	if (a4_included)
 		aad_len += 6;
@@ -158,7 +158,7 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
 	aad[2] = pos[0] & 0x8f;
 	aad[3] = pos[1] & 0xc7;
 	memcpy(aad + 4, hdr->addr1, 3 * ETH_ALEN);
-	pos = (u8 *) & hdr->seq_ctl;
+	pos = (u8 *) & hdr->seq_ctrl;
 	aad[22] = pos[0] & 0x0f;
 	aad[23] = 0;		/* all bits masked */
 	memset(aad + 24, 0, 8);
@@ -170,20 +170,20 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
 	}
 
 	/* Start with the first block and AAD */
-	ieee80211_ccmp_aes_encrypt(tfm, b0, auth);
+	lib80211_ccmp_aes_encrypt(tfm, b0, auth);
 	xor_block(auth, aad, AES_BLOCK_LEN);
-	ieee80211_ccmp_aes_encrypt(tfm, auth, auth);
+	lib80211_ccmp_aes_encrypt(tfm, auth, auth);
 	xor_block(auth, &aad[AES_BLOCK_LEN], AES_BLOCK_LEN);
-	ieee80211_ccmp_aes_encrypt(tfm, auth, auth);
+	lib80211_ccmp_aes_encrypt(tfm, auth, auth);
 	b0[0] &= 0x07;
 	b0[14] = b0[15] = 0;
-	ieee80211_ccmp_aes_encrypt(tfm, b0, s0);
+	lib80211_ccmp_aes_encrypt(tfm, b0, s0);
 }
 
-static int ieee80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
+static int lib80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
 			      u8 *aeskey, int keylen, void *priv)
 {
-	struct ieee80211_ccmp_data *key = priv;
+	struct lib80211_ccmp_data *key = priv;
 	int i;
 	u8 *pos;
 
@@ -217,12 +217,12 @@ static int ieee80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
 	return CCMP_HDR_LEN;
 }
 
-static int ieee80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct ieee80211_ccmp_data *key = priv;
+	struct lib80211_ccmp_data *key = priv;
 	int data_len, i, blocks, last, len;
 	u8 *pos, *mic;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u8 *b0 = key->tx_b0;
 	u8 *b = key->tx_b;
 	u8 *e = key->tx_e;
@@ -232,13 +232,13 @@ static int ieee80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		return -1;
 
 	data_len = skb->len - hdr_len;
-	len = ieee80211_ccmp_hdr(skb, hdr_len, NULL, 0, priv);
+	len = lib80211_ccmp_hdr(skb, hdr_len, NULL, 0, priv);
 	if (len < 0)
 		return -1;
 
 	pos = skb->data + hdr_len + CCMP_HDR_LEN;
 	mic = skb_put(skb, CCMP_MIC_LEN);
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 	ccmp_init_blocks(key->tfm, hdr, key->tx_pn, data_len, b0, b, s0);
 
 	blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
@@ -248,11 +248,11 @@ static int ieee80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		len = (i == blocks && last) ? last : AES_BLOCK_LEN;
 		/* Authentication */
 		xor_block(b, pos, len);
-		ieee80211_ccmp_aes_encrypt(key->tfm, b, b);
+		lib80211_ccmp_aes_encrypt(key->tfm, b, b);
 		/* Encryption, with counter */
 		b0[14] = (i >> 8) & 0xff;
 		b0[15] = i & 0xff;
-		ieee80211_ccmp_aes_encrypt(key->tfm, b0, e);
+		lib80211_ccmp_aes_encrypt(key->tfm, b0, e);
 		xor_block(pos, e, len);
 		pos += len;
 	}
@@ -284,11 +284,11 @@ static inline int ccmp_replay_check(u8 *pn_n, u8 *pn_o)
 	return 0;
 }
 
-static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct ieee80211_ccmp_data *key = priv;
+	struct lib80211_ccmp_data *key = priv;
 	u8 keyidx, *pos;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u8 *b0 = key->rx_b0;
 	u8 *b = key->rx_b;
 	u8 *a = key->rx_a;
@@ -303,7 +303,7 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		return -1;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 	pos = skb->data + hdr_len;
 	keyidx = pos[3];
 	if (!(keyidx & (1 << 5))) {
@@ -338,8 +338,8 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (ccmp_replay_check(pn, key->rx_pn)) {
-		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
-			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=%s "
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "CCMP: replay detected: STA=%s "
 				 "previous PN %02x%02x%02x%02x%02x%02x "
 				 "received PN %02x%02x%02x%02x%02x%02x\n",
 				 print_mac(mac, hdr->addr2),
@@ -362,11 +362,11 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		/* Decrypt, with counter */
 		b0[14] = (i >> 8) & 0xff;
 		b0[15] = i & 0xff;
-		ieee80211_ccmp_aes_encrypt(key->tfm, b0, b);
+		lib80211_ccmp_aes_encrypt(key->tfm, b0, b);
 		xor_block(pos, b, len);
 		/* Authentication */
 		xor_block(a, pos, len);
-		ieee80211_ccmp_aes_encrypt(key->tfm, a, a);
+		lib80211_ccmp_aes_encrypt(key->tfm, a, a);
 		pos += len;
 	}
 
@@ -389,9 +389,9 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	return keyidx;
 }
 
-static int ieee80211_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct ieee80211_ccmp_data *data = priv;
+	struct lib80211_ccmp_data *data = priv;
 	int keyidx;
 	struct crypto_cipher *tfm = data->tfm;
 
@@ -419,9 +419,9 @@ static int ieee80211_ccmp_set_key(void *key, int len, u8 * seq, void *priv)
 	return 0;
 }
 
-static int ieee80211_ccmp_get_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_ccmp_get_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct ieee80211_ccmp_data *data = priv;
+	struct lib80211_ccmp_data *data = priv;
 
 	if (len < CCMP_TK_LEN)
 		return -1;
@@ -442,9 +442,9 @@ static int ieee80211_ccmp_get_key(void *key, int len, u8 * seq, void *priv)
 	return CCMP_TK_LEN;
 }
 
-static char *ieee80211_ccmp_print_stats(char *p, void *priv)
+static char *lib80211_ccmp_print_stats(char *p, void *priv)
 {
-	struct ieee80211_ccmp_data *ccmp = priv;
+	struct lib80211_ccmp_data *ccmp = priv;
 
 	p += sprintf(p, "key[%d] alg=CCMP key_set=%d "
 		     "tx_pn=%02x%02x%02x%02x%02x%02x "
@@ -462,32 +462,32 @@ static char *ieee80211_ccmp_print_stats(char *p, void *priv)
 	return p;
 }
 
-static struct ieee80211_crypto_ops ieee80211_crypt_ccmp = {
+static struct lib80211_crypto_ops lib80211_crypt_ccmp = {
 	.name = "CCMP",
-	.init = ieee80211_ccmp_init,
-	.deinit = ieee80211_ccmp_deinit,
-	.build_iv = ieee80211_ccmp_hdr,
-	.encrypt_mpdu = ieee80211_ccmp_encrypt,
-	.decrypt_mpdu = ieee80211_ccmp_decrypt,
+	.init = lib80211_ccmp_init,
+	.deinit = lib80211_ccmp_deinit,
+	.build_iv = lib80211_ccmp_hdr,
+	.encrypt_mpdu = lib80211_ccmp_encrypt,
+	.decrypt_mpdu = lib80211_ccmp_decrypt,
 	.encrypt_msdu = NULL,
 	.decrypt_msdu = NULL,
-	.set_key = ieee80211_ccmp_set_key,
-	.get_key = ieee80211_ccmp_get_key,
-	.print_stats = ieee80211_ccmp_print_stats,
+	.set_key = lib80211_ccmp_set_key,
+	.get_key = lib80211_ccmp_get_key,
+	.print_stats = lib80211_ccmp_print_stats,
 	.extra_mpdu_prefix_len = CCMP_HDR_LEN,
 	.extra_mpdu_postfix_len = CCMP_MIC_LEN,
 	.owner = THIS_MODULE,
 };
 
-static int __init ieee80211_crypto_ccmp_init(void)
+static int __init lib80211_crypto_ccmp_init(void)
 {
-	return ieee80211_register_crypto_ops(&ieee80211_crypt_ccmp);
+	return lib80211_register_crypto_ops(&lib80211_crypt_ccmp);
 }
 
-static void __exit ieee80211_crypto_ccmp_exit(void)
+static void __exit lib80211_crypto_ccmp_exit(void)
 {
-	ieee80211_unregister_crypto_ops(&ieee80211_crypt_ccmp);
+	lib80211_unregister_crypto_ops(&lib80211_crypt_ccmp);
 }
 
-module_init(ieee80211_crypto_ccmp_init);
-module_exit(ieee80211_crypto_ccmp_exit);
+module_init(lib80211_crypto_ccmp_init);
+module_exit(lib80211_crypto_ccmp_exit);
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
similarity index 82%
rename from net/ieee80211/ieee80211_crypt_tkip.c
rename to net/wireless/lib80211_crypt_tkip.c
index bba0152..d6b7250 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -1,7 +1,8 @@
 /*
- * Host AP crypt: host-based TKIP encryption implementation for Host AP driver
+ * lib80211 crypt: host-based TKIP encryption implementation for lib80211
  *
  * Copyright (c) 2003-2004, Jouni Malinen <j@w1.fi>
+ * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -22,16 +23,20 @@
 #include <linux/if_arp.h>
 #include <asm/string.h>
 
-#include <net/ieee80211.h>
+#include <linux/wireless.h>
+#include <linux/ieee80211.h>
+#include <net/iw_handler.h>
 
 #include <linux/crypto.h>
 #include <linux/crc32.h>
 
+#include <net/lib80211.h>
+
 MODULE_AUTHOR("Jouni Malinen");
-MODULE_DESCRIPTION("Host AP crypt: TKIP");
+MODULE_DESCRIPTION("lib80211 crypt: TKIP");
 MODULE_LICENSE("GPL");
 
-struct ieee80211_tkip_data {
+struct lib80211_tkip_data {
 #define TKIP_KEY_LEN 32
 	u8 key[TKIP_KEY_LEN];
 	int key_set;
@@ -65,23 +70,23 @@ struct ieee80211_tkip_data {
 	unsigned long flags;
 };
 
-static unsigned long ieee80211_tkip_set_flags(unsigned long flags, void *priv)
+static unsigned long lib80211_tkip_set_flags(unsigned long flags, void *priv)
 {
-	struct ieee80211_tkip_data *_priv = priv;
+	struct lib80211_tkip_data *_priv = priv;
 	unsigned long old_flags = _priv->flags;
 	_priv->flags = flags;
 	return old_flags;
 }
 
-static unsigned long ieee80211_tkip_get_flags(void *priv)
+static unsigned long lib80211_tkip_get_flags(void *priv)
 {
-	struct ieee80211_tkip_data *_priv = priv;
+	struct lib80211_tkip_data *_priv = priv;
 	return _priv->flags;
 }
 
-static void *ieee80211_tkip_init(int key_idx)
+static void *lib80211_tkip_init(int key_idx)
 {
-	struct ieee80211_tkip_data *priv;
+	struct lib80211_tkip_data *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
@@ -92,7 +97,7 @@ static void *ieee80211_tkip_init(int key_idx)
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
 		       "crypto API arc4\n");
 		priv->tx_tfm_arc4 = NULL;
 		goto fail;
@@ -101,7 +106,7 @@ static void *ieee80211_tkip_init(int key_idx)
 	priv->tx_tfm_michael = crypto_alloc_hash("michael_mic", 0,
 						 CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_michael)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
 		       "crypto API michael_mic\n");
 		priv->tx_tfm_michael = NULL;
 		goto fail;
@@ -110,7 +115,7 @@ static void *ieee80211_tkip_init(int key_idx)
 	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
 		       "crypto API arc4\n");
 		priv->rx_tfm_arc4 = NULL;
 		goto fail;
@@ -119,7 +124,7 @@ static void *ieee80211_tkip_init(int key_idx)
 	priv->rx_tfm_michael = crypto_alloc_hash("michael_mic", 0,
 						 CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_michael)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
 		       "crypto API michael_mic\n");
 		priv->rx_tfm_michael = NULL;
 		goto fail;
@@ -143,9 +148,9 @@ static void *ieee80211_tkip_init(int key_idx)
 	return NULL;
 }
 
-static void ieee80211_tkip_deinit(void *priv)
+static void lib80211_tkip_deinit(void *priv)
 {
-	struct ieee80211_tkip_data *_priv = priv;
+	struct lib80211_tkip_data *_priv = priv;
 	if (_priv) {
 		if (_priv->tx_tfm_michael)
 			crypto_free_hash(_priv->tx_tfm_michael);
@@ -305,15 +310,15 @@ static void tkip_mixing_phase2(u8 * WEPSeed, const u8 * TK, const u16 * TTAK,
 #endif
 }
 
-static int ieee80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
+static int lib80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 			      u8 * rc4key, int keylen, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	int len;
 	u8 *pos;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (skb_headroom(skb) < 8 || skb->len < hdr_len)
 		return -1;
@@ -351,9 +356,9 @@ static int ieee80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 	return 8;
 }
 
-static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->tx_tfm_arc4 };
 	int len;
 	u8 rc4key[16], *pos, *icv;
@@ -363,8 +368,8 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (tkey->flags & IEEE80211_CRYPTO_TKIP_COUNTERMEASURES) {
 		if (net_ratelimit()) {
-			struct ieee80211_hdr_4addr *hdr =
-			    (struct ieee80211_hdr_4addr *)skb->data;
+			struct ieee80211_hdr *hdr =
+			    (struct ieee80211_hdr *)skb->data;
 			printk(KERN_DEBUG ": TKIP countermeasures: dropped "
 			       "TX packet to %s\n",
 			       print_mac(mac, hdr->addr1));
@@ -378,7 +383,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	len = skb->len - hdr_len;
 	pos = skb->data + hdr_len;
 
-	if ((ieee80211_tkip_hdr(skb, hdr_len, rc4key, 16, priv)) < 0)
+	if ((lib80211_tkip_hdr(skb, hdr_len, rc4key, 16, priv)) < 0)
 		return -1;
 
 	icv = skb_put(skb, 4);
@@ -407,22 +412,22 @@ static inline int tkip_replay_check(u32 iv32_n, u16 iv16_n,
 	return 0;
 }
 
-static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->rx_tfm_arc4 };
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
 	u16 iv16;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr *hdr;
 	u8 icv[4];
 	u32 crc;
 	struct scatterlist sg;
 	int plen;
 	DECLARE_MAC_BUF(mac);
 
-	hdr = (struct ieee80211_hdr_4addr *)skb->data;
+	hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (tkey->flags & IEEE80211_CRYPTO_TKIP_COUNTERMEASURES) {
 		if (net_ratelimit()) {
@@ -464,8 +469,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
-		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
-			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=%s"
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "TKIP: replay detected: STA=%s"
 			       " previous TSC %08x%04x received TSC "
 			       "%08x%04x\n", print_mac(mac, hdr->addr2),
 			       tkey->rx_iv32, tkey->rx_iv16, iv32, iv16);
@@ -504,8 +509,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			 * it needs to be recalculated for the next packet. */
 			tkey->rx_phase1_done = 0;
 		}
-		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
-			IEEE80211_DEBUG_DROP("TKIP: ICV error detected: STA="
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "TKIP: ICV error detected: STA="
 			       "%s\n", print_mac(mac, hdr->addr2));
 		}
 		tkey->dot11RSNAStatsTKIPICVErrors++;
@@ -549,13 +554,11 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
 
 static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
 {
-	struct ieee80211_hdr_4addr *hdr11;
-	u16 stype;
+	struct ieee80211_hdr *hdr11;
 
-	hdr11 = (struct ieee80211_hdr_4addr *)skb->data;
-	stype  = WLAN_FC_GET_STYPE(le16_to_cpu(hdr11->frame_ctl));
+	hdr11 = (struct ieee80211_hdr *)skb->data;
 
-	switch (le16_to_cpu(hdr11->frame_ctl) &
+	switch (le16_to_cpu(hdr11->frame_control) &
 		(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
 	case IEEE80211_FCTL_TODS:
 		memcpy(hdr, hdr11->addr3, ETH_ALEN);	/* DA */
@@ -575,20 +578,19 @@ static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
 		break;
 	}
 
-	if (stype & IEEE80211_STYPE_QOS_DATA) {
-		const struct ieee80211_hdr_3addrqos *qoshdr =
-			(struct ieee80211_hdr_3addrqos *)skb->data;
-		hdr[12] = le16_to_cpu(qoshdr->qos_ctl) & IEEE80211_QCTL_TID;
+	if (ieee80211_is_data_qos(hdr11->frame_control)) {
+		hdr[12] = le16_to_cpu(*ieee80211_get_qos_ctl(hdr11))
+			& IEEE80211_QOS_CTL_TID_MASK;
 	} else
 		hdr[12] = 0;		/* priority */
 
 	hdr[13] = hdr[14] = hdr[15] = 0;	/* reserved */
 }
 
-static int ieee80211_michael_mic_add(struct sk_buff *skb, int hdr_len,
+static int lib80211_michael_mic_add(struct sk_buff *skb, int hdr_len,
 				     void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	u8 *pos;
 
 	if (skb_tailroom(skb) < 8 || skb->len < hdr_len) {
@@ -607,8 +609,8 @@ static int ieee80211_michael_mic_add(struct sk_buff *skb, int hdr_len,
 	return 0;
 }
 
-static void ieee80211_michael_mic_failure(struct net_device *dev,
-					  struct ieee80211_hdr_4addr *hdr,
+static void lib80211_michael_mic_failure(struct net_device *dev,
+					  struct ieee80211_hdr *hdr,
 					  int keyidx)
 {
 	union iwreq_data wrqu;
@@ -628,10 +630,10 @@ static void ieee80211_michael_mic_failure(struct net_device *dev,
 	wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu, (char *)&ev);
 }
 
-static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
+static int lib80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 					int hdr_len, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	u8 mic[8];
 	DECLARE_MAC_BUF(mac);
 
@@ -643,14 +645,14 @@ static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 			skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
 		return -1;
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
-		struct ieee80211_hdr_4addr *hdr;
-		hdr = (struct ieee80211_hdr_4addr *)skb->data;
+		struct ieee80211_hdr *hdr;
+		hdr = (struct ieee80211_hdr *)skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
 		       "MSDU from %s keyidx=%d\n",
 		       skb->dev ? skb->dev->name : "N/A", print_mac(mac, hdr->addr2),
 		       keyidx);
 		if (skb->dev)
-			ieee80211_michael_mic_failure(skb->dev, hdr, keyidx);
+			lib80211_michael_mic_failure(skb->dev, hdr, keyidx);
 		tkey->dot11RSNAStatsTKIPLocalMICFailures++;
 		return -1;
 	}
@@ -665,9 +667,9 @@ static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 	return 0;
 }
 
-static int ieee80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_hash *tfm = tkey->tx_tfm_michael;
 	struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
@@ -698,9 +700,9 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
 	return 0;
 }
 
-static int ieee80211_tkip_get_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_tkip_get_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct ieee80211_tkip_data *tkey = priv;
+	struct lib80211_tkip_data *tkey = priv;
 
 	if (len < TKIP_KEY_LEN)
 		return -1;
@@ -727,9 +729,9 @@ static int ieee80211_tkip_get_key(void *key, int len, u8 * seq, void *priv)
 	return TKIP_KEY_LEN;
 }
 
-static char *ieee80211_tkip_print_stats(char *p, void *priv)
+static char *lib80211_tkip_print_stats(char *p, void *priv)
 {
-	struct ieee80211_tkip_data *tkip = priv;
+	struct lib80211_tkip_data *tkip = priv;
 	p += sprintf(p, "key[%d] alg=TKIP key_set=%d "
 		     "tx_pn=%02x%02x%02x%02x%02x%02x "
 		     "rx_pn=%02x%02x%02x%02x%02x%02x "
@@ -753,35 +755,35 @@ static char *ieee80211_tkip_print_stats(char *p, void *priv)
 	return p;
 }
 
-static struct ieee80211_crypto_ops ieee80211_crypt_tkip = {
+static struct lib80211_crypto_ops lib80211_crypt_tkip = {
 	.name = "TKIP",
-	.init = ieee80211_tkip_init,
-	.deinit = ieee80211_tkip_deinit,
-	.build_iv = ieee80211_tkip_hdr,
-	.encrypt_mpdu = ieee80211_tkip_encrypt,
-	.decrypt_mpdu = ieee80211_tkip_decrypt,
-	.encrypt_msdu = ieee80211_michael_mic_add,
-	.decrypt_msdu = ieee80211_michael_mic_verify,
-	.set_key = ieee80211_tkip_set_key,
-	.get_key = ieee80211_tkip_get_key,
-	.print_stats = ieee80211_tkip_print_stats,
+	.init = lib80211_tkip_init,
+	.deinit = lib80211_tkip_deinit,
+	.build_iv = lib80211_tkip_hdr,
+	.encrypt_mpdu = lib80211_tkip_encrypt,
+	.decrypt_mpdu = lib80211_tkip_decrypt,
+	.encrypt_msdu = lib80211_michael_mic_add,
+	.decrypt_msdu = lib80211_michael_mic_verify,
+	.set_key = lib80211_tkip_set_key,
+	.get_key = lib80211_tkip_get_key,
+	.print_stats = lib80211_tkip_print_stats,
 	.extra_mpdu_prefix_len = 4 + 4,	/* IV + ExtIV */
 	.extra_mpdu_postfix_len = 4,	/* ICV */
 	.extra_msdu_postfix_len = 8,	/* MIC */
-	.get_flags = ieee80211_tkip_get_flags,
-	.set_flags = ieee80211_tkip_set_flags,
+	.get_flags = lib80211_tkip_get_flags,
+	.set_flags = lib80211_tkip_set_flags,
 	.owner = THIS_MODULE,
 };
 
-static int __init ieee80211_crypto_tkip_init(void)
+static int __init lib80211_crypto_tkip_init(void)
 {
-	return ieee80211_register_crypto_ops(&ieee80211_crypt_tkip);
+	return lib80211_register_crypto_ops(&lib80211_crypt_tkip);
 }
 
-static void __exit ieee80211_crypto_tkip_exit(void)
+static void __exit lib80211_crypto_tkip_exit(void)
 {
-	ieee80211_unregister_crypto_ops(&ieee80211_crypt_tkip);
+	lib80211_unregister_crypto_ops(&lib80211_crypt_tkip);
 }
 
-module_init(ieee80211_crypto_tkip_init);
-module_exit(ieee80211_crypto_tkip_exit);
+module_init(lib80211_crypto_tkip_init);
+module_exit(lib80211_crypto_tkip_exit);
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
similarity index 74%
rename from net/ieee80211/ieee80211_crypt_wep.c
rename to net/wireless/lib80211_crypt_wep.c
index 3fa30c4..6d41e05 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -1,7 +1,8 @@
 /*
- * Host AP crypt: host-based WEP encryption implementation for Host AP driver
+ * lib80211 crypt: host-based WEP encryption implementation for lib80211
  *
  * Copyright (c) 2002-2004, Jouni Malinen <j@w1.fi>
+ * Copyright (c) 2008, John W. Linville <linville@tuxdriver.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,16 +20,16 @@
 #include <linux/mm.h>
 #include <asm/string.h>
 
-#include <net/ieee80211.h>
+#include <net/lib80211.h>
 
 #include <linux/crypto.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
-MODULE_DESCRIPTION("Host AP crypt: WEP");
+MODULE_DESCRIPTION("lib80211 crypt: WEP");
 MODULE_LICENSE("GPL");
 
-struct prism2_wep_data {
+struct lib80211_wep_data {
 	u32 iv;
 #define WEP_KEY_LEN 13
 	u8 key[WEP_KEY_LEN + 1];
@@ -38,9 +39,9 @@ struct prism2_wep_data {
 	struct crypto_blkcipher *rx_tfm;
 };
 
-static void *prism2_wep_init(int keyidx)
+static void *lib80211_wep_init(int keyidx)
 {
-	struct prism2_wep_data *priv;
+	struct lib80211_wep_data *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
@@ -49,7 +50,7 @@ static void *prism2_wep_init(int keyidx)
 
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm)) {
-		printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");
 		priv->tx_tfm = NULL;
 		goto fail;
@@ -57,7 +58,7 @@ static void *prism2_wep_init(int keyidx)
 
 	priv->rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm)) {
-		printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
+		printk(KERN_DEBUG "lib80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");
 		priv->rx_tfm = NULL;
 		goto fail;
@@ -78,9 +79,9 @@ static void *prism2_wep_init(int keyidx)
 	return NULL;
 }
 
-static void prism2_wep_deinit(void *priv)
+static void lib80211_wep_deinit(void *priv)
 {
-	struct prism2_wep_data *_priv = priv;
+	struct lib80211_wep_data *_priv = priv;
 	if (_priv) {
 		if (_priv->tx_tfm)
 			crypto_free_blkcipher(_priv->tx_tfm);
@@ -91,10 +92,10 @@ static void prism2_wep_deinit(void *priv)
 }
 
 /* Add WEP IV/key info to a frame that has at least 4 bytes of headroom */
-static int prism2_wep_build_iv(struct sk_buff *skb, int hdr_len,
+static int lib80211_wep_build_iv(struct sk_buff *skb, int hdr_len,
 			       u8 *key, int keylen, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 	u32 klen, len;
 	u8 *pos;
 
@@ -134,21 +135,21 @@ static int prism2_wep_build_iv(struct sk_buff *skb, int hdr_len,
  *
  * WEP frame payload: IV + TX key idx, RC4(data), ICV = RC4(CRC32(data))
  */
-static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 	struct blkcipher_desc desc = { .tfm = wep->tx_tfm };
 	u32 crc, klen, len;
 	u8 *pos, *icv;
 	struct scatterlist sg;
 	u8 key[WEP_KEY_LEN + 3];
 
-	/* other checks are in prism2_wep_build_iv */
+	/* other checks are in lib80211_wep_build_iv */
 	if (skb_tailroom(skb) < 4)
 		return -1;
 
 	/* add the IV to the frame */
-	if (prism2_wep_build_iv(skb, hdr_len, NULL, 0, priv))
+	if (lib80211_wep_build_iv(skb, hdr_len, NULL, 0, priv))
 		return -1;
 
 	/* Copy the IV into the first 3 bytes of the key */
@@ -181,9 +182,9 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
  * Returns 0 if frame was decrypted successfully and ICV was correct and -1 on
  * failure. If frame is OK, IV and ICV will be removed.
  */
-static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
+static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 	struct blkcipher_desc desc = { .tfm = wep->rx_tfm };
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
@@ -232,9 +233,9 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	return 0;
 }
 
-static int prism2_wep_set_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_wep_set_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 
 	if (len < 0 || len > WEP_KEY_LEN)
 		return -1;
@@ -245,9 +246,9 @@ static int prism2_wep_set_key(void *key, int len, u8 * seq, void *priv)
 	return 0;
 }
 
-static int prism2_wep_get_key(void *key, int len, u8 * seq, void *priv)
+static int lib80211_wep_get_key(void *key, int len, u8 * seq, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 
 	if (len < wep->key_len)
 		return -1;
@@ -257,39 +258,39 @@ static int prism2_wep_get_key(void *key, int len, u8 * seq, void *priv)
 	return wep->key_len;
 }
 
-static char *prism2_wep_print_stats(char *p, void *priv)
+static char *lib80211_wep_print_stats(char *p, void *priv)
 {
-	struct prism2_wep_data *wep = priv;
+	struct lib80211_wep_data *wep = priv;
 	p += sprintf(p, "key[%d] alg=WEP len=%d\n", wep->key_idx, wep->key_len);
 	return p;
 }
 
-static struct ieee80211_crypto_ops ieee80211_crypt_wep = {
+static struct lib80211_crypto_ops lib80211_crypt_wep = {
 	.name = "WEP",
-	.init = prism2_wep_init,
-	.deinit = prism2_wep_deinit,
-	.build_iv = prism2_wep_build_iv,
-	.encrypt_mpdu = prism2_wep_encrypt,
-	.decrypt_mpdu = prism2_wep_decrypt,
+	.init = lib80211_wep_init,
+	.deinit = lib80211_wep_deinit,
+	.build_iv = lib80211_wep_build_iv,
+	.encrypt_mpdu = lib80211_wep_encrypt,
+	.decrypt_mpdu = lib80211_wep_decrypt,
 	.encrypt_msdu = NULL,
 	.decrypt_msdu = NULL,
-	.set_key = prism2_wep_set_key,
-	.get_key = prism2_wep_get_key,
-	.print_stats = prism2_wep_print_stats,
+	.set_key = lib80211_wep_set_key,
+	.get_key = lib80211_wep_get_key,
+	.print_stats = lib80211_wep_print_stats,
 	.extra_mpdu_prefix_len = 4,	/* IV */
 	.extra_mpdu_postfix_len = 4,	/* ICV */
 	.owner = THIS_MODULE,
 };
 
-static int __init ieee80211_crypto_wep_init(void)
+static int __init lib80211_crypto_wep_init(void)
 {
-	return ieee80211_register_crypto_ops(&ieee80211_crypt_wep);
+	return lib80211_register_crypto_ops(&lib80211_crypt_wep);
 }
 
-static void __exit ieee80211_crypto_wep_exit(void)
+static void __exit lib80211_crypto_wep_exit(void)
 {
-	ieee80211_unregister_crypto_ops(&ieee80211_crypt_wep);
+	lib80211_unregister_crypto_ops(&lib80211_crypt_wep);
 }
 
-module_init(ieee80211_crypto_wep_init);
-module_exit(ieee80211_crypto_wep_exit);
+module_init(lib80211_crypto_wep_init);
+module_exit(lib80211_crypto_wep_exit);
-- 
1.5.4.3

