Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52451 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKXXVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 18:21:45 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so7555794wiv.14
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 15:21:44 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [PATCH 0/2] add TPC capability for AR9003 based chips
Date: Tue, 25 Nov 2014 00:21:39 +0100
Message-Id: <1416871301-9595-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141125_002148_823120_77E3A9E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds TPC capability to ath9k for AR9003 based chips. For the time
being some FCC checks are missing in ar9003_hw_init_txpower_stbc() and CDD mode
is not supported.

*[PATCH 1/2]: add TX power per-rate tables to cap TX power in TX descriptor path
*[PATCH 2/2]: cap per-packet TX power according to TX power per-rate tables

This pachset is based on Adrian Chadd's hints
(https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)

Changes since RFC:
- make the ah->txpower array one-dimensional and store max TX power for the
  current chainmask only

Lorenzo Bianconi (2):
  ath9k: add TX power per-rate tables
  ath9k: add TPC capability to TX descriptor path

 drivers/net/wireless/ath/ath9k/ar9002_mac.c    |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  47 +++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c    |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    | 174 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h         |   1 +
 drivers/net/wireless/ath/ath9k/beacon.c        |   5 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   6 +
 drivers/net/wireless/ath/ath9k/mac.h           |   2 +-
 drivers/net/wireless/ath/ath9k/reg.h           |   2 +
 drivers/net/wireless/ath/ath9k/xmit.c          |  37 +++++-
 10 files changed, 278 insertions(+), 12 deletions(-)

-- 
2.1.0

