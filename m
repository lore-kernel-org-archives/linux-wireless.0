Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbXLEQHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 11:07:43 -0500
Subject: [PATCH] orinoco: always use latest BSS info when caching scan
	results
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org,
	proski@gnu.org
Content-Type: text/plain
Date: Wed, 05 Dec 2007 11:01:23 -0500
Message-Id: <1196870483.2519.32.camel@localhost.localdomain> (sfid-20071205_160747_444545_AB8F27A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always copy the latest BSS information from the firmware's results to
the driver's BSS table to ensure that everything is up-to-date (IEs,
supported rates, encryption status, etc).

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 100ae33..cd9e0c7 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1194,7 +1208,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 	/* Read the entries one by one */
 	for (; offset + atom_len <= len; offset += atom_len) {
 		int found = 0;
-		bss_element *bss;
+		bss_element *bss = NULL;
 
 		/* Get next atom */
 		atom = (union hermes_scan_info *) (buf + offset);
@@ -1209,7 +1223,6 @@ static int orinoco_process_scan_results(struct net_device *dev,
 			if (memcmp(bss->bss.a.essid, atom->a.essid,
 			      le16_to_cpu(atom->a.essid_len)))
 				continue;
-			bss->last_scanned = jiffies;
 			found = 1;
 			break;
 		}
@@ -1220,10 +1233,14 @@ static int orinoco_process_scan_results(struct net_device *dev,
 					 bss_element, list);
 			list_del(priv->bss_free_list.next);
 
-			memcpy(bss, atom, sizeof(bss->bss));
-			bss->last_scanned = jiffies;
 			list_add_tail(&bss->list, &priv->bss_list);
 		}
+
+		if (bss) {
+			/* Always update the BSS to get latest beacon info */
+			memcpy(&bss->bss, atom, sizeof(bss->bss));
+			bss->last_scanned = jiffies;
+		}
 	}
 
 	return 0;

