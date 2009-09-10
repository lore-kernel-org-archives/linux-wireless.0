Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/10] atheros: expand common helpers
Date: Thu, 10 Sep 2009 15:30:17 -0400
Message-Id: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my third series of cleanups on atheros devices to help
with support for ath9k_htc. ath9k hw.c was relying on the driver
core structure ath_softc to access the bssidmask, macaddr, and
curbssid. To prevent this I moved these into the common structure
ath_common and also ported ath5k and ar9170 to use the same shared
data.

The rest are a few other cleanups I did along the way, like moving
ath_common to the hw structure for ath9k and ath5k and also one
final bt-coex fix/cleanup.

I've tested these changes on ath5k, ath9k and ar9170.

Luis R. Rodriguez (10):
  ath9k: make ath9k_hw_setbssidmask() and ath9k_hw_write_associd() use
    ath_hw
  ath9k: Use ath9k_hw_setbssidmask() on reset
  ath9k: use ath9k_hw_write_associd() on reset
  atheros/ath9k: move macaddr, curaid, curbssid and bssidmask to common
  ar9170: make use of common macaddr and curbssid
  ath5k: use common curbssid, bssidmask and macaddr
  ath5k: initialize eeprom struct early on attach
  ath9k: move ath_common to ath_hw
  ath5k: move ath_common to ath5k_hw
  ath9k: Define bus agnostic bluetooth coex prep helper

 drivers/net/wireless/ath/ar9170/ar9170.h |    2 -
 drivers/net/wireless/ath/ar9170/mac.c    |    5 +-
 drivers/net/wireless/ath/ar9170/main.c   |    6 ++-
 drivers/net/wireless/ath/ath.h           |    4 ++
 drivers/net/wireless/ath/ath5k/ath5k.h   |   11 +----
 drivers/net/wireless/ath/ath5k/attach.c  |   12 +++--
 drivers/net/wireless/ath/ath5k/base.c    |   29 ++++++++-----
 drivers/net/wireless/ath/ath5k/base.h    |    3 +-
 drivers/net/wireless/ath/ath5k/pcu.c     |   38 +++++-------------
 drivers/net/wireless/ath/ath5k/reset.c   |   13 ++++--
 drivers/net/wireless/ath/ath9k/ath9k.h   |    8 +---
 drivers/net/wireless/ath/ath9k/hw.c      |   51 +++++++++--------------
 drivers/net/wireless/ath/ath9k/hw.h      |    7 +--
 drivers/net/wireless/ath/ath9k/main.c    |   65 +++++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/pci.c     |   17 ++++++++
 drivers/net/wireless/ath/ath9k/recv.c    |   19 +++++---
 drivers/net/wireless/ath/ath9k/virtual.c |   22 +++++-----
 17 files changed, 160 insertions(+), 152 deletions(-)

