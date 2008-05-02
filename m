Return-path: <linux-wireless-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Received: from ra.tuxdriver.com ([70.61.120.52]:4845 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbYEBOa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 10:30:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: danielm77@spray.se, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wavelan: avoid index past end of array if DEBUG_SHOW_UNUSED is defined
Date: Fri,  2 May 2008 09:56:34 -0400
Message-Id: <1209736594-9510-1-git-send-email-linville@tuxdriver.com> (sfid-20080502_163039_854995_64960508)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Daniel Marjam=C3=A4ki <danielm77@spray.se> here:

	http://bugzilla.kernel.org/show_bug.cgi?id=3D10588

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wavelan.c    |    4 ++--
 drivers/net/wireless/wavelan_cs.c |    6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wave=
lan.c
index 03384a4..49ae970 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -908,9 +908,9 @@ static void wv_psa_show(psa_t * p)
 	     p->psa_call_code[3], p->psa_call_code[4], p->psa_call_code[5],
 	     p->psa_call_code[6], p->psa_call_code[7]);
 #ifdef DEBUG_SHOW_UNUSED
-	printk(KERN_DEBUG "psa_reserved[]: %02X:%02X:%02X:%02X\n",
+	printk(KERN_DEBUG "psa_reserved[]: %02X:%02X\n",
 	       p->psa_reserved[0],
-	       p->psa_reserved[1], p->psa_reserved[2], p->psa_reserved[3]);
+	       p->psa_reserved[1]);
 #endif				/* DEBUG_SHOW_UNUSED */
 	printk(KERN_DEBUG "psa_conf_status: %d, ", p->psa_conf_status);
 	printk("psa_crc: 0x%02x%02x, ", p->psa_crc[0], p->psa_crc[1]);
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/w=
avelan_cs.c
index baf7401..b584c0e 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -1074,11 +1074,9 @@ wv_psa_show(psa_t *	p)
 	 p->psa_call_code[6],
 	 p->psa_call_code[7]);
 #ifdef DEBUG_SHOW_UNUSED
-  printk(KERN_DEBUG "psa_reserved[]: %02X:%02X:%02X:%02X\n",
+  printk(KERN_DEBUG "psa_reserved[]: %02X:%02X\n",
 	 p->psa_reserved[0],
-	 p->psa_reserved[1],
-	 p->psa_reserved[2],
-	 p->psa_reserved[3]);
+	 p->psa_reserved[1]);
 #endif	/* DEBUG_SHOW_UNUSED */
   printk(KERN_DEBUG "psa_conf_status: %d, ", p->psa_conf_status);
   printk("psa_crc: 0x%02x%02x, ", p->psa_crc[0], p->psa_crc[1]);
--=20
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
