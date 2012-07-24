Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab2GXGf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 02:35:59 -0400
Date: Tue, 24 Jul 2012 08:35:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Hong Wu <Hong.Wu@dspg.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] wireless: reg: restore previous behaviour of chan->max_power
 calculations
Message-ID: <20120724063538.GB2265@redhat.com> (sfid-20120724_083604_696318_C141BD9E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit eccc068e8e84c8fe997115629925e0422a98e4de
Author: Hong Wu <Hong.Wu@dspg.com>
Date:   Wed Jan 11 20:33:39 2012 +0200

    wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit pow

changed the way we calculate chan->max_power as min(chan->max_power,
chan->max_reg_power). That broke rt2x00 (and perhaps some other
drivers) that do not set chan->max_power. It is not so easy to fix this
problem correctly in rt2x00.

According to commit eccc068e8 changelog, change claim only to save
maximum regulatory power - changing setting of chan->max_power was side
effect. This patch restore previous calculations of chan->max_power and
do not touch chan->max_reg_power.

Cc: stable@vger.kernel.org # 3.4+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/wireless/reg.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b2b3222..4a47878 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -894,7 +894,21 @@ static void handle_channel(struct wiphy *wiphy,
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
 	chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
-	chan->max_power = min(chan->max_power, chan->max_reg_power);
+	if (chan->orig_mpwr) {
+		/*
+		 * Devices that have their own custom regulatory domain
+		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
+		 * passed country IE power settings.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
+		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
+			chan->max_power = chan->max_reg_power;
+		else
+			chan->max_power = min(chan->orig_mpwr,
+					      chan->max_reg_power);
+	} else
+		chan->max_power = chan->max_reg_power;
 }
 
 static void handle_band(struct wiphy *wiphy,
-- 
1.7.1

