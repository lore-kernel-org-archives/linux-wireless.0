Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760266Ab2BNNJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 08:09:38 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: remove unnecessary PS wrappers
Date: Tue, 14 Feb 2012 18:39:19 +0530
Message-ID: <1329224959-12143-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120214_141049_384864_D20A0F35)
In-Reply-To: <1329224959-12143-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1329224959-12143-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ath_set_channel is called from ath9k_config which already has proper
PS wrappers

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 22785c7..c81304d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -371,12 +371,8 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
-	ath9k_ps_wakeup(sc);
-
 	r = ath_reset_internal(sc, hchan, false);
 
-	ath9k_ps_restore(sc);
-
 	return r;
 }
 
-- 
1.7.0.4

