Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57173 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaKKQLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 11:11:32 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi2so2106545wib.13
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 08:11:31 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Subject: [PATCH] mac80211: don't allow 40MHz tx rates in case of 20MHz chandef
Date: Tue, 11 Nov 2014 18:11:22 +0200
Message-Id: <1415722282-29309-1-git-send-email-egrumbach@gmail.com> (sfid-20141111_171135_471270_7DB91DD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

When 20MHz chandef is used, 40MHz rates shouldn't be
used (by the rate-control algorithm), even if the sta
ht capabilities indicate support for it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Singed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/vht.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 671ce0d..bc9e8fc 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -287,6 +287,8 @@ enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
 		/* fall through */
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
+		bw = IEEE80211_STA_RX_BW_20;
+		break;
 	case NL80211_CHAN_WIDTH_40:
 		bw = sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
-- 
1.9.1

