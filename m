Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:37283 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774AbaEQQnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 12:43:07 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCHv3 2/4] cfg80211: export expected throughput via nl80211 (GET_STATION)
Date: Sat, 17 May 2014 18:41:44 +0200
Message-Id: <1400344906-27984-3-git-send-email-antonio@meshcoding.com> (sfid-20140517_184318_391743_6B095094)
In-Reply-To: <1400344906-27984-1-git-send-email-antonio@meshcoding.com>
References: <1400344906-27984-1-git-send-email-antonio@meshcoding.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Send the expected throughput when replying to a GET_STATION
command via nl80211.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0cfa827..2964948 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2199,6 +2199,8 @@ enum nl80211_sta_bss_param {
  *	Contains a nested array of signal strength attributes (u8, dBm)
  * @NL80211_STA_INFO_CHAIN_SIGNAL_AVG: per-chain signal strength average
  *	Same format as NL80211_STA_INFO_CHAIN_SIGNAL.
+ * @NL80211_STA_EXPECTED_THROUGHPUT: expected throughput (considering also the
+ *	802.11 header) expressed in kbps
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -2230,6 +2232,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_TX_BYTES64,
 	NL80211_STA_INFO_CHAIN_SIGNAL,
 	NL80211_STA_INFO_CHAIN_SIGNAL_AVG,
+	NL80211_STA_INFO_EXPECTED_THROUGHPUT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ca19b15..9631648 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3650,6 +3650,10 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_FAILED,
 			sinfo->tx_failed))
 		goto nla_put_failure;
+	if ((sinfo->filled & STATION_INFO_EXPECTED_THROUGHPUT) &&
+	    nla_put_u32(msg, NL80211_STA_INFO_EXPECTED_THROUGHPUT,
+			sinfo->expected_throughput))
+		goto nla_put_failure;
 	if ((sinfo->filled & STATION_INFO_BEACON_LOSS_COUNT) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_BEACON_LOSS,
 			sinfo->beacon_loss_count))
-- 
1.8.5.5

