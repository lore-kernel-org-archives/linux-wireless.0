Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:29534 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbJMGil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 02:38:41 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] NFC: nfcwilink: Drop a useless static qualifier
Date: Tue, 13 Oct 2015 08:31:04 +0200
Message-Id: <1444717864-7109-1-git-send-email-christophe.jaillet@wanadoo.fr> (sfid-20151013_083846_274519_E2104330)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to have the 'struct nfcwilink *drv' variable static in the
probe function.
It only wastes a few bytes of memory.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nfc/nfcwilink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index ce2e2cf..f81e500 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -497,7 +497,7 @@ static struct nci_ops nfcwilink_ops = {
 
 static int nfcwilink_probe(struct platform_device *pdev)
 {
-	static struct nfcwilink *drv;
+	struct nfcwilink *drv;
 	int rc;
 	__u32 protocols;
 
-- 
2.1.4

