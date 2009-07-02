Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.148]:51386 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZGBT0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 15:26:52 -0400
Received: by ey-out-1920.google.com with SMTP id 3so431048eyh.36
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2009 12:26:54 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: fix printk format specifier for size_t arguments
Date: Thu,  2 Jul 2009 20:26:45 +0100
Message-Id: <1246562805-9785-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses the following compile warnings on 64-bit platforms.

drivers/net/wireless/orinoco/scan.c: In function 'orinoco_add_hostscan_results':
drivers/net/wireless/orinoco/scan.c:194: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/net/wireless/orinoco/scan.c:211: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
drivers/net/wireless/orinoco/scan.c:211: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

Thanks to Johannes for pointing this out.

This was introduced in patch 21 of the cfg80211 switch series "orinoco:
convert scanning to cfg80211"

---
 drivers/net/wireless/orinoco/scan.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index 522eb98..d2f10e9 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -190,7 +190,7 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 			/* Sanity check for atom_len */
 			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
 				printk(KERN_ERR "%s: Invalid atom_len in scan "
-				       "data: %d\n", priv->ndev->name,
+				       "data: %zu\n", priv->ndev->name,
 				       atom_len);
 				abort = true;
 				goto scan_abort;
@@ -206,8 +206,8 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 
 	/* Check that we got an whole number of atoms */
 	if ((len - offset) % atom_len) {
-		printk(KERN_ERR "%s: Unexpected scan data length %d, "
-		       "atom_len %d, offset %d\n", priv->ndev->name, len,
+		printk(KERN_ERR "%s: Unexpected scan data length %zu, "
+		       "atom_len %zu, offset %d\n", priv->ndev->name, len,
 		       atom_len, offset);
 		abort = true;
 		goto scan_abort;
-- 
1.6.0.6

