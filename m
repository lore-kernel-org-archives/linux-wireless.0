Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52680 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbcABUzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 15:55:42 -0500
Subject: [PATCH 2/3] NFC-mei_phy: Refactoring for mei_nfc_if_version()
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
Message-ID: <56883947.7050505@users.sourceforge.net> (sfid-20160102_215558_896623_F7FE1019)
Date: Sat, 2 Jan 2016 21:55:35 +0100
MIME-Version: 1.0
In-Reply-To: <56883849.2080304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 21:33:04 +0100

Rename a jump label according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/nfc/mei_phy.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 8e3a69f..3c74028 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -136,7 +136,7 @@ static int mei_nfc_if_version(struct nfc_mei_phy *phy)
 	if (bytes_recv < 0 || bytes_recv < sizeof(struct mei_nfc_reply)) {
 		pr_err("Could not read IF version\n");
 		r = -EIO;
-		goto err;
+		goto free_reply;
 	}
 
 	version = (struct mei_nfc_if_version *)reply->data;
@@ -144,8 +144,7 @@ static int mei_nfc_if_version(struct nfc_mei_phy *phy)
 	phy->fw_ivn = version->fw_ivn;
 	phy->vendor_id = version->vendor_id;
 	phy->radio_type = version->radio_type;
-
-err:
+free_reply:
 	kfree(reply);
 	return r;
 }
-- 
2.6.3

