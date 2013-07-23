Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57661 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab3GWCS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 14/21] mwifiex: add unregister_dev handler for usb interface
Date: Mon, 22 Jul 2013 19:17:51 -0700
Message-ID: <1374545878-15683-15-git-send-email-bzhao@marvell.com> (sfid-20130723_041914_349198_7CDBF25A)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Clear the data pointer stored in USB interface structure in
this handler. This helps to return from mwifiex_usb_disconnect()
if driver deinitialization is already performed while handling
an error path for mwifiex_usb_probe().

USB8797 card gets enumerated twice. First enumeration is for
firmware download and second enumeration expects firmware
initialization. mwifiex_usb_probe() always takes care of
deinitialization for first enumeration after firmware download.

Also, this change matches our handling for SDIO and PCIe
interfaces.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index f90fe21..fca98b5 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -786,6 +786,13 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+
+	usb_set_intfdata(card->intf, NULL);
+}
+
 static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 				    struct mwifiex_fw_image *fw)
 {
@@ -978,6 +985,7 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 
 static struct mwifiex_if_ops usb_ops = {
 	.register_dev =		mwifiex_register_dev,
+	.unregister_dev =	mwifiex_unregister_dev,
 	.wakeup =		mwifiex_pm_wakeup_card,
 	.wakeup_complete =	mwifiex_pm_wakeup_card_complete,
 
-- 
1.8.2.3

