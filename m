Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26116 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0JTOBr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 10:01:47 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 07:01:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath5k: make ath5k_update_bssid_mask_and_opmode() static
Date: Wed, 20 Oct 2010 06:59:38 -0700
Message-ID: <1287583178-2963-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287583178-2963-1-git-send-email-lrodriguez@atheros.com>
References: <1287583178-2963-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this sparse warning:

  CHECK   drivers/net/wireless/ath/ath5k/base.c
drivers/net/wireless/ath/ath5k/base.c:569:6: warning: symbol
'ath5k_update_bssid_mask_and_opmode' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8251946..aeb258a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -566,8 +566,8 @@ static void ath_do_set_opmode(struct ath5k_softc *sc)
 		  sc->opmode, ath_opmode_to_string(sc->opmode));
 }
 
-void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
-					struct ieee80211_vif *vif)
+static void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
+					       struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath5k_hw_common(sc->ah);
 	struct ath_vif_iter_data iter_data;
-- 
1.7.0.4

