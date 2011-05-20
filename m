Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59057 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964802Ab1ETMW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:22:56 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:22:26 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 6/6] mac80211: stop queues before rate control updation
Date: Fri, 20 May 2011 17:52:15 +0530
Message-ID: <1305894135-14036-6-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142300_320315_15BD860C)
In-Reply-To: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stop tx queues before updating rate control to ensure
proper rate selection. Otherwise packets can be transmitted
in 40 Mhz whereas hw is configured in HT20.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4f6b267..7465955 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -232,6 +232,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
 	}
 
+	ieee80211_stop_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	/* channel_type change automatically detected */
 	ieee80211_hw_config(local, 0);
 
@@ -245,6 +248,9 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	}
 
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-- 
1.7.5.1

