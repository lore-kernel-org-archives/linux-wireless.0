Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp124.mail.ukl.yahoo.com ([77.238.184.55]:48350 "HELO
	smtp124.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755643AbZIJNDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 09:03:25 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: akpm@linux-foundation.org, linux-mmc@vger.kernel.org
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH] sdio: pass unknown cis tuples to sdio drivers
Date: Thu, 10 Sep 2009 14:56:42 +0200
Message-Id: <1252587402-7382-2-git-send-email-albert_herranz@yahoo.es>
In-Reply-To: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
References: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some manufacturers provide vendor information in non-vendor specific CIS
tuples. For example, Broadcom uses an Extended Function tuple to provide
the MAC address on some of their network cards, as in the case of the
Nintendo Wii WLAN daughter card.

This patch allows passing correct tuples unknown to the SDIO core to
a matching SDIO driver instead of rejecting them and failing.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
v1
- fixed typo in commit message
- CC'd akpm as suggested by mb
- required by commit 4ea602e183ca20a7577ebe253323d0e5d0f9847 in net-next-2.6

 drivers/mmc/core/sdio_cis.c |   46 +++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 963f293..87934ac 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -123,8 +123,9 @@ static int cistpl_funce_func(struct sdio_func *func,
 	vsn = func->card->cccr.sdio_vsn;
 	min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
 
+	/* let the SDIO driver take care of unknown tuples */
 	if (size < min_size || buf[0] != 1)
-		return -EINVAL;
+		return -EILSEQ;
 
 	/* TPLFE_MAX_BLK_SIZE */
 	func->max_blksize = buf[12] | (buf[13] << 8);
@@ -154,13 +155,7 @@ static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
 	else
 		ret = cistpl_funce_common(card, buf, size);
 
-	if (ret) {
-		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
-		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
@@ -253,21 +248,12 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
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
@@ -275,7 +261,25 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 				ret = tpl->parse(card, func,
 						 this->data, tpl_link);
 			}
-			kfree(this);
+			/* already successfully parsed, not needed anymore */
+			if (!ret)
+				kfree(this);
+		} else {
+			/* unknown tuple */
+			ret = -EILSEQ;
+		}
+
+		if (ret == -EILSEQ) {
+			/* this tuple is unknown to the core */
+			this->next = NULL;
+			this->code = tpl_code;
+			this->size = tpl_link;
+			*prev = this;
+			prev = &this->next;
+			pr_debug("%s: queuing CIS tuple 0x%02x length %u\n",
+				 mmc_hostname(card->host), tpl_code, tpl_link);
+			/* keep on analyzing tuples */
+			ret = 0;
 		}
 
 		ptr += tpl_link;
-- 
1.6.0.4

