Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbaKZOcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 09:32:21 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com,
	Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 3/4] rt2x00: change REGISTER_TIMEOUT
Date: Wed, 26 Nov 2014 15:29:15 +0100
Message-Id: <1417012156-26197-3-git-send-email-sgruszka@redhat.com> (sfid-20141126_153229_705586_885B548D)
In-Reply-To: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting 500ms for register access is too long, decrease this value
to 100ms.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2x00usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 819690e..8f85fbd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -38,7 +38,7 @@
  * a higher value is required. In that case we use the REGISTER_TIMEOUT_FIRMWARE
  * and EEPROM_TIMEOUT.
  */
-#define REGISTER_TIMEOUT		500
+#define REGISTER_TIMEOUT		100
 #define REGISTER_TIMEOUT_FIRMWARE	1000
 #define EEPROM_TIMEOUT			2000
 
-- 
1.8.3.1

