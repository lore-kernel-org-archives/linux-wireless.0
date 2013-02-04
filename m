Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56614 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3BDMuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 07:50:11 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/2] iw: print DFS states for channels if available
Date: Mon,  4 Feb 2013 13:50:00 +0100
Message-Id: <1359982200-2321-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130204_135020_400466_948DF7F8)
In-Reply-To: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 info.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/info.c b/info.c
index 14db37f..bcf36d7 100644
--- a/info.c
+++ b/info.c
@@ -49,6 +49,20 @@ static char *cipher_name(__u32 c)
 	}
 }
 
+static char *dfs_state_name(enum nl80211_dfs_state state)
+{
+	switch (state) {
+	case NL80211_DFS_USABLE:
+		return "usable";
+	case NL80211_DFS_AVAILABLE:
+		return "available";
+	case NL80211_DFS_UNAVAILABLE:
+		return "unavailable";
+	default:
+		return "unknown";
+	}
+}
+
 static int print_phy_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
@@ -147,6 +161,17 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
  next:
 			if (open)
 				printf(")");
+			if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
+				enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
+				unsigned long time;
+
+				printf(" DFS state: %s", dfs_state_name(state));
+				if (tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]) {
+					time = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_TIME]);
+					printf(" (for %lu sec)", time/1000);
+				}
+			}
+
 			printf("\n");
 		}
 
-- 
1.7.10.4

