Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:35987 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LBK5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 05:57:44 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so9056526eaj.9
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 02:57:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC] mac80211: fix rx_nss calculation for drivers with hw rc
Date: Mon,  2 Dec 2013 11:54:07 +0100
Message-Id: <1385981647-4147-1-git-send-email-michal.kazior@tieto.com> (sfid-20131202_115748_237895_54877F2C)
In-Reply-To: <1385739434.8656.0.camel@jlt4.sipsolutions.net>
References: <1385739434.8656.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers with hardware rate control were given
sta->rx_nss set to 0. This was because rx_nss
calculation procedure was protected by hw/sw rate
control check.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Hi Johannes,

I've re-checked the issue I've mentioned with the patch 'ath10k: use nss
provided by mac80211'.

Apparently drivers with HW rate control are only affected by this bug
and this patch is what I came up with as a quick fix. Any comments?


 net/mac80211/rate.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 5dedc56..32cdbd2 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -54,6 +54,8 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
+	ieee80211_sta_set_rx_nss(sta);
+
 	if (!ref)
 		return;
 
@@ -67,8 +69,6 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 
 	sband = local->hw.wiphy->bands[chanctx_conf->def.chan->band];
 
-	ieee80211_sta_set_rx_nss(sta);
-
 	ref->ops->rate_init(ref->priv, sband, &chanctx_conf->def, ista,
 			    priv_sta);
 	rcu_read_unlock();
-- 
1.8.4.rc3

