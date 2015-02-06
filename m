Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33535 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbBFOjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 09:39:48 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so2890743wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 06:39:47 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [RFC 0/2] add per-vif TX power capability
Date: Fri,  6 Feb 2015 15:39:44 +0100
Message-Id: <1423233586-9258-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150206_153951_663795_33E84E39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the HW with highest TX power among all vif when HW TPC has been
enabled in order to add support for per-vif TX power capability. Cap per-packet
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

