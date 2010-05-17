Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0EQRPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 13:15:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: remove AR9003 from PCI IDs for now
Date: Mon, 17 May 2010 13:15:30 -0400
Message-Id: <1274116530-29308-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We tried to squeeze as much AR9003 support into this kernel
release cycle but there are a few features which are still
being tested and developed. Some of these features are critical
to the stable operation of AR9003 so for now disable AR9003 support
all together. This will get re-enabled once all necessary features
are in place but very likely will not happen for 2.6.35.

Reviewed-by: Don Breslin <don.breslin@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, after a lot of testing during this kernel release cycle
we do not feel ready for AR9003 for 2.6.35 so AR9003 will have
to wait until 2.6.36. We'll try cherry-picking some linux-next
patches on top of compat-wireless-2.6.35-rc but until we get all
the pending stuff ironed out [1] we just have to disable AR9003
from 2.6.35.

[1] http://wireless.kernel.org/en/users/Drivers/ath9k/todo/ar93xx

 drivers/net/wireless/ath/ath9k/pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 257b10b..1ec836c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -28,7 +28,6 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
-	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 	{ 0 }
 };
 
-- 
1.6.3.3

