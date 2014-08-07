Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38290 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaHGJO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:14:27 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so3849033wgg.12
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:14:26 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: fixes 2014-08-07, part 3
Date: Thu,  7 Aug 2014 11:05:03 +0200
Message-Id: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111430_479490_1043B0AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part 3 (of 3) of my patches. Split for
your reviewing pleasure.

This is related to start/restart sequences.

This is based on:
  [PATCH 0/5] ath10k: fixes 2014-08-07, part 2


Michal Kazior (5):
  ath10k: rework posting pci rx buffers
  ath10k: dont reset the chip on hif_stop
  ath10k: ignore ar_pci->started in pipe cleanup
  ath10k: remove ar_pci->started
  ath10k: flush hif buffers before recovery

 drivers/net/wireless/ath/ath10k/ce.c   |  71 +++++----
 drivers/net/wireless/ath/ath10k/ce.h   |  16 +-
 drivers/net/wireless/ath/ath10k/core.c |   1 +
 drivers/net/wireless/ath/ath10k/hif.h  |   3 +-
 drivers/net/wireless/ath/ath10k/pci.c  | 279 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h  |   4 +-
 6 files changed, 185 insertions(+), 189 deletions(-)

-- 
1.8.5.3

