Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39556 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0AGWZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:25:04 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] cfg80211: process the max power on a country IE
Date: Thu,  7 Jan 2010 17:24:56 -0500
Message-Id: <1262903097-2129-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The max power from each country IE triplet was being ignored.
This fix isn't critical as CRDA was always being used for the lower
limit, but we should process it in case the AP still wants to
decrease power output even more for whatever reason.

Reported-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7223a7a..1695d62 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -680,7 +680,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		 */
 		freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
 		power_rule->max_antenna_gain = DBI_TO_MBI(100);
-		power_rule->max_eirp = DBM_TO_MBM(100);
+		power_rule->max_eirp = DBM_TO_MBM(triplet->chans.max_power);
 
 		country_ie += 3;
 		country_ie_len -= 3;
-- 
1.6.3.3

