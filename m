Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60842 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbcABUyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 15:54:43 -0500
Subject: [PATCH 1/3] NFC-mei_phy: Refactoring for mei_nfc_connect()
To: linux-wireless@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <56883849.2080304@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5688390B.3080800@users.sourceforge.net> (sfid-20160102_215500_753074_288124B5)
Date: Sat, 2 Jan 2016 21:54:35 +0100
MIME-Version: 1.0
In-Reply-To: <56883849.2080304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 21:21:24 +0100

This issue was detected by using the Coccinelle software.

Adjust jump targets according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/nfc/mei_phy.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 83deda4..8e3a69f 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -173,8 +173,8 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 
 	reply = kzalloc(connect_resp_length, GFP_KERNEL);
 	if (!reply) {
-		kfree(cmd);
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto free_cmd;
 	}
 
 	connect_resp = (struct mei_nfc_connect_resp *)reply->data;
@@ -189,7 +189,7 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 	r = mei_cldev_send(phy->cldev, (u8 *)cmd, connect_length);
 	if (r < 0) {
 		pr_err("Could not send connect cmd %d\n", r);
-		goto err;
+		goto free_reply;
 	}
 
 	bytes_recv = mei_cldev_recv(phy->cldev, (u8 *)reply,
@@ -197,7 +197,7 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 	if (bytes_recv < 0) {
 		r = bytes_recv;
 		pr_err("Could not read connect response %d\n", r);
-		goto err;
+		goto free_reply;
 	}
 
 	MEI_DUMP_NFC_HDR("connect reply", &reply->hdr);
@@ -210,11 +210,10 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 		connect_resp->me_hotfix, connect_resp->me_build);
 
 	r = 0;
-
-err:
+free_reply:
 	kfree(reply);
+free_cmd:
 	kfree(cmd);
-
 	return r;
 }
 
-- 
2.6.3

