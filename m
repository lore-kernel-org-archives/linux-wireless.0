Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab2GFT7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:05 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 07/33] NFC: Driver failure API
Date: Fri,  6 Jul 2012 22:09:27 +0200
Message-Id: <1341605393-32056-8-git-send-email-sameo@linux.intel.com> (sfid-20120706_215909_269373_90B89226)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

This API should be used by drivers, HCI, SHDLC or NCI stacks to report an
unrecoverable error.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    2 ++
 net/nfc/core.c        |   10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 180964b..6431f5e 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -204,4 +204,6 @@ int nfc_tm_activated(struct nfc_dev *dev, u32 protocol, u8 comm_mode,
 int nfc_tm_deactivated(struct nfc_dev *dev);
 int nfc_tm_data_received(struct nfc_dev *dev, struct sk_buff *skb);
 
+void nfc_driver_failure(struct nfc_dev *dev, int err);
+
 #endif /* __NET_NFC_H */
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 4177bb5..32f2832 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -651,6 +651,16 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 }
 EXPORT_SYMBOL(nfc_target_lost);
 
+void nfc_driver_failure(struct nfc_dev *dev, int err)
+{
+	/*
+	 * TODO: if polling is active, send empty target_found
+	 * or else do whatever makes sense to let user space
+	 * know this device needs to be closed and reinitialized.
+	 */
+}
+EXPORT_SYMBOL(nfc_driver_failure);
+
 static void nfc_release(struct device *d)
 {
 	struct nfc_dev *dev = to_nfc_dev(d);
-- 
1.7.10

