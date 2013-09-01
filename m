Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:53588 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3IAIWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 04:22:11 -0400
Subject: [PATCH v2 0/2] ath10k: detect hw1.0 boards
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 11:22:06 +0300
Message-ID: <20130901082007.1930.79088.stgit@localhost6.localdomain6> (sfid-20130901_102234_673366_F5CC7597)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a patchset which detects hw1.0 from the
chip id register and fails the probe if found.

v2:

o use SOC_CHIP_ID_REV_MASK

o move detection to core.c so that it's not just PCI
  specific

o add debugfs file for reading the chip id

---

Kalle Valo (2):
      ath10k: check chip id from the soc register during probe
      ath10k: add chip_id file to debugfs


 drivers/net/wireless/ath/ath10k/core.c  |   35 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h  |    3 ++-
 drivers/net/wireless/ath/ath10k/debug.c |   22 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h    |    8 +++++++
 drivers/net/wireless/ath/ath10k/pci.c   |   15 ++++++++++++-
 5 files changed, 79 insertions(+), 4 deletions(-)

