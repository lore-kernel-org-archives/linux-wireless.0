Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30849 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2CDX6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:07 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 15/22] NFC: Export NFCID when detecting a p2p target with pn533
Date: Mon,  5 Mar 2012 01:03:47 +0100
Message-Id: <1330905834-6994-16-git-send-email-sameo@linux.intel.com> (sfid-20120305_005812_653231_E0F7EE7C)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index f5da5ae..ef33f64 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1316,6 +1316,8 @@ static int pn533_in_dep_link_up_complete(struct pn533 *dev, void *arg,
 		nfc_dev_dbg(&dev->interface->dev, "Creating new target");
 
 		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
+		nfc_target.nfcid1_len = 10;
+		memcpy(nfc_target.nfcid1, resp->nfcid3t, nfc_target.nfcid1_len);
 		rc = nfc_targets_found(dev->nfc_dev, &nfc_target, 1);
 		if (rc)
 			return 0;
-- 
1.7.7.3

