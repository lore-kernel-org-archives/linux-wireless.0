Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50181 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0JHOZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 10:25:00 -0400
Subject: wireless-testing: Branch to be pulled into wireless-testing
From: Luciano Coelho <luciano.coelho@nokia.com>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 17:24:40 +0300
Message-ID: <1286547880.21349.191.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

As we agreed, I have created a branch with the MMC patches that are
needed in order to compile wl1271 properly.  They were not directly
cherry-picked from mmc-next, but they are equivalent.  There is only one
extra patch "wl12xx: rebase sdio macro to the version in the wl12xx
tree", which Ohad created in order to fix a dependency on other changes
that are in mmc-next.

You can pull this branch into wireless-testing in order to avoid a build
break that will be introduced by the 2 wl1271 patches I send for pulling
earlier today.

The following changes since commit 4b8f8abb4fcb14b2a7b33a445e651dc24a2fc48c:
  John W. Linville (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wireless-testing

Ohad Ben-Cohen (11):
      PM / Runtime: Lenient generic runtime pm callbacks
      mmc: sdio: fully reconfigure oldcard on resume
      mmc: propagate power save/restore ops return value
      sdio: add power_restore support
      mmc: add runtime PM handlers
      sdio: use the generic runtime PM handlers
      sdio: enable runtime PM for SDIO cards
      sdio: enable runtime PM for SDIO functions
      sdio: ensure mmc_sdio_detect is powered
      sdio: support suspend/resume while runtime suspendedThe following changes since commit 4b8f8abb4fcb14b2a7b33a445e651dc24a2fc48c:
  John W. Linville (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wireless-testing

Ohad Ben-Cohen (11):
      PM / Runtime: Lenient generic runtime pm callbacks
      mmc: sdio: fully reconfigure oldcard on resume
      mmc: propagate power save/restore ops return value
      sdio: add power_restore support
      mmc: add runtime PM handlers
      sdio: use the generic runtime PM handlers
      sdio: enable runtime PM for SDIO cards
      sdio: enable runtime PM for SDIO functions
      sdio: ensure mmc_sdio_detect is powered
      sdio: support suspend/resume while runtime suspended
      wl12xx: rebase sdio macro to the version in the wl12xx tree

 drivers/base/power/generic_ops.c |    4 +-
 drivers/mmc/core/bus.c           |   37 ++++++++++++++++
 drivers/mmc/core/core.c          |   20 ++++++---
 drivers/mmc/core/core.h          |    4 +-
 drivers/mmc/core/mmc.c           |    8 +++-
 drivers/mmc/core/sd.c            |    8 +++-
 drivers/mmc/core/sdio.c          |   54 ++++++++++++++++++++----
 drivers/mmc/core/sdio_bus.c      |   85 +++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/host.h         |    4 +-
 9 files changed, 197 insertions(+), 27 deletions(-)

      wl12xx: rebase sdio macro to the version in the wl12xx tree

 drivers/base/power/generic_ops.c |    4 +-
 drivers/mmc/core/bus.c           |   37 ++++++++++++++++
 drivers/mmc/core/core.c          |   20 ++++++---
 drivers/mmc/core/core.h          |    4 +-
 drivers/mmc/core/mmc.c           |    8 +++-
 drivers/mmc/core/sd.c            |    8 +++-
 drivers/mmc/core/sdio.c          |   54 ++++++++++++++++++++----
 drivers/mmc/core/sdio_bus.c      |   85 +++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/host.h         |    4 +-
 9 files changed, 197 insertions(+), 27 deletions(-)


-- 
Cheers,
Luca.

