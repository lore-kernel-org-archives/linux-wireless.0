Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64137 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbZHDRFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 13:05:31 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 10:05:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Igor Perminov <igor.perminov@inbox.ru>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH] ath9k: use new FIF_PSPOLL configure filter
Date: Tue, 4 Aug 2009 10:05:30 -0700
Message-ID: <1249405530-14123-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We used to set pspoll filter on ath9k on AP mode but
we no longer need this mode specific check as mac80211
now does the check for us and informs us when we should
enable pspoll through FIF_PSPOLL.

Cc: Igor Perminov <igor.perminov@inbox.ru>
Cc: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 61edfab..6b07ced 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -448,8 +448,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	/* If in HOSTAP mode, want to enable reception of PSPOLL frames */
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP)
+	if (sc->rx.rxfilter & FIF_PSPOLL)
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
 	if (sc->sec_wiphy) {
-- 
1.6.3.3

