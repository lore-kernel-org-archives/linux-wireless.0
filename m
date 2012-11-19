Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41424 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2KSSdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:33:44 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: [PATCH 239/493] nfc: remove use of __devinit
Date: Mon, 19 Nov 2012 13:23:08 -0500
Message-Id: <1353349642-3677-239-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193359_163970_DEA4508E)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

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
index 407cdd6..d48a806 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -361,7 +361,7 @@ static struct nfc_phy_ops i2c_phy_ops = {
 	.disable = pn544_hci_i2c_disable,
 };
 
-static int __devinit pn544_hci_i2c_probe(struct i2c_client *client,
+static int pn544_hci_i2c_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
 	struct pn544_i2c_phy *phy;
-- 
1.8.0

