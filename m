Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64016 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaGGJbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:51 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so14713644wib.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:50 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 00/10] add support for ack timeout estimation in ath9k driver
Date: Mon,  7 Jul 2014 11:31:36 +0200
Message-Id: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113155_587042_C0CB344A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for estimation of the ack timeout (dynack) in ath9k
driver. Ath9k dynack computes the ack timeout based on ack frame RX timestamp,
TX frame timestamp and frame duration.

Ath9k dynack has been tested in indoor environment using AR9223 chipset
(running 3.15.3 kernel) configured as AP and using AR9280 chipset
(running 3.16.0-rc3) configured as STA. Ath9k dynack needs to be tested on a
long distance link in outdoor environment.

Lorenzo Bianconi (10):
  ath9k: export methods related to ack timeout estimation
  ath9k: add duration field to ath_tx_status
  ath9k: add dynamic ack timeout estimation
  ath9k: add config for (en|dis)abling ack timeout estimation
  ath9k: do not overwrite ack timeout estimation
  ath9k: add sampling methods for (tx|rx) timestamp
  ath9k: enable control frame reception
  ath9k: add debugfs support for dynack
  ath9k: disable dynack algorithm when coverage class is set
  ath9k: add ath_node linked list

 drivers/net/wireless/ath/ath.h              |   2 +
 drivers/net/wireless/ath/ath9k/Kconfig      |   7 +
 drivers/net/wireless/ath/ath9k/Makefile     |   3 +
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |   7 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   9 +
 drivers/net/wireless/ath/ath9k/ath9k.h      |   3 +
 drivers/net/wireless/ath/ath9k/debug.c      |  82 ++++++++
 drivers/net/wireless/ath/ath9k/dynack.c     | 293 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/dynack.h     |  81 ++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |  16 +-
 drivers/net/wireless/ath/ath9k/hw.h         |   7 +
 drivers/net/wireless/ath/ath9k/mac.h        |   1 +
 drivers/net/wireless/ath/ath9k/main.c       |  11 ++
 drivers/net/wireless/ath/ath9k/recv.c       |   7 +-
 drivers/net/wireless/ath/ath9k/xmit.c       |   5 +
 15 files changed, 530 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h

-- 
1.9.1

