Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60914 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3H0T1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 15:27:51 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] iw:  Print out HotSpot2 IE information.
Date: Tue, 27 Aug 2013 12:27:41 -0700
Message-Id: <1377631661-26997-1-git-send-email-greearb@candelatech.com> (sfid-20130827_212755_179245_B6A3989D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Example:

	HotSpot 2.0 Indication:
		DGAF: 0

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1a48509... c20c386... M	scan.c
 scan.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 1a48509..c20c386 100644
--- a/scan.c
+++ b/scan.c
@@ -1388,8 +1388,21 @@ static inline void print_p2p(const uint8_t type, uint8_t len, const uint8_t *dat
 	}
 }
 
+static inline void print_hs20_ind(const uint8_t type, uint8_t len, const uint8_t *data)
+{
+	/* I can't find the spec for this...just going off what wireshark uses. */
+	printf("\n");
+	if (len > 0) {
+		printf("\t\tDGAF: %i\n", (int)(data[0] & 0x1));
+	}
+	else {
+		printf("\t\tUnexpected length: %i\n", len);
+	}
+}
+
 static const struct ie_print wfa_printers[] = {
 	[9] = { "P2P", print_p2p, 2, 255, BIT(PRINT_SCAN), },
+	[16] = { "HotSpot 2.0 Indication", print_hs20_ind, 1, 255, BIT(PRINT_SCAN), },
 };
 
 static void print_vendor(unsigned char len, unsigned char *data,
-- 
1.7.3.4

