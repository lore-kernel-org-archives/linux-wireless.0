Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556AbYHUW3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:03 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:03 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 11/19] orinoco: address checkpatch typedef warning
Date: Thu, 21 Aug 2008 23:27:57 +0100
Message-Id: <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com> (sfid-20080822_005039_507316_FAE74455)
In-Reply-To: <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
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
index b83415d..3d5570d 100644
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
@@ -4547,7 +4548,7 @@ static int orinoco_ioctl_getscan(struct net_device *dev,
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
1.5.6.4

