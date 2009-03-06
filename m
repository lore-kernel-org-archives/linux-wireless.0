Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:38013 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZCFI5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 03:57:43 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: fix compile error in ahb.c
Date: Fri,  6 Mar 2009 09:57:38 +0100
Message-Id: <1236329859-17911-2-git-send-email-juhosg@openwrt.org> (sfid-20090306_095748_121264_B9D8D7AC)
In-Reply-To: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
References: <1236329859-17911-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath9k/ahb.c: In function 'ath_ahb_probe':
drivers/net/wireless/ath9k/ahb.c:136: error: 'aphy' undeclared (first
use in this function)

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath9k/ahb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index bc562bd..00cc7bb 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -60,6 +60,7 @@ static struct ath_bus_ops ath_ahb_bus_ops  = {
 static int ath_ahb_probe(struct platform_device *pdev)
 {
 	void __iomem *mem;
+	struct ath_wiphy *aphy;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	struct resource *res;
-- 
1.5.3.2

