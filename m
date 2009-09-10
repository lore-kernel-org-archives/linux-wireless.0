Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZIJHKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/7] ath9k/atheros: ps/bssid mask cleanups
Date: Thu, 10 Sep 2009 03:10:12 -0400
Message-Id: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my second series on cleanups to fixate driver core
changes in the right place. In this series I stuff power save
helpers which use the driver for locking.

Next thing I'm looking at is the usage of sc->bssidmask and
sc->curbssid even on hw.c on ath9k -- we should not access the
sc on hw code, anyway, while reviewing that I noticed
ath5k/ar9170 could benefit from a few changes already in place
on ath9k.

It seems the last thing we'll need to address is read/write ops.
I've considered defining read/write ops on the ath common
structure, or at the very least on ath_hw, upon initialization
then the driver core would set this. ath9k would use ath9k_iowrite32()
and ath9k_ioread32() would ath9k_htc would define its own. REG_READ
and REG_WRITE could then also point to the common->ops->read / write
or if we don't want to take that approach the ath_hw->rw->read / write.

Other suggestions are welcomed.

A minor thing I did notice is we use ieee80211_hw on ath9k hw.c
for configuration -- this is fine but I realized virtual wiphys
are not using their own hw conf, but the primary wiphy's.

Luis R. Rodriguez (7):
  ath9k: move ps helpers onto core driver when reseting tsf
  ath9k: move ath9k_ps_wakeup() and ath9k_ps_restore() to main.c
  ath9k: avoid usage of ath9k_hw_setpower() on hw.c
  ath9k: move ath9k_hw_setpower() to main.c
  ath9k: rename driver core and hw power save helpers
  ath: move ath_bcast_mac to common header
  atheros: use get_unaligned_le*() for bssid mask setting

 drivers/net/wireless/ath/ar9170/mac.c   |   10 +++---
 drivers/net/wireless/ath/ath.h          |    3 ++
 drivers/net/wireless/ath/ath5k/ath5k.h  |    7 ----
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c    |   38 +++++++++++--------
 drivers/net/wireless/ath/ath5k/reset.c  |    6 ++-
 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 -
 drivers/net/wireless/ath/ath9k/beacon.c |   17 ++++++++-
 drivers/net/wireless/ath/ath9k/hw.c     |   50 +-------------------------
 drivers/net/wireless/ath/ath9k/hw.h     |    5 ++-
 drivers/net/wireless/ath/ath9k/main.c   |   59 ++++++++++++++++++++++++++++---
 12 files changed, 109 insertions(+), 92 deletions(-)

