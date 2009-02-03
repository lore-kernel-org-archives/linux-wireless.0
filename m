Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZBCUmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:42:20 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:42:19 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 09/17] orinoco: Move scan helpers to a separate file
Date: Tue,  3 Feb 2009 20:40:31 +0000
Message-Id: <1233693639-8608-10-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214226_500441_EF5201B2)
In-Reply-To: <1233693639-8608-9-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-6-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-8-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-9-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional change.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile |    2 +-
 drivers/net/wireless/orinoco/main.c   |  220 +------------------------------
 drivers/net/wireless/orinoco/scan.c   |  233 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/scan.h   |   29 ++++
 4 files changed, 265 insertions(+), 219 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/scan.c
 create mode 100644 drivers/net/wireless/orinoco/scan.h

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index d2ac785..efde451 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o
+orinoco-objs := main.o scan.o
 
 obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 1ad1bdf..3307119 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -95,6 +95,8 @@
 
 #include "hermes_rid.h"
 #include "hermes_dld.h"
+#include "scan.h"
+
 #include "orinoco.h"
 
 /********************************************************************/
@@ -350,53 +352,6 @@ static inline void set_port_type(struct orinoco_private *priv)
 	}
 }
 
-#define ORINOCO_MAX_BSS_COUNT	64
-static int orinoco_bss_data_allocate(struct orinoco_private *priv)
-{
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
-	}
-	return 0;
-}
-
-static void orinoco_bss_data_free(struct orinoco_private *priv)
-{
-	kfree(priv->bss_xbss_data);
-	priv->bss_xbss_data = NULL;
-}
-
-#define PRIV_BSS	((struct bss_element *)priv->bss_xbss_data)
-#define PRIV_XBSS	((struct xbss_element *)priv->bss_xbss_data)
-static void orinoco_bss_data_init(struct orinoco_private *priv)
-{
-	int i;
-
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
 static inline u8 *orinoco_get_ie(u8 *data, size_t len,
 				 enum ieee80211_eid eid)
 {
@@ -1857,177 +1812,6 @@ static void orinoco_send_wevents(struct work_struct *work)
 	orinoco_unlock(priv, &flags);
 }
 
-static inline void orinoco_clear_scan_results(struct orinoco_private *priv,
-					      unsigned long scan_age)
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
-		}
-	}
-}
-
-static void orinoco_add_ext_scan_result(struct orinoco_private *priv,
-					struct agere_ext_scan_info *atom)
-{
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
-		break;
-	}
-
-	/* Grab a bss off the free list */
-	if (!found && !list_empty(&priv->bss_free_list)) {
-		bss = list_entry(priv->bss_free_list.next,
-				 struct xbss_element, list);
-		list_del(priv->bss_free_list.next);
-
-		list_add_tail(&bss->list, &priv->bss_list);
-	}
-
-	if (bss) {
-		/* Always update the BSS to get latest beacon info */
-		memcpy(&bss->bss, atom, sizeof(bss->bss));
-		bss->last_scanned = jiffies;
-	}
-}
-
-static int orinoco_process_scan_results(struct orinoco_private *priv,
-					unsigned char *buf,
-					int len)
-{
-	int			offset;		/* In the scan data */
-	union hermes_scan_info *atom;
-	int			atom_len;
-
-	switch (priv->firmware_type) {
-	case FIRMWARE_TYPE_AGERE:
-		atom_len = sizeof(struct agere_scan_apinfo);
-		offset = 0;
-		break;
-	case FIRMWARE_TYPE_SYMBOL:
-		/* Lack of documentation necessitates this hack.
-		 * Different firmwares have 68 or 76 byte long atoms.
-		 * We try modulo first.  If the length divides by both,
-		 * we check what would be the channel in the second
-		 * frame for a 68-byte atom.  76-byte atoms have 0 there.
-		 * Valid channel cannot be 0.  */
-		if (len % 76)
-			atom_len = 68;
-		else if (len % 68)
-			atom_len = 76;
-		else if (len >= 1292 && buf[68] == 0)
-			atom_len = 76;
-		else
-			atom_len = 68;
-		offset = 0;
-		break;
-	case FIRMWARE_TYPE_INTERSIL:
-		offset = 4;
-		if (priv->has_hostscan) {
-			atom_len = le16_to_cpup((__le16 *)buf);
-			/* Sanity check for atom_len */
-			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
-				printk(KERN_ERR "%s: Invalid atom_len in scan "
-				       "data: %d\n", priv->ndev->name,
-				       atom_len);
-				return -EIO;
-			}
-		} else
-			atom_len = offsetof(struct prism2_scan_apinfo, atim);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/* Check that we got an whole number of atoms */
-	if ((len - offset) % atom_len) {
-		printk(KERN_ERR "%s: Unexpected scan data length %d, "
-		       "atom_len %d, offset %d\n", priv->ndev->name, len,
-		       atom_len, offset);
-		return -EIO;
-	}
-
-	orinoco_clear_scan_results(priv, msecs_to_jiffies(15000));
-
-	/* Read the entries one by one */
-	for (; offset + atom_len <= len; offset += atom_len) {
-		int found = 0;
-		struct bss_element *bss = NULL;
-
-		/* Get next atom */
-		atom = (union hermes_scan_info *) (buf + offset);
-
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
-	}
-
-	return 0;
-}
-
 static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
