Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab1F1MBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 08:01:01 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 05:00:24 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: move few descriptor macros to ath9k.h
Date: Tue, 28 Jun 2011 17:30:54 +0530
Message-ID: <1309262454-21424-1-git-send-email-mshajakhan@atheros.com> (sfid-20110628_141504_130099_A55C3171)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    5 +++++
 drivers/net/wireless/ath/ath9k/init.c  |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ac9ec3c..53d05fa 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -100,6 +100,11 @@ enum buffer_type {
 
 #define ATH_TXSTATUS_RING_SIZE 64
 
+#define	DS2PHYS(_dd, _ds)						\
+	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
+#define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
+#define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
+
 struct ath_descdma {
 	void *dd_desc;
 	dma_addr_t dd_desc_paddr;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 50103b2..ce29717 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -298,10 +298,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		      struct list_head *head, const char *name,
 		      int nbuf, int ndesc, bool is_tx)
 {
-#define	DS2PHYS(_dd, _ds)						\
-	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
-#define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
-#define ATH_DESC_4KB_BOUND_NUM_SKIPPED(_len) ((_len) / 4096)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u8 *ds;
 	struct ath_buf *bf;
@@ -396,9 +392,6 @@ fail2:
 fail:
 	memset(dd, 0, sizeof(*dd));
 	return error;
-#undef ATH_DESC_4KB_BOUND_CHECK
-#undef ATH_DESC_4KB_BOUND_NUM_SKIPPED
-#undef DS2PHYS
 }
 
 void ath9k_init_crypto(struct ath_softc *sc)
-- 
1.7.0.4

