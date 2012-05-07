Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23070 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab2EGKcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:02 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/20] NFC: Remove useless HCI private nfc target table
Date: Mon,  7 May 2012 12:31:14 +0200
Message-Id: <1336386691-24840-4-git-send-email-sameo@linux.intel.com> (sfid-20120507_123206_018725_96F03ED2)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/hci.h |    2 --
 net/nfc/hci/core.c    |    7 -------
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/net/nfc/hci.h b/include/net/nfc/hci.h
index aca65a5..95fc0c2 100644
--- a/include/net/nfc/hci.h
+++ b/include/net/nfc/hci.h
@@ -83,8 +83,6 @@ struct nfc_hci_dev {
 	u8 gate2pipe[NFC_HCI_MAX_GATES];
 
 	bool poll_started;
-	struct nfc_target *targets;
-	int target_count;
 
 	u8 sw_romlib;
 	u8 sw_patch;
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 545c19f..ef5cd5c9 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -235,13 +235,6 @@ static int nfc_hci_target_discovered(struct nfc_hci_dev *hdev, u8 gate)
 	targets->hci_reader_gate = gate;
 
 	r = nfc_targets_found(hdev->ndev, targets, 1);
-	if (r < 0)
-		goto exit;
-
-	kfree(hdev->targets);
-	hdev->targets = targets;
-	targets = NULL;
-	hdev->target_count = 1;
 
 exit:
 	kfree(targets);
-- 
1.7.9.1

