Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62956 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGTMba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:30 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so6418030wes.15
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:29 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 00/10] add support for ack timeout estimation in ath9k driver
Date: Sun, 20 Jul 2014 14:31:16 +0200
Message-Id: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143133_507333_081687A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for estimation of the ack timeout (dynack) in ath9k
driver. Ath9k dynack computes the ack timeout based on ack frame RX timestamp,
TX frame timestamp and frame duration.

Ath9k dynack has been tested in indoor environment using AR9223/AR9280 chipset
(running 3.16.0-rc5 kernel) and on 9Km PtoP link using AR9280 chipset
(running OpenWRT trunk, compat-wireless-2014-05-22)

Changes since RFCv2:
- disable dynack by default
- add ath9k_enable_dynack() method to enable ack timeout estimation algorithm
- remove dynack entry from ath9k debugfs

Changes since RFCv1:
- use ISC license instead of GPLv2 one
- use an inline method instead of a macro for EWMA calculation
- use powers of two weights in EWMA calculation
- fix typos
- add ath_dynack_node_init/ath_dynack_node_deinit methods
- use different logic to enable/disable dynack processing

Lorenzo Bianconi (10):
  ath9k: export methods related to ack timeout estimation
  ath9k: add duration field to ath_tx_status
  ath9k: add dynamic ack timeout estimation
  ath9k: add config for (en|dis)abling ack timeout estimation
  ath9k: do not overwrite ack timeout estimation
  ath9k: add sampling methods for (tx|rx) timestamp
  ath9k: enable control frame reception
  ath9k: add debugfs support for dynack
  ath9k: add ath9k_enable_dynack() method
  ath9k: initialize ath_node linked list

 drivers/net/wireless/ath/ath.h              |   2 +
 drivers/net/wireless/ath/ath9k/Kconfig      |   7 +
 drivers/net/wireless/ath/ath9k/Makefile     |   3 +
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   7 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   9 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   3 +
 drivers/net/wireless/ath/ath9k/debug.c      |  28 +++
 drivers/net/wireless/ath/ath9k/dynack.c     | 345 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dynack.h     |  96 ++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |  16 +-
 drivers/net/wireless/ath/ath9k/hw.h         |   7 +
 drivers/net/wireless/ath/ath9k/mac.h        |   1 +
 drivers/net/wireless/ath/ath9k/main.c       |  38 +++
 drivers/net/wireless/ath/ath9k/recv.c       |   7 +-
 drivers/net/wireless/ath/ath9k/xmit.c       |   5 +
 15 files changed, 570 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h

-- 
1.9.1

