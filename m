Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42531 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:45:38 -0400
Subject: [PATCH v2 0/8] ath10k: fixes 2013-10-15
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:45:35 +0300
Message-ID: <20131016134503.25095.8044.stgit@localhost6.localdomain6> (sfid-20131016_154541_707152_83398692)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is Michal's patchset which he said:

  This is a bunch of fixes I've had queued up for
  some time now. I was reluctant to send them without some additional checks
  and because some of the fixes are not ideal. At least we can get a discussion
  going if anything raises any serious concern.

For v2 I added one patch myself, modified "ath10k: fix device initialization
routine" to use ath10k_pci_write32() style of wrappers and fixed long line warnings
from checkpatch.

---

Kalle Valo (1):
      ath10k: implement ath10k_pci_soc_read/write32()

Michal Kazior (7):
      ath10k: prevent starting monitor without a vdev
      ath10k: add sanity checks for monitor management
      ath10k: fix endianess in prints
      ath10k: fix NSS reporting in RX
      ath10k: fix NULL deref upon early FW crash
      ath10k: fix device initialization routine
      ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW


 drivers/net/wireless/ath/ath10k/ce.c     |   11 ++
 drivers/net/wireless/ath/ath10k/core.c   |    3 -
 drivers/net/wireless/ath/ath10k/htt_tx.c |   11 +-
 drivers/net/wireless/ath/ath10k/hw.h     |    7 ++
 drivers/net/wireless/ath/ath10k/mac.c    |   25 +++++-
 drivers/net/wireless/ath/ath10k/pci.c    |  135 ++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h    |   20 ++++
 drivers/net/wireless/ath/ath10k/txrx.c   |    2 
 drivers/net/wireless/ath/ath10k/wmi.c    |   16 ++--
 9 files changed, 158 insertions(+), 72 deletions(-)

