Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:34242 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1ADXsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:48:07 -0500
Subject: [RFC PATCH 02/17] zd1211rw: cancel process_intr work on
	zd_chip_disable_int()
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:48:03 +0200
Message-ID: <20110104234802.25309.55896.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
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
index 30f8d40..6effe18 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1406,6 +1406,9 @@ void zd_chip_disable_int(struct zd_chip *chip)
 	mutex_lock(&chip->mutex);
 	zd_usb_disable_int(&chip->usb);
 	mutex_unlock(&chip->mutex);
+
+	/* cancel pending interrupt work */
+	cancel_work_sync(&zd_chip_to_mac(chip)->process_intr);
 }
 
 int zd_chip_enable_rxtx(struct zd_chip *chip)

