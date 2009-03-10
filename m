Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZCJCHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:07:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] ath9k: Fix usage on SMP systems with PCI devices
Date: Mon,  9 Mar 2009 22:07:00 -0400
Message-Id: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030710_131268_8580112F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's the long expected finished serialization series for ath9k
which fixes usage of ath9k on PCI devices with SMP systems. The
CPU notifier is perhaps overkill but technically it is correct.

I finally managed to get a system to test this thing on and was able
to reproduce and at least for me and Adel Gadllah it fixes the issue
on STA, AP and IBSS modes.

I would usually wait on for more testing but at this point I'm quite
happy with the results. The serialization components are candidates for
stable, the cpu notifier is not required we assume we don't want to support
CPU hotplug for 2.6.27 and 2.6.28 :)

Luis R. Rodriguez (4):
  ath9k: implement IO serialization
  ath9k: AR9280 PCI devices must serialize IO as well
  ath9k: add cpu notifier to enhance device configuration
  ath9k: remove dummy PCI "retry timeout" fix

 drivers/net/wireless/ath9k/ath9k.h |    8 ++++
 drivers/net/wireless/ath9k/hw.c    |   73 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath9k/hw.h    |   11 ++++-
 drivers/net/wireless/ath9k/main.c  |   30 +++++++++++++++
 drivers/net/wireless/ath9k/pci.c   |   22 ++---------
 5 files changed, 123 insertions(+), 21 deletions(-)

