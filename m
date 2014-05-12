Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8584 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaELIro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 04:47:44 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/14] brcmfmac: enable 80Mhz in 5G custom regulatory rules
Date: Mon, 12 May 2014 10:47:36 +0200
Message-ID: <1399884459-5048-12-git-send-email-arend@broadcom.com> (sfid-20140512_104811_976330_712BF77E)
In-Reply-To: <1399884459-5048-1-git-send-email-arend@broadcom.com>
References: <1399884459-5048-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default allow 80Mhz in custom regulatory rules of the 5G band so
the channels will not be flagged with N0_80MHZ.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b56c2127..f6693b3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -221,9 +221,9 @@ static const struct ieee80211_regdomain brcmf_regdom = {
 		 */
 		REG_RULE(2484-10, 2484+10, 20, 6, 20, 0),
 		/* IEEE 802.11a, channel 36..64 */
-		REG_RULE(5150-10, 5350+10, 40, 6, 20, 0),
+		REG_RULE(5150-10, 5350+10, 80, 6, 20, 0),
 		/* IEEE 802.11a, channel 100..165 */
-		REG_RULE(5470-10, 5850+10, 40, 6, 20, 0), }
+		REG_RULE(5470-10, 5850+10, 80, 6, 20, 0), }
 };
 
 static const u32 __wl_cipher_suites[] = {
-- 
1.7.9.5

