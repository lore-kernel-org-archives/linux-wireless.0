Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46047 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab3H2WY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 18:24:28 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/4] iw:  Print 802.11u roaming consortium IE in scan results.
Date: Thu, 29 Aug 2013 15:23:46 -0700
Message-Id: <1377815027-3736-3-git-send-email-greearb@candelatech.com> (sfid-20130830_002431_389604_21D168DE)
In-Reply-To: <1377815027-3736-1-git-send-email-greearb@candelatech.com>
References: <1377815027-3736-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Example output:

	802.11u Roaming Consortium:
		ANQP OIs: 0
		OI 1: 01010101

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 53cef39... 14a4272... M	scan.c
 scan.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 53cef39..14a4272 100644
--- a/scan.c
+++ b/scan.c
@@ -711,6 +711,58 @@ static void print_11u_advert(const uint8_t type, uint8_t len, const uint8_t *dat
 	}
 }
 
+static void print_11u_rcon(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	/* See Section 7.3.2.96 in the 802.11u spec. */
+	int idx = 0;
+	int ln0 = data[1] & 0xf;
+	int ln1 = ((data[1] & 0xf0) >> 4);
+	int ln2 = 0;
+	printf("\n");
+
+	if (ln1) {
+		ln2 = len - 2 - ln0 - ln1;
+	}
+	printf("\t\tANQP OIs: %i\n", data[0]);
+
+	if (ln0 > 0) {
+		printf("\t\tOI 1: ");
+		if (2 + ln0 > len) {
+			printf("Invalid IE length.\n");
+		}
+		else {
+			for (idx = 0; idx < ln0; idx++) {
+				printf("%02hx", data[2 + idx]);
+			}
+			printf("\n");
+		}
+	}
+	if (ln1 > 0) {
+		printf("\t\tOI 2: ");
+		if (2 + ln0 + ln1 > len) {
+			printf("Invalid IE length.\n");
+		}
+		else {
+			for (idx = 0; idx < ln1; idx++) {
+				printf("%02hx", data[2 + ln0 + idx]);
+			}
+			printf("\n");
+		}
+	}
+	if (ln2 > 0) {
+		printf("\t\tOI 3: ");
+		if (2 + ln0 + ln1 + ln2 > len) {
+			printf("Invalid IE length.\n");
+		}
+		else {
+			for (idx = 0; idx < ln2; idx++) {
+				printf("%02hx", data[2 + ln0 + ln1 + idx]);
+			}
+			printf("\n");
+		}
+	}
+}
+
 static const char *ht_secondary_offset[4] = {
 	"no secondary",
 	"above",
@@ -990,6 +1042,7 @@ static const struct ie_print ieprinters[] = {
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
 	[107] = { "802.11u Interworking", print_interworking, 0, 255, BIT(PRINT_SCAN), },
 	[108] = { "802.11u Advertisement", print_11u_advert, 0, 255, BIT(PRINT_SCAN), },
+	[111] = { "802.11u Roaming Consortium", print_11u_rcon, 0, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_wifi_wpa(const uint8_t type, uint8_t len, const uint8_t *data)
-- 
1.7.3.4

