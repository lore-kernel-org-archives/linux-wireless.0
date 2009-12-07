Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbZLGTyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 14:54:39 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	johannes@sipsolutions.net
Subject: [PATCH] mac80211: parse the HT capabilities info through debugfs
Date: Mon,  7 Dec 2009 14:54:45 -0500
Message-Id: <1260215685-24385-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When debugging you want to be lazy and not have to parse
bits yourself so let mac80211 debugfs do the parsing for you.

This is what I get against my WRT610N:

root@tux:~# cat /sys/kernel/debug/ieee80211/phy0/stations/00\:22\:6b\:aa\:bb\:01/ht_capa
ht supported
cap: 0x000e
	HT20/HT40
	SM Power Save disabled
	No RX STBC
	Max AMSDU length: 7935 bytes
	No DSSS/CCK HT40
ampdu factor/density: 2/6
MCS mask: ff ff 00 00 00 00 00 00 00 00
MCS rx highest: 0
MCS tx params: 0

Cc: johannes@sipsolutions.net
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/debugfs_sta.c |   48 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index ae6a919..ab3397a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -160,7 +160,12 @@ STA_OPS(agg_status);
 static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 				size_t count, loff_t *ppos)
 {
-	char buf[200], *p = buf;
+#define PRINT_HT_CAP(_cond, _str) \
+	do { \
+	if (_cond) \
+			p += scnprintf(p, sizeof(buf)+buf-p, "\t" _str "\n"); \
+	} while (0)
+	char buf[1024], *p = buf;
 	int i;
 	struct sta_info *sta = file->private_data;
 	struct ieee80211_sta_ht_cap *htc = &sta->sta.ht_cap;
@@ -169,6 +174,47 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
 			htc->ht_supported ? "" : "not ");
 	if (htc->ht_supported) {
 		p += scnprintf(p, sizeof(buf)+buf-p, "cap: %#.4x\n", htc->cap);
+
+		PRINT_HT_CAP((htc->cap & BIT(0)), "RX LDCP");
+		PRINT_HT_CAP((htc->cap & BIT(1)), "HT20/HT40");
+		PRINT_HT_CAP(!(htc->cap & BIT(1)), "HT20");
+
+		PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 0, "Static SM Power Save");
+		PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 1, "Dynamic SM Power Save");
+		PRINT_HT_CAP(((htc->cap >> 2) & 0x3) == 3, "SM Power Save disabled");
+
+		PRINT_HT_CAP((htc->cap & BIT(4)), "RX Greenfield");
+		PRINT_HT_CAP((htc->cap & BIT(5)), "RX HT20 SGI");
+		PRINT_HT_CAP((htc->cap & BIT(6)), "RX HT40 SGI");
+		PRINT_HT_CAP((htc->cap & BIT(7)), "TX STBC");
+
+		PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 0, "No RX STBC");
+		PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 1, "RX STBC 1-stream");
+		PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 2, "RX STBC 2-streams");
+		PRINT_HT_CAP(((htc->cap >> 8) & 0x3) == 3, "RX STBC 3-streams");
+
+		PRINT_HT_CAP((htc->cap & BIT(10)), "HT Delayed Block Ack");
+
+		PRINT_HT_CAP((htc->cap & BIT(11)), "Max AMSDU length: "
+			     "3839 bytes");
+		PRINT_HT_CAP(!(htc->cap & BIT(11)), "Max AMSDU length: "
+			     "7935 bytes");
+
+		/*
+		 * For beacons and probe response this would mean the BSS
+		 * does or does not allow the usage of DSSS/CCK HT40.
+		 * Otherwise it means the STA does or does not use
+		 * DSSS/CCK HT40.
+		 */
+		PRINT_HT_CAP((htc->cap & BIT(12)), "DSSS/CCK HT40");
+		PRINT_HT_CAP(!(htc->cap & BIT(12)), "No DSSS/CCK HT40");
+
+		/* BIT(13) is reserved */
+
+		PRINT_HT_CAP((htc->cap & BIT(14)), "40 MHz Intolerant");
+
+		PRINT_HT_CAP((htc->cap & BIT(15)), "L-SIG TXOP protection");
+
 		p += scnprintf(p, sizeof(buf)+buf-p, "ampdu factor/density: %d/%d\n",
 				htc->ampdu_factor, htc->ampdu_density);
 		p += scnprintf(p, sizeof(buf)+buf-p, "MCS mask:");
-- 
1.6.3.3

