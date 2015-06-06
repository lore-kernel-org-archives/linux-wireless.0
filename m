Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35598 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbFFUq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 16:46:28 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	<stable@vger.kernel.org>
Subject: [PATCH FIX] b43: fix support for 14e4:4321 PCI dev with BCM4321 chipset
Date: Sat,  6 Jun 2015 22:45:59 +0200
Message-Id: <1433623559-25433-1-git-send-email-zajec5@gmail.com> (sfid-20150606_225054_941860_562D63B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems Broadcom released two devices with conflicting device id. There
are for sure 14e4:4321 PCI devices with BCM4321 (N-PHY) chipset, they
can be found in routers, e.g. Netgear WNR834Bv2. However, according to
Broadcom public sources 0x4321 is also used for 5 GHz BCM4306 (G-PHY).
It's unsure if they meant PCI device id, or "virtual" id (from SPROM).
To distinguish these devices lets check PHY type (G vs. N).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: <stable@vger.kernel.org> # 3.16+
---
Kalle: I'm aware it's quite late for a 4.1 fix, this bug was reported just
today. I guess you can just take it for wireless-drivers-next and let stable
guys handle it.
---
 drivers/net/wireless/b43/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f409929..9556454 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5361,6 +5361,10 @@ static void b43_supported_bands(struct b43_wldev *dev, bool *have_2ghz_phy,
 		*have_5ghz_phy = true;
 		return;
 	case 0x4321: /* BCM4306 */
+		/* There are 14e4:4321 PCI devs with 2.4 GHz BCM4321 (N-PHY) */
+		if (dev->phy.type != B43_PHYTYPE_G)
+			break;
+		/* fall through */
 	case 0x4313: /* BCM4311 */
 	case 0x431a: /* BCM4318 */
 	case 0x432a: /* BCM4321 */
-- 
1.8.4.5

