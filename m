Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49241 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2AHLlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 06:41:03 -0500
Received: by yenm11 with SMTP id m11so1216304yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 03:41:02 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Increase NCI deactivate timeout
Date: Sun,  8 Jan 2012 13:43:02 +0200
Message-Id: <1326022982-30205-1-git-send-email-ilane@ti.com> (sfid-20120108_124109_014269_5C86FE8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Increase NCI deactivate timeout from 5 sec to 30 sec.
NCI deactivate procedure might take a long time,
depending on the local and remote parameters.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index bccd89e..f4963ea 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -47,7 +47,7 @@ enum {
 #define NCI_RESET_TIMEOUT			5000
 #define NCI_INIT_TIMEOUT			5000
 #define NCI_RF_DISC_TIMEOUT			5000
-#define NCI_RF_DEACTIVATE_TIMEOUT		5000
+#define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
 
 struct nci_dev;
-- 
1.7.0.4

