Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:51055 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1KNRaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:30:10 -0500
Subject: [PATCH 00/10] ath6kl: configurable board address and multivif
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:29:54 +0200
Message-ID: <20111114172836.29925.4134.stgit@localhost6.localdomain6> (sfid-20111114_183017_044392_8559F8AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Read board address and max number of vif interfaces from firmware.
Also some cleanup in init.c.

---

Kalle Valo (10):
      ath6kl: remove hw version related parameter defines
      ath6kl: move hw version related to parameters to struct
      ath6kl: add board address to struct ath6kl_hw
      ath6kl: add firmware IE for board data address
      ath6kl: add name field to struct ath6kl_hw
      ath6kl: use hardware version names consistently
      ath6kl: add ar6004 firmwares to sdio module
      ath6kl: add firmware filename info to struct ath6kl_hw
      ath6kl: make maximum number of vifs runtime configurable
      ath6kl: add firmware IE for maximum number of vifs


 drivers/net/wireless/ath/ath6kl/cfg80211.c |    8 -
 drivers/net/wireless/ath/ath6kl/core.h     |   82 +++++---
 drivers/net/wireless/ath/ath6kl/init.c     |  299 +++++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/main.c     |   21 --
 drivers/net/wireless/ath/ath6kl/sdio.c     |   26 +-
 drivers/net/wireless/ath/ath6kl/target.h   |   17 --
 drivers/net/wireless/ath/ath6kl/txrx.c     |    2 
 drivers/net/wireless/ath/ath6kl/usb.c      |   12 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 -
 9 files changed, 247 insertions(+), 226 deletions(-)
