Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64285 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab0EXTyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 15:54:15 -0400
Received: by wwb28 with SMTP id 28so431747wwb.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 12:54:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] ssb: fast powerup delay calculation for PMU capable devices
Date: Mon, 24 May 2010 21:50:24 +0200
Message-Id: <1274730624-22922-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
References: <1274730624-22922-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/ssb/driver_chipcommon.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 59ae76b..bda8514 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -209,6 +209,24 @@ static void chipco_powercontrol_init(struct ssb_chipcommon *cc)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PmuFastPwrupDelay */
+static u16 pmu_fast_powerup_delay(struct ssb_chipcommon *cc)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+
+	switch (bus->chip_id) {
+	case 0x4312:
+	case 0x4322:
+	case 0x4328:
+		return 7000;
+	case 0x4325:
+		/* TODO: */
+	default:
+		return 15000;
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/ClkctlFastPwrupDelay */
 static void calc_fast_powerup_delay(struct ssb_chipcommon *cc)
 {
 	struct ssb_bus *bus = cc->dev->bus;
@@ -218,6 +236,12 @@ static void calc_fast_powerup_delay(struct ssb_chipcommon *cc)
 
 	if (bus->bustype != SSB_BUSTYPE_PCI)
 		return;
+
+	if (cc->capabilities & SSB_CHIPCO_CAP_PMU) {
+		cc->fast_pwrup_delay = pmu_fast_powerup_delay(cc);
+		return;
+	}
+
 	if (!(cc->capabilities & SSB_CHIPCO_CAP_PCTL))
 		return;
 
-- 
1.6.4.2

