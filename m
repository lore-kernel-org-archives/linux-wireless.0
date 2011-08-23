Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48868 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1HWLgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:36:39 -0400
Received: by fxh19 with SMTP id 19so173580fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 04:36:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: add uapsd_queues and max_sp params fields
Date: Tue, 23 Aug 2011 14:37:47 +0300
Message-Id: <1314099467-20464-2-git-send-email-eliad@wizery.com> (sfid-20110823_133641_594658_703FA76F)
In-Reply-To: <1314099467-20464-1-git-send-email-eliad@wizery.com>
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add uapsd_queues and max_sp fields to ieee80211_sta.
These fields might be needed by low-level drivers in
order to configure the AP.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/net/mac80211.h |    2 ++
 net/mac80211/cfg.c     |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..2e752df 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -954,6 +954,8 @@ struct ieee80211_sta {
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
 	bool wme;
+	u8 uapsd_queues;
+	u8 max_sp;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c1fa577..4bb6a92 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -697,6 +697,9 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
+	sta->sta.uapsd_queues = params->uapsd_queues;
+	sta->sta.max_sp = params->max_sp;
+
 	/*
 	 * cfg80211 validates this (1-2007) and allows setting the AID
 	 * only when creating a new station entry
-- 
1.7.6.401.g6a319

