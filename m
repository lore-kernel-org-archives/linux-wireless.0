Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26323 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1C1U5T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:56:55 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/9] ath9k/ath9k_htc: pending stable patches for 2.6.37.y
Date: Mon, 28 Mar 2011 13:57:06 -0700
Message-ID: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

here are a few stable patches were required backport and also
a few which are marked as stable but which have not yet been
propagated to the older stable trees. I've been carrying these
on the compat-wireless-2.6.37 release for a while now so they
have gotten some consumption and only now just got a chance to
send them over to you.

Felix Fietkau (2):
  ath9k_hw: fix potential spurious tx error bit interpretation
  ath9k: add missing ps wakeup/restore calls

Luis R. Rodriguez (5):
  ath9k: simplify hw reset locking
  ath9k: move the PCU lock to the sc structure
  ath9k: content DMA start / stop through the PCU lock
  ath9k: Fix power save count imbalance on ath_radio_enable()
  ath9k_hw: ASPM interoperability fix for AR9380/AR9382

Mohammed Shafi Shajakhan (1):
  ath9k: Fix memory leak due to failed PAPRD frames

Stanislaw Gruszka (1):
  ath9k_htc: fix race conditions when stop device

 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   21 +++--
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    3 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   19 +++-
 drivers/net/wireless/ath/ath9k/init.c              |    1 -
 drivers/net/wireless/ath/ath9k/main.c              |   85 +++++++++----------
 drivers/net/wireless/ath/ath9k/recv.c              |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 -
 10 files changed, 71 insertions(+), 71 deletions(-)

-- 
1.7.4.15.g7811d

