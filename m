Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:42536 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab2L0Lw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:52:57 -0500
Subject: [PATCH 0/7] ath6kl: tracing support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:15 +0200
Message-ID: <20121227114156.27069.30223.stgit@localhost6.localdomain6> (sfid-20121227_125303_751021_785FF70B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally I added tracing support to ath6kl, should have done that
a long time ago. The tracing framework is new for me so I would
appreciate some more eyeballs to check these.

---

Kalle Valo (7):
      ath6kl: add tracing support and tracing points for wmi packets
      ath6kl: add tracing points for sdio transfers
      ath6kl: add tracing point for hif irqs
      ath6kl: adding tracing points for htc_mbox
      ath6kl: convert ath6kl_info/err/warn macros to real functions
      ath6kl: add tracing support to log functions
      ath6kl: add tracing support to debug message macros


 drivers/net/wireless/ath/ath6kl/Kconfig    |    9 +
 drivers/net/wireless/ath/ath6kl/Makefile   |    5 
 drivers/net/wireless/ath/ath6kl/debug.c    |   12 +
 drivers/net/wireless/ath/ath6kl/debug.h    |   57 +++++-
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   21 ++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   22 ++
 drivers/net/wireless/ath/ath6kl/trace.c    |   26 +++
 drivers/net/wireless/ath/ath6kl/trace.h    |  283 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c     |    3 
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 
 11 files changed, 432 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.h

