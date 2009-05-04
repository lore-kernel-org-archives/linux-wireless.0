Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46742 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZEDGZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 02:25:26 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH] add human readable decoding for capability information field
Date: Sun,  3 May 2009 23:25:13 -0700
Message-Id: <1241418313-4446-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 scan.c |   45 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/scan.c b/scan.c
index 5caa504..19c7388 100644
--- a/scan.c
+++ b/scan.c
@@ -13,6 +13,20 @@
 #include "nl80211.h"
 #include "iw.h"
 
+#define WLAN_CAPABILITY_ESS		(1<<0)
+#define WLAN_CAPABILITY_IBSS		(1<<1)
+#define WLAN_CAPABILITY_CF_POLLABLE	(1<<2)
+#define WLAN_CAPABILITY_CF_POLL_REQUEST	(1<<3)
+#define WLAN_CAPABILITY_PRIVACY		(1<<4)
+#define WLAN_CAPABILITY_SHORT_PREAMBLE	(1<<5)
+#define WLAN_CAPABILITY_PBCC		(1<<6)
+#define WLAN_CAPABILITY_CHANNEL_AGILITY	(1<<7)
+#define WLAN_CAPABILITY_SPECTRUM_MGMT	(1<<8)
+#define WLAN_CAPABILITY_QOS		(1<<9)
+#define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
+#define WLAN_CAPABILITY_APSD		(1<<11)
+#define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+
 static unsigned char vendor_oui[3] = { 0x00, 0x50, 0xf2 };
 static unsigned char cipher_oui[3] = { 0x00, 0x0f, 0xac };
 
@@ -491,10 +505,33 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 	if (bss[NL80211_BSS_BEACON_INTERVAL])
 		printf("\tbeacon interval: %d\n",
 			nla_get_u16(bss[NL80211_BSS_BEACON_INTERVAL]));
-	if (bss[NL80211_BSS_CAPABILITY])
-		printf("\tcapability: 0x%.4x\n",
-			nla_get_u16(bss[NL80211_BSS_CAPABILITY]));
-	if (bss[NL80211_BSS_SIGNAL_MBM]) {
+	if (bss[NL80211_BSS_CAPABILITY]) {
+		__u16 capa = nla_get_u16(bss[NL80211_BSS_CAPABILITY]);
+		printf("\tcapability:");
+		if (capa & WLAN_CAPABILITY_ESS)
+			printf(" ESS");
+		if (capa & WLAN_CAPABILITY_IBSS)
+			printf(" IBSS");
+		if (capa & WLAN_CAPABILITY_PRIVACY)
+			printf(" Privacy");
+		if (capa & WLAN_CAPABILITY_SHORT_PREAMBLE)
+			printf(" ShortPreamble");
+		if (capa & WLAN_CAPABILITY_PBCC)
+			printf(" PBCC");
+		if (capa & WLAN_CAPABILITY_CHANNEL_AGILITY)
+			printf(" ChannelAgility");
+		if (capa & WLAN_CAPABILITY_SPECTRUM_MGMT)
+			printf(" SpectrumMgmt");
+		if (capa & WLAN_CAPABILITY_QOS)
+			printf(" QoS");
+		if (capa & WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			printf(" ShortSlotTime");
+		if (capa & WLAN_CAPABILITY_APSD)
+			printf(" APSD");
+		if (capa & WLAN_CAPABILITY_DSSS_OFDM)
+			printf(" DSSS-OFDM");
+		printf(" (0x%.4x)\n", capa);
+	} if (bss[NL80211_BSS_SIGNAL_MBM]) {
 		int s = nla_get_u32(bss[NL80211_BSS_SIGNAL_MBM]);
 		printf("\tsignal: %d.%.2d dBm\n", s/100, s%100);
 	}
-- 
1.6.0.6

