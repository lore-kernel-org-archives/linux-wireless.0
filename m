Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55423 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbcABU4g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 15:56:36 -0500
Subject: [PATCH 3/3] NFC-mei_phy: Delete an unnecessary variable
 initialisation in mei_nfc_if_version()
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
Message-ID: <5688397F.50701@users.sourceforge.net> (sfid-20160102_215640_133304_1B099A6A)
Date: Sat, 2 Jan 2016 21:56:31 +0100
MIME-Version: 1.0
In-Reply-To: <56883849.2080304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 21:40:10 +0100

Omit explicit initialisation at the beginning for one local variable
that is redefined before its first use.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/nfc/mei_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 3c74028..99fd87d 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -105,7 +105,7 @@ static int mei_nfc_if_version(struct nfc_mei_phy *phy)
 {
 
 	struct mei_nfc_cmd cmd;
-	struct mei_nfc_reply *reply = NULL;
+	struct mei_nfc_reply *reply;
 	struct mei_nfc_if_version *version;
 	size_t if_version_length;
 	int bytes_recv, r;
-- 
2.6.3

