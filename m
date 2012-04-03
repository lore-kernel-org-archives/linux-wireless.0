Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:29451 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab2DCBlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 21:41:01 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 0/4] rt2800: fix initialization after legacy driver
Date: Tue,  3 Apr 2012 03:40:46 +0200
Message-Id: <1333417250-24560-1-git-send-email-kubakici@wp.pl> (sfid-20120403_034106_410024_6AA4C0F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the main purpose of this set is to make it possible to switch between
rt2800pci and legacy driver w/o rebooting or suspending whole machine.
Today rt2800pci will fail to bring the interface up if it was earlier
operated by legacy drv. I'm sure it happens with rt3090, rt2860 seems
to work fine.

First two patches bring back disabling DMA before loading firmware, 
third and fourth actually fix the take over issue.

Jakub Kicinski (4):
  rt2800: introduce wpdma_disable function
  rt2800: add disabling of DMA before loading firmware
  rt2800: initialize queues before giving up due to DMA error
  rt2800: zero registers of unused TX rings

 drivers/net/wireless/rt2x00/rt2800lib.c |   36 +++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   26 +++++++++++++---------
 3 files changed, 36 insertions(+), 27 deletions(-)

-- 
1.7.7.6

