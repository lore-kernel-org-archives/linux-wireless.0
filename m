Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63602 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaAOQHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:07:36 -0500
Received: from ultralex.lan ([93.218.75.192]) by mail.gmx.com (mrgmx003) with
 ESMTPSA (Nemesis) id 0MAyVY-1WB8Vz0uLk-009zBi for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:07:35 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/5] use one common ath_is_mybeacon
Date: Wed, 15 Jan 2014 17:07:13 +0100
Message-Id: <1389802038-6688-1-git-send-email-linux@rempel-privat.de> (sfid-20140115_170739_801510_50C0098E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most ATH driver use same beacon check. It is worth to place it
to the main ATH lib.

Oleksij Rempel (5):
  ath: add common function ath_is_mybeacon
  ath9k: use ath_is_mybeacon
  ath9k_htc: use ath_is_mybeacon
  ath5k: use ath_is_mybeacon
  carl9170: use ath_is_mybeacon

 drivers/net/wireless/ath/ath.h                |  2 ++
 drivers/net/wireless/ath/ath5k/base.c         | 33 +++++++--------------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  4 +---
 drivers/net/wireless/ath/ath9k/recv.c         | 20 ++++------------
 drivers/net/wireless/ath/carl9170/rx.c        |  9 +++-----
 drivers/net/wireless/ath/main.c               | 11 +++++++++
 6 files changed, 29 insertions(+), 50 deletions(-)

-- 
1.8.5.2

