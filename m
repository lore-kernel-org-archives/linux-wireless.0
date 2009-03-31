Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 9/9] ath5k: sparse fix ath5k_led_on needs to be static
Date: Mon, 30 Mar 2009 22:30:35 -0400
Message-Id: <1238466635-23280-10-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043046_167962_9B36B4D1)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath5k/led.c:81:6: warning:
symbol 'ath5k_led_on' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/led.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 19555fb..006f771 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -78,7 +78,7 @@ void ath5k_led_enable(struct ath5k_softc *sc)
 	}
 }
 
-void ath5k_led_on(struct ath5k_softc *sc)
+static void ath5k_led_on(struct ath5k_softc *sc)
 {
 	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
 		return;
-- 
1.6.0.6

