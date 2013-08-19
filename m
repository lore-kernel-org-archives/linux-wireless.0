Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35155 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab3HSNLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 09:11:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 0/6] rt2x00: fix beaconing on RT3593
Date: Mon, 19 Aug 2013 15:11:12 +0200
Message-Id: <1376917878-25094-1-git-send-email-juhosg@openwrt.org> (sfid-20130819_151136_849451_997BED28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (6):
  rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
  rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
  rt2x00: rt2800: serialize shared memory access
  rt2x00: rt2800lib: add rt2800_hw_beacon_base helper
  rt2x00: rt2800lib: don't hardcode beacon offsets
  rt2x00: rt2800lib: fix beacon generation on RT3593

 drivers/net/wireless/rt2x00/rt2800.h    |   18 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c |  141 ++++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2800lib.h |   42 +++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +++
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 ++
 5 files changed, 193 insertions(+), 23 deletions(-)

--
1.7.10
