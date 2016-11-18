Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbcKRJsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 04:48:11 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 0/9] rt2800: random fixes 
Date: Fri, 18 Nov 2016 10:43:52 +0100
Message-Id: <1479462241-9299-1-git-send-email-sgruszka@redhat.com> (sfid-20161118_104814_859927_997BDA99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Random fixes mostly related to HT performance.

v1 -> v2:
 - drop patch "rt2800: make ba_size depend on ampdu_factor"
 - fix changelog for patch "rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE" 

Stanislaw Gruszka (9):
  rt2800: correctly report MCS TX parameters
  rt2800usb: do not wipe out USB_DMA_CFG settings
  rt2800: OFDM rates are mandatory
  rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
  rt2800: correct AUTO_RSP_CFG
  rt2800: correct TX_SW_CFG1 for 5592
  rt2800: use RTS/CTS protection instead of CTS-to-self
  rt2800: tune *_PROT_CFG parameters
  rt2800: disable CCK rates on HT

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 62 +++++++++++++-------------
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c |  5 +--
 2 files changed, 33 insertions(+), 34 deletions(-)

-- 
1.8.3.1
