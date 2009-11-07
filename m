Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37890 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbZKGWAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:00:05 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:00:03 +0000
Message-ID: <1257631203.15927.462.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 50/75] libertas: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/libertas/if_cs.c   |    1 +
 drivers/net/wireless/libertas/if_sdio.c |    6 ++++++
 drivers/net/wireless/libertas/if_spi.c  |    4 ++++
 drivers/net/wireless/libertas/if_usb.c  |    2 ++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
index 9127d2a..9834e3f 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -48,6 +48,7 @@
 MODULE_AUTHOR("Holger Schurig <hs4233@mail.mn-solutions.de>");
 MODULE_DESCRIPTION("Driver for Marvell 83xx compact flash WLAN cards");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("libertas_cs_helper.fw");
 


diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 9716728..09fcfad 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -99,6 +99,12 @@ static struct if_sdio_model if_sdio_models[] = {
 		.firmware = "sd8688.bin",
 	},
 };
+MODULE_FIRMWARE("sd8385_helper.bin");
+MODULE_FIRMWARE("sd8385.bin");
+MODULE_FIRMWARE("sd8686_helper.bin");
+MODULE_FIRMWARE("sd8686.bin");
+MODULE_FIRMWARE("sd8688_helper.bin");
+MODULE_FIRMWARE("sd8688.bin");
 
 struct if_sdio_packet {
 	struct if_sdio_packet	*next;
diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index d6a48dd..bf4bfba 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -902,6 +902,10 @@ static int if_spi_calculate_fw_names(u16 card_id,
 		 chip_id_to_device_name[i].name);
 	return 0;
 }
+MODULE_FIRMWARE("libertas/gspi8385_hlp.bin");
+MODULE_FIRMWARE("libertas/gspi8385.bin");
+MODULE_FIRMWARE("libertas/gspi8686_hlp.bin");
+MODULE_FIRMWARE("libertas/gspi8686.bin");
 
 static int __devinit if_spi_probe(struct spi_device *spi)
 {
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index f12d667..65e1745 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -28,6 +28,8 @@
 static char *lbs_fw_name = "usb8388.bin";
 module_param_named(fw_name, lbs_fw_name, charp, 0644);
 
+MODULE_FIRMWARE("usb8388.bin");
+
 static struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001) },
-- 
1.6.5.2



