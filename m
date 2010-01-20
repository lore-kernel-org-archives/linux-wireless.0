Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab0ATRvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 12:51:49 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: add country IE parsing
Date: Wed, 20 Jan 2010 12:51:48 -0500
Message-Id: <1264009908-27195-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I've considered showing only the channel set from the Country IE
but since cfg80211 now mangles contigious channel sets together
it seems more useful for iw to just display the individual triplets
separately so this patch is left intact. The triplet print is
kept since technically speaking this should also show the
regulatory extension stuff when one is found.

 scan.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/scan.c b/scan.c
index 999aba4..26e07e6 100644
--- a/scan.c
+++ b/scan.c
@@ -36,6 +36,23 @@ struct scan_params {
 	bool show_both_ie_sets;
 };
 
+#define IEEE80211_COUNTRY_EXTENSION_ID 201
+
+struct ieee80211_country_ie_triplet {
+	union {
+		struct {
+			__u8 first_channel;
+			__u8 num_channels;
+			__s8 max_power;
+		} __attribute__ ((packed)) chans;
+		struct {
+			__u8 reg_extension_id;
+			__u8 reg_class;
+			__u8 coverage_class;
+		} __attribute__ ((packed)) ext;
+	};
+} __attribute__ ((packed));
+
 static int handle_scan(struct nl80211_state *state,
 		       struct nl_cb *cb,
 		       struct nl_msg *msg,
@@ -143,29 +160,65 @@ static void print_ds(const uint8_t type, uint8_t len, const uint8_t *data)
 	printf(" channel %d\n", data[0]);
 }
 
-static void print_country(const uint8_t type, uint8_t len, const uint8_t *data)
+static const char *country_env_str(char environment)
 {
-	int i;
-
-	printf(" %.*s", 2, data);
-	switch (data[2]) {
+	switch (environment) {
 	case 'I':
-		printf(" (indoor)");
-		break;
+		return "Indoor only";
 	case 'O':
-		printf(" (outdoor)");
-		break;
+		return "Outdoor only";
 	case ' ':
-		printf(" (in/outdoor)");
-		break;
+		return "Indoor/Outdoor";
 	default:
-		printf(" (invalid environment)");
-		break;
+		return "bogus";
 	}
-	printf(", data:");
-	for(i=0; i<len-3; i++)
-		printf(" %.02x", data[i + 3]);
-	printf("\n");
+}
+
+static void print_country(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	printf(" %.*s", 2, data);
+
+	printf("\tEnvironment: %s\n", country_env_str(data[2]));
+
+	data += 3;
+	len -= 3;
+
+	if (len < 3) {
+		printf("\t\tNo country IE triplets present\n");
+		return;
+	}
+
+	printf("\tCountry IE triplets:\n");
+
+	while (len >= 3) {
+		int end_channel;
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) data;
+
+		if (triplet->ext.reg_extension_id >= IEEE80211_COUNTRY_EXTENSION_ID) {
+			printf("\t\tExtension ID: %d Regulatory Class: %d Coverage class: %d\n",
+			       triplet->ext.reg_extension_id,
+			       triplet->ext.reg_class,
+			       triplet->ext.coverage_class);
+
+			data += 3;
+			len -= 3;
+			continue;
+		}
+
+		/* 2 GHz */
+		if (triplet->chans.first_channel <= 14)
+			end_channel = triplet->chans.first_channel + (triplet->chans.num_channels - 1);
+		else
+			end_channel =  triplet->chans.first_channel + (4 * (triplet->chans.num_channels - 1));
+
+		printf("\t\tChannels [%d - %d]\n", triplet->chans.first_channel, end_channel);
+
+		data += 3;
+		len -= 3;
+	}
+
+	return;
 }
 
 static void print_powerconstraint(const uint8_t type, uint8_t len, const uint8_t *data)
-- 
1.6.3.3

