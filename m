Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:47887 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZKQLYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 06:24:50 -0500
Message-ID: <4B0281CA.9030101@uni-dortmund.de>
Date: Tue, 17 Nov 2009 11:58:18 +0100
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	"Christian Lamparter" <chunkeey@web.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Joerg Albert" <jal2@gmx.de>
Subject: [PATCH] ar9170: Add support for D-Link DWA 160 A2
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At least two revisions of the D-Link DWA 160 exist, called A1 and A2. A1
(USB-ID 07d1:3c10) is already listed in usb.c as D-Link DWA 160A. A2
(USB-ID 07d1:3a09) works if added to ar9170_usb_ids. I didn't do much
testing until now, but I was able to connect to APs using WPA or WEP and
transmit data. This patch is against current wireless-testing (rev
b648d866b42a29f027262542d636155e3cb4b3cb).

Summary:

* Add model revision number to the comment for D-Link DWA 160 A1 (07d1:3c10)
* Add support for D-Link DWA 160 A2 (07d1:3a09)

Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>

---
 drivers/net/wireless/ath/ar9170/usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c
b/drivers/net/wireless/ath/ar9170/usb.c
index 6bdcdf6..e0799d9 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -68,8 +68,10 @@ static struct usb_device_id ar9170_usb_ids[] = {
        { USB_DEVICE(0x0cf3, 0x1002) },
        /* Cace Airpcap NX */
        { USB_DEVICE(0xcace, 0x0300) },
-       /* D-Link DWA 160A */
+       /* D-Link DWA 160 A1 */
        { USB_DEVICE(0x07d1, 0x3c10) },
+       /* D-Link DWA 160 A2 */
+       { USB_DEVICE(0x07d1, 0x3a09) },
        /* Netgear WNDA3100 */
        { USB_DEVICE(0x0846, 0x9010) },
        /* Netgear WN111 v2 */

