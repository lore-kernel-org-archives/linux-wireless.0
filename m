Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39991 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v2 11/11] ath9k: enable support for AR9100
Date: Fri,  9 Jan 2009 13:24:28 +0100
Message-Id: <1231503868-29226-12-git-send-email-juhosg@openwrt.org> (sfid-20090109_132557_714019_7AD5057E)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because we have support for the AR9100 devices now, we can enable them.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 742ecc1..8bfa216 100644
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

