Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2GFT7b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:31 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 14/33] NFC: update PN544 HCI driver state when opened/closed
Date: Fri,  6 Jul 2012 22:09:34 +0200
Message-Id: <1341605393-32056-15-git-send-email-sameo@linux.intel.com> (sfid-20120706_220533_174194_CD32CADB)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn544_hci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nfc/pn544_hci.c b/drivers/nfc/pn544_hci.c
index 457eac3..69df6fe 100644
--- a/drivers/nfc/pn544_hci.c
+++ b/drivers/nfc/pn544_hci.c
@@ -377,6 +377,9 @@ static int pn544_hci_open(struct nfc_shdlc *shdlc)
 
 	r = pn544_hci_enable(info, HCI_MODE);
 
+	if (r == 0)
+		info->state = PN544_ST_READY;
+
 out:
 	mutex_unlock(&info->info_lock);
 	return r;
@@ -393,6 +396,8 @@ static void pn544_hci_close(struct nfc_shdlc *shdlc)
 
 	pn544_hci_disable(info);
 
+	info->state = PN544_ST_COLD;
+
 out:
 	mutex_unlock(&info->info_lock);
 }
-- 
1.7.10

