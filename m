Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab2AXNJv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 08:09:51 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/4] rt2800usb: remove PWR_PIN_CFG=0x3 during init
Date: Tue, 24 Jan 2012 14:09:09 +0100
Message-Id: <1327410549-4714-4-git-send-email-sgruszka@redhat.com> (sfid-20120124_140954_818135_A353FEFA)
In-Reply-To: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems to be only needed as workaround for hardware problem on
PCI devices.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 425267a..f0074bc 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -226,8 +226,6 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00usb_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 	rt2x00usb_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
 
-	rt2x00usb_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
-
 	reg = 0;
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 1);
-- 
1.7.1

