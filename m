Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8976 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911AbbJVJMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 05:12:21 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v4 04/10] nfc: nci: Do not call post_setup when setup fails
Date: Thu, 22 Oct 2015 12:11:36 +0300
Message-Id: <1445505102-16639-5-git-send-email-robert.dolca@intel.com> (sfid-20151022_113342_873299_5DB428FB)
In-Reply-To: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
References: <1445505102-16639-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver should know that it can continue with post setup where
setup left off. Being able to execute post_setup when setup fails may
force the developer to keep this state in the driver.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 net/nfc/nci/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 0909720..5362d8f 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -402,9 +402,8 @@ static int nci_open_device(struct nci_dev *ndev)
 				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
 	}
 
-	if (ndev->ops->post_setup) {
+	if (!rc && ndev->ops->post_setup)
 		rc = ndev->ops->post_setup(ndev);
-	}
 
 	if (!rc) {
 		rc = __nci_request(ndev, nci_init_complete_req, 0,
-- 
1.9.1

