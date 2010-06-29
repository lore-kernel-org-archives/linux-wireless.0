Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38403 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab0F2TvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:08 -0400
Received: by wwb18 with SMTP id 18so547wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:06 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/21] rt2x00: Correctly detect 93C86 EEPROMs in rt2800pci.
Date: Tue, 29 Jun 2010 21:44:18 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292143.04173.IvDoorn@gmail.com> <201006292143.45392.IvDoorn@gmail.com>
In-Reply-To: <201006292143.45392.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292144.19486.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 0af53bd..b48b949 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -139,8 +139,18 @@ static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 	eeprom.data = rt2x00dev;
 	eeprom.register_read = rt2800pci_eepromregister_read;
 	eeprom.register_write = rt2800pci_eepromregister_write;
-	eeprom.width = !rt2x00_get_field32(reg, E2PROM_CSR_TYPE) ?
-	    PCI_EEPROM_WIDTH_93C46 : PCI_EEPROM_WIDTH_93C66;
+	switch (rt2x00_get_field32(reg, E2PROM_CSR_TYPE))
+	{
+	case 0:
+		eeprom.width = PCI_EEPROM_WIDTH_93C46;
+		break;
+	case 1:
+		eeprom.width = PCI_EEPROM_WIDTH_93C66;
+		break;
+	default:
+		eeprom.width = PCI_EEPROM_WIDTH_93C86;
+		break;
+	}
 	eeprom.reg_data_in = 0;
 	eeprom.reg_data_out = 0;
 	eeprom.reg_data_clock = 0;
-- 
1.6.6.1

