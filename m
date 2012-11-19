Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41520 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2KSSfV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:21 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: [PATCH 473/493] nfc: remove use of __devexit
Date: Mon, 19 Nov 2012 13:27:02 -0500
Message-Id: <1353349642-3677-473-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193550_383332_6CB05A57)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org> 
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org> 
Cc: Samuel Ortiz <sameo@linux.intel.com> 
Cc: linux-wireless@vger.kernel.org 
Cc: linux-nfc@lists.01.org 
---
 drivers/nfc/pn544/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index d48a806..a85d4aa4 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -442,7 +442,7 @@ err_phy_alloc:
 	return r;
 }
 
-static __devexit int pn544_hci_i2c_remove(struct i2c_client *client)
+static int pn544_hci_i2c_remove(struct i2c_client *client)
 {
 	struct pn544_i2c_phy *phy = i2c_get_clientdata(client);
 	struct pn544_nfc_platform_data *pdata = client->dev.platform_data;
-- 
1.8.0

