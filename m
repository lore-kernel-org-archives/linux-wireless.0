Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZIKBex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:34:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] atheros: implement common read/write ops
Date: Thu, 10 Sep 2009 21:34:51 -0400
Message-Id: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is my fourth series, as I had noted earlier another
thing we needed to do was make read/write driver core
specific so that ath9k_htc can define its own and yet
share common hw code. As it turns out this means the work
here allows us to also start sharing hw code between ath9k
and ath5k. The last patch is an example of this.

Luis R. Rodriguez (4):
  atheros/ath9k: add common read/write ops and port ath9k to use it
  ath5k: allocate ath5k_hw prior to initializing hw
  ath5k: define ath_common ops
  atheros: define shared bssidmask setting

 drivers/net/wireless/ath/Makefile        |    5 +-
 drivers/net/wireless/ath/ath.h           |    9 ++
 drivers/net/wireless/ath/ath5k/ath5k.h   |   24 ++++---
 drivers/net/wireless/ath/ath5k/attach.c  |   25 +-----
 drivers/net/wireless/ath/ath5k/base.c    |   38 ++++++++-
 drivers/net/wireless/ath/ath5k/base.h    |   11 ---
 drivers/net/wireless/ath/ath5k/pcu.c     |  113 +--------------------------
 drivers/net/wireless/ath/ath9k/ath9k.h   |    3 -
 drivers/net/wireless/ath/ath9k/hw.c      |   42 +----------
 drivers/net/wireless/ath/ath9k/hw.h      |    4 +-
 drivers/net/wireless/ath/ath9k/main.c    |   43 ++++++++++
 drivers/net/wireless/ath/ath9k/recv.c    |    2 +-
 drivers/net/wireless/ath/ath9k/virtual.c |    2 +-
 drivers/net/wireless/ath/hw.c            |  126 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h           |    2 +
 15 files changed, 245 insertions(+), 204 deletions(-)
 create mode 100644 drivers/net/wireless/ath/hw.c
 create mode 100644 drivers/net/wireless/ath/reg.h

