Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133AbZLPGgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 01:36:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, ic.felix@gmail.com,
	=?utf-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
Subject: [PATCH] iw: add country IE parsing support for scanning
Date: Wed, 16 Dec 2009 01:36:38 -0500
Message-Id: <1260945398-301-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Screenshot:

BSS 00:0b:85:aa:bb:cc (on wlan11)
        TSF: 488777932855 usec (5d, 15:46:17)
        freq: 5320
        beacon interval: 100
        capability: ESS (0x0001)
        signal: -74.00 dBm
        last seen: 1730 ms ago
        SSID: Foobar
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0
        Country: US     Environment: Indoor/Outdoor
        Country IE triplets:
                Channels [36 - 48]
                Channels [52 - 64]
                Channels [149 - 165]

I haven't found any regclasses while scanning at work.
We can likely start using the info here:

http://wireless.kernel.org/en/developers/Documentation/ChannelList

to process this info more.

Cc: ic.felix@gmail.com
Cc: Lukáš Turek <8an@praha12.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scan.c |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 70 insertions(+), 17 deletions(-)

diff --git a/scan.c b/scan.c
index d37ae7c..142eedb 100644
--- a/scan.c
+++ b/scan.c
@@ -35,6 +35,23 @@ struct scan_params {
 	enum print_ie_type type;
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
@@ -142,29 +159,65 @@ static void print_ds(const uint8_t type, uint8_t len, const uint8_t *data)
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
+			end_channel = triplet->chans.first_channel + triplet->chans.num_channels;
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

