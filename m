Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48938 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2FNUHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 16:07:52 -0400
Received: by dady13 with SMTP id y13so3025799dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 13:07:52 -0700 (PDT)
From: Devendra Naga <devendra.aaru@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] NFC: fix sparse warnings in pn533.c
Date: Fri, 15 Jun 2012 01:37:42 +0530
Message-Id: <1339704462-6931-1-git-send-email-devendra.aaru@gmail.com> (sfid-20120614_220755_877852_D680D9F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

these warnings were showed up,
drivers/nfc/pn533.c:1410:42: warning: Using plain integer as NULL pointer
drivers/nfc/pn533.c:1706:16: warning: symbol 'pn533_nfc_ops' was not declared. Should it be static?

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/nfc/pn533.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 19110f0..9025708 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -1407,7 +1407,7 @@ out:
 
 static int pn533_dep_link_down(struct nfc_dev *nfc_dev)
 {
-	pn533_deactivate_target(nfc_dev, 0);
+	pn533_deactivate_target(nfc_dev, NULL);
 
 	return 0;
 }
@@ -1703,7 +1703,7 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 	return rc;
 }
 
-struct nfc_ops pn533_nfc_ops = {
+static struct nfc_ops pn533_nfc_ops = {
 	.dev_up = NULL,
 	.dev_down = NULL,
 	.dep_link_up = pn533_dep_link_up,
-- 
1.7.9.5

