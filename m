Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbcCVXRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 19:17:04 -0400
From: Colin King <colin.king@canonical.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@intel.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: set info->ram_patch to NULL when it is released
Date: Tue, 22 Mar 2016 23:17:00 +0000
Message-Id: <1458688620-14219-1-git-send-email-colin.king@canonical.com> (sfid-20160323_001727_496473_1ED944A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

When info->ram_patch is released info->otp_patch is being set
to NULL rather than info->ram_patch. I believe this is a cut-n-paste
bug from almost identical code proceeding it that uses the same
idiom for info->otp_patch.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ccb07a1..177ac9a 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -344,7 +344,7 @@ static void fdp_nci_release_firmware(struct nci_dev *ndev)
 
 	if (info->ram_patch) {
 		release_firmware(info->ram_patch);
-		info->otp_patch = NULL;
+		info->ram_patch = NULL;
 	}
 }
 
-- 
2.7.3

