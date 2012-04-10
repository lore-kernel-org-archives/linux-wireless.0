Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2DJRfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 13:35:34 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 08/18] NFC: Fix next target_idx type and rename for clarity
Date: Tue, 10 Apr 2012 19:43:10 +0200
Message-Id: <1334079800-10671-9-git-send-email-sameo@linux.intel.com> (sfid-20120410_193537_297618_99867DE2)
In-Reply-To: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
References: <1334079800-10671-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nfc.h |    2 +-
 net/nfc/core.c        |    2 +-
 net/nfc/rawsock.c     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 45f0563..f4f6950 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -89,7 +89,7 @@ struct nfc_genl_data {
 
 struct nfc_dev {
 	unsigned idx;
-	unsigned target_idx;
+	u32 target_next_idx;
 	struct nfc_target *targets;
 	int n_targets;
 	int targets_generation;
diff --git a/net/nfc/core.c b/net/nfc/core.c
index d924000..db88429 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -435,7 +435,7 @@ int nfc_targets_found(struct nfc_dev *dev,
 	dev->polling = false;
 
 	for (i = 0; i < n_targets; i++)
-		targets[i].idx = dev->target_idx++;
+		targets[i].idx = dev->target_next_idx++;
 
 	spin_lock_bh(&dev->targets_lock);
 
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index b2825aa..ec1134c 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -92,8 +92,8 @@ static int rawsock_connect(struct socket *sock, struct sockaddr *_addr,
 		goto error;
 	}
 
-	if (addr->target_idx > dev->target_idx - 1 ||
-	    addr->target_idx < dev->target_idx - dev->n_targets) {
+	if (addr->target_idx > dev->target_next_idx - 1 ||
+	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
 		rc = -EINVAL;
 		goto error;
 	}
-- 
1.7.9.1

