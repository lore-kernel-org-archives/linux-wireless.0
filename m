Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/9] ath9k: rebasing pending patches
Date: Tue, 14 Jul 2009 20:17:06 -0400
Message-Id: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have some patches I want to send but our queue has
been growing. To help speed up the processing of our
patches I have taken the time to cherry pick what I
saw was pending and rebased it against wireless-testing
and the rate control cleanup series I just sent.

If I missed any pendign ath9k patch you should rebase
against all pending patches and send it afterwards.

Gabor Juhos (3):
  ath9k: serialize ath9k_hw_setpower calls
  ath9k: uninline ath9k_ps_{wakeup,restore} functions
  ath9k: serialize ath9k_ps_{wakeup,restore} calls

Senthil Balasubramanian (3):
  ath9k: Manipulate and report the correct RSSI
  ath9k: RX stucks during heavy traffic in HT40 mode.
  ath9k: Fix TX hang issue with Atheros chipsets

Vasanthakumar Thiagarajan (3):
  ath9k: Remove bogus assert in ath_clone_txbuf()
  ath9k: Handle tx desc shortage more appropriately
  ath9k: Remove pointless ath9k_ps_restore() in ath_detach()

 drivers/net/wireless/ath/ath9k/ath9k.h    |   46 +++++++++--------
 drivers/net/wireless/ath/ath9k/calib.c    |   13 ++++-
 drivers/net/wireless/ath/ath9k/calib.h    |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.c   |   20 +++++++-
 drivers/net/wireless/ath/ath9k/hw.c       |   52 +++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/initvals.h |   47 +++++++++--------
 drivers/net/wireless/ath/ath9k/mac.c      |   30 +++++++++---
 drivers/net/wireless/ath/ath9k/main.c     |    6 ++-
 drivers/net/wireless/ath/ath9k/recv.c     |   25 +++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c     |   76 +++++++++++++++++++++++------
 10 files changed, 244 insertions(+), 75 deletions(-)

