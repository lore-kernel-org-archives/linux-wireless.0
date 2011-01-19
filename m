Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:7568 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753795Ab1ASJUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:38 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0535238836
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:36 +0900 (JST)
Subject: [PATCH 6/8] ath5: Remove unused CTL definitions
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:21:02 +0900
Message-ID: <20110119092102.19628.68971.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are unused in ath5k and a more detailled definition is in
ath/regd_common.h.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/eeprom.h |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index d46f105..6511c27 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -268,29 +268,6 @@ enum ath5k_ctl_mode {
 	AR5K_CTL_MODE_M = 15,
 };
 
-/* Default CTL ids for the 3 main reg domains.
- * Atheros only uses these by default but vendors
- * can have up to 32 different CTLs for different
- * scenarios. Note that theese values are ORed with
- * the mode id (above) so we can have up to 24 CTL
- * datasets out of these 3 main regdomains. That leaves
- * 8 ids that can be used by vendors and since 0x20 is
- * missing from HAL sources i guess this is the set of
- * custom CTLs vendors can use. */
-#define	AR5K_CTL_FCC	0x10
-#define	AR5K_CTL_CUSTOM	0x20
-#define	AR5K_CTL_ETSI	0x30
-#define	AR5K_CTL_MKK	0x40
-
-/* Indicates a CTL with only mode set and
- * no reg domain mapping, such CTLs are used
- * for world roaming domains or simply when
- * a reg domain is not set */
-#define	AR5K_CTL_NO_REGDOMAIN	0xf0
-
-/* Indicates an empty (invalid) CTL */
-#define AR5K_CTL_NO_CTL		0xff
-
 /* Per channel calibration data, used for power table setup */
 struct ath5k_chan_pcal_info_rf5111 {
 	/* Power levels in half dbm units

