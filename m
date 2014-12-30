Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62014 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaL3WKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 17:10:25 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so21461891wgh.15
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2014 14:10:24 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [PATCH 0/3] add TPC capability for AR9002 based chips
Date: Tue, 30 Dec 2014 23:10:17 +0100
Message-Id: <1419977420-23732-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141230_231046_449551_657638C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds TPC capability to ath9k for AR9002 based chips

*[PATCH 1/3]: add TX power per-rate tables to cap TX power in TX descriptor path
*[PATCH 2/3]: cap per-packet TX power according to TX power per-rate tables
*[PATCH 3/3]: enable per-packet TPC on AR9002 based chips by default

This pachset is based on Adrian Chadd's hints
(https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)

Changes since RFC:
- fix compilation error

Lorenzo Bianconi (3):
  ath9k: add power per-rate tables for AR9002 chips
  ath9k: add TPC to TX path for AR9002 based chips
  ath9k: enable per-packet TPC on AR9002 based chips

 drivers/net/wireless/ath/ath9k/ar5008_phy.c  | 80 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.c       |  5 --
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 14 +++++
 drivers/net/wireless/ath/ath9k/eeprom_9287.c | 15 ++++++
 drivers/net/wireless/ath/ath9k/eeprom_def.c  | 14 +++++
 drivers/net/wireless/ath/ath9k/hw.c          |  3 +-
 drivers/net/wireless/ath/ath9k/hw.h          |  2 +
 drivers/net/wireless/ath/ath9k/xmit.c        | 68 ++++++++++++++++++-----
 8 files changed, 182 insertions(+), 19 deletions(-)

-- 
2.1.0

