Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:56417 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1KKKR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:17:29 -0500
Subject: [PATCH 00/10] ath6kl: ar6004 sdio support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:17:22 +0200
Message-ID: <20111111101551.12075.94865.stgit@localhost6.localdomain6> (sfid-20111111_111733_038808_7F37526D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for ar6004 sdio and also beginning of
ar6004 usb support.

---

Kalle Valo (9):
      ath6kl: move bmi calls to hif driver
      ath6kl: change bmi sizes being configurable by HIF
      ath6kl: move diag commands to hif driver
      ath6kl: update ar6004 definitions
      ath6kl: firmware boot fixes for ar6004
      ath6kl: add hif_type
      ath6kl: add USB support
      ath6kl: disable HTC for USB devices
      ath6kl: enable USB support

Naveen Gangadharan (1):
      ath6kl: AR6004 SDIO support


 drivers/net/wireless/ath/ath6kl/Kconfig   |   25 +-
 drivers/net/wireless/ath/ath6kl/Makefile  |   37 ++
 drivers/net/wireless/ath/ath6kl/bmi.c     |  245 +++-------------
 drivers/net/wireless/ath/ath6kl/bmi.h     |    6 
 drivers/net/wireless/ath/ath6kl/core.h    |   26 +-
 drivers/net/wireless/ath/ath6kl/debug.h   |    1 
 drivers/net/wireless/ath/ath6kl/hif-ops.h |   30 ++
 drivers/net/wireless/ath/ath6kl/hif.c     |    5 
 drivers/net/wireless/ath/ath6kl/hif.h     |    5 
 drivers/net/wireless/ath/ath6kl/htc.c     |   10 +
 drivers/net/wireless/ath/ath6kl/init.c    |   34 ++
 drivers/net/wireless/ath/ath6kl/main.c    |   76 -----
 drivers/net/wireless/ath/ath6kl/sdio.c    |  268 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/target.h  |    9 -
 drivers/net/wireless/ath/ath6kl/usb.c     |  431 +++++++++++++++++++++++++++++
 15 files changed, 899 insertions(+), 309 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/usb.c

