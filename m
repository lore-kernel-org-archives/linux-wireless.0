Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46231 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3H0Qug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 12:50:36 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Print 802.11u Advertisement IE info in scan results.
Date: Tue, 27 Aug 2013 09:50:19 -0700
Message-Id: <1377622219-25786-1-git-send-email-greearb@candelatech.com> (sfid-20130827_185039_273210_9A95F74B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Sample output looks like:

	802.11u Advertisement:
		Query Response Info: 0x7f
			Query Response Length Limit: 127
			ANQP

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1894769... b1917b0... M	scan.c
 scan.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 1894769..b1917b0 100644
--- a/scan.c
+++ b/scan.c
@@ -677,6 +677,38 @@ static void print_interworking(const uint8_t type, uint8_t len, const uint8_t *d
 		       data[1], data[2], data[3], data[4], data[5], data[6]);
 }
 
+static void print_11u_advert(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	/* See Section 7.3.2.93 in the 802.11u spec. */
+	/* TODO: This code below does not decode private protocol IDs */
+	int idx = 0;
+	printf("\n");
+	while (idx < (len - 1)) {
+		uint8_t qri = data[idx];
+		uint8_t proto_id = data[idx + 1];
+		printf("\t\tQuery Response Info: 0x%hx\n", (unsigned short)(qri));
+		printf("\t\t\tQuery Response Length Limit: %i\n",
+		       (qri & 0x7f));
+		if (qri & (1<<7))
+			printf("\t\t\tPAME-BI\n");
+		switch(proto_id) {
+		case 0:
+			printf("\t\t\tANQP\n"); break;
+		case 1:
+			printf("\t\t\tMIH Information Service\n"); break;
+		case 2:
+			printf("\t\t\tMIH Command and Event Services Capability Discovery\n"); break;
+		case 3:
+			printf("\t\t\tEmergency Alert System (EAS)\n"); break;
+		case 221:
+			printf("\t\t\tVendor Specific\n"); break;
+		default:
+			printf("\t\t\tReserved: %i\n", proto_id); break;
+		}
+		idx += 2;
+	}
+}
+
 static const char *ht_secondary_offset[4] = {
 	"no secondary",
 	"above",
@@ -955,6 +987,7 @@ static const struct ie_print ieprinters[] = {
 	[114] = { "MESH ID", print_ssid, 0, 32, BIT(PRINT_SCAN) | BIT(PRINT_LINK), },
 	[127] = { "Extended capabilities", print_capabilities, 0, 255, BIT(PRINT_SCAN), },
 	[107] = { "802.11u Interworking", print_interworking, 0, 255, BIT(PRINT_SCAN), },
+	[108] = { "802.11u Advertisement", print_11u_advert, 0, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_wifi_wpa(const uint8_t type, uint8_t len, const uint8_t *data)
-- 
1.7.3.4

