Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59810 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaA2TF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:05:28 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MKIEQ-1WAF8q0MuU-001g3L for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:05:26 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 00/13] eliminate some ath9k_htc code
Date: Wed, 29 Jan 2014 20:05:02 +0100
Message-Id: <1391022315-20946-1-git-send-email-linux@rempel-privat.de> (sfid-20140129_200532_393430_88F665D4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set moves most common RX code from ath9k/recv.c to
common.c without any additional changes and reworks ath9k_htc RX code 
to make use of new common functions.
Since ath9k_htc part was more intrusive I made tests in STA and AP modes. No noticeable regressions was introduced. 
Last patch is important for debugging FW crashes.

Oleksij Rempel (13):
  ath: add last_rssi to ath_common
  ath9k: move ath9k_process_rssi to common.c
  ath9k: move ath9k_process_rate to common.c
  ath9k: move ath9k_rx_accept to common.c
  ath9k_htc: add rx header converter to make it usable by ath9k
  ath9k_htc: use ath9k_cmn_process_rssi
  ath9k_htc: use ath9k_cmn_process_rate
  ath9k_htc: use ath9k_cmn_rx_accept
  ath9k_htc: sync rx_status-> related code with ath9k
  ath9k: move ath9k_rx_skb_postprocess to common.c
  ath9k_htc: use ath9k_cmn_rx_skb_postprocess
  ath9k_htc: remove useless memcpy
  ath9k_htc: catch fw panic pattern

 drivers/net/wireless/ath/ath.h                |   2 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
 drivers/net/wireless/ath/ath9k/common.c       | 244 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h       |  19 ++
 drivers/net/wireless/ath/ath9k/htc.h          |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 180 ++++++-----------
 drivers/net/wireless/ath/ath9k/htc_hst.c      |  36 ++++
 drivers/net/wireless/ath/ath9k/htc_hst.h      |  12 ++
 drivers/net/wireless/ath/ath9k/init.c         |   2 +-
 drivers/net/wireless/ath/ath9k/mac.h          |   9 +-
 drivers/net/wireless/ath/ath9k/main.c         |   2 +-
 drivers/net/wireless/ath/ath9k/recv.c         | 266 ++------------------------
 14 files changed, 392 insertions(+), 384 deletions(-)

-- 
1.8.5.3

