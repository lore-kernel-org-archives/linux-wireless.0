Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1246 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/15] brcm80211: smac: drop "40MHz intolerant" flag
 from HT capability info
Date: Tue, 18 Oct 2011 14:02:59 +0200
Message-ID: <1318939391-19495-4-git-send-email-arend@broadcom.com> (sfid-20111018_140331_785439_4A60ACAB)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac driver registered with mac80211 with HT capability info
set to 40MHz intolerant. This cause any other station on the channel
to be forced to use 20MHz. This flag has been removed.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index ac8d02b..538b504 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -215,8 +215,7 @@ static const struct ieee80211_supported_band brcms_band_2GHz_nphy_template = {
 	.ht_cap = {
 		   /* from include/linux/ieee80211.h */
 		   .cap = IEEE80211_HT_CAP_GRN_FLD |
-		   IEEE80211_HT_CAP_SGI_20 |
-		   IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,
+			  IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40,
 		   .ht_supported = true,
 		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
 		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
@@ -237,8 +236,7 @@ static const struct ieee80211_supported_band brcms_band_5GHz_nphy_template = {
 			BRCMS_LEGACY_5G_RATE_OFFSET,
 	.ht_cap = {
 		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
-			  IEEE80211_HT_CAP_SGI_40 |
-			  IEEE80211_HT_CAP_40MHZ_INTOLERANT, /* No 40 mhz yet */
+			  IEEE80211_HT_CAP_SGI_40,
 		   .ht_supported = true,
 		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
 		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
-- 
1.7.4.1


