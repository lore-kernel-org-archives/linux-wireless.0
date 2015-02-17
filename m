Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55504 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbbBQJMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 04:12:21 -0500
Received: by mail-wi0-f180.google.com with SMTP id h11so31481976wiw.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 01:12:20 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 0/2] add per-vif TX power capability
Date: Tue, 17 Feb 2015 10:12:16 +0100
Message-Id: <1424164338-10547-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150217_101226_835910_3D2FCD91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the HW with highest TX power among all vif when HW TPC has been
enabled in order to add support to per-vif TX power capability. Cap per-packet
TX power to vif configured power in the TX path

Lorenzo Bianconi (2):
  ath9k: add per-vif TX power capability
  ath9k: add per-vif TX power capability to TX path

 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/debug.c |  5 +++-
 drivers/net/wireless/ath/ath9k/main.c  | 52 ++++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/xmit.c  | 42 ++++++++++++++++++---------
 4 files changed, 77 insertions(+), 23 deletions(-)

-- 
2.1.0

