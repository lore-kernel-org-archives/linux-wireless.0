Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35163 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab0KSVzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:55:45 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3/4] mac80211: probe the AP when resuming
Date: Fri, 19 Nov 2010 22:55:39 +0100
Message-Id: <1290203740-57124-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-2-git-send-email-nbd@openwrt.org>
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
 <1290203740-57124-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send a nullfunc packet on resume as a fast probe of whether we're still
associated to the AP. If the association expired, the AP will send a
disassoc/deauth, allowing the station to reconnect immediately.

Signed-off-by: Nathan Williams <njw@google.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f2b414b..ae99c0b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2060,6 +2060,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
 		add_timer(&ifmgd->chswitch_timer);
 	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_send_nullfunc(sdata->local, sdata, 0);
 }
 #endif
 
-- 
1.7.3.2

