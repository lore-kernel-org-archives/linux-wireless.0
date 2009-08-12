Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46850 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbZHLQ5C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:57:02 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 09:57:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<ath5k-devel@lists.ath5k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath: advance ath.ko with one more helper
Date: Wed, 12 Aug 2009 09:56:58 -0700
Message-ID: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a common structure where we can start stuffing shared items
and introduces a helper for both ath5k and ath9k's use.

Luis R. Rodriguez (3):
  ath: add common ath_rxbuf_alloc() and make ath9k use it
  ath5k: use common ath.ko ath_rxbuf_alloc()
  ath5k: use bit shift operators for cache line size

 drivers/net/wireless/ath/Kconfig       |    4 +--
 drivers/net/wireless/ath/ath.h         |   30 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.c  |   23 ++++++------------
 drivers/net/wireless/ath/ath5k/base.h  |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h |    4 ++-
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c  |   40 +++----------------------------
 drivers/net/wireless/ath/main.c        |   36 ++++++++++++++++++++++++++++
 8 files changed, 85 insertions(+), 57 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath.h

