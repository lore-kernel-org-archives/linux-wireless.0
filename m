Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52703 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab0BSS4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:56:00 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, 8an@praha12.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2] iw: add country IE parsing
Date: Fri, 19 Feb 2010 13:55:58 -0500
Message-Id: <1266605758-19695-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spits out the channels as seen on the IE, useful when debugging
issues with APs. When found the equivalent distance of the
coverage class is printed out.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

On v2 this uses 450 * coverage_class to get the distance
in meters now.

 scan.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/scan.c b/scan.c
index ec63e61..3253d9b 100644
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
@@ -143,29 +160,64 @@ static void print_ds(const uint8_t type, uint8_t len, const uint8_t *data)
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
+	while (len >= 3) {
+		int end_channel;
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) data;
+
+		if (triplet->ext.reg_extension_id >= IEEE80211_COUNTRY_EXTENSION_ID) {
+			printf("\t\tExtension ID: %d Regulatory Class: %d Coverage class: %d (up to %dm)\n",
+			       triplet->ext.reg_extension_id,
+			       triplet->ext.reg_class,
+			       triplet->ext.coverage_class,
+			       triplet->ext.coverage_class * 450);
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

