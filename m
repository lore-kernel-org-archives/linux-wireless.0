Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:54078 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZAMNly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:41:54 -0500
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
	Pavel Roskin <proski@gnu.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v3 11/11] ath9k: enable support for AR9100
Date: Tue, 13 Jan 2009 14:40:29 +0100
Message-Id: <1231854029-26810-12-git-send-email-juhosg@openwrt.org> (sfid-20090113_144205_194949_DCA5BE47)
In-Reply-To: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
References: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because we have support for the AR9100 devices now, we can enable them.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index e2a92d7..f7cb52f 100644
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
@@ -1175,6 +1177,7 @@ struct ath_hal *ath9k_hw_attach(u16 devid, struct ath_softc *sc,
 	switch (devid) {
 	case AR5416_DEVID_PCI:
 	case AR5416_DEVID_PCIE:
+	case AR5416_AR9100_DEVID:
 	case AR9160_DEVID_PCI:
 	case AR9280_DEVID_PCI:
 	case AR9280_DEVID_PCIE:
-- 
1.5.3.2

