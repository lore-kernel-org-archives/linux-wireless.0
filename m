Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22563 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2JPQCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 12:02:07 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_htc: Add PID/VID for a Ubiquiti WiFiStation
Date: Tue, 16 Oct 2012 21:31:49 +0530
Message-ID: <1350403309-7407-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121016_180211_889404_14F61AE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Roger says, Ubiquiti produce 2 versions of their WiFiStation USB adapter.  One
has an internal antenna, the other has an external antenna and
name suffix EXT.  They have separate USB ids and in distribution
openSUSE 12.2 (kernel 3.4.6), file /usr/share/usb.ids shows:

  0cf3  Atheros Communications, Inc.
       ...
       b002  Ubiquiti WiFiStation 802.11n [Atheros AR9271]
       b003  Ubiquiti WiFiStationEXT 802.11n [Atheros AR9271]

Add b002 Ubiquiti WiFiStation in the PID/VID list.

Reported-by: Roger Price <ath9k@rogerprice.org>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 924c461..f5dda84 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -38,6 +38,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
 	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
 	{ USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
+	{ USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
 	{ USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
 
 	{ USB_DEVICE(0x0cf3, 0x7015),
-- 
1.7.0.4

