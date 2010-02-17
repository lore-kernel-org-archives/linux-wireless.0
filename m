Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:56042 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab0BQVEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:04:23 -0500
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 905748C149
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:22 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 7B87D4033
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:21 +0200 (EET)
Subject: [RFC PATCH 3/3] mac80211: add support connection monitor in hardware
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 23:04:21 +0200
Message-ID: <20100217210421.30634.29786.stgit@tikku>
In-Reply-To: <20100217210202.30634.69236.stgit@tikku>
References: <20100217210202.30634.69236.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl1271 has a feature so that it handles the connection monitor logic
in hardware, basically sending periodically nullfunc frames and reporting
to the host if AP is lost.

Add support to mac80211 by adding a new flag IEEE80211_HW_CONNECTION_MONITOR
which prevents conn_mon_timer from triggering during idle periods.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/net/mac80211.h |    1 +
 net/mac80211/mlme.c    |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 80eb7cc..1d28fcc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -975,6 +975,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4b9596f..3fa8e6a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -850,6 +850,9 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 }