new file mode 100644
index 0000000..89d699d
--- /dev/null
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -0,0 +1,233 @@
+/* Helpers for managing scan queues
+ *
+ * See copyright notice in main.c
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/etherdevice.h>
+
+#include "hermes.h"
+#include "orinoco.h"
+
+#include "scan.h"
+
+#define ORINOCO_MAX_BSS_COUNT	64
+
+#define PRIV_BSS	((struct bss_element *)priv->bss_xbss_data)
+#define PRIV_XBSS	((struct xbss_element *)priv->bss_xbss_data)
+
+int orinoco_bss_data_allocate(struct orinoco_private *priv)
+{
+	if (priv->bss_xbss_data)
+		return 0;
+
+	if (priv->has_ext_scan)
+		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
+					      sizeof(struct xbss_element),
+					      GFP_KERNEL);
+	else
+		priv->bss_xbss_data = kzalloc(ORINOCO_MAX_BSS_COUNT *
+					      sizeof(struct bss_element),
+					      GFP_KERNEL);
+
+	if (!priv->bss_xbss_data) {
+		printk(KERN_WARNING "Out of memory allocating beacons");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void orinoco_bss_data_free(struct orinoco_private *priv)
+{
+	kfree(priv->bss_xbss_data);
+	priv->bss_xbss_data = NULL;
+}
+
+void orinoco_bss_data_init(struct orinoco_private *priv)
+{
+	int i;
+
+	INIT_LIST_HEAD(&priv->bss_free_list);
+	INIT_LIST_HEAD(&priv->bss_list);
+	if (priv->has_ext_scan)
+		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
+			list_add_tail(&(PRIV_XBSS[i].list),
+				      &priv->bss_free_list);
+	else
+		for (i = 0; i < ORINOCO_MAX_BSS_COUNT; i++)
+			list_add_tail(&(PRIV_BSS[i].list),
+				      &priv->bss_free_list);
+
+}
+
+void orinoco_clear_scan_results(struct orinoco_private *priv,
+				unsigned long scan_age)
+{
+	if (priv->has_ext_scan) {
+		struct xbss_element *bss;
+		struct xbss_element *tmp_bss;
+
+		/* Blow away current list of scan results */
+		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
+			if (!scan_age ||
+			    time_after(jiffies, bss->last_scanned + scan_age)) {
+				list_move_tail(&bss->list,
+					       &priv->bss_free_list);
+				/* Don't blow away ->list, just BSS data */
+				memset(&bss->bss, 0, sizeof(bss->bss));
+				bss->last_scanned = 0;
+			}
+		}
+	} else {
+		struct bss_element *bss;
+		struct bss_element *tmp_bss;
+
+		/* Blow away current list of scan results */
+		list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
+			if (!scan_age ||
+			    time_after(jiffies, bss->last_scanned + scan_age)) {
+				list_move_tail(&bss->list,
+					       &priv->bss_free_list);
+				/* Don't blow away ->list, just BSS data */
+				memset(&bss->bss, 0, sizeof(bss->bss));
+				bss->last_scanned = 0;
+			}
+		}
+	}
+}
+
+void orinoco_add_ext_scan_result(struct orinoco_private *priv,
+				 struct agere_ext_scan_info *atom)
+{
+	struct xbss_element *bss = NULL;
+	int found = 0;
+
+	/* Try to update an existing bss first */
+	list_for_each_entry(bss, &priv->bss_list, list) {
+		if (compare_ether_addr(bss->bss.bssid, atom->bssid))
+			continue;
+		/* ESSID lengths */
+		if (bss->bss.data[1] != atom->data[1])
+			continue;
+		if (memcmp(&bss->bss.data[2], &atom->data[2],
+			   atom->data[1]))
+			continue;
+		found = 1;
+		break;
+	}
+
+	/* Grab a bss off the free list */
+	if (!found && !list_empty(&priv->bss_free_list)) {
+		bss = list_entry(priv->bss_free_list.next,
+				 struct xbss_element, list);
+		list_del(priv->bss_free_list.next);
+
+		list_add_tail(&bss->list, &priv->bss_list);
+	}
+
+	if (bss) {
+		/* Always update the BSS to get latest beacon info */
+		memcpy(&bss->bss, atom, sizeof(bss->bss));
+		bss->last_scanned = jiffies;
+	}
+}
+
+int orinoco_process_scan_results(struct orinoco_private *priv,
+				 unsigned char *buf,
+				 int len)
+{
+	int			offset;		/* In the scan data */
+	union hermes_scan_info *atom;
+	int			atom_len;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE:
+		atom_len = sizeof(struct agere_scan_apinfo);
+		offset = 0;
+		break;
+	case FIRMWARE_TYPE_SYMBOL:
+		/* Lack of documentation necessitates this hack.
+		 * Different firmwares have 68 or 76 byte long atoms.
+		 * We try modulo first.  If the length divides by both,
+		 * we check what would be the channel in the second
+		 * frame for a 68-byte atom.  76-byte atoms have 0 there.
+		 * Valid channel cannot be 0.  */
+		if (len % 76)
+			atom_len = 68;
+		else if (len % 68)
+			atom_len = 76;
+		else if (len >= 1292 && buf[68] == 0)
+			atom_len = 76;
+		else
+			atom_len = 68;
+		offset = 0;
+		break;
+	case FIRMWARE_TYPE_INTERSIL:
+		offset = 4;
+		if (priv->has_hostscan) {
+			atom_len = le16_to_cpup((__le16 *)buf);
+			/* Sanity check for atom_len */
+			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
+				printk(KERN_ERR "%s: Invalid atom_len in scan "
+				       "data: %d\n", priv->ndev->name,
+				       atom_len);
+				return -EIO;
+			}
+		} else
+			atom_len = offsetof(struct prism2_scan_apinfo, atim);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/* Check that we got an whole number of atoms */
+	if ((len - offset) % atom_len) {
+		printk(KERN_ERR "%s: Unexpected scan data length %d, "
+		       "atom_len %d, offset %d\n", priv->ndev->name, len,
+		       atom_len, offset);
+		return -EIO;
+	}
+
+	orinoco_clear_scan_results(priv, msecs_to_jiffies(15000));
+
+	/* Read the entries one by one */
+	for (; offset + atom_len <= len; offset += atom_len) {
+		int found = 0;
+		struct bss_element *bss = NULL;
+
+		/* Get next atom */
+		atom = (union hermes_scan_info *) (buf + offset);
+
+		/* Try to update an existing bss first */
+		list_for_each_entry(bss, &priv->bss_list, list) {
+			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
+				continue;
+			if (le16_to_cpu(bss->bss.a.essid_len) !=
+			      le16_to_cpu(atom->a.essid_len))
+				continue;
+			if (memcmp(bss->bss.a.essid, atom->a.essid,
+			      le16_to_cpu(atom->a.essid_len)))
+				continue;
+			found = 1;
+			break;
+		}
+
+		/* Grab a bss off the free list */
+		if (!found && !list_empty(&priv->bss_free_list)) {
+			bss = list_entry(priv->bss_free_list.next,
+					 struct bss_element, list);
+			list_del(priv->bss_free_list.next);
+
+			list_add_tail(&bss->list, &priv->bss_list);
+		}
+
+		if (bss) {
+			/* Always update the BSS to get latest beacon info */
+			memcpy(&bss->bss, atom, sizeof(bss->bss));
+			bss->last_scanned = jiffies;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/orinoco/scan.h b/drivers/net/wireless/orinoco/scan.h
new file mode 100644
index 0000000..f319f74
--- /dev/null
+++ b/drivers/net/wireless/orinoco/scan.h
@@ -0,0 +1,29 @@
+/* Helpers for managing scan queues
+ *
+ * See copyright notice in main.c
+ */
+#ifndef _ORINOCO_SCAN_H_
+#define _ORINOCO_SCAN_H_
+
+/* Forward declarations */
+struct orinoco_private;
+struct agere_ext_scan_info;
+
+/* Setup and free memory for scan results */
+int orinoco_bss_data_allocate(struct orinoco_private *priv);
+void orinoco_bss_data_free(struct orinoco_private *priv);
+void orinoco_bss_data_init(struct orinoco_private *priv);
+
+/* Add scan results */
+void orinoco_add_ext_scan_result(struct orinoco_private *priv,
+				 struct agere_ext_scan_info *atom);
+int orinoco_process_scan_results(struct orinoco_private *dev,
+				 unsigned char *buf,
+				 int len);
+
+/* Clear scan results */
+void orinoco_clear_scan_results(struct orinoco_private *priv,
+				unsigned long scan_age);
+
+
+#endif /* _ORINOCO_SCAN_H_ */
-- 
1.6.0.6

