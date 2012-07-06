Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2GFT7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:35 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/33] NFC: Core must test the device polling state inside the device lock
Date: Fri,  6 Jul 2012 22:09:30 +0200
Message-Id: <1341605393-32056-11-git-send-email-sameo@linux.intel.com> (sfid-20120706_220538_419025_F8684484)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

There can ever be only one call to nfc_targets_found() after polling
has been engaged. This could be from a target discovered event from
the driver, or from an error handler to notify poll will never complete.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 32f2832..94ccf07 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -571,13 +571,18 @@ int nfc_targets_found(struct nfc_dev *dev,
 
 	pr_debug("dev_name=%s n_targets=%d\n", dev_name(&dev->dev), n_targets);
 
-	dev->polling = false;
-
 	for (i = 0; i < n_targets; i++)
 		targets[i].idx = dev->target_next_idx++;
 
 	device_lock(&dev->dev);
 
+	if (dev->polling == false) {
+		device_unlock(&dev->dev);
+		return 0;
+	}
+
+	dev->polling = false;
+
 	dev->targets_generation++;
 
 	kfree(dev->targets);
-- 
1.7.10

