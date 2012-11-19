Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41684 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2KSSiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:08 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: [PATCH 137/493] NFC: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:21:26 -0500
Message-Id: <1353349642-3677-137-git-send-email-wfp5p@virginia.edu> (sfid-20121119_193832_020642_A2924EAF)
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
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
index fb430d8..407cdd6 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -469,7 +469,7 @@ static struct i2c_driver pn544_hci_i2c_driver = {
 		  },
 	.probe = pn544_hci_i2c_probe,
 	.id_table = pn544_hci_i2c_id_table,
-	.remove = __devexit_p(pn544_hci_i2c_remove),
+	.remove = pn544_hci_i2c_remove,
 };
 
 static int __init pn544_hci_i2c_init(void)
-- 
1.8.0

