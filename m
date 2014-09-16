Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33312 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbaIPANT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:19 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so4663990wgh.7
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:18 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 00/10] add support for ACK timeout estimation in ath9k driver
Date: Tue, 16 Sep 2014 02:13:06 +0200
Message-Id: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021323_787781_EC34ECCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for estimation of the ACK timeout (dynack) in ath9k
driver. Ath9k dynack computes the ACK timeout based on ACK frame RX timestamp,
TX frame timestamp and frame duration.

Ath9k dynack has been tested in indoor environment using AR9223/AR9280 chipset
(running 3.17.0-rc5 kernel), on 9Km PtoP link using AR9280 chipset
(running OpenWRT trunk, compat-wireless-2014-05-22) and on an AP using AR9280
chipset (running OpenWRT trunk, compat-wireless-2014-05-22) serving 35 STA with
links up to 8Km

Changes since v1:
- rebase on top of "configure dynack through mac80211/cfg80211 stack" patchset
- improve documentation

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
  ath9k: export methods related to ACK timeout estimation
  ath9k: add duration field to ath_tx_status
  ath9k: add dynamic ACK timeout estimation
  ath9k: add config for (en|dis)abling ACK timeout estimation
  ath9k: do not overwrite ACK timeout estimation
  ath9k: add sampling methods for (tx|rx) timestamp
  ath9k: enable control frame reception
  ath9k: add debugfs support for dynack
  ath9k: enable dynack using set_coverage_class codepath
  ath9k: initialize ath_node linked list

 drivers/net/wireless/ath/ath.h              |   2 +
 drivers/net/wireless/ath/ath9k/Kconfig      |   9 +
 drivers/net/wireless/ath/ath9k/Makefile     |   3 +
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   7 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   9 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   3 +
 drivers/net/wireless/ath/ath9k/debug.c      |  28 +++
 drivers/net/wireless/ath/ath9k/dynack.c     | 352 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dynack.h     | 103 ++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |  16 +-
 drivers/net/wireless/ath/ath9k/hw.h         |   7 +
 drivers/net/wireless/ath/ath9k/mac.h        |   1 +
 drivers/net/wireless/ath/ath9k/main.c       |  37 ++-
 drivers/net/wireless/ath/ath9k/recv.c       |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c       |   5 +
 15 files changed, 582 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h

-- 
1.9.1

