Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46197 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1FSVwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 17:52:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC v2 09/12] bcma: add check if sprom is available before accessing it.
Date: Sun, 19 Jun 2011 23:50:06 +0200
Message-Id: <1308520209-668-10-git-send-email-hauke@hauke-m.de> (sfid-20110619_235226_827942_5E27BC5B)
In-Reply-To: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
References: <1308520209-668-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c  |    4 +++-
 drivers/bcma/sprom.c |    3 +++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 83942f1..9eca7a5 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -159,7 +159,9 @@ int bcma_bus_register(struct bcma_bus *bus)
 
 	/* Try to get SPROM */
 	err = bcma_sprom_get(bus);
-	if (err) {
+	if (err == -ENOENT) {
+		pr_err("No SPROM available\n");
+	} else if (err) {
 		pr_err("Failed to get SPROM: %d\n", err);
 		return -ENOENT;
 	}
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index ffbb0e3..8e8d5cf 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -143,6 +143,9 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!bus->drv_cc.core)
 		return -EOPNOTSUPP;
 
+	if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
+		return -ENOENT;
+
 	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 			GFP_KERNEL);
 	if (!sprom)
-- 
1.7.4.1

