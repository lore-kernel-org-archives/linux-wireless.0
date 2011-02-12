Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:33152 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571Ab1BLSnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:20 -0500
Subject: [PATCH 0/4] Fix high CPU usage in AP-mode
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 12 Feb 2011 20:43:13 +0200
Message-ID: <20110212184254.2062.33710.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series fix high CPU usage noticed in AP-mode. On Intel Atom AP-mode with
100 TU beacon interval was causing CPU usage of ~10%. With these patches 
CPU usage goes down to ~2%.

---

Jussi Kivilinna (4):
      zd1211rw: correct use of usb_bulk_msg on interrupt endpoints
      zd1211rw: use async urb for write command
      zd1211rw: move async iowrite16v up to callers
      zd1211rw: add unlikely to ZD_ASSERT


 drivers/net/wireless/zd1211rw/zd_chip.c |   35 +++++-
 drivers/net/wireless/zd1211rw/zd_def.h  |    2 
 drivers/net/wireless/zd1211rw/zd_usb.c  |  177 +++++++++++++++++++++++++------
 drivers/net/wireless/zd1211rw/zd_usb.h  |    9 +-
 4 files changed, 182 insertions(+), 41 deletions(-)
