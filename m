Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbcGONBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 09:01:22 -0400
From: Colin King <colin.king@canonical.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: null-ify info->ram_patch when firmware is released
Date: Fri, 15 Jul 2016 14:00:33 +0100
Message-Id: <1468587633-25766-1-git-send-email-colin.king@canonical.com> (sfid-20160715_150142_843817_4AECA273)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

When the firmware is released for info->ram_patch currently
info->otp_patch is being nullified and not info->ram_patch.
This looks like a cut-n-paste coding error. Fix this by
nullifing the correct field.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index e44a7a2..d93d314 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -345,7 +345,7 @@ static void fdp_nci_release_firmware(struct nci_dev *ndev)
 
 	if (info->ram_patch) {
 		release_firmware(info->ram_patch);
-		info->otp_patch = NULL;
+		info->ram_patch = NULL;
 	}
 }
 
-- 
2.8.1

