Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:50559 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KINiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 08:38:46 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] iw: print the ssid when requesting device info
Date: Fri,  9 Nov 2012 14:37:58 +0100
Message-Id: <1352468278-30931-1-git-send-email-ordex@autistici.org> (sfid-20121109_143859_471440_F87EEFB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GET_INTERFACE command receives also the ssid as part of the reply.
This patch makes iw print the ssid together with the other information
when issuing the "iw dev $vif info" command.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 interface.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/interface.c b/interface.c
index 810c2b9..a1e2861 100644
--- a/interface.c
+++ b/interface.c
@@ -294,6 +294,13 @@ static int print_iface_handler(struct nl_msg *msg, void *arg)
 		mac_addr_n2a(mac_addr, nla_data(tb_msg[NL80211_ATTR_MAC]));
 		printf("%s\taddr %s\n", indent, mac_addr);
 	}
+	if (tb_msg[NL80211_ATTR_SSID]) {
+		char ssid[33];
+		memcpy(ssid, nla_data(tb_msg[NL80211_ATTR_SSID]),
+		       nla_len(tb_msg[NL80211_ATTR_SSID]));
+		ssid[nla_len(tb_msg[NL80211_ATTR_SSID])] = '\0';
+		printf("%s\tssid %s\n", indent, ssid);
+	}
 	if (tb_msg[NL80211_ATTR_IFTYPE])
 		printf("%s\ttype %s\n", indent, iftype_name(nla_get_u32(tb_msg[NL80211_ATTR_IFTYPE])));
 	if (!wiphy && tb_msg[NL80211_ATTR_WIPHY])
-- 
1.8.0

