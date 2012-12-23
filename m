Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41286 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2LWIgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 03:36:21 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] iw: print capability info for DMG (60GHz band)
Date: Sun, 23 Dec 2012 10:36:17 +0200
Message-ID: <15592562.1rgtRnahzt@lx-vladimir> (sfid-20121223_093626_081325_4A5AB22A)
In-Reply-To: <1356082023.9580.5.camel@jlt4.sipsolutions.net>
References: <3409795.QNLPYz7pkM@lx-vladimir> <1356082023.9580.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, December 21, 2012 10:27:03 AM Johannes Berg wrote:
> On Mon, 2012-12-17 at 13:32 +0200, Vladimir Kondratiev wrote:
> > From cc320b6c4433b63f3b1641646a49c4540e8954d2 Mon Sep 17 00:00:00 2001
> > From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> > Date: Mon, 17 Dec 2012 13:31:36 +0200
> > Subject: [PATCH] iw: print capability info for 60GHz band
> > 
> > On the 60GHz band, capability info defined different from .11n
> 
> I would prefer you didn't use "11ad" or "11n", in particular not "11n",
> it hasn't existed for quite a while now.
> 
> Also, the 2.4/5ghz capability bits really have nothing to do with 11n
> anyway.
> 
> johannes

Well, agree, I rephrased. Also, squash these 2:

[PATCH] iw: print capability info for 60GHz band
[PATCH] iw: print all capability bits

Combined patch follows

>From e79a5515929c6d4cab691e96e51f2616d7602240 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 17 Dec 2012 13:31:36 +0200
Subject: [PATCH v2] iw: print capability info for DMG (60GHz band)

On the DMG (Directed Multi-Gigabit) aka 60GHz band, capability info
defined by the 802.11ad spec differently from non-DMG one

Detect DMG band by frequency, spec says DMG if above 45 GHz;
parse and print accordingly

For the non-DMG capability info, add more bits as defined in the
IEEE802.11-2012

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 scan.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 93 insertions(+), 25 deletions(-)

diff --git a/scan.c b/scan.c
index 05bad0b..2188166 100644
--- a/scan.c
+++ b/scan.c
@@ -25,7 +25,25 @@
 #define WLAN_CAPABILITY_QOS		(1<<9)
 #define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
 #define WLAN_CAPABILITY_APSD		(1<<11)
+#define WLAN_CAPABILITY_RADIO_MEASURE	(1<<12)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+#define WLAN_CAPABILITY_DEL_BACK	(1<<14)
+#define WLAN_CAPABILITY_IMM_BACK	(1<<15)
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
@@ -1216,6 +1234,70 @@ void print_ies(unsigned char *ie, int ielen, bool unknown,
 	}
 }
 
+static void print_capa_dmg(__u16 capa)
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
+static void print_capa_non_dmg(__u16 capa)
+{
+	if (capa & WLAN_CAPABILITY_ESS)
+		printf(" ESS");
+	if (capa & WLAN_CAPABILITY_IBSS)
+		printf(" IBSS");
+	if (capa & WLAN_CAPABILITY_CF_POLLABLE)
+		printf(" CfPollable");
+	if (capa & WLAN_CAPABILITY_CF_POLL_REQUEST)
+		printf(" CfPollReq");
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
+	if (capa & WLAN_CAPABILITY_RADIO_MEASURE)
+		printf(" RadioMeasure");
+	if (capa & WLAN_CAPABILITY_DSSS_OFDM)
+		printf(" DSSS-OFDM");
+	if (capa & WLAN_CAPABILITY_DEL_BACK)
+		printf(" DelayedBACK");
+	if (capa & WLAN_CAPABILITY_IMM_BACK)
+		printf(" ImmediateBACK");
+}
+
 static int print_bss_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb[NL80211_ATTR_MAX + 1];
@@ -1237,6 +1319,7 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 	};
 	struct scan_params *params = arg;
 	int show = params->show_both_ie_sets ? 2 : 1;
+	bool is_dmg = false;
 
 	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
 		  genlmsg_attrlen(gnlh, 0), NULL);
@@ -1285,37 +1368,22 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
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
+			is_dmg = true;
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
+		if (is_dmg)
+			print_capa_dmg(capa);
+		else
+			print_capa_non_dmg(capa);
 		printf(" (0x%.4x)\n", capa);
 	}
 	if (bss[NL80211_BSS_SIGNAL_MBM]) {
-- 
1.7.10.4


