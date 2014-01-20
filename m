Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60985 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaATSs2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:48:28 -0500
Received: from ultralex.lan ([79.218.100.244]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0Lqyi7-1VS9Js0JkZ-00efma for
 <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 19:48:27 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/5] eliminate some ath9k_htc code
Date: Mon, 20 Jan 2014 19:48:08 +0100
Message-Id: <1390243693-9061-1-git-send-email-linux@rempel-privat.de> (sfid-20140120_194831_885527_AF9E9B2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ath9k_htc has too match outdated copy/paste from ath9k.

This patch set trying to remove some of it and make some function common
to both drivers.

Oleksij Rempel (5):
  ath: add last_rssi to ath_common
  ath9k: move ath9k_process_rssi to common.c
  ath9k: move ath9k_process_rate to common.c
  ath9k: move ath9k_rx_accept to common.c
  ath9k_htc: rework ath9k_rx_prepare and make use of common funcs

 drivers/net/wireless/ath/ath.h                |   2 +
 drivers/net/wireless/ath/ath9k/ath9k.h        |   1 -
 drivers/net/wireless/ath/ath9k/common.c       | 192 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h       |  14 ++
 drivers/net/wireless/ath/ath9k/htc.h          |   1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 149 ++++++------------
 drivers/net/wireless/ath/ath9k/init.c         |   2 +-
 drivers/net/wireless/ath/ath9k/mac.h          |   9 +-
 drivers/net/wireless/ath/ath9k/main.c         |   2 +-
 drivers/net/wireless/ath/ath9k/recv.c         | 211 ++------------------------
 12 files changed, 270 insertions(+), 315 deletions(-)

-- 
1.8.5.2

