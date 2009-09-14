Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43426 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZINIcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:32:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 0/4] atheros: implement common read/write ops
Date: Mon, 14 Sep 2009 04:31:59 -0400
Message-Id: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a respin on my fourth series. We leave ath5k as is and only
use the common read/write ops for it for shared hw code. ath9k however
does need to use the common ops as we need to make read/write code
driver core independent to share with ath9k_htc, even before its
moved into ath hw common code.

Other changes worth noting are the order of the write op arguments
to coincide more with more kernel code.

Luis R. Rodriguez (4):
  atheros/ath9k: add common read/write ops and port ath9k to use it
  ath5k: allocate ath5k_hw prior to initializing hw
  ath5k: define ath_common ops
  atheros: define shared bssidmask setting

 drivers/net/wireless/ath/Makefile         |    5 +-
 drivers/net/wireless/ath/ath.h            |    9 ++
 drivers/net/wireless/ath/ath5k/ath5k.h    |   20 +++--
 drivers/net/wireless/ath/ath5k/attach.c   |   25 +-----
 drivers/net/wireless/ath/ath5k/base.c     |   38 ++++++++-
 drivers/net/wireless/ath/ath5k/base.h     |   11 ---
 drivers/net/wireless/ath/ath5k/initvals.c |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c      |  121 ++--------------------------
 drivers/net/wireless/ath/ath5k/reg.h      |    8 +--
 drivers/net/wireless/ath/ath9k/ath9k.h    |   13 ---
 drivers/net/wireless/ath/ath9k/hw.c       |   42 +---------
 drivers/net/wireless/ath/ath9k/hw.h       |   17 ++++-
 drivers/net/wireless/ath/ath9k/main.c     |   43 ++++++++++
 drivers/net/wireless/ath/ath9k/recv.c     |    2 +-
 drivers/net/wireless/ath/ath9k/reg.h      |    5 +-
 drivers/net/wireless/ath/ath9k/virtual.c  |    2 +-
 drivers/net/wireless/ath/hw.c             |  126 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h            |   27 ++++++
 18 files changed, 290 insertions(+), 228 deletions(-)
 create mode 100644 drivers/net/wireless/ath/hw.c
 create mode 100644 drivers/net/wireless/ath/reg.h

