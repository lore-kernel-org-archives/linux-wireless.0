Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42608 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbXGaHiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 03:38:10 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] orinoco, wl3501, zd1201: use linux/ieee80211.h instead of net/ieee80211.h
Date: Tue, 31 Jul 2007 00:36:14 -0700
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, proski@gnu.org,
	acme@ghostprotocols.net, pe1rxq@amsat.org
Message-Id: <200707310036.15013.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

These drivers only need 802.11 definitions.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/orinoco.c |   13 +++++++------
 drivers/net/wireless/wl3501.h  |    4 ++--
 drivers/net/wireless/zd1201.c  |    4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 062286d..5e61a10 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -84,8 +84,8 @@
 #include <linux/ethtool.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
+#include <linux/ieee80211.h>
 #include <net/iw_handler.h>
-#include <net/ieee80211.h>
 
 #include "hermes_rid.h"
 #include "orinoco.h"
@@ -137,7 +137,7 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 #define ENCAPS_OVERHEAD		(sizeof(encaps_hdr) + 2)
 
 #define ORINOCO_MIN_MTU		256
-#define ORINOCO_MAX_MTU		(IEEE80211_DATA_LEN - ENCAPS_OVERHEAD)
+#define ORINOCO_MAX_MTU		(IEEE80211_MAX_DATA_LEN - ENCAPS_OVERHEAD)
 
 #define SYMBOL_MAX_VER_LEN	(14)
 #define USER_BAP		0
@@ -401,7 +401,7 @@ static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
 		return -EINVAL;
 
-	if ( (new_mtu + ENCAPS_OVERHEAD + IEEE80211_HLEN) >
+	if ( (new_mtu + ENCAPS_OVERHEAD + sizeof(struct ieee80211_hdr)) >
 	     (priv->nicbuf_size - ETH_HLEN) )
 		return -EINVAL;
 
@@ -754,7 +754,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	}
 
 	/* sanity check the length */
-	if (datalen > IEEE80211_DATA_LEN + 12) {
+	if (datalen > IEEE80211_MAX_DATA_LEN + 12) {
 		printk(KERN_DEBUG "%s: oversized monitor frame, "
 		       "data length = %d\n", dev->name, datalen);
 		stats->rx_length_errors++;
@@ -857,7 +857,7 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
                    data. */
 		return;
 	}
-	if (length > IEEE80211_DATA_LEN) {
+	if (length > IEEE80211_MAX_DATA_LEN) {
 		printk(KERN_WARNING "%s: Oversized frame received (%d bytes)\n",
 		       dev->name, length);
 		stats->rx_length_errors++;
@@ -2235,7 +2235,8 @@ static int orinoco_init(struct net_device *dev)
 
 	/* No need to lock, the hw_unavailable flag is already set in
 	 * alloc_orinocodev() */
-	priv->nicbuf_size = IEEE80211_FRAME_LEN + ETH_HLEN;
+	priv->nicbuf_size = IEEE80211_MAX_DATA_LEN +
+			    sizeof(struct ieee80211_hdr) + ETH_HLEN;
 
 	/* Initialize the firmware */
 	err = hermes_init(hw);
diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index 65ceb08..59bb3a5 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -2,7 +2,7 @@
 #define __WL3501_H__
 
 #include <linux/spinlock.h>
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 
 /* define for WLA 2.0 */
 #define WL3501_BLKSZ 256
@@ -548,7 +548,7 @@ struct wl3501_80211_tx_plcp_hdr {
 
 struct wl3501_80211_tx_hdr {
 	struct wl3501_80211_tx_plcp_hdr	pclp_hdr;
-	struct ieee80211_hdr_4addr		mac_hdr;
+	struct ieee80211_hdr		mac_hdr;
 } __attribute__ ((packed));
 
 /*
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 935b144..57b03bb 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -21,7 +21,7 @@
 #include <linux/string.h>
 #include <linux/if_arp.h>
 #include <linux/firmware.h>
-#include <net/ieee80211.h>
+#include <linux/ieee80211.h>
 #include "zd1201.h"
 
 static struct usb_device_id zd1201_table[] = {
@@ -346,7 +346,7 @@ static void zd1201_usbrx(struct urb *urb)
 				frag = kmalloc(sizeof(*frag), GFP_ATOMIC);
 				if (!frag)
 					goto resubmit;
-				skb = dev_alloc_skb(IEEE80211_DATA_LEN +14+2);
+				skb = dev_alloc_skb(IEEE80211_MAX_DATA_LEN+14+2);
 				if (!skb) {
 					kfree(frag);
 					goto resubmit;

