Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1255 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/15] brcm80211: smac: remove phy api bypass in rate.h
Date: Tue, 18 Oct 2011 14:03:08 +0200
Message-ID: <1318939391-19495-13-git-send-email-arend@broadcom.com> (sfid-20111018_140358_379896_47599235)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obviously the phy api should be used to interface with the phy. In
rate.h a table within phy was accessed directly by declaring the
table extern in rate.h itself. This patch fixes this using the
provided api function to obtain the table reference. This bypass
was found by a sparse warning on the table not being defined static.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/rate.h     |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index a314925..2faea50 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -112,7 +112,7 @@ static const struct chan_info_basic chan_info_all[] = {
 	{216, 50800}
 };
 
-const u8 ofdm_rate_lookup[] = {
+static const u8 ofdm_rate_lookup[] = {
 
 	BRCM_RATE_48M,
 	BRCM_RATE_24M,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/rate.h b/drivers/net/wireless/brcm80211/brcmsmac/rate.h
index e7b9dc2..980d578 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/rate.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/rate.h
@@ -19,6 +19,7 @@
 
 #include "types.h"
 #include "d11.h"
+#include "phy_hal.h"
 
 extern const u8 rate_info[];
 extern const struct brcms_c_rateset cck_ofdm_mimo_rates;
@@ -198,11 +199,9 @@ static inline u8 cck_rspec(u8 cck)
 
 /* Convert encoded rate value in plcp header to numerical rates in 500 KHz
  * increments */
-extern const u8 ofdm_rate_lookup[];
-
 static inline u8 ofdm_phy2mac_rate(u8 rlpt)
 {
-	return ofdm_rate_lookup[rlpt & 0x7];
+	return wlc_phy_get_ofdm_rate_lookup()[rlpt & 0x7];
 }
 
 static inline u8 cck_phy2mac_rate(u8 signal)
-- 
1.7.4.1


