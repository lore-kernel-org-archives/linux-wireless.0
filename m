Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36089 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbYJDFpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 01:45:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2008 22:45:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>
Subject: [PATCH 2/3] ath9k: fix oops on trying to hold the wrong spinlock
Date: Fri, 3 Oct 2008 15:45:26 -0700
Message-ID: <1223073927-16266-3-git-send-email-lrodriguez@atheros.com> (sfid-20081004_074555_229676_70753312)
In-Reply-To: <1223073927-16266-2-git-send-email-lrodriguez@atheros.com>
References: <1223073927-16266-1-git-send-email-lrodriguez@atheros.com>
 <1223073927-16266-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were trying to hold the wrong spinlock due to a typo
on IEEE80211_BAR_CTL_TID_S's definition. We use this to
compute the tid number and then hold this this tid number's
spinlock.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 80814c9..5b4f1c4 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -309,7 +309,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 #define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
 #define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  2       /* tid shift */
+#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
 
 enum ATH_RX_TYPE {
 	ATH_RX_NON_CONSUMED = 0,
-- 
1.5.6.rc2.15.g457bb.dirty

