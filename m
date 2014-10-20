Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56394 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTM22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:28 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so3818310lbv.35
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/6] ath10k: pci related fixes 2014-10-09
Date: Mon, 20 Oct 2014 14:14:36 +0200
Message-Id: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142832_438896_4A38962D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First 2 patches address some irq issues.

Other 4 fix and cleanup device resetting.

Hopefully this will make ath10k a little more
robust when it comes to warm reset.

As a side effect of the changes ath10k now boots a
little faster (slightly over a second instead of
two).

v2:
 * don't remove power_up/down [Kalle]
 * fix CE crash [Janusz]
 * remove irq workaround in patch #2


Michal Kazior (6):
  ath10k: re-disable interrupts after target init
  ath10k: mask/unmask msi fw irq
  ath10k: split ce pipe init/alloc further
  ath10k: make warm reset a bit safer and faster
  ath10k: split reset logic from power up
  ath10k: don't reset chip on power_down

 drivers/net/wireless/ath/ath10k/ce.c  |  56 +++--
 drivers/net/wireless/ath/ath10k/ce.h  |   8 +-
 drivers/net/wireless/ath/ath10k/hw.h  |   1 +
 drivers/net/wireless/ath/ath10k/pci.c | 390 +++++++++++++++++-----------------
 4 files changed, 227 insertions(+), 228 deletions(-)

-- 
1.8.5.3

