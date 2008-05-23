Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18500 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYEWKRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 06:17:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: use lbs_pr_XX instead of printk
Date: Fri, 23 May 2008 12:16:51 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805231216.51953.hs4233@mail.mn-solutions.de> (sfid-20080523_121713_462047_23899C1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... because lbs_pr_XXX prefixes all messages with "libertas: "

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux.orig/drivers/net/wireless/libertas/cmd.c
+++ linux/drivers/net/wireless/libertas/cmd.c
@@ -110,7 +110,7 @@
 	 * CF card    firmware 5.0.16p0:   cap 0x00000303
 	 * USB dongle firmware 5.110.17p2: cap 0x00000303
 	 */
-	printk("libertas: %s, fw %u.%u.%up%u, cap 0x%08x\n",
+	lbs_pr_info("%s, fw %u.%u.%up%u, cap 0x%08x\n",
 		print_mac(mac, cmd.permanentaddr),
 		priv->fwrelease >> 24 & 0xff,
 		priv->fwrelease >> 16 & 0xff,
--- linux.orig/drivers/net/wireless/libertas/persistcfg.c
+++ linux/drivers/net/wireless/libertas/persistcfg.c
@@ -188,7 +188,7 @@
 		return ret;
 
 	if (defs.meshie.val.mesh_id_len > IW_ESSID_MAX_SIZE) {
-		printk(KERN_ERR "Inconsistent mesh ID length");
+		lbs_pr_err("inconsistent mesh ID length");
 		defs.meshie.val.mesh_id_len = IW_ESSID_MAX_SIZE;
 	}
 
