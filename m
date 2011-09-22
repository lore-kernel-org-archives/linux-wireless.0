Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:63645 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVIPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 04:15:23 -0400
Received: by gwj16 with SMTP id 16so1404396gwj.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 01:15:22 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: implicitly deactivate in nci_start_poll
Date: Thu, 22 Sep 2011 11:13:01 +0300
Message-Id: <1316679181-4917-1-git-send-email-ilane@ti.com> (sfid-20110922_101527_662011_E1CD8F98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

When start_poll is called, and a target was implicitly activated,
we need to implicitly deactivate it.
On the other hand, when the target was activated by the user,
we should not deactivate it.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 net/nfc/nci/core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 895e5fd..361491b 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -365,8 +365,13 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 		return -EBUSY;
 	}
 
+	if (ndev->target_active_prot) {
+		nfc_err("there is an active target");
+		return -EBUSY;
+	}
+
 	if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
-		nfc_dbg("target already active, first deactivate...");
+		nfc_dbg("target is active, implicitly deactivate...");
 
 		rc = nci_request(ndev, nci_rf_deactivate_req, 0,
 			msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
-- 
1.7.0.4

