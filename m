Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34897 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdEINb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:31:27 -0400
Received: by mail-pf0-f196.google.com with SMTP id u26so50525pfd.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 06:31:26 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 00/11] Firmware loading changes
Date: Tue,  9 May 2017 19:00:03 +0530
Message-Id: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170509_153140_951626_26AACED1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes firmware loading enhancements for
Redpine 9113 chipset. The older method is not being used by any
Redpine chipset. There is no firmware image submitted to upstream
yet. We will submit 9113's firmware image once these changes are
accepted.

This patch series is based on original work submitted by Prameela
earlier. We have done some cleanup work and prepared smaller
incremental patches. We will start maintaining changelog for further
revisions.

Prameela Rani Garnepudi (11):
  rsi: Rename file rsi_91x_pkt.c to rsi_91x_hal.c
  rsi: Changes to sdio reads and writes
  rsi: Changes in USB read and write operations
  rsi: use macros in USB specific code
  rsi: Remove unnecessary buffer allocation
  rsi: Handle usb multi-byte write failure case properly
  rsi: Add usb multi-byte read operation
  rsi: Add host interface operations as separate structure.
  rsi: Add new host interface operations
  rsi: Add new firmware loading method
  rsi: Remove old firmware loading method

 drivers/net/wireless/rsi/Makefile           |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c      | 740 ++++++++++++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_pkt.c      | 215 --------
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 211 +++++++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 190 +------
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 182 +++++--
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  | 125 -----
 drivers/net/wireless/rsi/rsi_common.h       |   3 +-
 drivers/net/wireless/rsi/rsi_hal.h          |  90 ++++
 drivers/net/wireless/rsi/rsi_main.h         |  36 +-
 drivers/net/wireless/rsi/rsi_sdio.h         |   6 +-
 drivers/net/wireless/rsi/rsi_usb.h          |   3 -
 12 files changed, 1215 insertions(+), 588 deletions(-)
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_hal.c
 delete mode 100644 drivers/net/wireless/rsi/rsi_91x_pkt.c
 create mode 100644 drivers/net/wireless/rsi/rsi_hal.h

-- 
2.7.4
