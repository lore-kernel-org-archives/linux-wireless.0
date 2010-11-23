Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52027 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab0KWT2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:28:07 -0500
Message-ID: <4CEC15C3.2010901@openwrt.org>
Date: Tue, 23 Nov 2010 20:28:03 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, johannes@sipsolutions.net,
	Paul Stewart <pstew@google.com>
Subject: [PATCH v2 3/4] mac80211: probe the AP when resuming
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org> <1290203740-57124-2-git-send-email-nbd@openwrt.org> <1290203740-57124-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-3-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the connection by probing the AP (either using nullfunc or a
probe request). If nullfunc probing is supported and the assoc is no
longer valid, the AP will send a disassoc/deauth immediately.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2068,6 +2068,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
 		add_timer(&ifmgd->chswitch_timer);
 	ieee80211_sta_reset_beacon_monitor(sdata);
+	ieee80211_restart_sta_timer(sdata);
 }
 #endif
  

