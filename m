Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2130 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXB0VE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 16:04:58 -0500
Date: Tue, 27 Feb 2007 15:50:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070227205045.GF5826@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit c8f71b01a50597e298dc3214a2f2be7b8d31170c:
  Linus Torvalds (1):
        Linux 2.6.21-rc1

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

Stefano Brivio (1):
      bcm43xx: fix for 4309

 drivers/net/wireless/bcm43xx/bcm43xx_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_main.c b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
index 73c831a..e594af4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -2733,8 +2733,9 @@ static int bcm43xx_probe_cores(struct bcm43xx_private *bcm)
 				 * dangling pins on the second core. Be careful
 				 * and ignore these cores here.
 				 */
-				if (bcm->pci_dev->device != 0x4324) {
-					dprintk(KERN_INFO PFX "Ignoring additional 802.11 core.\n");
+				if (1 /*bcm->pci_dev->device != 0x4324*/ ) {
+				/* TODO: A PHY */
+					dprintk(KERN_INFO PFX "Ignoring additional 802.11a core.\n");
 					continue;
 				}
 			}
-- 
John W. Linville
linville@tuxdriver.com
