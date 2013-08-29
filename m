Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46039 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3H2WYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 18:24:05 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/4] iw:  Print Interworking IE details in scan results.
Date: Thu, 29 Aug 2013 15:23:44 -0700
Message-Id: <1377815027-3736-1-git-send-email-greearb@candelatech.com> (sfid-20130830_002410_127030_D4EECE6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Output looks like:

	802.11u Interworking:
		Network Options: 0xf1
			Network Type: 1 (Private with Guest)
			Internet
			ASRA
			ESR
			UESA
		Venue Group: 2 (Business)
		Venue Type: 1
		HESSID: 00:00:00:00:00:01

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Fix bracket whitespace as requested.
     Fix typo in patch description.

:100644 100644 af21cbc... e8957d1... M	scan.c
 scan.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index af21cbc..e8957d1 100644
--- a/scan.c
+++ b/scan.c
@@ -614,6 +614,71 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 	print_ht_mcs(data + 3);
 }
 
+static const char* ntype_11u(uint8_t t)
+{
+	switch (t) {
+	case 0: return "Private";
+	case 1: return "Private with Guest";
+	case 2: return "Chargeable Public";
+	case 3: return "Free Public";
+	case 4: return "Personal Device";
+	case 5: return "Emergency Services Only";
+	case 14: return "Test or Experimental";
+	case 15: return "Wildcard";
+	default: return "Reserved";
+	}
+}
+
+static const char* vgroup_11u(uint8_t t)
+{
+	switch (t) {
+	case 0: return "Unspecified";
+	case 1: return "Assembly";
+	case 2: return "Business";
+	case 3: return "Educational";
+	case 4: return "Factory and Industrial";
+	case 5: return "Institutional";
+	case 6: return "Mercantile";
+	case 7: return "Residential";
+	case 8: return "Storage";
+	case 9: return "Utility and Miscellaneous";
+	case 10: return "Vehicular";
+	case 11: return "Outdoor";
+	default: return "Reserved";
+	}
+}
+
+static void print_interworking(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	/* See Section 7.3.2.92 in the 802.11u spec. */
+	printf("\n");
+	if (len >= 1) {
+		uint8_t ano = data[0];
+		printf("\t\tNetwork Options: 0x%hx\n", (unsigned short)(ano));
+		printf("\t\t\tNetwork Type: %i (%s)\n",
+		       (int)(ano & 0xf), ntype_11u(ano & 0xf));
+		if (ano & (1<<4))
+			printf("\t\t\tInternet\n");
+		if (ano & (1<<5))
+			printf("\t\t\tASRA\n");
+		if (ano & (1<<6))
+			printf("\t\t\tESR\n");
+		if (ano & (1<<7))
+			printf("\t\t\tUESA\n");
+	}
+	if ((len == 3) || (len == 9)) {
+		printf("\t\tVenue Group: %i (%s)\n",
+		       (int)(data[1]), vgroup_11u(data[1]));
+		printf("\t\tVenue Type: %i\n", (int)(data[2]));
+	}
+	if (len == 9)
+		printf("\t\tHESSID: %02hx:%02hx:%02hx:%02hx:%02hx:%02hx\n",
+		       data[3], data[4], data[5], data[6], data[7], data[8]);
+	else if (len == 7)
+		printf("\t\tHESSID: %02hx:%02hx:%02hx:%02hx:%02hx:%02hx\n",
+		       data[1], data[2], data[3], data[4], data[5], data[6]);
+}
+
 static const char *ht_secondary_offset[4] = {
 	"no secondary",
 	"above",
@@ -891,6 +956,7 @@ static const struct ie_print ieprinters[] = {
 	[113] = { "MESH Configuration", print_mesh_conf, 7, 7, BIT(PRINT_SCAN), },
 	[114] = { "MESH ID", print_ssid, 0, 32, BIT(PRINT_SCAN) | BIT(PRINT_LINK), },
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
+	[107] = { "802.11u Interworking", print_interworking, 0, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_wifi_wpa(const uint8_t type, uint8_t len, const uint8_t *data)
-- 
1.7.3.4

