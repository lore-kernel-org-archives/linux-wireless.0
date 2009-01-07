Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:44046 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZAGKLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 05:11:07 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH 08/11] ath9k: enable support for AR9100
Date: Wed,  7 Jan 2009 11:09:29 +0100
Message-Id: <1231322972-24094-9-git-send-email-juhosg@openwrt.org> (sfid-20090107_111133_655032_422B6AA7)
In-Reply-To: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
References: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because we have support for the AR9100 devices now, we can enable them.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 088d968..e4aa39e 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -373,6 +373,8 @@ static const char *ath9k_hw_devname(u16 devid)
 		return "Atheros 5418";
 	case AR9160_DEVID_PCI:
 		return "Atheros 9160";
+	case AR5416_AR9100_DEVID:
+		return "Atheros 9100";
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
 		return "Atheros 9280";
@@ -1176,6 +1178,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 	switch (devid) {
 	case AR5416_DEVID_PCI:
 	case AR5416_DEVID_PCIE:
+	case AR5416_AR9100_DEVID:
 	case AR9160_DEVID_PCI:
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
-- 
1.5.3.2

