Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35545
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752289AbbLEOHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2015 09:07:07 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC] mac80211: ignore AP power level when tx power type is "fixed"
Date: Sat,  5 Dec 2015 15:07:03 +0100
Message-Id: <1449324423-99589-1-git-send-email-nbd@openwrt.org> (sfid-20151205_150712_098301_E2766078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases a user might want to connect to a far away access point,
which announces a low tx power limit. Using the AP's power limit can
make the connection significantly more unstable or even impossible, and
mac80211 currently provides no way to disable this behavior.

To fix this, use the currently unused distinction between limited and
fixed tx power to decide whether a remote AP's power limit should be
accepted.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d6a1a46..f3ee9ab 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -61,7 +61,8 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
 		power = min(power, sdata->user_power_level);
 
-	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
+	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL &&
+	    sdata->vif.bss_conf.txpower_type != NL80211_TX_POWER_FIXED)
 		power = min(power, sdata->ap_power_level);
 
 	if (power != sdata->vif.bss_conf.txpower) {
-- 
2.2.2

