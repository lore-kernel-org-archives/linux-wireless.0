Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52096 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965110AbZLHCNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 21:13:49 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] iw: fix 'iw list' MCS set print
Date: Mon,  7 Dec 2009 21:13:56 -0500
Message-Id: <1260238436-15791-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MCS set was being printed backward, fix this and while at it
add a helper to share with scanning.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 info.c |    6 +++---
 iw.h   |    2 ++
 scan.c |    6 ++----
 util.c |    9 +++++++++
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/info.c b/info.c
index ddff78b..c80a11f 100644
--- a/info.c
+++ b/info.c
@@ -153,9 +153,9 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			unsigned char *mcs = nla_data(tb_band[NL80211_BAND_ATTR_HT_MCS_SET]);
 			bool tx_mcs_set_defined, tx_mcs_set_equal, tx_unequal_modulation;
 
-			printf("\t\tHT MCS set: %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x %.2x\n",
-				mcs[0], mcs[1], mcs[2], mcs[3], mcs[4], mcs[5], mcs[6], mcs[7],
-				mcs[8], mcs[9], mcs[10], mcs[11], mcs[12], mcs[13], mcs[14], mcs[15]);
+			printf("\t\tHT MCS set:");
+			print_mcs_set(mcs);
+			printf("\n");
 
 			max_rx_supp_data_rate = ((mcs[10] >> 8) & ((mcs[11] & 0x3) << 8));
 			tx_mcs_set_defined = !!(mcs[12] & (1 << 0));
diff --git a/iw.h b/iw.h
index e22a281..ef22737 100644
--- a/iw.h
+++ b/iw.h
@@ -120,6 +120,8 @@ void mac_addr_n2a(char *mac_addr, unsigned char *arg);
 
 int parse_keys(struct nl_msg *msg, char **argv, int argc);
 
+void print_mcs_set(const uint8_t *data);
+
 const char *iftype_name(enum nl80211_iftype iftype);
 const char *command_name(enum nl80211_commands cmd);
 int ieee80211_channel_to_frequency(int chan);
diff --git a/scan.c b/scan.c
index 1889bd0..973d690 100644
--- a/scan.c
+++ b/scan.c
@@ -547,11 +547,9 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
 	       print_ampdu_space(ampdu_spacing), ampdu_spacing);
 
 	/* This is the whole MCS set, which is 16 bytes */
-	printf("\t\tMCS set: ");
+	printf("\t\tMCS set:");
 	data+=2;
-	for (i = 15; i != 0; i--) {
-		printf(" %.2x", data[i]);
-	}
+	print_mcs_set(data);
 	printf("\n");
 
 	if (htc->mcs_set.tx_rx_mcs_defined && htc->mcs_set.tx_rx_mcs_not_equal)
diff --git a/util.c b/util.c
index 6a3fcc0..3b6fa47 100644
--- a/util.c
+++ b/util.c
@@ -292,3 +292,12 @@ int parse_keys(struct nl_msg *msg, char **argv, int argc)
 			"for example: d:2:6162636465 is the same as d:2:abcde\n");
 	return 2;
 }
+
+void print_mcs_set(const uint8_t *data)
+{
+	unsigned int i;
+
+        for (i = 15; i != 0; i--) {
+                printf(" %.2x", data[i]);
+        }
+}
-- 
1.6.3.3

