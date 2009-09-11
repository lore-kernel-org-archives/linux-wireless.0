Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp111.mail.ukl.yahoo.com ([77.238.184.49]:38150 "HELO
	smtp111.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752980AbZIKJyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 05:54:12 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: akpm@linux-foundation.org, pierre@ossman.eu,
	linux-mmc@vger.kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH v2] sdio: pass whitelisted cis funce tuples to sdio drivers
Date: Fri, 11 Sep 2009 11:54:12 +0200
Message-Id: <1252662852-20548-2-git-send-email-albert_herranz@yahoo.es>
In-Reply-To: <1252662852-20548-1-git-send-email-albert_herranz@yahoo.es>
References: <1252662852-20548-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some manufacturers provide vendor information in non-vendor specific CIS
tuples. For example, Broadcom uses an Extended Function tuple to provide
the MAC address on some of their network cards, as in the case of the
Nintendo Wii WLAN daughter card.

This patch allows passing whitelisted FUNCE tuples unknown to the SDIO core to
a matching SDIO driver instead of rejecting them and failing.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
v1
- fixed typo in commit message
- CC'd akpm as suggested by mb
- required by commit 4ea602e183ca20a7577ebe253323d0e5d0f9847 in net-next-2.6

v2
- renamed from "sdio: pass unknown cis tuples to sdio drivers"
- added funce tuple whitelist concept
- fixed leak reported by akpm

 drivers/mmc/core/sdio_cis.c |   65 ++++++++++++++++++++++++++++++++----------
 1 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 963f293..4e4fac1 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -98,6 +98,22 @@ static const unsigned char speed_val[16] =
 static const unsigned int speed_unit[8] =
 	{ 10000, 100000, 1000000, 10000000, 0, 0, 0, 0 };
 
+/* FUNCE tuples with these types get passed to SDIO drivers */
+static const unsigned char funce_type_whitelist[] = {
+	4 /* CISTPL_FUNCE_LAN_NODE_ID used in Broadcom cards */
+};
+
+static int cistpl_funce_whitelisted(unsigned char type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(funce_type_whitelist); i++) {
+		if (funce_type_whitelist[i] == type)
+			return 1;
+	}
+	return 0;
+}
+
 static int cistpl_funce_common(struct mmc_card *card,
 			       const unsigned char *buf, unsigned size)
 {
@@ -120,6 +136,10 @@ static int cistpl_funce_func(struct sdio_func *func,
 	unsigned vsn;
 	unsigned min_size;
 
+	/* let SDIO drivers take care of whitelisted FUNCE tuples */
+	if (cistpl_funce_whitelisted(buf[0]))
+		return -EILSEQ;
+
 	vsn = func->card->cccr.sdio_vsn;
 	min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
 
@@ -154,13 +174,12 @@ static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
 	else
 		ret = cistpl_funce_common(card, buf, size);
 
-	if (ret) {
+	if (ret && ret != -EILSEQ) {
 		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
 		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
-		return ret;
 	}
 
-	return 0;
+	return ret;
 }
 
 typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
@@ -253,21 +272,12 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 		for (i = 0; i < ARRAY_SIZE(cis_tpl_list); i++)
 			if (cis_tpl_list[i].code == tpl_code)
 				break;
-		if (i >= ARRAY_SIZE(cis_tpl_list)) {
-			/* this tuple is unknown to the core */
-			this->next = NULL;
-			this->code = tpl_code;
-			this->size = tpl_link;
-			*prev = this;
-			prev = &this->next;
-			printk(KERN_DEBUG
-			       "%s: queuing CIS tuple 0x%02x length %u\n",
-			       mmc_hostname(card->host), tpl_code, tpl_link);
-		} else {
+		if (i < ARRAY_SIZE(cis_tpl_list)) {
 			const struct cis_tpl *tpl = cis_tpl_list + i;
 			if (tpl_link < tpl->min_size) {
 				printk(KERN_ERR
-				       "%s: bad CIS tuple 0x%02x (length = %u, expected >= %u)\n",
+				       "%s: bad CIS tuple 0x%02x"
+				       " (length = %u, expected >= %u)\n",
 				       mmc_hostname(card->host),
 				       tpl_code, tpl_link, tpl->min_size);
 				ret = -EINVAL;
@@ -275,7 +285,30 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 				ret = tpl->parse(card, func,
 						 this->data, tpl_link);
 			}
-			kfree(this);
+			/*
+			 * We don't need the tuple anymore if it was
+			 * successfully parsed by the SDIO core or if it is
+			 * not going to be parsed by SDIO drivers.
+			 */
+			if (!ret || ret != -EILSEQ)
+				kfree(this);
+		} else {
+			/* unknown tuple */
+			ret = -EILSEQ;
+		}
+
+		if (ret == -EILSEQ) {
+			/* this tuple is unknown to the core or whitelisted */
+			this->next = NULL;
+			this->code = tpl_code;
+			this->size = tpl_link;
+			*prev = this;
+			prev = &this->next;
+			printk(KERN_DEBUG
+			       "%s: queuing CIS tuple 0x%02x length %u\n",
+			       mmc_hostname(card->host), tpl_code, tpl_link);
+			/* keep on analyzing tuples */
+			ret = 0;
 		}
 
 		ptr += tpl_link;
-- 
1.6.0.4

