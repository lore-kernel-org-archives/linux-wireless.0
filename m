Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46050 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab3H2WYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 18:24:37 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/4] iw:  Print out HotSpot2 IE information.
Date: Thu, 29 Aug 2013 15:23:47 -0700
Message-Id: <1377815027-3736-4-git-send-email-greearb@candelatech.com> (sfid-20130830_002439_910427_3146FBA0)
In-Reply-To: <1377815027-3736-1-git-send-email-greearb@candelatech.com>
References: <1377815027-3736-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Example:

	HotSpot 2.0 Indication:
		DGAF: 0

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 14a4272... 2686ff3... M	scan.c
 scan.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/scan.c b/scan.c
index 14a4272..2686ff3 100644
--- a/scan.c
+++ b/scan.c
@@ -1390,8 +1390,21 @@ static inline void print_p2p(const uint8_t type, uint8_t len, const uint8_t *dat
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

