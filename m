Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63417 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbaKTNbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 08:31:44 -0500
Received: by mail-wg0-f42.google.com with SMTP id z12so3741382wgg.29
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 05:31:43 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 0/3] add TPC capability for AR9003 based chips
Date: Thu, 20 Nov 2014 14:31:37 +0100
Message-Id: <1416490300-6451-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141120_143154_193942_E048DDED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds TPC capability to ath9k for AR9003 based chips. For the time
being some FCC checks are missing in ar9003_hw_init_txpower_stbc() and CDD mode
is not supported.
*[RFC 1/3]: add chainmask parameter to ath9k_hw_get_scaled_power() to compute
maximum TX power for different number of TX chains
*[RFC 2/3]: add TX power per-rate per-chain tables to cap TX power in TX
descriptor path
*[RFC 3/3]: cap per-packet TX power according to TX power per-rate per-chain
tables
This pachset is based on Adrian Chadd's hints
(https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)

Lorenzo Bianconi (3):
  ath9k: add chainmask parameter to ath9k_hw_get_scaled_power()
  ath9k: add TX power per-rate per-chain tables
  ath9k: add TPC capability to TX descriptor path

 drivers/net/wireless/ath/ath9k/ar9002_mac.c    |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  68 +++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   5 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c    |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 281 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h         |   1 +
 drivers/net/wireless/ath/ath9k/beacon.c        |   5 +-
 drivers/net/wireless/ath/ath9k/eeprom.c        |   4 +-
 drivers/net/wireless/ath/ath9k/eeprom.h        |   2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   3 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   3 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   6 +
 drivers/net/wireless/ath/ath9k/mac.h           |   2 +-
 drivers/net/wireless/ath/ath9k/reg.h           |   2 +
 drivers/net/wireless/ath/ath9k/xmit.c          |  41 +++-
 15 files changed, 419 insertions(+), 20 deletions(-)

-- 
2.1.0

