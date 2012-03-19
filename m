Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44655 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161643Ab2CSQPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH 0/9] ath6kl: add full USB support
Date: Mon, 19 Mar 2012 18:14:55 +0200
Message-Id: <1332173704-18877-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120319_171657_926889_1E14952D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds full USB support and new HTC pipe implementation. Please review
and send comments.

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
 drivers/net/wireless/ath/ath6kl/core.c             |   25 +-
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
 15 files changed, 2851 insertions(+), 73 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc-ops.h
 rename drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c} (96%)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_pipe.c

