Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40048 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab2GCROD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 03/20] ath9k: set MAC version for AR9550
Date: Tue,  3 Jul 2012 19:13:17 +0200
Message-Id: <1341335614-15419-4-git-send-email-juhosg@openwrt.org> (sfid-20120703_191427_915901_D4792C88)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ebfb2a3..36cf591 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -342,6 +342,9 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		val = REG_READ(ah, AR_SREV);
 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 		return;
+	case AR9300_DEVID_QCA955X:
+		ah->hw_version.macVersion = AR_SREV_VERSION_9550;
+		return;
 	}
 
 	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
-- 
1.7.2.1

