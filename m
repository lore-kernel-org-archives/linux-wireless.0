Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52231 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1GIERr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:17:47 -0400
Subject: [PATCH 1/2] ath5k: validate mode in ath5k_ani_init() before trying
 to set it
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 09 Jul 2011 00:17:45 -0400
Message-ID: <20110709041745.22099.12306.stgit@mj.roinet.com> (sfid-20110709_061749_076103_A325DCA8)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ani.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index a08f173..b88d10c 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -630,6 +630,11 @@ ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
 	if (ah->ah_version < AR5K_AR5212)
 		return;
 
+	if (mode < ATH5K_ANI_MODE_OFF || mode > ATH5K_ANI_MODE_AUTO) {
+		ATH5K_ERR(ah->ah_sc, "ANI mode %d out of range", mode);
+		return;
+	}
+
 	/* clear old state information */
 	memset(&ah->ah_sc->ani_state, 0, sizeof(ah->ah_sc->ani_state));
 
