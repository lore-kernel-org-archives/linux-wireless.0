Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60339 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaHVMdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:24 -0400
Received: by mail-lb0-f175.google.com with SMTP id 10so9561693lbg.34
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/6] ath10k: ath10k: fixes 2014-08-07, part 2
Date: Fri, 22 Aug 2014 14:23:28 +0200
Message-Id: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143328_980964_DCA0CEFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part 2 (of 3) of my patches. Split for
your reviewing pleasure.

This is related to irq handling only. Prepares for
more start/restart sequences fixes.

v2:
 * patch [1/6] is from part 1
 * patch [5/6] is new
 * some fixes, see notes
 * based on
   f2c7cb774e3e0a8152b1134015c245ba0abddfc6 and
   4 crash dump patches (v8) from Kalle


Michal Kazior (6):
  ath10k: move fw init print
  ath10k: fix legacy irq workaround
  ath10k: setup irq method in probe
  ath10k: split ce irq/handler setup
  ath10k: make sure to really disable irqs
  ath10k: remove early irq handling

 drivers/net/wireless/ath/ath10k/ce.c   |  36 ++--
 drivers/net/wireless/ath/ath10k/ce.h   |  12 +-
 drivers/net/wireless/ath/ath10k/core.c |   6 +-
 drivers/net/wireless/ath/ath10k/core.h |   1 -
 drivers/net/wireless/ath/ath10k/pci.c  | 320 +++++++++++++--------------------
 drivers/net/wireless/ath/ath10k/pci.h  |   1 -
 6 files changed, 142 insertions(+), 234 deletions(-)

-- 
1.8.5.3

