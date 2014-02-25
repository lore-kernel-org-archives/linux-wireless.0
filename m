Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49217 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaBYNtM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:49:12 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LzoSt-1XN3tH0AiZ-01507P for
 <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 14:49:10 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/7] ath9k|ath9k_htc: remove code dups
Date: Tue, 25 Feb 2014 14:48:49 +0100
Message-Id: <1393336136-31069-1-git-send-email-linux@rempel-privat.de> (sfid-20140225_144915_686441_8EA9A14D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k code moved to common-init.c and then reused in ath9k_htc.

Oleksij Rempel (7):
  ath9k: move ath9k_init_channels_rates to common-init
  ath9k_htc: use ath9k_cmn_init_channels_rates
  ath9k: move setup_ht_cap to common-init
  ath9k_htc: use ath9k_cmn_setup_ht_cap
  ath9k-common: set maxstream=1 for ar9271
  ath9k: move ath9k_reload_chainmask_settings to common
  ath9k_htc: use ath9k_cmn_reload_chainmask

 drivers/net/wireless/ath/ath.h                |   1 +
 drivers/net/wireless/ath/ath9k/Makefile       |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
 drivers/net/wireless/ath/ath9k/beacon.c       |   2 +-
 drivers/net/wireless/ath/ath9k/common-init.c  | 244 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common-init.h  |  20 +++
 drivers/net/wireless/ath/ath9k/common.h       |   2 +
 drivers/net/wireless/ath/ath9k/htc.h          |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 176 +------------------
 drivers/net/wireless/ath/ath9k/init.c         | 230 +-----------------------
 drivers/net/wireless/ath/ath9k/main.c         |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |   3 +-
 12 files changed, 286 insertions(+), 399 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-init.h

-- 
1.9.0

