Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZBDXGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:32 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:31 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 07/16] orinoco: use orinoco_private instead of net_device in scan helper
Date: Wed,  4 Feb 2009 23:05:49 +0000
Message-Id: <1233788758-9850-8-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000637_052305_69D185BC)
In-Reply-To: <1233788758-9850-7-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-3-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-4-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-6-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-7-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the interface to the scan helpers consistent, so we can split
them out.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index e43e3e2..9e8da9c 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1929,11 +1929,10 @@ static void orinoco_add_ext_scan_result(struct orinoco_private *priv,
 	}
 }
 
-static int orinoco_process_scan_results(struct net_device *dev,
+static int orinoco_process_scan_results(struct orinoco_private *priv,
 					unsigned char *buf,
 					int len)
 {
-	struct orinoco_private *priv = netdev_priv(dev);
 	int			offset;		/* In the scan data */
 	union hermes_scan_info *atom;
 	int			atom_len;
@@ -1967,7 +1966,8 @@ static int orinoco_process_scan_results(struct net_device *dev,
 			/* Sanity check for atom_len */
 			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
 				printk(KERN_ERR "%s: Invalid atom_len in scan "
-				       "data: %d\n", dev->name, atom_len);
+				       "data: %d\n", priv->ndev->name,
+				       atom_len);
 				return -EIO;
 			}
 		} else
@@ -1980,7 +1980,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 	/* Check that we got an whole number of atoms */
 	if ((len - offset) % atom_len) {
 		printk(KERN_ERR "%s: Unexpected scan data length %d, "
-		       "atom_len %d, offset %d\n", dev->name, len,
+		       "atom_len %d, offset %d\n", priv->ndev->name, len,
 		       atom_len, offset);
 		return -EIO;
 	}
@@ -2187,7 +2187,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		}
 #endif	/* ORINOCO_DEBUG */
 
-		if (orinoco_process_scan_results(dev, buf, len) == 0) {
+		if (orinoco_process_scan_results(priv, buf, len) == 0) {
 			/* Send an empty event to user space.
 			 * We don't send the received data on the event because
 			 * it would require us to do complex transcoding, and
-- 
1.6.0.6

