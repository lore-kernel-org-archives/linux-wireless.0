Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40591
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXDGPVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 11:21:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Please pull from http://bu3sch.de/git/wireless-dev.git/ for-linville
Date: Sat, 7 Apr 2007 17:20:39 +0200
MIME-Version: 1.0
Message-Id: <200704071720.39487.mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 32bfb29ad13f7451c3a09f092430b30133fc6739:
  Johannes Berg:
        fix debugfs compile w/o debug counters

are found in the git repository at:

  http://bu3sch.de/git/wireless-dev.git/ for-linville

Mostly bugfixes.

Michael Buesch:
      bcm43xx-mac80211: Fix 2050 radio init value restore for lb gain devices.
      bcm43xx-mac80211: vstack: Fix slight bug and add debugging
      bcm43xx-mac80211: Add more VStack debugging.
      bcm43xx-mac80211: Remove old unsupported devs from the PCI list.
      bcm43xx-mac80211: Update my email address.
      bcm43xx-mac80211: LO setup: Registers are ORed, not overwritten.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Fix extlna flag for 2050 init
      ssb: Do pci core init on attach stage.
      ssb: use container_of for the dev-wrapper.
      ssb: kfree devwrap (not dev) in dev register error path.
      bcm43xx-mac80211: Fix hwencryption breakage for latest firmware.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Replace vstack in LO setup by a data structure.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-dev
      bcm43xx-mac80211: Remove the "vstack" and its remaining uses.

 drivers/net/wireless/mac80211/bcm43xx/Makefile     |   16 +-
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx.h    |   33 ++-
 .../wireless/mac80211/bcm43xx/bcm43xx_debugfs.c    |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_dma.c    |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_leds.c   |    2 
 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_lo.c |  177 ++++++++++--------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.c   |   86 +++++-----
 .../net/wireless/mac80211/bcm43xx/bcm43xx_main.h   |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_pcmcia.c |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_phy.c    |  119 ++++++++------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_pio.c    |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_power.c  |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_power.h  |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_sysfs.c  |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_tables.c |    2 
 .../net/wireless/mac80211/bcm43xx/bcm43xx_vstack.c |  202 -----------------------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_vstack.h |   83 ---------
 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c   |   12 -
 .../net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h   |   35 ++++
 drivers/ssb/main.c                                 |   14 +
 include/linux/ssb/ssb.h                            |    4 
 21 files changed, 307 insertions(+), 494 deletions(-)
 delete mode 100644 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_vstack.c
 delete mode 100644 drivers/net/wireless/mac80211/bcm43xx/bcm43xx_vstack.h

-- 
Greetings Michael.
