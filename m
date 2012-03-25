Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:42150 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab2CYOPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 10:15:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH v2 0/9] ath6kl: add full USB support
Date: Sun, 25 Mar 2012 17:15:20 +0300
Message-Id: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120325_161619_128057_5417D347)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds full USB support and new HTC pipe implementation. Please review
and send comments.

Changes in v2:

o fix sizeof(report) in htc_process_trailer() (Ray Chen)
o add EXPORT_SYMBOL() to core.c (Ray Chen)

Kalle Valo (9):
  ath6kl: set ram reserved size only for ar6003
  ath6kl: Add tx_complete() to struct htc_ep_callbacks
  ath6kl: add tx_comp_multi() to struct htc_ep_callbacks
  ath6kl: add pointer to the skb in htc_packet
  ath6kl: add rx data padding support
  ath6kl: remove void pointer from ath6kl_credit_setup()
  ath6kl: add htc ops
  ath6kl: Add HTC pipe implementation
  ath6kl: add full USB support

 drivers/net/wireless/ath/ath6kl/Makefile           |    3 +-
 drivers/net/wireless/ath/ath6kl/core.c             |   27 +-
 drivers/net/wireless/ath/ath6kl/core.h             |   14 +-
 drivers/net/wireless/ath/ath6kl/debug.h            |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |   34 +
 drivers/net/wireless/ath/ath6kl/hif.h              |    6 +
 drivers/net/wireless/ath/ath6kl/htc-ops.h          |  113 ++
 drivers/net/wireless/ath/ath6kl/htc.h              |   98 +-
 .../net/wireless/ath/ath6kl/{htc.c => htc_mbox.c}  |   81 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c         | 1713 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/init.c             |   26 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   20 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |  785 +++++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    3 +
 15 files changed, 2853 insertions(+), 73 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc-ops.h
 rename drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c} (96%)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_pipe.c

