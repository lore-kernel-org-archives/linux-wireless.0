Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39616 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab2AaXOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 18:14:06 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, m@bues.ch, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] ssb/bcma: misc fixes
Date: Wed,  1 Feb 2012 00:13:52 +0100
Message-Id: <1328051636-15449-1-git-send-email-hauke@hauke-m.de> (sfid-20120201_001410_513685_D89CA1B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This contains a fix which makes cardbus work with the PCI host 
controller found on some ssb based SoCs. It also add a log entry for 
informations about the bcma/ssb chip used. The last patch adds support 
for the BCM5354 SoC.

Hauke Mehrtens (4):
  ssb: fix cardbus slot in hostmode
  bcma: log the id, rev and pkg of the chip found
  ssb: log the id, rev and pkg of the chip found
  ssb: add support for bcm5354

 drivers/bcma/scan.c                 |   10 +++++--
 drivers/ssb/driver_chipcommon_pmu.c |   48 +++++++++++++++++++++++++++++++---
 drivers/ssb/driver_mipscore.c       |    3 ++
 drivers/ssb/driver_pcicore.c        |    2 +-
 drivers/ssb/main.c                  |    3 ++
 drivers/ssb/scan.c                  |    3 ++
 drivers/ssb/ssb_private.h           |    4 +++
 7 files changed, 64 insertions(+), 9 deletions(-)

-- 
1.7.5.4

