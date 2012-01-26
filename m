Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:26244 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2AZGOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 01:14:09 -0500
Date: Thu, 26 Jan 2012 09:13:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] nfc: NULL vs zero in nci_activate_target()
Message-ID: <20120126061330.GA15856@elgon.mountain> (sfid-20120126_071451_294795_EA2FE14F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a pointer so it should be NULL instead of zero.  Sparse
complains about this stuff:
net/nfc/nci/core.c:447:37: warning: Using plain integer as NULL pointer

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 12d1d4d..a47e90c 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -444,7 +444,7 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	struct nci_rf_discover_select_param param;
-	struct nfc_target *target = 0;
+	struct nfc_target *target = NULL;
 	int i;
 	int rc = 0;
 
