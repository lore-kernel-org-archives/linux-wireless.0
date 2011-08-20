Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12060 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HTLyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 07:54:09 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: Mark mandatory rates as basic
Date: Sat, 20 Aug 2011 17:24:35 +0530
Message-ID: <1313841275-7868-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110820_135415_748038_FB02B99D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 announces a supported rate set with
no basic rates. This patch marks the mandatory rates as
basic while constructing supported rate element.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/cfg80211.h |    3 +++
 net/mac80211/mesh.c    |    5 ++++-
 net/mac80211/util.c    |    6 +++++-
 net/mac80211/work.c    |    6 +++++-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d86a15d..bb9000a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -167,6 +167,9 @@ enum ieee80211_rate_flags {
 	IEEE80211_RATE_ERP_G		= 1<<4,
 };
 
+#define IEEE80211_ALL_MANDATORY_RATES \
+	(IEEE80211_RATE_MANDATORY_A | IEEE80211_RATE_MANDATORY_B | \
+	 IEEE80211_RATE_MANDATORY_G)
 /**
  * struct ieee80211_rate - bitrate definition
  *
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29e9980..9b429dd 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -221,7 +221,10 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos++ = len;
 	for (i = 0; i < len; i++) {
 		rate = sband->bitrates[i].bitrate;
-		*pos++ = (u8) (rate / 5);
+		*pos = (u8) (rate / 5);
+		if (sband->bitrates[i].flags & IEEE80211_ALL_MANDATORY_RATES)
+			*pos |= 0x80;
+		pos++;
 	}
 
 	if (sband->n_bitrates > len) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce916ff..8b32b57 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -758,7 +758,11 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if ((BIT(i) & rate_mask) == 0)
 			continue; /* skip rate */
-		rates[num_rates++] = (u8) (sband->bitrates[i].bitrate / 5);
+		rates[num_rates] = (u8) (sband->bitrates[i].bitrate / 5);
+		/* Mark as basic rates */
+		if (sband->bitrates[i].flags & IEEE80211_ALL_MANDATORY_RATES)
+			rates[num_rates] |= 0x80;
+		num_rates++;
 	}
 
 	supp_rates_len = min_t(int, num_rates, 8);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 380b9a7..8647201 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -295,7 +295,11 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	for (i = 0; i < sband->n_bitrates; i++) {
 		if (BIT(i) & rates) {
 			int rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
+			*pos = (u8) (rate / 5);
+			if (sband->bitrates[i].flags &
+				IEEE80211_ALL_MANDATORY_RATES)
+				*pos |= 0x80;
+			pos++;
 			if (++count == 8)
 				break;
 		}
-- 
1.7.6

