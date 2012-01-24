Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2AXNJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 08:09:39 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/4] rt2800: zero MAC_SYS_CTRL bits during BBP and MAC reset
Date: Tue, 24 Jan 2012 14:09:08 +0100
Message-Id: <1327410549-4714-3-git-send-email-sgruszka@redhat.com> (sfid-20120124_140942_523690_18D75A3C)
In-Reply-To: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zero all other bits than RESET_CSR and RESET_BBP when want to do the
reset, that the vendor driver behaviour.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index dc88bae..4e98502 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -489,7 +489,7 @@ static int rt2800pci_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00pci_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
-	rt2x00pci_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	reg = 0;
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
 	rt2x00pci_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 262ee9e..425267a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -228,7 +228,7 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00usb_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
 
-	rt2x00usb_register_read(rt2x00dev, MAC_SYS_CTRL, &reg);
+	reg = 0;
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
 	rt2x00usb_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
-- 
1.7.1

