Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35737 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbbDMJSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 05:18:30 -0400
Received: by wgyo15 with SMTP id o15so73900740wgy.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 02:18:29 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 1/2] mwifiex: sdio: create global list of adapters
Date: Mon, 13 Apr 2015 11:18:23 +0200
Message-Id: <1428916704-9635-1-git-send-email-afenkart@gmail.com> (sfid-20150413_111833_587925_7992F789)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we need to verify that a an adapter pointer, still points to a
valid adapter. this is not possible through other global structures,
such as net_namespace_list. the problem with the net_namespace_list
is that an adapter can have multiple interfaces, hence we had to
de-reference the maybe invalid pointer to get the interface struct.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 14 ++++++++++++++
 drivers/net/wireless/mwifiex/sdio.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 91e36cd..a70e114 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -69,6 +69,12 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 /*
+ * list of active cards
+ */
+static LIST_HEAD(cards);
+static DEFINE_MUTEX(cards_mutex);
+
+/*
  * SDIO probe.
  *
  * This function probes an mwifiex device and registers it. It allocates
@@ -130,6 +136,10 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		ret = -1;
 	}
 
+	mutex_lock(&cards_mutex);
+	list_add(&card->next, &cards);
+	mutex_unlock(&cards_mutex);
+
 	return ret;
 }
 
@@ -196,6 +206,10 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!card)
 		return;
 
+	mutex_lock(&cards_mutex);
+	list_del(&card->next);
+	mutex_unlock(&cards_mutex);
+
 	adapter = card->adapter;
 	if (!adapter || !adapter->priv_num)
 		return;
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 957cca2..9be5650 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -260,6 +260,7 @@ struct sdio_mmc_card {
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
+	struct list_head next;
 };
 
 struct mwifiex_sdio_device {
-- 
2.1.4

