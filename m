Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41225 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab1HBVPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 17:15:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] compat: add PCMCIA_DEVICE_MANF_CARD_PROD_ID3
Date: Tue,  2 Aug 2011 23:14:21 +0200
Message-Id: <1312319663-21654-3-git-send-email-hauke@hauke-m.de> (sfid-20110802_231533_076721_DB485B46)
In-Reply-To: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
References: <1312319663-21654-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.1.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index f9b7e88..cff6521 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -27,6 +27,15 @@
 #define IFF_TX_SKB_SHARING	0x10000	/* The interface supports sharing
 					 * skbs on transmit */
 
+#define PCMCIA_DEVICE_MANF_CARD_PROD_ID3(manf, card, v3, vh3) { \
+	.match_flags = PCMCIA_DEV_ID_MATCH_MANF_ID| \
+			PCMCIA_DEV_ID_MATCH_CARD_ID| \
+			PCMCIA_DEV_ID_MATCH_PROD_ID3, \
+	.manf_id = (manf), \
+	.card_id = (card), \
+	.prod_id = { NULL, NULL, (v3), NULL }, \
+	.prod_id_hash = { 0, 0, (vh3), 0 }, }
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.1

