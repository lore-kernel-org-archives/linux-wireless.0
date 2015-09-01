Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbbIAOzR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 10:55:17 -0400
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH v2 5/9] nfc: nci: Do not call post_setup when setup fails
Date: Tue,  1 Sep 2015 17:54:24 +0300
Message-Id: <1441119268-30654-6-git-send-email-robert.dolca@intel.com> (sfid-20150901_165723_494835_7B2749B0)
In-Reply-To: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
References: <1441119268-30654-1-git-send-email-robert.dolca@intel.com>
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
index e2bd5f4..29607f9 100644
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

