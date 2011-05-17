Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:57994 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1EQHML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 03:12:11 -0400
Received: by pxi16 with SMTP id 16so161677pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 00:12:11 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19922.8044.978298.696663@gargle.gargle.HOWL> (sfid-20110517_091214_890163_0F9FECBA)
Date: Tue, 17 May 2011 12:40:36 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Luis.Rodriguez@atheros.com
Subject: [PATCH 0/8] ath9k_htc patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series fixes a few issues with BSSID handling and removes
unused stuff in both the firmware and the host driver.

The required firmware version is now 1.3 and the new firmware will
be uploaded to http://wireless.kernel.org/download/htc_fw/ once Luis
comes out of his slumber.

For the record, the FW Changelog for v1.3 is:

* Remove unused PHY modes (TURBO etc.)
* Remove unused MIMO PS code.
* Cleanup node flags.
* Remove FastFrame code.
* Fix various bugs in management frame transmission.
* Fix duration calculation.
* Fix packet type calculation.
* Enable CAB queue for UB94/95.
* Fix sequence number assignment.
* Remove vendor-specific hacks.
* Add TX completion for multicast packets.
* Various code cleanups.
* Reduce credit size for UB94/95 to 45.

Sujith

Sujith Manoharan (8):
  ath9k_htc: Fix mode selection
  ath9k_htc: Fix station flags
  ath9k_htc: Recalculate the BSSID mask on interface removal
  ath9k_htc: Fix RX filter calculation
  ath9k_htc: Fix BSSID calculation
  ath9k_htc: Fix max subframe handling
  ath9k_htc: Change credit limit for UB94/95
  ath9k_htc: Fix packet timeout

 drivers/net/wireless/ath/ath9k/hif_usb.h      |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h          |   23 ++------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    7 +--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   77 ++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 +
 5 files changed, 61 insertions(+), 52 deletions(-)

-- 
1.7.5.1

