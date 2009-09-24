Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43117 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbZIXDHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] atheros: move ath9k hw code to a module
Date: Wed, 23 Sep 2009 23:06:58 -0400
Message-Id: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on review through IRC of my RFC patches about moving ath9k hw
code onto ath/ we determined its best to separate hw code from the
ath module and instead use a separate new module. Since its shared
between ath9k and ath9k_htc and since I'm working on reducing the
number of files ath9k_htc has we'll just keep this new module,
ath9k_hw, under ath9k/ as well as the future ath9k_htc module.

This patch series was rebased as of today's wireless-testing and
applies on top of the other pending ath9k patches, specifically
on top of Senthil's patch, "ath9k: Fix bugs in handling TX power".

If you have today's wireless-testing and want to apply all
pending ath9k patches you can get all 61 patches from here:

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-23.patch

Its sha1sum is: 90b59e0c85029a89bff7c6ec064220586cc6543e

If you're working on new patches please rebase on top of these.

Luis R. Rodriguez (4):
  ath9k: use common read/write ops on pci and debug code
  ath9k: move hw code to its own module
  ath9k_hw: print device ID if not supported
  ath9k_hw: add AR9271 srev and device ID to allow hw to support ar9271

 drivers/net/wireless/ath/Makefile       |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig  |    4 ++
 drivers/net/wireless/ath/ath9k/Makefile |   27 ++++++------
 drivers/net/wireless/ath/ath9k/ani.c    |    2 +
 drivers/net/wireless/ath/ath9k/btcoex.c |    6 +++
 drivers/net/wireless/ath/ath9k/calib.c  |    3 +
 drivers/net/wireless/ath/ath9k/debug.c  |   21 ++++++----
 drivers/net/wireless/ath/ath9k/hw.c     |   71 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h     |    5 ++
 drivers/net/wireless/ath/ath9k/mac.c    |   30 +++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c    |    4 +-
 11 files changed, 148 insertions(+), 27 deletions(-)

