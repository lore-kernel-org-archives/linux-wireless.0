Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4124 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592Ab2FFKHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:35 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/29] NFC: Call the DEP link down ops even when in target mode
Date: Wed,  6 Jun 2012 12:16:33 +0200
Message-Id: <1338977806-30279-17-git-send-email-sameo@linux.intel.com> (sfid-20120606_120740_741591_AF671A9B)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even in target mode we need to let the driver know that we want to
bring the DEP link down.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 6a3799e..4177bb5 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -268,11 +268,6 @@ int nfc_dep_link_down(struct nfc_dev *dev)
 		goto error;
 	}
 
-	if (dev->rf_mode == NFC_RF_TARGET) {
-		rc = -EOPNOTSUPP;
-		goto error;
-	}
-
 	rc = dev->ops->dep_link_down(dev);
 	if (!rc) {
 		dev->dep_link_up = false;
-- 
1.7.9.1

