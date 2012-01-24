Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab2AXNJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 08:09:34 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/4] rt2800usb: initialize H2M_INT_SRC register
Date: Tue, 24 Jan 2012 14:09:06 +0100
Message-Id: <1327410549-4714-1-git-send-email-sgruszka@redhat.com> (sfid-20120124_140939_533998_E57CCD20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ralink USB driver initialize H2M_INT_SRC to 0 after firmware load, and
never touch this register later. It is not touched at all by Ralink PCI
driver.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 22a1a8f..3e194b7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -448,6 +448,8 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	if (rt2x00_is_usb(rt2x00dev))
+		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
 	msleep(1);
 
 	return 0;
-- 
1.7.1

