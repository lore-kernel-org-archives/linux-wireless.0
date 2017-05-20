Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35409 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdETUd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 16:33:59 -0400
Received: by mail-lf0-f68.google.com with SMTP id 99so2388708lfu.2
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 13:33:59 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 0/3] ath10k usb support
Date: Sat, 20 May 2017 22:33:27 +0200
Message-Id: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20170520_223411_905882_690837C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the 2nd version of the ath10k USB RFC. There are only minor updates
since last version.

The main difference when compared to the previous RFC is that the
high latency stuff that is common between USB and SDIO has been moved out
of this patchset and into another (separate) patchset.

I was actually thinking about squashing all the patches into one, but
decided not to do so since I wanted usb.h, usb.c and the update Kconfig +
Makefile in one separate patch.

Perhaps patch 1 and 2 should be squashed?

Erik Stromdahl (3):
  ath10k: various usb related definitions
  ath10k: different fw file names for usb
  ath10k: add initial USB support

 drivers/net/wireless/ath/ath10k/Kconfig  |    7 +
 drivers/net/wireless/ath/ath10k/Makefile |    3 +
 drivers/net/wireless/ath/ath10k/core.c   |    1 +
 drivers/net/wireless/ath/ath10k/core.h   |    3 +
 drivers/net/wireless/ath/ath10k/debug.h  |    2 +
 drivers/net/wireless/ath/ath10k/usb.c    | 1128 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/usb.h    |  128 ++++
 7 files changed, 1272 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.c
 create mode 100644 drivers/net/wireless/ath/ath10k/usb.h

-- 
2.7.4
