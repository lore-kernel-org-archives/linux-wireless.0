Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091AbXHUPJ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:09:59 -0400
Message-Id: <20070821150052.127733000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 26/27] mac80211: refactor event sending
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create a new file event.c that will contain code to send mac/mlme
events to userspace. For now put the Michael MIC failure condition
into it and remove sending of that condition via the management
interface, hostapd interestingly doesn't do anything when it gets
such a packet besides printing a message, it reacts only on the
private iwevent.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile      |    1 +
 net/mac80211/event.c       |   36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/rx.c          |   41 ++++++++---------------------------------
 net/mac80211/wpa.c         |   34 ++++------------------------------
 5 files changed, 51 insertions(+), 63 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-21 15:59:22.705923881 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-21 16:00:34.675923881 +0200
@@ -938,5 +938,7 @@ u8 *ieee80211_get_bssid(struct ieee80211
 int ieee80211_is_eapol(const struct sk_buff *skb);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
+void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
+				     struct ieee80211_hdr *hdr);
 
 #endif /* IEEE80211_I_H */
--- wireless-dev.orig/net/mac80211/wpa.c	2007-08-21 15:28:19.455923881 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-08-21 16:00:34.675923881 +0200
@@ -11,10 +11,8 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/compiler.h>
-#include <net/iw_handler.h>
-
 #include <net/mac80211.h>
-#include "ieee80211_common.h"
+
 #include "ieee80211_i.h"
 #include "michael.h"
 #include "tkip.h"
@@ -246,33 +244,9 @@ ieee80211_rx_h_michael_mic_verify(struct
 		printk(" (%d)\n", authenticator);
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
 
-		do {
-			struct ieee80211_hdr *hdr;
-			union iwreq_data wrqu;
-			char *buf = kmalloc(128, GFP_ATOMIC);
-			if (!buf)
-				break;
-
-			/* TODO: needed parameters: count, key type, TSC */
-			hdr = (struct ieee80211_hdr *) skb->data;
-			sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
-				"keyid=%d %scast addr=" MAC_FMT ")",
-				rx->key->keyidx,
-				hdr->addr1[0] & 0x01 ? "broad" : "uni",
-				MAC_ARG(hdr->addr2));
-			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = strlen(buf);
-			wireless_send_event(rx->dev, IWEVCUSTOM, &wrqu, buf);
-			kfree(buf);
-		} while (0);
-
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_michael_mic_failure);
-
-		return TXRX_QUEUED;
+		mac80211_ev_michael_mic_failure(rx->dev, rx->key->keyidx,
+						(void *) skb->data);
+		return TXRX_DROP;
 	}
 
  remove_mic:
--- wireless-dev.orig/net/mac80211/rx.c	2007-08-21 15:29:55.865923881 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-21 16:02:54.815923881 +0200
@@ -13,7 +13,6 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <net/iw_handler.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 
@@ -1354,20 +1353,17 @@ static void ieee80211_rx_michael_mic_rep
 	}
 
 	if ((rx->local->hw.flags & IEEE80211_HW_WEP_INCLUDE_IV) &&
-	    rx->sdata->type == IEEE80211_IF_TYPE_AP) {
-		keyidx = ieee80211_wep_get_keyidx(rx->skb);
+	    rx->sdata->type == IEEE80211_IF_TYPE_AP && keyidx) {
 		/* AP with Pairwise keys support should never receive Michael
 		 * MIC errors for non-zero keyidx because these are reserved
 		 * for group keys and only the AP is sending real multicast
 		 * frames in BSS. */
-		if (keyidx) {
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: ignored Michael MIC "
-				       "error for a frame with non-zero keyidx"
-				       " (%d) (src " MAC_FMT ")\n", dev->name,
-				       keyidx, MAC_ARG(hdr->addr2));
-			goto ignore;
-		}
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: ignored Michael MIC error for "
+			       "a frame with non-zero keyidx (%d)"
+			       " (src " MAC_FMT ")\n", dev->name, keyidx,
+			       MAC_ARG(hdr->addr2));
+		goto ignore;
 	}
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
@@ -1381,32 +1377,11 @@ static void ieee80211_rx_michael_mic_rep
 		goto ignore;
 	}
 
-	do {
-		union iwreq_data wrqu;
-		char *buf = kmalloc(128, GFP_ATOMIC);
-		if (!buf)
-			break;
-
-		/* TODO: needed parameters: count, key type, TSC */
-		sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
-			"keyid=%d %scast addr=" MAC_FMT ")",
-			keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
-			MAC_ARG(hdr->addr2));
-		memset(&wrqu, 0, sizeof(wrqu));
-		wrqu.data.length = strlen(buf);
-		wireless_send_event(rx->dev, IWEVCUSTOM, &wrqu, buf);
-		kfree(buf);
-	} while (0);
-
 	/* TODO: consider verifying the MIC error report with software
 	 * implementation if we get too many spurious reports from the
 	 * hardware. */
-	if (!rx->local->apdev)
-		goto ignore;
-	ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-			  ieee80211_msg_michael_mic_failure);
-	return;
 
+	mac80211_ev_michael_mic_failure(rx->dev, keyidx, hdr);
  ignore:
 	dev_kfree_skb(rx->skb);
 	rx->skb = NULL;
--- wireless-dev.orig/net/mac80211/Makefile	2007-08-21 14:58:38.245923881 +0200
+++ wireless-dev/net/mac80211/Makefile	2007-08-21 16:00:34.715923881 +0200
@@ -22,4 +22,5 @@ mac80211-objs := \
 	tx.o \
 	key.o \
 	util.o \
+	event.o \
 	$(mac80211-objs-y)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/event.c	2007-08-21 16:00:34.715923881 +0200
@@ -0,0 +1,36 @@
+/*
+ * mac80211 - events
+ */
+
+#include <linux/netdevice.h>
+#include <net/iw_handler.h>
+#include "ieee80211_i.h"
+
+/*
+ * indicate a failed Michael MIC to userspace; the passed packet
+ * (in the variable hdr) must be long enough to extract the TKIP
+ * fields like TSC
+ */
+void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
+				     struct ieee80211_hdr *hdr)
+{
+	union iwreq_data wrqu;
+	char *buf = kmalloc(128, GFP_ATOMIC);
+
+	if (buf) {
+		/* TODO: needed parameters: count, key type, TSC */
+		sprintf(buf, "MLME-MICHAELMICFAILURE.indication("
+			"keyid=%d %scast addr=" MAC_FMT ")",
+			keyidx, hdr->addr1[0] & 0x01 ? "broad" : "uni",
+			MAC_ARG(hdr->addr2));
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = strlen(buf);
+		wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
+		kfree(buf);
+	}
+
+	/*
+	 * TODO: re-add support for sending MIC failure indication
+	 * with all info via nl80211
+	 */
+}

-- 

