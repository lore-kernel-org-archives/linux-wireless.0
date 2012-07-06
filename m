Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2GFT7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:37 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 12/33] NFC: nfc_driver_failure() implementation
Date: Fri,  6 Jul 2012 22:09:32 +0200
Message-Id: <1341605393-32056-13-git-send-email-sameo@linux.intel.com> (sfid-20120706_220532_071857_E2314AF5)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

If the device is polling we sent a 0 target found event.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 749ee48..00105e7 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -663,13 +663,9 @@ int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
 }
 EXPORT_SYMBOL(nfc_target_lost);
 
-void nfc_driver_failure(struct nfc_dev *dev, int err)
+inline void nfc_driver_failure(struct nfc_dev *dev, int err)
 {
-	/*
-	 * TODO: if polling is active, send empty target_found
-	 * or else do whatever makes sense to let user space
-	 * know this device needs to be closed and reinitialized.
-	 */
+	nfc_targets_found(dev, NULL, 0);
 }
 EXPORT_SYMBOL(nfc_driver_failure);
 
-- 
1.7.10

