Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61629 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab2FFKHm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:07:42 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 18/29] NFC: Unregister device if pn533 initial configuration fails
Date: Wed,  6 Jun 2012 12:16:35 +0200
Message-Id: <1338977806-30279-19-git-send-email-sameo@linux.intel.com> (sfid-20120606_120745_206576_58618B5D)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 6b8a65c..2a7e4e8 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2112,13 +2112,17 @@ static int pn533_probe(struct usb_interface *interface,
 	if (rc) {
 		nfc_dev_err(&dev->interface->dev, "Error on setting MAX_RETRIES"
 								" config");
-		goto free_nfc_dev;
+		goto unregister_nfc_dev;
 	}
 
 	return 0;
 
+unregister_nfc_dev:
+	nfc_unregister_device(dev->nfc_dev);
+
 free_nfc_dev:
 	nfc_free_device(dev->nfc_dev);
+
 destroy_wq:
 	destroy_workqueue(dev->wq);
 error:
-- 
1.7.9.1

