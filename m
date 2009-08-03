Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34781 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbZHCTY5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:24:57 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:24:59 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 01/24] ath9k: remove usage of AR_SREV_*() wrapper to detect supported hw
Date: Mon, 3 Aug 2009 12:24:33 -0700
Message-ID: <1249327496-24629-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will clean this up next to just use a switch.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7a0a6ae..e0bc4c5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -665,8 +665,10 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 	if ((ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCI) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_5416_PCIE) &&
 	    (ah->hw_version.macVersion != AR_SREV_VERSION_9160) &&
-	    (!AR_SREV_9100(ah)) && (!AR_SREV_9280(ah)) &&
-	    (!AR_SREV_9285(ah)) && (!AR_SREV_9287(ah))) {
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_9100) &&
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_9280) &&
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_9285) &&
+	    (ah->hw_version.macVersion != AR_SREV_VERSION_9287)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Mac Chip Rev 0x%02x.%x is not supported by "
 			"this driver\n", ah->hw_version.macVersion,
-- 
1.6.3.3

