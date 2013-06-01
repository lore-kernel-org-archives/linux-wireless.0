Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:60669 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3FALYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:24:11 -0400
Subject: [PATCH v2 00/29] ath10k: mac80211 driver for Qualcomm Atheros
 802.11ac CQA98xx devices
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:24:06 +0300
Message-ID: <20130601111820.32443.46794.stgit@localhost6.localdomain6> (sfid-20130601_132427_274737_78884775)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a new mac80211 driver for Qualcomm Atheros 802.11ac QCA98xx devices.
A major difference from ath9k is that there's now a firmware and that's why we
had to implement a new driver.

We received very little comments in the first review round. This is the second,
and hopefully the final, version of the driver for review. I'll first send the
driver in smaller patches, one file per patch, to make it easier to review. The
final version will be one big commit, which I'm planning to submit through
ath6kl.git together with ath6kl patches. And no need to panic, I will rename
the git tree to something better in the future :)

The firmware is temporarily available here:

https://github.com/kvalo/ath10k-firmware

This is the commit log I'll use with the big commit:

---------------------------------------------------------------------
ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices

Here's a new mac80211 driver for Qualcomm Atheros 802.11ac QCA98xx devices.
A major difference from ath9k is that there's now a firmware and
that's why we had to implement a new driver.

The wiki page for the driver is:

http://wireless.kernel.org/en/users/Drivers/ath10k

The driver has had many authors, they are listed here alphabetically:

Bartosz Markowski <bartosz.markowski@tieto.com>
Janusz Dziedzic <janusz.dziedzic@tieto.com>
Kalle Valo <kvalo@qca.qualcomm.com>
Marek Kwaczynski <marek.kwaczynski@tieto.com>
Marek Puzyniak <marek.puzyniak@tieto.com>
Michal Kazior <michal.kazior@tieto.com>
Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---------------------------------------------------------------------

And these are the changes from v1:

Kalle Valo (6):
      ath10k: set vht_nss correctly
      ath10k: change chan_to_phymode() use chandef
      ath10k: remove band_center_freq()
      ath10k: include all management frames to ATH10K_DBG_BEACON
      ath10k: add ATH10K_DBG_DATA
      ath10k: preliminary VHT support

Michal Kazior (14):
      ath10k: remove CTRY_DEFAULT assignment
      ath10k: remove static mac address mask
      ath10k: remove unnecessary include
      ath10k: program FW with appropriate regdomain
      ath10k: fix hw scan cancelling
      ath10k: sync WMI interface to FW 636
      ath10k: change errno if we run out of msdu_ids
      ath10k: ath10k_htc_prepare_tx_skb() never fails
      ath10k: add lockdep asserts to htc skb dequeuing
      ath10k: simplify htc flow control
      ath10k: remove unused queue limit
      ath10k: introduce proper htt tx flow control
      ath10k: detect htt pending tx limit at runtime
      ath10k: fix sparse warning

The actual commits are available from ath10k.git:

https://github.com/kvalo/ath10k

Please review and comment. I'm hoping to get this driver to 3.11.

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


 drivers/net/wireless/ath/ath10k/Kconfig     |   39 
 drivers/net/wireless/ath/ath10k/Makefile    |   20 
 drivers/net/wireless/ath/ath10k/bmi.c       |  295 +++
 drivers/net/wireless/ath/ath10k/bmi.h       |  224 ++
 drivers/net/wireless/ath/ath10k/ce.c        | 1189 ++++++++++
 drivers/net/wireless/ath/ath10k/ce.h        |  516 +++++
 drivers/net/wireless/ath/ath10k/core.c      |  665 ++++++
 drivers/net/wireless/ath/ath10k/core.h      |  369 +++
 drivers/net/wireless/ath/ath10k/debug.c     |  503 ++++
 drivers/net/wireless/ath/ath10k/debug.h     |   90 +
 drivers/net/wireless/ath/ath10k/hif.h       |  137 +
 drivers/net/wireless/ath/ath10k/htc.c       | 1000 +++++++++
 drivers/net/wireless/ath/ath10k/htc.h       |  368 +++
 drivers/net/wireless/ath/ath10k/htt.c       |  152 +
 drivers/net/wireless/ath/ath10k/htt.h       | 1338 ++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c    | 1167 ++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c    |  510 ++++
 drivers/net/wireless/ath/ath10k/hw.h        |  304 +++
 drivers/net/wireless/ath/ath10k/mac.c       | 3066 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h       |   61 +
 drivers/net/wireless/ath/ath10k/pci.c       | 2506 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.h       |  355 +++
 drivers/net/wireless/ath/ath10k/rx_desc.h   |  990 +++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h |  449 ++++
 drivers/net/wireless/ath/ath10k/trace.c     |   20 
 drivers/net/wireless/ath/ath10k/trace.h     |  170 +
 drivers/net/wireless/ath/ath10k/txrx.c      |  417 ++++
 drivers/net/wireless/ath/ath10k/txrx.h      |   39 
 drivers/net/wireless/ath/ath10k/wmi.c       | 2081 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h       | 3052 +++++++++++++++++++++++++++
 30 files changed, 22092 insertions(+)
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

