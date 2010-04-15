Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0DOFbL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 01:31:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 22:31:11 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19398.42095.140609.399357@gargle.gargle.HOWL>
Date: Thu, 15 Apr 2010 11:00:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] ath: Add buffered register write operations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required to implement delayed/buffered
register writes in ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath.h |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 1fbf6b1..d32f282 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -71,9 +71,21 @@ struct ath_regulatory {
 	struct reg_dmn_pair_mapping *regpair;
 };
 
+/**
+ * struct ath_ops - Register read/write operations
+ *
+ * @read: Register read
+ * @write: Register write
+ * @enable_write_buffer: Enable multiple register writes
+ * @disable_write_buffer: Disable multiple register writes
+ * @write_flush: Flush buffered register writes
+ */
 struct ath_ops {
 	unsigned int (*read)(void *, u32 reg_offset);
-        void (*write)(void *, u32 val, u32 reg_offset);
+	void (*write)(void *, u32 val, u32 reg_offset);
+	void (*enable_write_buffer)(void *);
+	void (*disable_write_buffer)(void *);
+	void (*write_flush) (void *);
 };
 
 struct ath_common;
-- 
1.7.0.4

