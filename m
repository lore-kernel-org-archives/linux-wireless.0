Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45966 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYKVUCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 15:02:55 -0500
Date: Sat, 22 Nov 2008 22:02:02 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH iw] Report max TX power from NL80211_BAND_ATTR_FREQS
Message-ID: <20081122200202.GC8265@jm.kir.nu> (sfid-20081122_210300_486179_3014FFD9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <j@w1.fi>


diff --git a/info.c b/info.c
index ced78dd..cd82ebc 100644
--- a/info.c
+++ b/info.c
@@ -34,6 +34,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		[NL80211_FREQUENCY_ATTR_PASSIVE_SCAN] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_NO_IBSS] = { .type = NLA_FLAG },
 		[NL80211_FREQUENCY_ATTR_RADAR] = { .type = NLA_FLAG },
+		[NL80211_FREQUENCY_ATTR_MAX_TX_POWER] = { .type = NLA_U32 },
 	};
 
 	struct nlattr *tb_rate[NL80211_BITRATE_ATTR_MAX + 1];
@@ -142,6 +143,10 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			if (!tb_freq[NL80211_FREQUENCY_ATTR_FREQ])
 				continue;
 			printf("\t\t\t* %d MHz", nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_FREQ]));
+
+			if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
+				printf(" (%.1f dBm)", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_MAX_TX_POWER]));
+
 			open = 0;
 			if (tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
 				print_flag("disabled", &open);
diff --git a/nl80211.h b/nl80211.h
index e4cc786..596961d 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -497,6 +497,8 @@ enum nl80211_band_attr {
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
  *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
+ *	(100 * dBm).
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -505,12 +507,15 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
+	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
 	NL80211_FREQUENCY_ATTR_MAX = __NL80211_FREQUENCY_ATTR_AFTER_LAST - 1
 };
 
+#define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
  * @NL80211_BITRATE_ATTR_RATE: Bitrate in units of 100 kbps

-- 
Jouni Malinen                                            PGP id EFC895FA
