Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55827 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943473AbcJSPA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:00:56 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/5] nfc: mei_phy: get phy from the driver data
Date: Wed, 19 Oct 2016 16:33:30 +0300
Message-Id: <1476884011-20645-5-git-send-email-tomas.winkler@intel.com> (sfid-20161019_174232_238255_B1612216)
In-Reply-To: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
References: <1476884011-20645-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to remove rather redundant context from the callback
signature we the get nfc mei_phy from the driver's data.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/nfc/mei_phy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 83deda4bb4d6..66dfd81ffb18 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -300,7 +300,10 @@ static int mei_nfc_recv(struct nfc_mei_phy *phy, u8 *buf, size_t length)
 static void nfc_mei_event_cb(struct mei_cl_device *cldev, u32 events,
 			     void *context)
 {
-	struct nfc_mei_phy *phy = context;
+	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
+
+	if (!phy)
+		return;
 
 	if (phy->hard_fault != 0)
 		return;
-- 
2.7.4
