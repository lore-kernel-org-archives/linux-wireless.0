Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s14.blu0.hotmail.com ([65.55.111.89]:4974 "EHLO
	blu0-omc2-s14.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab3ALKrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 05:47:09 -0500
Message-ID: <BLU0-SMTP98AD32E757F0A7255A238DAC280@phx.gbl> (sfid-20130112_114714_653632_7F08D37A)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 2/5] bcma: jump to 'out' label for invalid 'func' value
Date: Sat, 12 Jan 2013 02:46:14 -0800
In-Reply-To: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
References: <1357987577-20661-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Consistently jump to the 'out' label for error conditions (adds
missing check for 'func' validity in bcma_extpci_write_config).

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 56073a5..187cc9f 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -94,7 +94,7 @@ static int bcma_extpci_read_config(struct bcma_drv_pci *pc, unsigned int dev,
 	if (dev == 0) {
 		/* we support only two functions on device 0 */
 		if (func > 1)
-			return -EINVAL;
+			goto out;
 
 		/* accesses to config registers with offsets >= 256
 		 * requires indirect access.
@@ -157,6 +157,10 @@ static int bcma_extpci_write_config(struct bcma_drv_pci *pc, unsigned int dev,
 	if (unlikely(len != 1 && len != 2 && len != 4))
 		goto out;
 	if (dev == 0) {
+		/* we support only two functions on device 0 */
+		if (func > 1)
+			goto out;
+
 		/* accesses to config registers with offsets >= 256
 		 * requires indirect access.
 		 */
-- 
1.7.7.6

