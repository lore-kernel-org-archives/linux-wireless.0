Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:42537 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2C0OvO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 10:51:14 -0400
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 0/4] rt2x00: fix initialization after legacy driver
Date: Tue, 27 Mar 2012 16:51:03 +0200
Message-Id: <1332859867-27921-1-git-send-email-kubakici@wp.pl> (sfid-20120327_165119_432167_AA4F8945)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been testing these patches for a few weeks and I think it's about 
the time to post them.

The main purpose of this set is to make it possible to switch between
rt2800pci and legacy driver w/o rebooting or suspending whole machine.
Today rt2800pci will fail to bring the interface up if it was earlier
operated by legacy drv. I'm sure it happens with rt3090, rt2860 seems
to work fine.

First two patches are just random fixes, third and fourth actually 
fix the issue.

Jakub Kicinski (4):
  rt2x00: broaden PCIE L1-state wakeup configuration
  rt2x00: move disabling of DMA before loading firmware
  rt2x00: initialize queues before giving up due to DMA error
  rt2x00: zero registers of unused TX rings

 drivers/net/wireless/rt2x00/rt2800lib.c |   23 ++++++++++-------------
 drivers/net/wireless/rt2x00/rt2800pci.c |   21 +++++++++++++++------
 2 files changed, 25 insertions(+), 19 deletions(-)

-- 
1.7.7.6

