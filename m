Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZCJC2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:28:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] iw: parse max allowed bandwidth
Date: Mon,  9 Mar 2009 22:28:48 -0400
Message-Id: <1236652130-29971-2-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032858_292032_0D8DC1E3)
In-Reply-To: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
References: <1236652130-29971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 info.c    |   17 ++++++++++++++---
 nl80211.h |    3 +++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/info.c b/info.c
index ed135a9..f704131 100644
--- a/info.c
+++ b/info.c
@@ -54,6 +54,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_RADAR] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] = { .type = NLA_U32 },
+		[NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH] = { .type = NLA_U32 },
 	};
 
 	struct nlattr *tb_rate[NL80211_BITRATE_ATTR_MAX + 1];
@@ -205,9 +206,19 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			freq = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]);
 			printf("\t\t\t* %d MHz [%d]", freq, ieee80211_frequency_to_channel(freq));
 
-			if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] &&
-			    !tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
-				printf(" (%.1f dBm)", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
+			if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
+				bool set_freq_pow_bw = false;
+				if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]) {
+					printf(" (%.1f dBm", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
+					set_freq_pow_bw = true;
+				}
+				if (tb_freq[NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH]) {
+					printf(" / %d MHz", nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH]));
+					set_freq_pow_bw = true;
+				}
+				if (set_freq_pow_bw)
+					printf(")");
+			}
 
 			open = 0;
 			if (tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
diff --git a/nl80211.h b/nl80211.h
index f6e5637..55565a4 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -639,6 +639,7 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
  *	(100 * dBm).
+ * @NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH: max bandwidth allowed, given in MHz
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -648,6 +649,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
 	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+	NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -655,6 +657,7 @@ enum nl80211_frequency_attr {
 };
 
 #define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+#define NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH NL80211_FREQUENCY_ATTR_MAX_BANDWIDTH
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
-- 
1.6.0.6

