Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49736 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752971AbcKBOMX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:23 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 00/10] rt2800: random fixes
Date: Wed,  2 Nov 2016 15:10:55 +0100
Message-Id: <1478095865-8651-1-git-send-email-sgruszka@redhat.com> (sfid-20161102_151227_611581_A04C68CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Random fixes mostly related to HT performance.

Stanislaw Gruszka (10):
  rt2800: correctly report MCS TX parameters
  rt2800usb: do not wipe out USB_DMA_CFG settings
  rt2800: OFDM rates are mandatory
  rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
  rt2800: make ba_size depend on ampdu_factor
  rt2800: correct AUTO_RSP_CFG
  rt2800: correct TX_SW_CFG1 for 5592
  rt2800: use RTS/CTS protection instead of CTS-to-self
  rt2800: tune *_PROT_CFG parameters
  rt2800: disable CCK rates on HT

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   |   62 +++++++++++----------
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c   |    5 +--
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |   15 ++++--
 3 files changed, 43 insertions(+), 39 deletions(-)
