Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14851 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab0JTXHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 19:07:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 16:07:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/6] ath9k: fix RX poison issue
Date: Wed, 20 Oct 2010 16:07:02 -0700
Message-ID: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses the RX poison issue reported by Ben.
I've split the patches up into as many atomic pieces to make
it easier for review and understanding. Some are stable, the
last few patches are for debugging.

Luis R. Rodriguez (6):
  ath9k: add locking for stopping RX
  ath9k: add locking for starting the PCU on RX
  ath9k: rename rxflushlock to pcu_lock
  ath9k: lock reset and PCU start/stopping
  ath: add a ATH_DBG_WARN()
  ath9k: add a debug warning when we cannot stop RX

 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |   31 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/recv.c  |   17 +++++++++--------
 drivers/net/wireless/ath/debug.h       |    2 ++
 4 files changed, 41 insertions(+), 11 deletions(-)

