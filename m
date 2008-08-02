Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbYHBKPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:15:34 -0400
Received: by nf-out-0910.google.com with SMTP id d3so537527nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:15:34 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 11/19] orinoco: address checkpatch typedef warning
Date: Sat,  2 Aug 2008 11:14:25 +0100
Message-Id: <1217672073-7094-12-git-send-email-kilroyd@gmail.com> (sfid-20080802_121544_031820_13EA0B4D)
In-Reply-To: <1217672073-7094-11-git-send-email-kilroyd@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-3-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-4-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-5-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-6-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-7-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-8-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-9-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-10-git-send-email-kilroyd@gmail.com>
 <1217672073-7094-11-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just sprinkle the necessary structs around...

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   13 +++++++------
 drivers/net/wireless/orinoco.h |    6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 64db579..07e118c 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -279,7 +279,8 @@ static int orinoco_bss_data_allocate(struct orinoco_private *priv)
 		return 0;
 
 	priv->bss_data =
-	    kzalloc(ORINOCO_MAX_BSS_COUNT * sizeof(bss_element), GFP_KERNEL);
+	    kzalloc(ORINOCO_MAX_BSS_COUNT * sizeof(struct bss_element),
+		    GFP_KERNEL);
 	if (!priv->bss_data) {
 		printk(KERN_WARNING "Out of memory allocating beacons");
 		return -ENOMEM;
@@ -1413,8 +1414,8 @@ static void orinoco_send_wevents(struct work_struct *work)
 static inline void orinoco_clear_scan_results(struct orinoco_private *priv,
 					      unsigned long scan_age)
 {
-	bss_element *bss;
-	bss_element *tmp_bss;
+	struct bss_element *bss;
+	struct bss_element *tmp_bss;
 
 	/* Blow away current list of scan results */
 	list_for_each_entry_safe(bss, tmp_bss, &priv->bss_list, list) {
@@ -1489,7 +1490,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 	/* Read the entries one by one */
 	for (; offset + atom_len <= len; offset += atom_len) {
 		int found = 0;
-		bss_element *bss = NULL;
+		struct bss_element *bss = NULL;
 
 		/* Get next atom */
 		atom = (union hermes_scan_info *) (buf + offset);
@@ -1511,7 +1512,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 		/* Grab a bss off the free list */
 		if (!found && !list_empty(&priv->bss_free_list)) {
 			bss = list_entry(priv->bss_free_list.next,
-					 bss_element, list);
+					 struct bss_element, list);
 			list_del(priv->bss_free_list.next);
 
 			list_add_tail(&bss->list, &priv->bss_list);
@@ -4554,7 +4555,7 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	bss_element *bss;
+	struct bss_element *bss;
 	int err = 0;
 	unsigned long flags;
 	char *current_ev = extra;
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index f93752f..584d8c9 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -36,11 +36,11 @@ typedef enum {
 	FIRMWARE_TYPE_SYMBOL
 } fwtype_t;
 
-typedef struct {
+struct bss_element {
 	union hermes_scan_info bss;
 	unsigned long last_scanned;
 	struct list_head list;
-} bss_element;
+};
 
 struct orinoco_private {
 	void *card;	/* Pointer to card dependent structure */
@@ -117,7 +117,7 @@ struct orinoco_private {
 	/* Scanning support */
 	struct list_head bss_list;
 	struct list_head bss_free_list;
-	bss_element *bss_data;
+	struct bss_element *bss_data;
 
 	int	scan_inprogress;	/* Scan pending... */
 	u32	scan_mode;		/* Type of scan done */
-- 
1.5.4.5

