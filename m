Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:41596 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3GENPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [PATCH 00/16] ath10k: pending patches
Date: Fri,  5 Jul 2013 16:15:01 +0300
Message-Id: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151525_293493_DD9C5BE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are pending patches which were commited to ath10k.git while
ath10k was under review. They were only sent to ath9k-devel, I'm
resending them now before I reapply them to my new ath.git tree.

Michal Kazior (16):
  ath10k: fix teardown ordering
  ath10k: fix possible deadlock
  ath10k: setup rts/frag thresholds upon vdev creation
  ath10k: do not setup rts/frag thresholds for suspended interfaces
  ath10k: remove ath10k_bus
  ath10k: fix typo in define name
  ath10k: silent warning in IBSS mode
  ath10k: lower print level for a message
  ath10k: provide errno if bmi read/write fails
  ath10k: change function to take struct ath10k as arg
  ath10k: rename hif callback
  ath10k: embed HTC struct inside ath10k
  ath10k: embed HTT struct inside ath10k
  ath10k: improve locking
  ath10k: abort scan properly if wmi_scan_stop fails
  ath10k: add missing debug prints

 drivers/net/wireless/ath/ath10k/bmi.c    |    6 +-
 drivers/net/wireless/ath/ath10k/ce.c     |    2 +-
 drivers/net/wireless/ath/ath10k/core.c   |   42 +++++-------
 drivers/net/wireless/ath/ath10k/core.h   |   15 ++---
 drivers/net/wireless/ath/ath10k/hif.h    |   10 +--
 drivers/net/wireless/ath/ath10k/htc.c    |   30 +++------
 drivers/net/wireless/ath/ath10k/htc.h    |    4 +-
 drivers/net/wireless/ath/ath10k/htt.c    |   27 ++++----
 drivers/net/wireless/ath/ath10k/htt.h    |    3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |    3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   12 ++--
 drivers/net/wireless/ath/ath10k/mac.c    |  107 +++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/pci.c    |   23 +++----
 drivers/net/wireless/ath/ath10k/pci.h    |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c    |   14 ++--
 15 files changed, 180 insertions(+), 122 deletions(-)

-- 
1.7.9.5

