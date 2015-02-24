Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49822 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbbBXKCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:02:36 -0500
From: Robert Dolca <robert.dolca@intel.com>
To: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Robert Dolca <robert.dolca@intel.com>
Subject: [PATCH 5/8] NFC: NCI: Don't call setup if previous NCI request failed
Date: Tue, 24 Feb 2015 12:01:49 +0200
Message-Id: <1424772112-27399-6-git-send-email-robert.dolca@intel.com> (sfid-20150224_110534_812612_3D91E2BA)
In-Reply-To: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the previous nci_request (NCI reset) failed the setup function
was being called anyway. It shouldn't be called if the reset failed.

The result of the setup function is taken into consideration. If it
fails the init should fail.

Signed-off-by: Robert Dolca <robert.dolca@intel.com>
---
 net/nfc/nci/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 1a449ac..d2e7adf 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -365,8 +365,8 @@ static int nci_open_device(struct nci_dev *ndev)
 	rc = __nci_request(ndev, nci_reset_req, 0,
 			   msecs_to_jiffies(NCI_RESET_TIMEOUT));
 
-	if (ndev->ops->setup)
-		ndev->ops->setup(ndev);
+	if (!rc && ndev->ops->setup)
+		rc = ndev->ops->setup(ndev);
 
 	if (!rc) {
 		rc = __nci_request(ndev, nci_init_req, 0,
-- 
1.9.1

