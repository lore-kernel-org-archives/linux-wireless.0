Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48634 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453Ab3EOOwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:52:37 -0400
Subject: [PATCH 00/29] ath10k: mac80211 driver for Qualcomm Atheros qca988x
 devices
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Wed, 15 May 2013 17:42:36 +0300
Message-ID: <20130515143356.4492.43033.stgit@localhost6.localdomain6> (sfid-20130515_165305_764857_9D240305)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a new mac80211 driver for Qualcomm Atheros qca988x devices.
A major difference from ath9k is that there's now a firmware and
that's why we had to implement a new driver.

I'll first submit the driver in smaller patches, one file per
patch, to make it easier to review. The final version will
be one big patch, perhaps submitted through ath6kl.git?

Various people have been contributing to ath10k and I will prepare
a proper author list for the final commit log. I'm hoping to
get this driver to 3.11.

Please review and comment.

---

Kalle Valo (29):
      ath10k: add bmi.c
      ath10k: add bmi.h
      ath10k: add ce.c
      ath10k: add ce.h
      ath10k: add core.c
      ath10k: add core.h
      ath10k: add debug.c
      ath10k: add debug.h
      ath10k: add hif.h
      ath10k: add htc.c
      ath10k: add htc.h
      ath10k: add htt.c
      ath10k: add htt.h
      ath10k: add htt_rx.c
      ath10k: add htt_tx.c
      ath10k: add hw.h
      ath10k: add mac.c
      ath10k: add mac.h
      ath10k: add pci.c
      ath10k: add pci.h
      ath10k: add rx_desc.h
      ath10k: add targaddrs.h
      ath10k: add trace.c
      ath10k: add trace.h
      ath10k: add txrx.c
      ath10k: add txrx.h
      ath10k: add wmi.c
      ath10k: add wmi.h
      ath10k: add Kconfig and Makefile


 drivers/net/wireless/ath/Kconfig            |    1 
 drivers/net/wireless/ath/Makefile           |    1 
 drivers/net/wireless/ath/ath10k/Kconfig     |   39 
 drivers/net/wireless/ath/ath10k/Makefile    |   20 
 drivers/net/wireless/ath/ath10k/bmi.c       |  295 +++
 drivers/net/wireless/ath/ath10k/bmi.h       |  224 ++
 drivers/net/wireless/ath/ath10k/ce.c        | 1189 +++++++++++
 drivers/net/wireless/ath/ath10k/ce.h        |  516 +++++
 drivers/net/wireless/ath/ath10k/core.c      |  665 ++++++
 drivers/net/wireless/ath/ath10k/core.h      |  369 +++
 drivers/net/wireless/ath/ath10k/debug.c     |  503 +++++
 drivers/net/wireless/ath/ath10k/debug.h     |   89 +
 drivers/net/wireless/ath/ath10k/hif.h       |  137 +
 drivers/net/wireless/ath/ath10k/htc.c       | 1062 ++++++++++
 drivers/net/wireless/ath/ath10k/htc.h       |  372 +++
 drivers/net/wireless/ath/ath10k/htt.c       |  165 +
 drivers/net/wireless/ath/ath10k/htt.h       | 1352 ++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c    | 1167 ++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c    |  436 ++++
 drivers/net/wireless/ath/ath10k/hw.h        |  304 +++
 drivers/net/wireless/ath/ath10k/mac.c       | 2979 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h       |   61 +
 drivers/net/wireless/ath/ath10k/pci.c       | 2506 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.h       |  355 +++
 drivers/net/wireless/ath/ath10k/rx_desc.h   |  990 +++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |  449 ++++
 drivers/net/wireless/ath/ath10k/trace.c     |   20 
 drivers/net/wireless/ath/ath10k/trace.h     |  170 ++
 drivers/net/wireless/ath/ath10k/txrx.c      |  415 ++++
 drivers/net/wireless/ath/ath10k/txrx.h      |   39 
 drivers/net/wireless/ath/ath10k/wmi.c       | 2075 +++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h       | 3011 +++++++++++++++++++++++++++
 32 files changed, 21976 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath10k/Makefile
 create mode 100644 drivers/net/wireless/ath/ath10k/bmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/bmi.h
 create mode 100644 drivers/net/wireless/ath/ath10k/ce.c
 create mode 100644 drivers/net/wireless/ath/ath10k/ce.h
 create mode 100644 drivers/net/wireless/ath/ath10k/core.c
 create mode 100644 drivers/net/wireless/ath/ath10k/core.h
 create mode 100644 drivers/net/wireless/ath/ath10k/debug.c
 create mode 100644 drivers/net/wireless/ath/ath10k/debug.h
 create mode 100644 drivers/net/wireless/ath/ath10k/hif.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htc.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htt.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htt.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htt_rx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htt_tx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/hw.h
 create mode 100644 drivers/net/wireless/ath/ath10k/mac.c
 create mode 100644 drivers/net/wireless/ath/ath10k/mac.h
 create mode 100644 drivers/net/wireless/ath/ath10k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath10k/pci.h
 create mode 100644 drivers/net/wireless/ath/ath10k/rx_desc.h
 create mode 100644 drivers/net/wireless/ath/ath10k/targaddrs.h
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.c
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.h
 create mode 100644 drivers/net/wireless/ath/ath10k/txrx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/txrx.h
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi.h

