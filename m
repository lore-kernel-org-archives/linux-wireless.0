Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58898 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaL0OM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 09:12:29 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so18689355wiv.13
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 06:12:28 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 0/3] add TPC capability for AR9002 based chips
Date: Sat, 27 Dec 2014 15:12:22 +0100
Message-Id: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141227_151240_060733_DE2B9A31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds TPC capability to ath9k for AR9002 based chips

*[RFC 1/3]: add TX power per-rate tables to cap TX power in TX descriptor path
*[RFC 2/3]: cap per-packet TX power according to TX power per-rate tables
*[RFC 3/3]: enable per-packet TPC on AR9002 based chips by default

This pachset is based on Adrian Chadd's hints
(https://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg10396.html)

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
 drivers/net/wireless/ath/ath9k/xmit.c        | 66 +++++++++++++++++++----
 8 files changed, 181 insertions(+), 18 deletions(-)

-- 
2.1.0

