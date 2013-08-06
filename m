Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:47030 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3HFL2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 07:28:48 -0400
Subject: [PATCH] zd1201: do not use stack as URB transfer_buffer
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 14:28:42 +0300
Message-ID: <20130806112842.14897.95337.stgit@localhost6.localdomain6> (sfid-20130806_132853_065218_4D3F1A6A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes zd1201 not to use stack as URB transfer_buffer. URB buffers need
to be DMA-able, which stack is not.

Patch is only compile tested.

Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 drivers/net/wireless/zd1201.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 4941f20..b8ba1f9 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
 		goto exit;
 
 	err = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), 0x4,
-	    USB_DIR_IN | 0x40, 0,0, &ret, sizeof(ret), ZD1201_FW_TIMEOUT);
+	    USB_DIR_IN | 0x40, 0, 0, buf, sizeof(ret), ZD1201_FW_TIMEOUT);
 	if (err < 0)
 		goto exit;
 
+	memcpy(&ret, buf, sizeof(ret));
+
 	if (ret & 0x80) {
 		err = -EIO;
 		goto exit;

