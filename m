Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab2DJRfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:13 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/18] NFC: Export target lost function
Date: Tue, 10 Apr 2012 19:43:05 +0200
Message-Id: <1334079800-10671-4-git-send-email-sameo@linux.intel.com> (sfid-20120410_193518_446274_8B1C2669)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@linux.intel.com>

NFC drivers will call this routine when they detect that a tag leaves the
RF field. This will eventually lead to the corresponding netlink event
to be sent.

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    1 +
 net/nfc/core.c        |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index bac070b..57ea095 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -181,6 +181,7 @@ int nfc_set_remote_general_bytes(struct nfc_dev *dev,
 
 int nfc_targets_found(struct nfc_dev *dev,
 		      struct nfc_target *targets, int ntargets);
+int nfc_target_lost(struct nfc_dev *dev, u32 target_idx);
 
 int nfc_dep_link_is_up(struct nfc_dev *dev, u32 target_idx,
 		       u8 comm_mode, u8 rf_mode);
diff --git a/net/nfc/core.c b/net/nfc/core.c
index 295d129..deb4721 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -455,6 +455,45 @@ int nfc_targets_found(struct nfc_dev *dev,
 }
 EXPORT_SYMBOL(nfc_targets_found);
 
+int nfc_target_lost(struct nfc_dev *dev, u32 target_idx)
+{
+	struct nfc_target *tg;
+	int i;
+
+	pr_debug("dev_name %s n_target %d\n", dev_name(&dev->dev), target_idx);
+
+	spin_lock_bh(&dev->targets_lock);
+
+	for (i = 0; i < dev->n_targets; i++) {
+		tg = &dev->targets[i];
+		if (tg->idx == target_idx)
+			break;
+	}
+
+	if (i == dev->n_targets) {
+		spin_unlock_bh(&dev->targets_lock);
+		return -EINVAL;
+	}
+
+	dev->targets_generation++;
+	dev->n_targets--;
+
+	if (dev->n_targets) {
+		memcpy(&dev->targets[i], &dev->targets[i + 1],
+		       (dev->n_targets - i) * sizeof(struct nfc_target));
+	} else {
+		kfree(dev->targets);
+		dev->targets = NULL;
+	}
+
+	spin_unlock_bh(&dev->targets_lock);
+
+	nfc_genl_target_lost(dev, target_idx);
+
+	return 0;
+}
+EXPORT_SYMBOL(nfc_target_lost);
+
 static void nfc_release(struct device *d)
 {
 	struct nfc_dev *dev = to_nfc_dev(d);
-- 
1.7.9.1

