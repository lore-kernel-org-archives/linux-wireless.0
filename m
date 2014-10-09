Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60549 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaJIIdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:39 -0400
Received: by mail-wg0-f43.google.com with SMTP id m15so705861wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 01:33:37 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: pci related fixes 2014-10-09
Date: Thu,  9 Oct 2014 10:22:25 +0200
Message-Id: <1412842950-14098-1-git-send-email-michal.kazior@tieto.com> (sfid-20141009_103412_716366_2F6CF250)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First 2 patches address some irq issues.

Other 3 fix and cleanup device resetting.

Hopefully this will make ath10k a little more
robust when it comes to warm reset.

As a side effect of the changes ath10k now boots a
little faster (slightly over a second instead of
two).


Michal Kazior (5):
  ath10k: re-disable interrupts after target init
  ath10k: mask/unmask msi fw irq
  ath10k: make warm reset a bit safer and faster
  ath10k: split reset logic from power up
  ath10k: replace power up/down with reset callback

 drivers/net/wireless/ath/ath10k/core.c     |   7 +-
 drivers/net/wireless/ath/ath10k/hif.h      |  22 +--
 drivers/net/wireless/ath/ath10k/hw.h       |   1 +
 drivers/net/wireless/ath/ath10k/mac.c      |   8 +-
 drivers/net/wireless/ath/ath10k/pci.c      | 299 +++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/testmode.c |   8 +-
 6 files changed, 164 insertions(+), 181 deletions(-)

-- 
1.8.5.3

