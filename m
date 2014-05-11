Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63027 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaEKIFH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:05:07 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 00/10] ath9k & ath9k_htc: remove some debugfs code dups
Date: Sun, 11 May 2014 10:04:30 +0200
Message-Id: <1399795480-7459-1-git-send-email-linux@rempel-privat.de> (sfid-20140511_100524_696980_49DD7D4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

some debugfs related parts in this drivers are identical or almost identical.
This patch set remove most obvious parts.

Module sizes before patch set:
ath9k_htc		 81196
ath9k			125783
ath9k_common		  8185

Module sizes after patch set:
ath9k_htc		 63361
ath9k			121433
ath9k_common		 13145

Oleksij Rempel (10):
  ath9k-common: create common-debug and move modal_eeprom to cmn
  ath9k_htc: use ath9k_cmn_debug_modal_eeprom
  ath9k: move base_eeprom debug code to ath9k_cmn_debug_base_eeprom
  ath9k_htc: use ath9k_cmn_debug_base_eeprom
  ath9k: reorder or remove some includes
  ath9k & ath9k_htc: move ath_rx_stats to cmn
  ath9k: move recv to ath9k_cmn_debug_recv
  ath9k_htc: use ath9k_cmn_debug_recv
  ath9k: move phy_err to ath9k_cmn_debug_phy_err
  ath9k_htc: use ath9k_cmn_debug_phy_err

 drivers/net/wireless/ath/ath9k/Makefile        |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h         |   2 +-
 drivers/net/wireless/ath/ath9k/common-debug.c  | 253 +++++++++++
 drivers/net/wireless/ath/ath9k/common-debug.h  |  72 ++++
 drivers/net/wireless/ath/ath9k/common.h        |   1 +
 drivers/net/wireless/ath/ath9k/debug.c         | 214 +---------
 drivers/net/wireless/ath/ath9k/debug.h         |  44 --
 drivers/net/wireless/ath/ath9k/htc.h           |  17 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c | 555 ++-----------------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |   3 +-
 drivers/net/wireless/ath/ath9k/hw.c            |   1 -
 11 files changed, 377 insertions(+), 788 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common-debug.h

-- 
1.9.1

