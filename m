Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1KUKJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 05:09:26 -0500
Subject: [PATCH] cfg80211: work around a sparse issue
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 11:09:22 +0100
Message-ID: <1321870162.3999.32.camel@jlt3.sipsolutions.net> (sfid-20111121_110929_931644_2950B0F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

sparse reports:
net/wireless/util.c:499:30: error: cannot size expression
net/wireless/util.c:503:30: error: cannot size expression

This is evidently due to the EXPORT_SYMBOL() of the
bridge_tunnel_header and rfc1042 header variables.
Move them to the end of the file to work around the
sparse issue. The error itself from sparse can be
ignored safely, but since sparse stops parsing at
errors, other issues after this would go undetected.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/net/wireless/util.c	2011-11-21 10:59:07.000000000 +0100
+++ b/net/wireless/util.c	2011-11-21 11:02:58.000000000 +0100
@@ -239,17 +239,6 @@ int cfg80211_validate_key_settings(struc
 	return 0;
 }
 
-/* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
-/* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-const unsigned char rfc1042_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
-EXPORT_SYMBOL(rfc1042_header);
-
-/* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-const unsigned char bridge_tunnel_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
-EXPORT_SYMBOL(bridge_tunnel_header);
-
 unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc)
 {
 	unsigned int hdrlen = 24;
@@ -1049,3 +1038,14 @@ int ieee80211_get_ratemask(struct ieee80
 
 	return 0;
 }
+
+/* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
+/* Ethernet-II snap header (RFC1042 for most EtherTypes) */
+const unsigned char rfc1042_header[] __aligned(2) =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+EXPORT_SYMBOL(rfc1042_header);
+
+/* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
+const unsigned char bridge_tunnel_header[] __aligned(2) =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
+EXPORT_SYMBOL(bridge_tunnel_header);


