Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33130 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3FLSQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 14:16:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k-devel@qca.qualcomm.com>
Subject: Pull request: ath10k 20130612
Date: Wed, 12 Jun 2013 21:15:53 +0300
Message-ID: <87ppvrqjom.fsf@kamboji.qca.qualcomm.com> (sfid-20130612_201607_680922_1D1B6861)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here's the pull request for ath10k. This is the same version I submitted
June 1st for the second review, now it's just one big commit with the
necessary changes to Makefile and Kconfig in drivers/net/wireless/ath.

Please let me know if there are any problems.

Kalle

The following changes since commit 8b3e7be437a6b62118d0485ad971e724afe23fdf:

  cw1200: Fix an assorted pile of checkpatch warnings. (2013-06-11 12:48:10 -0400)

are available in the git repository at:

  git://github.com/kvalo/ath6kl.git for-linville-ath10k

for you to fetch changes up to 5e3dd157d7e70f0e3cea3f2573ed69fb156a19d5:

  ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices (2013-06-12 20:52:10 +0300)

----------------------------------------------------------------
Kalle Valo (1):
      ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices

 drivers/net/wireless/ath/Kconfig            |    1 +
 drivers/net/wireless/ath/Makefile           |    1 +
 drivers/net/wireless/ath/ath10k/Kconfig     |   39 +
 drivers/net/wireless/ath/ath10k/Makefile    |   20 +
 drivers/net/wireless/ath/ath10k/bmi.c       |  295 +++
 drivers/net/wireless/ath/ath10k/bmi.h       |  224 ++
 drivers/net/wireless/ath/ath10k/ce.c        | 1189 +++++++++++
 drivers/net/wireless/ath/ath10k/ce.h        |  516 +++++
 drivers/net/wireless/ath/ath10k/core.c      |  665 ++++++
 drivers/net/wireless/ath/ath10k/core.h      |  369 ++++
 drivers/net/wireless/ath/ath10k/debug.c     |  503 +++++
 drivers/net/wireless/ath/ath10k/debug.h     |   90 +
 drivers/net/wireless/ath/ath10k/hif.h       |  137 ++
 drivers/net/wireless/ath/ath10k/htc.c       | 1000 +++++++++
 drivers/net/wireless/ath/ath10k/htc.h       |  368 ++++
 drivers/net/wireless/ath/ath10k/htt.c       |  152 ++
 drivers/net/wireless/ath/ath10k/htt.h       | 1338 ++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c    | 1167 ++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c    |  510 +++++
 drivers/net/wireless/ath/ath10k/hw.h        |  304 +++
 drivers/net/wireless/ath/ath10k/mac.c       | 3066 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h       |   61 +
 drivers/net/wireless/ath/ath10k/pci.c       | 2506 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.h       |  355 ++++
 drivers/net/wireless/ath/ath10k/rx_desc.h   |  990 +++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |  449 ++++
 drivers/net/wireless/ath/ath10k/trace.c     |   20 +
 drivers/net/wireless/ath/ath10k/trace.h     |  170 ++
 drivers/net/wireless/ath/ath10k/txrx.c      |  417 ++++
 drivers/net/wireless/ath/ath10k/txrx.h      |   39 +
 drivers/net/wireless/ath/ath10k/wmi.c       | 2081 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h       | 3052 ++++++++++++++++++++++++++
 32 files changed, 22094 insertions(+)
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

