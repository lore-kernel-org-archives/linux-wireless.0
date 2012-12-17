Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63959 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2LQLcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 06:32:52 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: print capability info for 60GHz band
Date: Mon, 17 Dec 2012 13:32:48 +0200
Message-ID: <3409795.QNLPYz7pkM@lx-vladimir> (sfid-20121217_123257_113947_4BE79DC2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From cc320b6c4433b63f3b1641646a49c4540e8954d2 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 17 Dec 2012 13:31:36 +0200
Subject: [PATCH] iw: print capability info for 60GHz band

On the 60GHz band, capability info defined different from .11n

Detect 11ad band by frequency; print accordingly

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 scan.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 25 deletions(-)

diff --git a/scan.c b/scan.c
index 05bad0b..295a51c 100644
--- a/scan.c
+++ b/scan.c
@@ -26,6 +26,21 @@
 #define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
 #define WLAN_CAPABILITY_APSD		(1<<11)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+/* DMG (60gHz) 802.11ad */
+/* type - bits 0..1 */
+#define WLAN_CAPABILITY_DMG_TYPE_MASK		(3<<0)
+
+#define WLAN_CAPABILITY_DMG_TYPE_IBSS		(1<<0) /* Tx by: STA */
+#define WLAN_CAPABILITY_DMG_TYPE_PBSS		(2<<0) /* Tx by: PCP */
+#define WLAN_CAPABILITY_DMG_TYPE_AP		(3<<0) /* Tx by: AP */
+
+#define WLAN_CAPABILITY_DMG_CBAP_ONLY		(1<<2)
+#define WLAN_CAPABILITY_DMG_CBAP_SOURCE		(1<<3)
+#define WLAN_CAPABILITY_DMG_PRIVACY		(1<<4)
+#define WLAN_CAPABILITY_DMG_ECPAC		(1<<5)
+
+#define WLAN_CAPABILITY_DMG_SPECTRUM_MGMT	(1<<8)
+#define WLAN_CAPABILITY_DMG_RADIO_MEASURE	(1<<12)
 
 static unsigned char ms_oui[3]		= { 0x00, 0x50, 0xf2 };
 static unsigned char ieee80211_oui[3]	= { 0x00, 0x0f, 0xac };
@@ -1216,6 +1231,60 @@ void print_ies(unsigned char *ie, int ielen, bool unknown,
 	}
 }
 
+static void print_capa_11ad(__u16 capa)
+{
+	switch (capa & WLAN_CAPABILITY_DMG_TYPE_MASK) {
+	case WLAN_CAPABILITY_DMG_TYPE_AP:
+		printf(" DMG_ESS");
+		break;
+	case WLAN_CAPABILITY_DMG_TYPE_PBSS:
+		printf(" DMG_PCP");
+		break;
+	case WLAN_CAPABILITY_DMG_TYPE_IBSS:
+		printf(" DMG_IBSS");
+		break;
+	}
+
+	if (capa & WLAN_CAPABILITY_DMG_CBAP_ONLY)
+		printf(" CBAP_Only");
+	if (capa & WLAN_CAPABILITY_DMG_CBAP_SOURCE)
+		printf(" CBAP_Src");
+	if (capa & WLAN_CAPABILITY_DMG_PRIVACY)
+		printf(" Privacy");
+	if (capa & WLAN_CAPABILITY_DMG_ECPAC)
+		printf(" ECPAC");
+	if (capa & WLAN_CAPABILITY_DMG_SPECTRUM_MGMT)
+		printf(" SpectrumMgmt");
+	if (capa & WLAN_CAPABILITY_DMG_RADIO_MEASURE)
+		printf(" RadioMeasure");
+}
+
+static void print_capa_11n(__u16 capa)
+{
+	if (capa & WLAN_CAPABILITY_ESS)
+		printf(" ESS");
+	if (capa & WLAN_CAPABILITY_IBSS)
+		printf(" IBSS");
+	if (capa & WLAN_CAPABILITY_PRIVACY)
+		printf(" Privacy");
+	if (capa & WLAN_CAPABILITY_SHORT_PREAMBLE)
+		printf(" ShortPreamble");
+	if (capa & WLAN_CAPABILITY_PBCC)
+		printf(" PBCC");
+	if (capa & WLAN_CAPABILITY_CHANNEL_AGILITY)
+		printf(" ChannelAgility");
+	if (capa & WLAN_CAPABILITY_SPECTRUM_MGMT)
+		printf(" SpectrumMgmt");
+	if (capa & WLAN_CAPABILITY_QOS)
+		printf(" QoS");
+	if (capa & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+		printf(" ShortSlotTime");
+	if (capa & WLAN_CAPABILITY_APSD)
+		printf(" APSD");
+	if (capa & WLAN_CAPABILITY_DSSS_OFDM)
+		printf(" DSSS-OFDM");
+}
+
 static int print_bss_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
@@ -1237,6 +1306,7 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 	};
 	struct scan_params *params = arg;
 	int show = params->show_both_ie_sets ? 2 : 1;
+	bool is_11ad = false;
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -1285,37 +1355,22 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 			tsf, tsf/1000/1000/60/60/24, (tsf/1000/1000/60/60) % 24,
 			(tsf/1000/1000/60) % 60, (tsf/1000/1000) % 60);
 	}
-	if (bss[NL80211_BSS_FREQUENCY])
-		printf("\tfreq: %d\n",
-			nla_get_u32(bss[NL80211_BSS_FREQUENCY]));
+	if (bss[NL80211_BSS_FREQUENCY]) {
+		int freq = nla_get_u32(bss[NL80211_BSS_FREQUENCY]);
+		printf("\tfreq: %d\n", freq);
+		if (freq > 45000)
+			is_11ad = true;
+	}
 	if (bss[NL80211_BSS_BEACON_INTERVAL])
 		printf("\tbeacon interval: %d\n",
 			nla_get_u16(bss[NL80211_BSS_BEACON_INTERVAL]));
 	if (bss[NL80211_BSS_CAPABILITY]) {
 		__u16 capa = nla_get_u16(bss[NL80211_BSS_CAPABILITY]);
 		printf("\tcapability:");
-		if (capa & WLAN_CAPABILITY_ESS)
-			printf(" ESS");
-		if (capa & WLAN_CAPABILITY_IBSS)
-			printf(" IBSS");
-		if (capa & WLAN_CAPABILITY_PRIVACY)
-			printf(" Privacy");
-		if (capa & WLAN_CAPABILITY_SHORT_PREAMBLE)
-			printf(" ShortPreamble");
-		if (capa & WLAN_CAPABILITY_PBCC)
-			printf(" PBCC");
-		if (capa & WLAN_CAPABILITY_CHANNEL_AGILITY)
-			printf(" ChannelAgility");
-		if (capa & WLAN_CAPABILITY_SPECTRUM_MGMT)
-			printf(" SpectrumMgmt");
-		if (capa & WLAN_CAPABILITY_QOS)
-			printf(" QoS");
-		if (capa & WLAN_CAPABILITY_SHORT_SLOT_TIME)
-			printf(" ShortSlotTime");
-		if (capa & WLAN_CAPABILITY_APSD)
-			printf(" APSD");
-		if (capa & WLAN_CAPABILITY_DSSS_OFDM)
-			printf(" DSSS-OFDM");
+		if (is_11ad)
+			print_capa_11ad(capa);
+		else
+			print_capa_11n(capa);
 		printf(" (0x%.4x)\n", capa);
 	}
 	if (bss[NL80211_BSS_SIGNAL_MBM]) {
-- 
1.7.10.4


