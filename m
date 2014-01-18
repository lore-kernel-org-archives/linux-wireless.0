Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaARMyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 07:54:36 -0500
Received: from ultralex.lan ([93.218.86.193]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0MTO3f-1VwQxz1FLT-00SMM4 for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 13:54:34 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/5] use one common ath_is_mybeacon
Date: Sat, 18 Jan 2014 13:54:14 +0100
Message-Id: <1390049659-27021-1-git-send-email-linux@rempel-privat.de> (sfid-20140118_135449_704256_BF3C61BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like there is no more suggestions. It's time to resend complete
patchset.

Most ATH driver use same beacon check. It is worth to place it
to the main ATH lib.

Oleksij Rempel (5):
  ath: add common function ath_is_mybeacon
  ath9k: use ath_is_mybeacon
  ath9k_htc: use ath_is_mybeacon
  ath5k: use ath_is_mybeacon
  carl9170: use ath_is_mybeacon

 drivers/net/wireless/ath/ath.h                | 10 +++++++-
 drivers/net/wireless/ath/ath5k/base.c         | 33 +++++++--------------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  4 +---
 drivers/net/wireless/ath/ath9k/recv.c         | 20 ++++------------
 drivers/net/wireless/ath/carl9170/rx.c        |  9 +++-----
 5 files changed, 25 insertions(+), 51 deletions(-)

-- 
1.8.5.2

