Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46706 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYJPSNE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 14:13:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2008 11:13:04 -0700
Date: Thu, 16 Oct 2008 04:12:55 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <stable@kernel.org>
CC: <steven@uplinklabs.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: fix oops on trying to hold the wrong spinlock
Message-ID: <20081016111255.GA5899@tesla> (sfid-20081016_201308_862714_B81982BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes on oops when you get try to send a BA to an 11n AP.
The oops occurred because we were trying to aquire an incorrect
spinlock.

We were trying to hold the wrong spinlock due to a typo
on IEEE80211_BAR_CTL_TID_S's definition. We use this to
compute the tid number and then hold this this tid number's
spinlock.

Tested-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

I don't see this queue'd yet for 2.6.27.2

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

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
