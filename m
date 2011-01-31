Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:42618 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1AaSrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:47:23 -0500
Subject: [PATCH 02/22] zd1211rw: cancel process_intr work on
	zd_chip_disable_int()
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Mon, 31 Jan 2011 20:47:17 +0200
Message-ID: <20110131184717.10044.89440.stgit@fate.lan>
In-Reply-To: <20110131184657.10044.98610.stgit@fate.lan>
References: <20110131184657.10044.98610.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OOPS if worker is running and disconnect() is called (triggered
by unpluging device). Much harder to trigger at this stage but
later when we have AP beacon work in process_intr it happens very
easy.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_chip.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 6a9b660..b644ced 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1407,6 +1407,9 @@ void zd_chip_disable_int(struct zd_chip *chip)
 	mutex_lock(&chip->mutex);
 	zd_usb_disable_int(&chip->usb);
 	mutex_unlock(&chip->mutex);
+
+	/* cancel pending interrupt work */
+	cancel_work_sync(&zd_chip_to_mac(chip)->process_intr);
 }
 
 int zd_chip_enable_rxtx(struct zd_chip *chip)

