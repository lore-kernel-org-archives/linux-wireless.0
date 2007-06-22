Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42186
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXFVKPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 06:15:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull bcm43xx-mac80211
Date: Fri, 22 Jun 2007 12:13:21 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706221213.21855.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's growing..., better pull it :P
This log includes all the stuff from the last pull request, too.


The following changes since commit 9181e959da76d85d688d8ec763702ed2f3b4edf9:
  John W. Linville:
        rt2x00firmware.c: include delay.h to avoid build error on ppc64

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git/ for-linville

Johannes Berg:
      bcm43xx: honour promisc bit even in monitor mode

Michael Buesch:
      bcm43xx-mac80211: Don't stop the mac80211 software queues in pwork.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Use the mac80211 provided workqueue
      bcm43xx-mac80211: Fix mutex leakage in pwork.
      bcm43xx-mac80211: Flush the workqueue to make sure periodic work has finished.
      bcm43xx-mac80211: Implement runtime debugging mechanism.
      bcm43xx-mac80211: Code to inject TX ring overflows.
      bcm43xx-mac80211: Rewrite the attenuation adjustment.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      ssb: Fix maxpwr and itssi read.
      bcm43xx-mac80211: Add more txpower debugging.
      bcm43xx-mac80211: add debugfs file to manually control txpower
      bcm43xx-mac80211: Some LO cleanups
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Use the dynamic min/max values for adjusting the attenuation.
      ssb: b44 sprom workaround; avoid warning message
      ssb: Rewrite invariants fetching code.
      ssb: Replace ceildiv() by DIV_ROUND_UP()
      bcm43xx-mac80211: Kill all huge udelay()s.
      bcm43xx-mac80211: Add cond_resched() into LO calibration.
      bcm43xx-mac80211: Fix rate memory init for A-PHY.
      bcm43xx-mac80211: Fix MAC address upload.
      bcm43xx-mac80211: Also write BSSID macfilter.
      bcm43xx-mac80211: Add pwork debugging.
      bcm43xx-mac80211: Run TX without taking the global spinlock.

 drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |   39 +
 .../wireless/mac80211/bcm43xx/bcm43xx_debugfs.c    |  216 ++++++++-
 .../wireless/mac80211/bcm43xx/bcm43xx_debugfs.h    |   23 +
 .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.c    |  189 ++++++--
 .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.h    |   12 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_leds.c   |    4 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.c |  117 ++--
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.h |    6 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |  202 ++++----
 .../net/wireless/mac80211/bcm43xx/bcm43xx_pcmcia.c |    7 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  565 ++++++++++++-----------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.h    |   23 -
 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c   |   48 ++
 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h   |   17 +
 drivers/ssb/driver_chipcommon.c                    |   20 -
 drivers/ssb/main.c                                 |   49 +-
 drivers/ssb/pci.c                                  |   76 ++-
 drivers/ssb/pcmcia.c                               |    7 
 drivers/ssb/ssb_private.h                          |   22 -
 include/linux/ssb/ssb.h                            |   41 +
 include/linux/ssb/ssb_regs.h                       |   12 
 21 files changed, 1085 insertions(+), 610 deletions(-)

-- 
Greetings Michael.
